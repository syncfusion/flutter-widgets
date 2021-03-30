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
      [double? borderWidth,
      double? horizontalRadius,
      double? verticalRadius,
      PdfBorderStyle? borderStyle,
      int? dashArray]) {
    _array._add(_PdfNumber(0));
    _array._add(_PdfNumber(0));
    _array._add(_PdfNumber(1));
    this.horizontalRadius = horizontalRadius ??= 0;
    width = borderWidth ??= 1;
    this.verticalRadius = verticalRadius ??= 0;
    _borderStyle = borderStyle ??= PdfBorderStyle.solid;
    _dictionary._setName(
        _PdfName(_DictionaryProperties.s), _styleToString(_borderStyle));
    if (dashArray != null) {
      this.dashArray = dashArray;
    }
  }

  PdfAnnotationBorder._asWidgetBorder() {
    _dictionary.setProperty(
        _DictionaryProperties.type, _PdfName(_DictionaryProperties.border));
    _borderStyle = PdfBorderStyle.solid;
    _dictionary._setName(
        _PdfName(_DictionaryProperties.s), _styleToString(_borderStyle));
    _isWidgetBorder = true;
  }

  // fields
  double _horizontalRadius = 0;
  double _verticalRadius = 0;
  double _borderWidth = 1;
  int? _dashArray;
  late PdfBorderStyle _borderStyle;
  bool _isLineBorder = false;
  bool _isWidgetBorder = false;
  final _PdfDictionary _dictionary = _PdfDictionary();
  final _PdfArray _array = _PdfArray();

  // properties
  /// Gets or sets the horizontal corner radius of the annotations.
  double get horizontalRadius => _horizontalRadius;

  set horizontalRadius(double value) {
    if (value != _horizontalRadius) {
      _horizontalRadius = value;
      _setNumber(0, value);
    }
  }

  /// Gets or sets the vertical corner radius of the annotation.
  double get verticalRadius => _verticalRadius;

  set verticalRadius(double value) {
    if (value != _verticalRadius) {
      _verticalRadius = value;
      _setNumber(1, value);
    }
  }

  /// Gets or sets the width of annotation's border.
  double get width => _borderWidth;

  set width(double value) {
    if (value != _borderWidth) {
      _borderWidth = value;
      if (!_isWidgetBorder) {
        _setNumber(2, value);
      }
      _dictionary._setNumber(_DictionaryProperties.w, _borderWidth.toInt());
    }
  }

  /// Gets or sets the border style.
  PdfBorderStyle get borderStyle => _borderStyle;

  set borderStyle(PdfBorderStyle value) {
    if (value != _borderStyle) {
      _borderStyle = value;
      _dictionary._setName(
          _PdfName(_DictionaryProperties.s), _styleToString(_borderStyle));
    }
  }

  /// Gets or sets the line dash of the annotation.
  int? get dashArray => _dashArray;

  set dashArray(int? value) {
    if (value != null && _dashArray != value) {
      _dashArray = value;
      final _PdfArray dasharray = _PdfArray();
      dasharray._add(_PdfNumber(_dashArray!));
      dasharray._add(_PdfNumber(_dashArray!));
      _dictionary.setProperty(_DictionaryProperties.d, dasharray);
    }
  }

  void _setNumber(int index, double value) {
    final _PdfNumber number = _array[index] as _PdfNumber;
    number.value = value;
  }

  String _styleToString(PdfBorderStyle? borderStyle) {
    switch (borderStyle) {
      case PdfBorderStyle.beveled:
        return 'B';
      case PdfBorderStyle.dashed:
      case PdfBorderStyle.dot:
        return 'D';
      case PdfBorderStyle.inset:
        return 'I';
      case PdfBorderStyle.underline:
        return 'U';
      default:
        return 'S';
    }
  }

  @override
  _IPdfPrimitive get _element {
    if (_isLineBorder || _isWidgetBorder) {
      return _dictionary;
    } else {
      return _array;
    }
  }

  @override
  // ignore: unused_element
  set _element(_IPdfPrimitive? value) {
    _element = value;
  }
}
