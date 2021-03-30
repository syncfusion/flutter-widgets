part of pdf;

class _PdfReader {
  //Constructor
  _PdfReader(List<int>? data) {
    _streamReader = _StreamReader(data);
    _peekedByte = 0;
    _bytePeeked = false;
    _delimiters = '()<>[]{}/%';
  }

  //Fields
  late _StreamReader _streamReader;
  late String _delimiters;
  final List<String> _spaceCharacters = <String>[
    '\u0020',
    '\u00a0',
    '\u1680',
    '\u2000',
    '\u2001',
    '\u2002',
    '\u2003',
    '\u2004',
    '\u2005',
    '\u2006',
    '\u2007',
    '\u2008',
    '\u2009',
    '\u200a',
    '\u202f',
    '\u205f',
    '\u3000',
    '\u2028',
    '\u2029',
    '\u0009',
    '\u000a',
    '\u000b',
    '\u000c',
    '\u000d',
    '\u0085'
  ];
  late int _peekedByte;
  late bool _bytePeeked;

  //Properties
  int get position => _streamReader.position;
  set position(int value) {
    _streamReader.position = value;
  }

  int? get length => _streamReader.length;

  //Implementation
  void _skipWhiteSpace() {
    if (position != _streamReader.length) {
      int value;
      do {
        value = _read();
      } while (
          value != -1 && _spaceCharacters.contains(String.fromCharCode(value)));
      position = value == -1 ? _streamReader.length! : (position - 1);
    }
  }

  int _skipWhiteSpaceBack() {
    if (position == 0) {
      throw ArgumentError.value(position, 'Invalid PDF Document Format');
    }
    position -= 1;
    while (_spaceCharacters.contains(String.fromCharCode(_read()))) {
      position -= 2;
    }
    return position;
  }

  int _read() {
    int? value = 0;
    if (_bytePeeked) {
      value = _getPeeked(value);
    } else {
      value = _streamReader.readByte();
    }
    return value!;
  }

  List<int> _readBytes(int length) {
    final List<int> bytes = List<int>.filled(length, 0, growable: true);
    for (int i = 0; i < length; i++) {
      bytes[i] = _read();
    }
    return bytes;
  }

  int _readBlock(List<String> buffer, int index, int count) {
    if (count < 0) {
      throw ArgumentError.value(count, 'The value cannot be less then zero');
    }
    int i = index;
    if (_bytePeeked && count > 0) {
      buffer[i] = String.fromCharCode(_peekedByte);
      _bytePeeked = false;
      --count;
      ++i;
    }
    if (count > 0) {
      final List<int> buf = List<int>.filled(count, 0);
      int tempCount = 0;
      for (int j = 0; j < count && position < length!; j++) {
        buf[j] = _read();
        tempCount++;
      }
      count = tempCount;
      for (int k = 0; k < count; ++k) {
        final String ch = String.fromCharCode(buf[k]);
        buffer[i + k] = ch;
      }
      i += count;
    }
    return i - index;
  }

  String _readLine() {
    String line = '';
    int character;
    character = _read();
    while (character != -1 && !_isEol(String.fromCharCode(character))) {
      line += String.fromCharCode(character);
      character = _read();
    }
    if (character == 13) {
      if (String.fromCharCode(_read()) != '\n') {
        position -= 1;
      }
    }
    return line;
  }

  bool _isEol(String character) {
    return character == '\n' || character == '\r';
  }

  int readData(List<int>? buffer, int index, int count) {
    if (count < 0) {
      throw ArgumentError.value(count, 'The value can\'t be less then zero');
    }
    int i = index;
    if (_bytePeeked && count > 0) {
      buffer![i] = _peekedByte;
      _bytePeeked = false;
      --count;
      ++i;
    }
    if (count > 0) {
      if (position == length) {
        count = 0;
      } else {
        final int lp = length! - position;
        count = count > lp ? lp : count;
        final List<int> bytes = _readBytes(count);
        for (int j = 0; j < count; j++) {
          buffer![i + j] = bytes[j];
        }
      }
      i += count;
    }
    return i - index;
  }

  Map<String, dynamic> _copyBytes(List<int>? buffer, int index, int count) {
    if (index < 0 || index > buffer!.length) {
      throw ArgumentError.value(index, 'Invalid index to read');
    }
    final int pos = position;
    for (int i = pos;
        i < length! && i < (pos + count) && index < buffer.length;
        i++) {
      buffer[index] = _read();
      index++;
    }
    return <String, dynamic>{'next': index, 'buffer': buffer};
  }

