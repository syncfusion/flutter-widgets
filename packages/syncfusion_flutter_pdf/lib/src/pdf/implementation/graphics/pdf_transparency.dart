part of pdf;

class _PdfTransparency implements _IPdfWrapper {
  //Constructor
  _PdfTransparency(double stroke, double fill, PdfBlendMode mode) {
    _dictionary = _PdfDictionary();
    if (stroke < 0) {
      throw ArgumentError.value(
          stroke, 'stroke', 'The value cannot be less then zero.');
    }

    if (fill < 0) {
      throw ArgumentError.value(
          fill, 'fill', 'The value cannot be less then zero.');
    }
    _dictionary[_DictionaryProperties.stroke] = _PdfNumber(stroke);
    _dictionary[_DictionaryProperties.fill] = _PdfNumber(fill);
    _dictionary[_DictionaryProperties.bm] = _PdfName(_getBlendMode(mode));
  }

  //Fields
  _PdfDictionary _dictionary;

  //Properties
  double get stroke => _getNumber(_DictionaryProperties.stroke);
  double get fill => _getNumber(_DictionaryProperties.fill);

  //Implementation
  double _getNumber(String keyName) {
    double result = 0;
    if (_dictionary.containsKey(keyName) &&
        _dictionary[keyName] is _PdfNumber) {
      final _PdfNumber numb = _dictionary[keyName];
      result = numb.value;
    }
    return result;
  }

  String _getBlendMode(PdfBlendMode mode) {
    switch (mode) {
      case PdfBlendMode.multiply:
        return 'Multiply';
      case PdfBlendMode.screen:
        return 'Screen';
      case PdfBlendMode.overlay:
        return 'Overlay';
      case PdfBlendMode.darken:
        return 'Darken';
      case PdfBlendMode.lighten:
        return 'Lighten';
      case PdfBlendMode.colorDodge:
        return 'ColorDodge';
      case PdfBlendMode.colorBurn:
        return 'ColorBurn';
      case PdfBlendMode.hardLight:
        return 'HardLight';
      case PdfBlendMode.softLight:
        return 'SoftLight';
      case PdfBlendMode.difference:
        return 'Difference';
      case PdfBlendMode.exclusion:
        return 'Exclusion';
      case PdfBlendMode.hue:
        return 'Hue';
      case PdfBlendMode.saturation:
        return 'Saturation';
      case PdfBlendMode.color:
        return 'Color';
      case PdfBlendMode.luminosity:
        return 'Luminosity';
      default:
        return 'Normal';
    }
  }

  //_IPdfWrapper elements
  @override
  _IPdfPrimitive get _element => _dictionary;
  @override
  // ignore: unused_element
  set _element(_IPdfPrimitive value) {
    _dictionary = value;
  }
}
