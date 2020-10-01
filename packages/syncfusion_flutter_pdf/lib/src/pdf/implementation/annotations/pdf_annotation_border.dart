part of pdf;

/// Represents the appearance of an annotation's border.
/// [PdfAnnotationBorder] class is used to create the annotation border
class PdfAnnotationBorder implements _IPdfWrapper {
  //constructor
  /// Initializes a new instance of the
  /// [PdfAnnotationBorder] class with specified border width,
  /// horizontal and vertical radius.
  ///
  /// The borderStyle and dashArray only used for shape annotations.
  PdfAnnotationBorder(
      [double borderWidth,
      double horizontalRadius,
      double verticalRadius,
      PdfBorderStyle borderStyle,
      int dashArray]) {
    _array._add(_PdfNumber(0));
    _array._add(_PdfNumber(0));
    _array._add(_PdfNumber(1));
    this.horizontalRadius = horizontalRadius ??= 0;
    width = borderWidth ??= 1;
    this.verticalRadius = verticalRadius ??= 0;
    this.borderStyle = borderStyle ??= PdfBorderStyle.solid;
    if (dashArray != null) {
      this.dashArray = dashArray;
    }
  }

  // fields
  double _horizontalRadius = 0;
  double _verticalRadius = 0;
  double _borderWidth = 1;
  int _dashArray;
  PdfBorderStyle _borderStyle;
  //ignore: prefer_final_fields
  bool _isLineBorder = false;
  final _PdfDictionary _dictionary = _PdfDictionary();
  final _PdfArray _array = _PdfArray();

  // properties
  /// Gets a horizontal corner radius of the annotations.
  double get horizontalRadius => _horizontalRadius;

  /// Sets a horizontal corner radius of the annotations.
  set horizontalRadius(double value) {
    if (value != _horizontalRadius && value != null) {
      _horizontalRadius = value;
      _setNumber(0, value);
    }
  }

  /// Gets a vertical corner radius of the annotation.
  double get verticalRadius => _verticalRadius;

  /// Sets a vertical corner radius of the annotation.
  set verticalRadius(double value) {
    if (value != null && value != _verticalRadius) {
      _verticalRadius = value;
      _setNumber(1, value);
    }
  }

  /// Gets the width of annotation's border.
  double get width => _borderWidth;

  /// Sets the width of annotation's border.
  set width(double value) {
    if (value != null && value != _borderWidth) {
      _borderWidth = value;
      _setNumber(2, value);
      _dictionary._setNumber(_DictionaryProperties.w, _borderWidth.toInt());
    }
  }

  /// Gets the border style.
  PdfBorderStyle get borderStyle => _borderStyle;

  /// Sets the border style.
  set borderStyle(PdfBorderStyle value) {
    if (value != null && value != _borderStyle) {
      _borderStyle = value;
      _dictionary._setName(
          _PdfName(_DictionaryProperties.s), _styleToString(_borderStyle));
    }
  }

  /// Gets the line dash of the annotation.
  int get dashArray => _dashArray;

  /// Sets the line dash of the annotation.
  set dashArray(int value) {
    if (value != null && _dashArray != value) {
      _dashArray = value;
      final _PdfArray dasharray = _PdfArray();
      dasharray._add(_PdfNumber(_dashArray));
      dasharray._add(_PdfNumber(_dashArray));
      _dictionary.setProperty(_DictionaryProperties.d, dasharray);
    }
  }

  void _setNumber(int index, double value) {
    final _PdfNumber number = _array[index] as _PdfNumber;
    number.value = value;
  }

  String _styleToString(PdfBorderStyle borderStyle) {
    switch (borderStyle) {
      case PdfBorderStyle.solid:
        return 'S';
        break;
      case PdfBorderStyle.beveled:
        return 'B';
        break;
      case PdfBorderStyle.dashed:
      case PdfBorderStyle.dot:
        return 'D';
        break;
      case PdfBorderStyle.inset:
        return 'I';
        break;
      case PdfBorderStyle.underline:
        return 'U';
        break;
      default:
        return 's';
    }
  }

  @override
  _IPdfPrimitive get _element {
    if (_isLineBorder) {
      return _dictionary;
    } else {
      return _array;
    }
  }

  @override
  set _element(_IPdfPrimitive value) {
    _element = value;
  }
}
