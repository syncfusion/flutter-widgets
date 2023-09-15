import '../primitives/pdf_array.dart';
import '../primitives/pdf_number.dart';
import 'enums.dart';

/// Implements structures and routines working with color.
///
/// ```dart
/// //Creates a new PDF document.
/// PdfDocument document = PdfDocument()
///   ..pages.add().graphics.drawString(
///       'Hello World!', PdfStandardFont(PdfFontFamily.helvetica, 12),
///       //Using PDF color set pen.
///       pen: PdfPen(PdfColor(200, 120, 80)));
/// //Saves the document.
/// List<int> bytes = await document.save();
/// //Dispose the document.
/// document.dispose();
/// ```
class PdfColor {
  /// Initializes a new instance of the [PdfColor] class
  /// with Red, Green, Blue and Alpha channels.
  ///
  /// ```dart
  /// //Creates a new PDF document.
  /// PdfDocument document = PdfDocument()
  ///   ..pages.add().graphics.drawString(
  ///       'Hello World!', PdfStandardFont(PdfFontFamily.helvetica, 12),
  ///       //Using PDF color set pen.
  ///       pen: PdfPen(PdfColor(200, 120, 80)));
  /// //Saves the document.
  /// List<int> bytes = await document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  PdfColor(int red, int green, int blue, [int alpha = 255]) {
    _helper = PdfColorHelper(this);
    _black = 0;
    _cyan = 0;
    _magenta = 0;
    _yellow = 0;
    _gray = 0;
    _red = red;
    _green = green;
    _blue = blue;
    _helper.alpha = alpha;
    _helper.isFilled = _helper.alpha != 0;
    _assignCMYK(_red, _green, _blue);
  }

  /// Initializes a new instance of the [PdfColor] class
  /// with Cyan, Magenta, Yellow and Black channels.
  ///
  /// ```dart
  /// //Creates a new PDF document.
  /// PdfDocument document = PdfDocument()
  ///   ..pages.add().graphics.drawString(
  ///       'Hello World!', PdfStandardFont(PdfFontFamily.helvetica, 12),
  ///       //Using PDF color set pen.
  ///       pen: PdfPen(PdfColor.fromCMYK(200, 120, 80, 40)));
  /// //Saves the document.
  /// List<int> bytes = await document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  PdfColor.fromCMYK(double cyan, double magenta, double yellow, double black) {
    _helper = PdfColorHelper(this);
    _red = 0;
    _cyan = cyan;
    _green = 0;
    _magenta = magenta;
    _blue = 0;
    _yellow = yellow;
    _black = black;
    _gray = 0;
    _helper.alpha = _maxColourChannelValue.toInt();
    _helper.isFilled = true;
    _assignRGB(cyan, magenta, yellow, black);
  }

  PdfColor._fromGray(double gray) {
    _helper = PdfColorHelper(this);
    if (gray < 0) {
      gray = 0;
    }
    if (gray > 1) {
      gray = 1;
    }
    _red = (gray * _maxColourChannelValue).round().toUnsigned(8);
    _green = (gray * _maxColourChannelValue).round().toUnsigned(8);
    _blue = (gray * _maxColourChannelValue).round().toUnsigned(8);
    _cyan = gray;
    _magenta = gray;
    _yellow = gray;
    _black = gray;
    _gray = gray;
    _helper.alpha = _maxColourChannelValue.round().toUnsigned(8);
    _helper.isFilled = true;
  }

  PdfColor._empty() {
    _helper = PdfColorHelper(this);
    _red = 0;
    _cyan = 0;
    _green = 0;
    _magenta = 0;
    _blue = 0;
    _yellow = 0;
    _black = 0;
    _gray = 0;
    _helper.alpha = 0;
    _helper.isFilled = false;
  }

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  bool operator ==(Object other) {
    return other is PdfColor &&
        _red == other._red &&
        _cyan == other._cyan &&
        _green == other._green &&
        _magenta == other._magenta &&
        _blue == other._blue &&
        _yellow == other._yellow &&
        _black == other._black &&
        _gray == other._gray &&
        _helper.alpha == other._helper.alpha &&
        _helper.isFilled == other._helper.isFilled;
  }

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  int get hashCode => _helper.alpha.hashCode;

  /// Gets the empty(null) color.
  ///
  /// ```dart
  /// //Creates a new PDF document.
  /// PdfDocument document = PdfDocument()
  ///   ..pages.add().graphics.drawString(
  ///       'Hello World!', PdfStandardFont(PdfFontFamily.helvetica, 12),
  ///       //Create PDF color.
  ///       pen: PdfPen(PdfColor.empty));
  /// //Saves the document.
  /// List<int> bytes = await document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  static PdfColor get empty {
    return PdfColor._empty();
  }

  //Fields
  late PdfColorHelper _helper;

  /// Holds RGB colors converted into strings.
  final Map<int, Object> _rgbStrings = <int, Object>{};

  /// Value of Red channel.
  late int _red;

  /// Value of Cyan channel.
  late double _cyan;

  /// Value of Green channel.
  late int _green;

  /// Value of Magenta channel.
  late double _magenta;

  /// Value of Blue channel.
  late int _blue;

  /// Value of Yellow channel.
  late double _yellow;

  /// Value of Black channel.
  late double _black;

  /// Value of Gray channel.
  late double _gray;

  /// Max value of color channel.
  final double _maxColourChannelValue = 255.0;

  //Properties
  /// Gets or sets Red channel value.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument document = PdfDocument()
  ///   ..pages.add().graphics.drawRectangle(
  ///       //sets the red channel value.
  ///       pen: PdfPen(PdfColor(0, 0, 0)..r = 255),
  ///       bounds: Rect.fromLTWH(10, 10, 200, 100));
  /// //Save the document.
  /// List<int> bytes = await document.save();
  /// //Close the document.
  /// document.dispose();
  /// ```
  int get r => _red;
  set r(int value) {
    _red = value;
    _assignCMYK(_red, _green, _blue);
    _helper.isFilled = true;
  }

  /// Gets or sets Green channel value.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument document = PdfDocument()
  ///   ..pages.add().graphics.drawRectangle(
  ///       //sets the green channel value.
  ///       pen: PdfPen(PdfColor(0, 0, 0)..g = 255),
  ///       bounds: Rect.fromLTWH(10, 10, 200, 100));
  /// //Save the document.
  /// List<int> bytes = await document.save();
  /// //Close the document.
  /// document.dispose();
  /// ```
  int get g => _green;
  set g(int value) {
    _green = value;
    _assignCMYK(_red, _green, _blue);
    _helper.isFilled = true;
  }

  /// Gets or sets Blue channel value.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument document = PdfDocument()
  ///   ..pages.add().graphics.drawRectangle(
  ///       //sets the blue channel value.
  ///       pen: PdfPen(PdfColor(0, 0, 0)..b = 255),
  ///       bounds: Rect.fromLTWH(10, 10, 200, 100));
  /// //Save the document.
  /// List<int> bytes = await document.save();
  /// //Close the document.
  /// document.dispose();
  /// ```
  int get b => _blue;
  set b(int value) {
    _blue = value;
    _assignCMYK(_red, _green, _blue);
    _helper.isFilled = true;
  }

  /// Gets whether the PDFColor is Empty or not.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument document = PdfDocument();
  /// //Create a new PDF pen instance.
  /// PdfColor color = PdfColor.empty;
  /// //Draw rectangle with the pen.
  /// document.pages.add().graphics.drawString('Color present: ${color.isEmpty}',
  ///     PdfStandardFont(PdfFontFamily.helvetica, 12),
  ///     pen: PdfPen(color));
  /// //Save the document.
  /// List<int> bytes = await document.save();
  /// //Close the document.
  /// document.dispose();
  /// ```
  bool get isEmpty => !_helper.isFilled;

  //Implementation
  /// Converts RGB to CMYK.
  void _assignCMYK(int r, int g, int b) {
    final double red = r / _maxColourChannelValue;
    final double green = g / _maxColourChannelValue;
    final double blue = b / _maxColourChannelValue;
    final double black = _min(1 - red, 1 - green, 1 - blue);
    final double cyan = black == 1.0 ? 0 : (1 - red - black) / (1 - black);
    final double magenta = black == 1.0 ? 0 : (1 - green - black) / (1 - black);
    final double yellow = black == 1.0 ? 0 : (1 - blue - black) / (1 - black);
    _black = black;
    _cyan = cyan;
    _magenta = magenta;
    _yellow = yellow;
  }

  /// Converts CMYK to RGB.
  void _assignRGB(double c, double m, double y, double k) {
    final double black = k * _maxColourChannelValue;
    final double red = (c * (_maxColourChannelValue - black)) + black;
    final double green = (m * (_maxColourChannelValue - black)) + black;
    final double blue = (y * (_maxColourChannelValue - black)) + black;
    _red = (_maxColourChannelValue -
            (_maxColourChannelValue <= red ? _maxColourChannelValue : red))
        .toInt()
        .toUnsigned(8);
    _green = (_maxColourChannelValue -
            (_maxColourChannelValue <= green ? _maxColourChannelValue : green))
        .toInt()
        .toUnsigned(8);
    _blue = (_maxColourChannelValue -
            (_maxColourChannelValue <= blue ? _maxColourChannelValue : blue))
        .toInt()
        .toUnsigned(8);
  }

  /// Gets minimum from RGB color values.
  double _min(double r, double g, double b) {
    final double min = r <= g ? r : g;
    return b <= min ? b : min;
  }

  PdfArray _toArray([PdfColorSpace colorSpace = PdfColorSpace.rgb]) {
    final PdfArray array = PdfArray();
    switch (colorSpace) {
      case PdfColorSpace.cmyk:
        array.add(PdfNumber(_cyan));
        array.add(PdfNumber(_magenta));
        array.add(PdfNumber(_yellow));
        array.add(PdfNumber(_black));
        break;
      case PdfColorSpace.grayScale:
        array.add(PdfNumber(_gray / _maxColourChannelValue));
        break;
      case PdfColorSpace.rgb:
        array.add(PdfNumber(_red / _maxColourChannelValue));
        array.add(PdfNumber(_green / _maxColourChannelValue));
        array.add(PdfNumber(_blue / _maxColourChannelValue));
        break;
      // ignore: no_default_cases
      default:
        throw ArgumentError.value('Unsupported colour space.');
    }
    return array;
  }
}