  String _readBack(int length) {
    if (position < length) {
      throw ArgumentError.value(position, 'Invalid PDF Document Format');
    }
    position -= length;
    return String.fromCharCodes(_readBytes(length));
  }

  int? _seekEnd() {
    return _streamReader.length;
  }

  int _searchBack(String token) {
    int pos = position;
    position = _skipWhiteSpaceBack();
    if (position < token.length) {
      return -1;
    }
    String str = _readBack(token.length);
    pos = position - token.length;
    while (str != token) {
      if (pos < 0) {
        throw ArgumentError.value(pos, 'Invalid PDF Document Format');
      }
      position -= 1;
      if (position < token.length) {
        return -1;
      }
      str = _readBack(token.length);
      pos = position - token.length;
    }
    while (token == _Operators.crossReference) {
      final int xrefPos = pos;
      final int startPos = _searchBack(_Operators.startCrossReference);
      if (startPos == xrefPos - 5) {
        str = _Operators.startCrossReference;
        while (str != token) {
          if (pos < 0) {
            throw ArgumentError.value(pos, 'Invalid PDF Document Format');
          }
          position -= 1;
          if (position < token.length) {
            return -1;
          }
          str = _readBack(token.length);
          pos = position - token.length;
        }
      } else {
        pos = xrefPos;
        break;
      }
    }
    position = pos;
    return pos;
  }

  int _searchForward(String token) {
    List<int>? buf = List<int>.filled(token.length, 0);
    bool isStartXref = false;
    while (true) {
      int pos = position;
      final int character = _read();
      buf![0] = character.toUnsigned(8);
      if (buf[0] == token.codeUnitAt(0)) {
        if (!isStartXref) {
          pos = position - 1;
          final Map<String, dynamic> result =
              _copyBytes(buf, 1, token.length - 1);
          final int length = result['next'];
          buf = result['buffer'];
          position = pos;
          if (length < token.length - 1) {
            return -1;
          } else if (token == String.fromCharCodes(buf!)) {
            return pos;
          } else {
            position += 1;
          }
        }
      } else if (buf[0] == _Operators.startCrossReference.codeUnitAt(0)) {
        isStartXref = false;
        pos = position - 1;
        position = pos;
        int newPosition = pos;
        List<int>? buff =
            List<int>.filled(_Operators.startCrossReference.length, 0);
        final Map<String, dynamic> result =
            _copyBytes(buff, 1, _Operators.startCrossReference.length);
        buff = result['buffer'];
        if (_Operators.startCrossReference == String.fromCharCodes(buff!)) {
          isStartXref = true;
          position = ++newPosition;
        }
      } else if (character == -1) {
        return -1;
      }
    }
  }

  int _getPeeked(int? byteValue) {
    if (_bytePeeked) {
      _bytePeeked = false;
      byteValue = _peekedByte;
    } else {
      byteValue = 0;
    }
    return byteValue;
  }

  String _getEqualChar(int? charCode) {
    return charCode == -1 ? '\uffff' : String.fromCharCode(charCode!);
  }

  String? _getNextToken() {
    String? token = '';
    int? character = 0;
    _skipWhiteSpace();
    character = _peek();
    if (_isDelimiter(_getEqualChar(character))) {
      final Map<String, dynamic> result = _appendChar(token);
      character = result['character'];
      token = result['token'];
      return token;
    }
    while (character != -1 &&
        !_isSeparator(_getEqualChar(character)) &&
        token != '\u0000') {
      final Map<String, dynamic> result = _appendChar(token);
      character = result['character'];
      token = result['token'];
      character = _peek();
    }
    return token;
  }

  Map<String, dynamic> _appendChar(String? token) {
    final int character = _read();
    if (character != -1) {
      token = token! + String.fromCharCode(character);
    }
    final Map<String, dynamic> result = <String, dynamic>{};
    result['token'] = token;
    result['character'] = character;
    return result;
  }

  int _peek() {
    int? value = 0;
    if (_bytePeeked) {
      value = _getPeeked(value);
    } else {
      _peekedByte = _read();
      value = _peekedByte;
    }
    if (_peekedByte != -1) {
      _bytePeeked = true;
    }
    return value;
  }

  bool _isDelimiter(String character) {
    for (int index = 0; index < _delimiters.length; index++) {
      if (_delimiters[index] == character) {
        return true;
      }
    }
    return false;
  }

  bool _isSeparator(String character) {
    return _spaceCharacters.contains(character) || _isDelimiter(character);
  }
}
