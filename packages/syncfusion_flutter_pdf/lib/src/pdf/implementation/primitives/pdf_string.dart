part of pdf;

class _PdfString implements _IPdfPrimitive {
  _PdfString(String value) {
    ArgumentError.checkNotNull(value, 'value');
    if (value.isEmpty) {
      this.value = '';
    } else {
      this.value = value;
      data = <int>[];
      for (int i = 0; i < value.length; i++) {
        data.add(value.codeUnitAt(i).toUnsigned(8));
      }
    }
    _isHex = false;
  }

  _PdfString.fromBytes(List<int> value) {
    ArgumentError.checkNotNull(value, 'value');
    if (value.isEmpty) {
      throw ArgumentError.value(value, 'value is empty');
    } else {
      data = value;
      this.value = String.fromCharCodes(data);
    }
    _isHex = true;
  }

  //Constants
  static const String stringMark = '()';
  static const String hexStringMark = '<>';

  //Fields
  List<int> data;
  String value;
  bool isAsciiEncode = false;
  bool _isSaving;
  int _objectCollectionIndex;
  int _position;
  _ObjectStatus _status;
  bool _isHex;
  _ForceEncoding encode = _ForceEncoding.none;

  //Implementations
  List<int> _pdfEncode() {
    List<int> result = <int>[];
    result.add(_isHex
        ? _PdfString.hexStringMark.codeUnitAt(0)
        : _PdfString.stringMark.codeUnitAt(0));
    if (_isHex) {
      result.addAll(_getHexBytes(data));
    } else if (isAsciiEncode) {
      final List<int> data = _escapeSymbols(value);
      for (int i = 0; i < data.length; i++) {
        result.add(data[i].toUnsigned(8));
      }
    } else if (utf8.encode(value).length != value.length) {
      result = _toUnicodeArray(value, true);
      result = _escapeSymbols(result);
      result.insert(
          0,
          _isHex
              ? _PdfString.hexStringMark.codeUnitAt(0)
              : _PdfString.stringMark.codeUnitAt(0));
    } else {
      for (int i = 0; i < value.length; i++) {
        result.add(value.codeUnitAt(i).toUnsigned(8));
      }
    }
    result.add(_isHex
        ? _PdfString.hexStringMark.codeUnitAt(1)
        : _PdfString.stringMark.codeUnitAt(1));
    return result;
  }

  List<int> _getHexBytes(List<int> data) {
    final List<int> result = <int>[];
    for (int i = 0; i < data.length; i++) {
      String radix = data[i].toRadixString(16);
      radix = (radix.length == 1 ? '0' + radix : radix).toUpperCase();
      result.add(radix.codeUnitAt(0).toUnsigned(8));
      result.add(radix.codeUnitAt(1).toUnsigned(8));
    }
    return result;
  }

  /// Converts string to array of unicode symbols.
  static List<int> toUnicodeArray(String value) {
    ArgumentError.checkNotNull(value);
    final List<int> data = <int>[];
    for (int i = 0; i < value.length; i++) {
      final int code = value.codeUnitAt(i);
      data.add(code ~/ 256 >> 0);
      data.add(code & 0xff);
    }
    return data;
  }

  static List<int> _escapeSymbols(dynamic value) {
    if (value == null) {
      throw ArgumentError.value(value, 'value', 'value cannot be null');
    }
    final List<int> data = <int>[];
    int code = 0;
    for (int i = 0; i < value.length; i++) {
      if (value is String) {
        code = value.codeUnitAt(i);
      } else if (value is List<int>) {
        code = value[i];
      }
      switch (code) {
        case 40:
        case 41:
          data.add(92);
          data.add(code);
          break;
        case 13:
          data.add(92);
          data.add(114);
          break;
        case 92:
          data.add(92);
          data.add(code);
          break;

        default:
          data.add(code);
          break;
      }
    }
    return data;
  }

  static List<int> _toUnicodeArray(String value, bool addPrefix) {
    ArgumentError.checkNotNull(value);
    final List<int> output = <int>[];
    if (addPrefix) {
      output.add(254);
      output.add(255);
    }
    for (int i = 0; i < value.length; i++) {
      final int code = value.codeUnitAt(i);
      output.add(code ~/ (256 >> 0));
      output.add(code & 0xff);
    }
    return output;
  }

  static String _byteToString(List<int> data, [int length]) {
    ArgumentError.checkNotNull(data);
    length ??= data.length;
    if (length > data.length) {
      ArgumentError.value(length);
    }
    return String.fromCharCodes(data, 0, length);
  }

  //_IPdfPrimitive members
  @override
  bool get isSaving {
    _isSaving ??= false;
    return _isSaving;
  }

  @override
  set isSaving(bool value) {
    _isSaving = value;
  }

  @override
  int get objectCollectionIndex {
    _objectCollectionIndex ??= 0;
    return _objectCollectionIndex;
  }

  @override
  set objectCollectionIndex(int value) {
    _objectCollectionIndex = value;
  }

  @override
  int get position {
    _position ??= -1;
    return _position;
  }

  @override
  set position(int value) {
    _position = value;
  }

  @override
  _ObjectStatus get status {
    _status ??= _ObjectStatus.none;
    return _status;
  }

  @override
  set status(_ObjectStatus value) {
    _status = value;
  }

  @override
  _IPdfPrimitive clonedObject;

  @override
  void save(_IPdfWriter writer) {
    ArgumentError.checkNotNull(writer, 'writer');
    writer._write(_pdfEncode());
  }

  @override
  void dispose() {
    if (data != null) {
      data.clear();
      data = null;
    }
    if (_status != null) {
      _status = null;
    }
  }
}

enum _ForceEncoding { none, ascii, unicode }