/// [PdfColor] helper
class PdfColorHelper {
  /// internal constructor
  PdfColorHelper(this.base);

  /// internal field
  late PdfColor base;

  /// internal method
  static PdfColorHelper getHelper(PdfColor base) {
    return base._helper;
  }

  /// internal method
  static PdfColor fromGray(double gray) {
    return PdfColor._fromGray(gray);
  }

  /// internal method
  static PdfArray toArray(PdfColor color,
      [PdfColorSpace colorSpace = PdfColorSpace.rgb]) {
    return color._toArray(colorSpace);
  }

  /// Value of alpha channel.
  late int alpha;

  /// Shows if the color is empty.
  bool isFilled = false;

  /// internal method
  /// Converts [PdfColor] to PDF string representation.
  String getString(PdfColorSpace? colorSpace, bool stroke) {
    if (base.isEmpty) {
      return '';
    }
    return _rgbToString(stroke);
  }

  /// Sets RGB color.
  String _rgbToString(bool ifStroking) {
    int key = (base.r << 16) + (base.g << 8) + base.b;
    if (ifStroking) {
      key += 1 << 24;
    }
    String colour;
    Object? obj;
    if (base._rgbStrings.containsKey(key)) {
      obj = base._rgbStrings[key];
    }
    if (obj == null) {
      dynamic red = base.r / base._maxColourChannelValue;
      dynamic green = base.g / base._maxColourChannelValue;
      dynamic blue = base.b / base._maxColourChannelValue;
      red = red % 1 == 0 ? red.toInt() : red;
      green = green % 1 == 0 ? green.toInt() : green;
      blue = blue % 1 == 0 ? blue.toInt() : blue;
      colour =
          '${_trimEnd(red.toString())} ${_trimEnd(green.toString())} ${_trimEnd(blue.toString())}${ifStroking ? ' RG' : ' rg'}';
      base._rgbStrings[key] = colour;
    } else {
      colour = obj.toString();
    }
    return colour;
  }

  String _trimEnd(String color) {
    if (color.endsWith('.00')) {
      color = color.substring(0, color.length - 3);
    }
    return color.isEmpty ? '0' : color;
  }
}
