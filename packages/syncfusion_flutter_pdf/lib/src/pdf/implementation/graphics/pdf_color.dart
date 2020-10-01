part of pdf;

/// Implements structures and routines working with color.
class PdfColor {
  /// Initializes a new instance of the [PdfColor] class
  /// with Red, Green, Blue and Alpha channels.
  PdfColor(int red, int green, int blue, [int alpha]) {
    _black = 0;
    _cyan = 0;
    _magenta = 0;
    _yellow = 0;
    _gray = 0;
    _red = red;
    _green = green;
    _blue = blue;
    _alpha = alpha ?? _maxColourChannelValue.toInt();
    _isFilled = _alpha != 0;
    _assignCMYK(_red, _green, _blue);
  }

  /// Initializes a new instance of the [PdfColor] class
  /// with Cyan, Magenta, Yellow and Black channels.
  PdfColor.fromCMYK(double cyan, double magenta, double yellow, double black) {
    _red = 0;
    _cyan = cyan;
    _green = 0;
    _magenta = magenta;
    _blue = 0;
    _yellow = yellow;
    _black = black;
    _gray = 0;
    _alpha = _maxColourChannelValue.toInt();
    _isFilled = true;
    _assignRGB(cyan, magenta, yellow, black);
  }

  PdfColor._fromGray(double gray) {
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
    _alpha = _maxColourChannelValue.round().toUnsigned(8);
    _isFilled = true;
  }

  PdfColor._empty() {
    _red = 0;
    _cyan = 0;
    _green = 0;
    _magenta = 0;
    _blue = 0;
    _yellow = 0;
    _black = 0;
    _gray = 0;
    _alpha = 0;
    _isFilled = false;
  }

  @override
  bool operator ==(Object other) {
    return other is PdfColor
        ? _red == other._red &&
            _cyan == other._cyan &&
            _green == other._green &&
            _magenta == other._magenta &&
            _blue == other._blue &&
            _yellow == other._yellow &&
            _black == other._black &&
            _gray == other._gray &&
            _alpha == other._alpha &&
            _isFilled == other._isFilled
        : false;
  }

  @override
  int get hashCode => _alpha.hashCode;

  /// Gets the empty(null) color.
  static PdfColor get empty {
    return PdfColor._empty();
  }

  //Fields
  /// Holds RGB colors converted into strings.
  final Map<int, Object> _rgbStrings = <int, Object>{};

  /// Value of Red channel.
  int _red;

  /// Value of Cyan channel.
  double _cyan;

  /// Value of Green channel.
  int _green;

  /// Value of Magenta channel.
  double _magenta;

  /// Value of Blue channel.
  int _blue;

  /// Value of Yellow channel.
  double _yellow;

  /// Value of Black channel.
  double _black;

  /// Value of Gray channel.
  double _gray;

  /// Value of alpha channel.
  int _alpha;

  /// Shows if the color is empty.
  bool _isFilled;

  /// Max value of color channel.
  final double _maxColourChannelValue = 255.0;

  //Properties
  /// Gets Red channel value.
  int get r => _red;

  /// Sets Red channel value.
  set r(int value) {
    _red = value;
    _assignCMYK(_red, _green, _blue);
    _isFilled = true;
  }

  /// Gets Green channel value.
  int get g => _green;

  /// Sets Red channel value.
  set g(int value) {
    _green = value;
    _assignCMYK(_red, _green, _blue);
    _isFilled = true;
  }

  /// Gets Blue channel value.
  int get b => _blue;

  /// Sets Blue channel value.
  set b(int value) {
    _blue = value;
    _assignCMYK(_red, _green, _blue);
    _isFilled = true;
  }

  /// Gets whether the PDFColor is Empty or not.
  bool get isEmpty => !_isFilled;

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

  /// Converts [PdfColor] to PDF string representation.
  String _toString(PdfColorSpace colorSpace, bool stroke) {
    if (isEmpty) {
      return '';
    }
    return _rgbToString(stroke);
  }

  /// Sets RGB color.
  String _rgbToString(bool ifStroking) {
    int key = (r << 16) + (g << 8) + b;
    if (ifStroking) {
      key += 1 << 24;
    }
    String colour;
    Object obj;
    if (_rgbStrings.containsKey(key)) {
      obj = _rgbStrings[key];
    }
    if (obj == null) {
      final double red = r / _maxColourChannelValue;
      final double green = g / _maxColourChannelValue;
      final double blue = b / _maxColourChannelValue;
      colour = _trimEnd(red.toString()) +
          ' ' +
          _trimEnd(green.toString()) +
          ' ' +
          _trimEnd(blue.toString()) +
          (ifStroking ? ' RG' : ' rg');
      _rgbStrings[key] = colour;
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

  _PdfArray _toArray([PdfColorSpace colorSpace]) {
    final _PdfArray array = _PdfArray();

    switch (colorSpace) {
      case PdfColorSpace.cmyk:
        array._add(_PdfNumber(_cyan));
        array._add(_PdfNumber(_magenta));
        array._add(_PdfNumber(_yellow));
        array._add(_PdfNumber(_black));
        break;
      case PdfColorSpace.grayScale:
        array._add(_PdfNumber(_gray / _maxColourChannelValue));
        break;
      case PdfColorSpace.rgb:
        array._add(_PdfNumber(_red / _maxColourChannelValue));
        array._add(_PdfNumber(_green / _maxColourChannelValue));
        array._add(_PdfNumber(_blue / _maxColourChannelValue));
        break;
      default:
        throw ArgumentError.value('Unsupported colour space.');
    }
    return array;
  }
}
