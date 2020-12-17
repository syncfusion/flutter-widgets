part of pdf;

class _PdfString implements _IPdfPrimitive {
  _PdfString(String value, [bool encrypted]) {
    ArgumentError.checkNotNull(value, 'value');
    if (encrypted != null) {
      if (!encrypted && value.isNotEmpty) {
        data = _hexToBytes(value);
        if (data.isNotEmpty) {
          this.value = _byteToString(data);
        }
      } else {
        this.value = value;
      }
      _isHex = true;
    } else {
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
    decrypted = false;
    isParentDecrypted = false;
  }

  _PdfString.fromBytes(List<int> value) {
    ArgumentError.checkNotNull(value, 'value');
    data = value;
    if (value.isNotEmpty) {
      this.value = String.fromCharCodes(data);
    }
    _isHex = true;
    decrypted = false;
    isParentDecrypted = false;
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
  _PdfCrossTable _crossTable;
  _PdfString _clonedObject;
  bool isParentDecrypted;

  //Implementations
  List<int> _pdfEncode(PdfDocument document) {
    final List<int> result = <int>[];
    result.add(_isHex
        ? _PdfString.hexStringMark.codeUnitAt(0)
        : _PdfString.stringMark.codeUnitAt(0));
    List<int> tempData;
    bool needStartMark = false;
    if (_isHex) {
      tempData = _getHexBytes(data);
    } else if (isAsciiEncode) {
      final List<int> data = _escapeSymbols(value);
      tempData = <int>[];
      for (int i = 0; i < data.length; i++) {
        tempData.add(data[i].toUnsigned(8));
      }
    } else if (utf8.encode(value).length != value.length) {
      tempData = _toUnicodeArray(value, true);
      tempData = _escapeSymbols(result);
      needStartMark = true;
    } else {
      tempData = <int>[];
      for (int i = 0; i < value.length; i++) {
        tempData.add(value.codeUnitAt(i).toUnsigned(8));
      }
    }
    bool hex = false;
    tempData = _encryptIfNeeded(tempData, document);
    for (int i = 0; i < tempData.length; i++) {
      if ((tempData[i] >= 48 && tempData[i] <= 57) ||
          (tempData[i] >= 65 && tempData[i] <= 70) ||
          (tempData[i] >= 97 && tempData[i] <= 102)) {
        hex = true;
      } else {
        hex = false;
        break;
      }
    }
    if (_isHex && !hex) {
      tempData = _getHexBytes(tempData);
    }
    result.addAll(tempData);
    if (needStartMark) {
      result.insert(
          0,
          _isHex
              ? _PdfString.hexStringMark.codeUnitAt(0)
              : _PdfString.stringMark.codeUnitAt(0));
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

  List<int> _hexToBytes(String value) {
    final List<int> hexNumbers = <int>[];
    for (int i = 0; i < value.length; i++) {
      final int charCode = value.codeUnitAt(i);
      if ((charCode >= 48 && charCode <= 57) ||
          (charCode >= 65 && charCode <= 70) ||
          (charCode >= 97 && charCode <= 102)) {
        hexNumbers.add(_parseHex(charCode));
      }
    }
    return _hexDigitsToNumbers(hexNumbers);
  }

  List<int> _hexDigitsToNumbers(List<int> hexNumbers) {
    int value = 0;
    bool start = true;
    final List<int> list = <int>[];
    hexNumbers.forEach((int digit) {
      if (start) {
        value = (digit << 4).toUnsigned(8);
        start = false;
      } else {
        value += digit;
        list.add(value);
        start = true;
      }
    });
    if (!start) {
      list.add(value);
    }
    return list;
  }

  int _parseHex(int c) {
    int value = 0;
    if (c >= 48 && c <= 57) {
      value = (c - 48).toUnsigned(8);
    } else if (c >= 65 && c <= 70) {
      value = (c - 55).toUnsigned(8);
    } else if (c >= 97 && c <= 102) {
      value = (c - 87).toUnsigned(8);
    }
    return value;
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
    writer._write(_pdfEncode(writer._document));
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

  @override
  _IPdfPrimitive _clone(_PdfCrossTable crossTable) {
    if (_clonedObject != null && _clonedObject._crossTable == crossTable) {
      return _clonedObject;
    } else {
      _clonedObject = null;
    }
    final _PdfString newString = _PdfString(value);
    newString.encode = encode;
    newString._isHex = _isHex;
    newString._crossTable = crossTable;
    _clonedObject = newString;
    return newString;
  }

  List<int> _encryptIfNeeded(List<int> data, PdfDocument document) {
    ArgumentError.checkNotNull(data, 'value cannor be null');
    final PdfSecurity security = (document == null) ? null : document.security;
    if (security == null || !security._encryptor.encrypt) {
      return data;
    } else {
      data = security._encryptor
          ._encryptData(document._currentSavingObject._objNum, data, true);
    }
    return _escapeSymbols(data);
  }

  bool decrypted;
  void decrypt(_PdfEncryptor encryptor, int currentObjectNumber) {
    if (encryptor != null && !decrypted && !isParentDecrypted) {
      decrypted = true;
      value = _byteToString(data);
      final List<int> bytes =
          encryptor._encryptData(currentObjectNumber, data, false);
      value = _byteToString(bytes);
      data = bytes;
    }
  }
}

enum _ForceEncoding { none, ascii, unicode }
