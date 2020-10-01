part of pdf;

class _PdfParser {
  //Constructor
  _PdfParser(_CrossTable cTable, _PdfReader reader, _PdfCrossTable crossTable) {
    ArgumentError.checkNotNull(reader, 'reader');
    ArgumentError.checkNotNull(cTable, 'cTable');
    ArgumentError.checkNotNull(crossTable, 'crossTable');
    _isColorSpace = false;
    _isPassword = false;
    _encrypted = false;
    _reader = reader;
    _cTable = cTable;
    _crossTable = crossTable;
    _lexer = _PdfLexer(reader);
  }

  //Fields
  _CrossTable _cTable;
  _PdfReader _reader;
  _PdfLexer _lexer;
  _TokenType _next;
  _PdfCrossTable _crossTable;
  Queue<int> integerQueue = Queue<int>();
  bool _isPassword;
  bool _isColorSpace;
  bool _encrypted;

  //Implementation
  void _setOffset(int offset) {
    _reader.position = offset;
    if (integerQueue.isNotEmpty) {
      integerQueue = Queue<int>();
    }
    _lexer._reset();
  }

  _PdfNumber _parseInteger() {
    final double value = double.tryParse(_lexer.text);
    _PdfNumber integer;
    if (value != null) {
      integer = _PdfNumber(value);
    } else {
      _error(_ErrorType.badlyFormedInteger, _lexer.text);
    }
    _advance();
    return integer;
  }

  _IPdfPrimitive _number() {
    _IPdfPrimitive obj;
    _PdfNumber integer;
    if (integerQueue.isNotEmpty) {
      integer = _PdfNumber(integerQueue.removeFirst());
    } else {
      _match(_next, _TokenType.number);
      integer = _parseInteger();
    }
    obj = integer;
    if (_next == _TokenType.number) {
      final _PdfNumber integer2 = _parseInteger();
      if (_next == _TokenType.reference) {
        final _PdfReference reference =
            _PdfReference(integer.value.toInt(), integer2.value.toInt());
        obj = _PdfReferenceHolder.fromReference(reference, _crossTable);
        _advance();
      } else {
        integerQueue.addLast(integer2.value.toInt());
      }
    }
    return obj;
  }

  void _parseOldXRef(_CrossTable cTable, Map<int, _ObjectInformation> objects) {
    _advance();
    while (_isSubsection()) {
      cTable._parseSubsection(this, objects);
    }
  }

  bool _isSubsection() {
    bool result = false;
    if (_next == _TokenType.trailer) {
      result = false;
    } else if (_next == _TokenType.number) {
      result = true;
    } else {
      throw ArgumentError.value(result, 'Invalid format');
    }
    return result;
  }

  Map<String, dynamic> _parseCrossReferenceTable(
      Map<int, _ObjectInformation> objects, _CrossTable cTable) {
    _IPdfPrimitive obj;
    _advance();
    if (_next == _TokenType.xRef) {
      _parseOldXRef(cTable, objects);
      obj = _trailer();
      final _PdfDictionary trailerDic = obj as _PdfDictionary;
      if (trailerDic.containsKey('Size')) {
        final int size = (trailerDic['Size'] as _PdfNumber).value.toInt();
        int initialNumber = 0;
        if (cTable._initialSubsectionCount ==
            cTable._initialNumberOfSubsection) {
          initialNumber = cTable._initialNumberOfSubsection;
        } else {
          initialNumber = cTable._initialSubsectionCount;
        }
        int total = 0;
        total = cTable._totalNumberOfSubsection;
        if (size < initialNumber + total &&
            initialNumber > 0 &&
            size == total) {
          final int difference = initialNumber + total - size;
          final Map<int, _ObjectInformation> newObjects =
              <int, _ObjectInformation>{};
          final List<int> keys = objects.keys.toList();
          for (int i = 0; i < keys.length; i++) {
            newObjects[keys[i] - difference] = objects[keys[i]];
          }
          objects = newObjects;
          cTable._objects = newObjects;
        }
      }
    } else {
      obj = _parse();
      objects = cTable._parseNewTable(obj as _PdfStream, objects);
    }
    return <String, dynamic>{'object': obj, 'objects': objects};
  }

  _IPdfPrimitive _trailer() {
    _match(_next, _TokenType.trailer);
    _advance();
    return _dictionary();
  }

  _IPdfPrimitive _parseOffset(int offset) {
    _setOffset(offset);
    _advance();
    return _parse();
  }

  _IPdfPrimitive _parse() {
    _match(_next, _TokenType.number);
    _simple();
    _simple();
    _match(_next, _TokenType.objectStart);
    _advance();
    final _IPdfPrimitive obj = _simple();
    if (_next != _TokenType.objectEnd) {
      _next = _TokenType.objectEnd;
    }
    _match(_next, _TokenType.objectEnd);
    if (!_lexer._skip) {
      _advance();
    } else {
      _lexer._skip = false;
    }
    return obj;
  }

  _IPdfPrimitive _simple() {
    _IPdfPrimitive obj;
    if (integerQueue.isNotEmpty) {
      obj = _number();
    } else {
      switch (_next) {
        case _TokenType.dictionaryStart:
          obj = _dictionary();
          break;
        case _TokenType.arrayStart:
          obj = _array();
          break;
        case _TokenType.hexStringStart:
          obj = _hexString();
          break;
        case _TokenType.string:
          obj = _readString();
          break;
        case _TokenType.unicodeString:
          obj = _readUnicodeString();
          break;
        case _TokenType.name:
          obj = _readName();
          break;
        case _TokenType.boolean:
          obj = _readBoolean();
          break;
        case _TokenType.real:
          obj = _real();
          break;
        case _TokenType.number:
          obj = _number();
          break;
        case _TokenType.nullType:
          obj = _PdfNull();
          _advance();
          break;
        default:
          obj = null;
          break;
      }
    }
    return obj;
  }

  _IPdfPrimitive _real() {
    _match(_next, _TokenType.real);
    final double value = double.tryParse(_lexer.text);
    _PdfNumber real;
    if (value != null) {
      real = _PdfNumber(value);
    } else {
      _error(_ErrorType.badlyFormedReal, _lexer.text);
    }
    _advance();
    return real;
  }

  _IPdfPrimitive _readBoolean() {
    _match(_next, _TokenType.boolean);
    final bool value = _lexer.text == 'true';
    final _PdfBoolean result = _PdfBoolean(value);
    _advance();
    return result;
  }

  _IPdfPrimitive _readName() {
    _match(_next, _TokenType.name);
    final String name = _lexer.text.substring(1);
    final _PdfName result = _PdfName(name);
    _advance();
    return result;
  }

  void _startFrom(int offset) {
    _setOffset(offset);
    _advance();
  }

  void _rebuildXrefTable(
      Map<int, _ObjectInformation> newObjects, _CrossTable crosstable) {
    final _PdfReader reader = _PdfReader(_reader._streamReader._data);
    reader.position = 0;
    newObjects.clear();
    int objNumber = 0;
    int marker = 0;
    List<String> previoursToken = <String>['\u0000'];
    while (true) {
      if (reader.position >= reader.length - 1) {
        break;
      }
      String str = '';
      str = reader._readLine();
      if (str == '') {
        continue;
      }
      final List<String> tokens = str.split('');
      final bool previousObject =
          previoursToken[0].codeUnitAt(0) >= '0'.codeUnitAt(0) &&
              previoursToken[0].codeUnitAt(0) <= '9'.codeUnitAt(0) &&
              tokens.length > 1 &&
              tokens[1].codeUnitAt(0) >= '0'.codeUnitAt(0) &&
              tokens[1].codeUnitAt(0) <= '9'.codeUnitAt(0);
      if (tokens[0].codeUnitAt(0) >= '0'.codeUnitAt(0) &&
              tokens[0].codeUnitAt(0) <= '9'.codeUnitAt(0) ||
          previousObject) {
        if (!previousObject) {
          previoursToken = tokens;
        }
        final List<String> words = str.split(' ');
        if (previousObject && words[0] == '') {
          words[0] = previoursToken[0];
        }
        if (words.length > 2) {
          objNumber = int.tryParse(words[0]);
          if (objNumber != null) {
            marker = int.tryParse(words[1]);
            if (marker != null) {
              if (marker == 0 && words[2] == _DictionaryProperties.obj) {
                final _ObjectInformation objectInfo = _ObjectInformation(
                    _reader.position - tokens.length - 1, null, crosstable);
                if (!newObjects.containsKey(objNumber)) {
                  newObjects[objNumber] = objectInfo;
                }
              }
            }
          }
        }
      }
    }
  }

  _IPdfPrimitive _readString() {
    _match(_next, _TokenType.string);
    String text = _lexer.stringText;
    bool unicode = false;
    if (_isPassword) {
      text = _processEscapes(text, false);
    } else if (!_isColorSpace) {
      if (_checkForPreamble(text)) {
        bool isSkip = false;
        bool isSubstring = false;
        while (
            text.contains('\\') || (isSubstring && text.contains('\u0000'))) {
          if (!isSubstring) {
            text = text.substring(2);
          }
          final String originalText = text.substring(0);
          text = _processEscapes(text, true);
          isSubstring = true;
          isSkip = true;
          if (originalText == text ||
              (text.contains('\\') && text.indexOf('\\') != text.length - 1)) {
            break;
          }
        }
        if (_checkForPreamble(text) && !isSkip) {
          text = _processUnicodeWithPreamble(text);
          unicode = true;
        }
      } else {
        if (!_checkUnicodePreamble(text)) {
          text = _processEscapes(text, false);
        }
        if (_checkForPreamble(text)) {
          text = _processUnicodeWithPreamble(text);
          unicode = true;
        }
      }
    } else {
      if (_isColorSpace) {
        text = _processEscapes(text, false);
      }
      text = 'ColorFound' + text;
    }
    final _PdfString str = _PdfString(text);
    if (!unicode) {
      str.encode = _ForceEncoding.ascii;
    } else {
      str.encode = _ForceEncoding.unicode;
    }
    _advance();
    return str;
  }

  String _processUnicodeWithPreamble(String text) {
    List<int> data = List<int>.filled(text.length - 2, 0);
    int j = 0;
    for (int i = 2; i < text.length; i++) {
      data[j++] = text[i].codeUnitAt(0).toUnsigned(8);
    }
    int textIndex = 0;
    String tempText;
    bool isNewLine = false;
    for (int i = 0; i < data.length - 1; i++) {
      if ((data[i] == 92 &&
              (data[i + 1] == 40 ||
                  data[i + 1] == 41 ||
                  data[i + 1] == 13 ||
                  data[i + 1] == 0x3e ||
                  data[i + 1] == 92)) ||
          data[i] == 13) {
        for (int j = i; j < data.length - 1; j++) {
          data[j] = data[j + 1];
        }
        final List<int> tempSub = List<int>.filled(data.length - 1, 0);
        List.copyRange(tempSub, 0, data, 0, data.length - 1);
        data = tempSub;
        i--;
      } else if (data[i] == 92 && data[i + 1] == 114) {
        final List<int> list = <int>[];
        for (int j = 0; j < i; j++) {
          list.add(data[j]);
        }
        list.add(13);
        for (int j = i + 2; j < data.length; j++) {
          list.add(data[j]);
        }
        data = list;
      } else if (data[i] == 92 && data[i + 1] == 110) {
        isNewLine = true;
        final int tempTextRange = i - 1 - textIndex;
        tempText += _decodeBigEndian(data, textIndex, tempTextRange);
        tempText += '\r\n';
        textIndex = i + 2;
        i += 2;
      }
    }
    final int remaining = data.length - textIndex;
    if (isNewLine) {
      text = tempText;
      text += _decodeBigEndian(data, textIndex, remaining);
    } else {
      text = _decodeBigEndian(data, textIndex, remaining);
    }
    return text;
  }

  _IPdfPrimitive _readUnicodeString([String validateText]) {
    final String text = validateText ?? _lexer.text;
    String value = text.substring(0);
    if (value != null && value.length > 2) {
      value = value.substring(1, value.length - 1);
    }
    if (_checkForPreamble(value)) {
      final String actualText = value.substring(2);
      if (actualText.length >= 3 && actualText[2] == '0') {
        value = _processEscapes(value, false);
      }
    }
    final _PdfString str = _PdfString(value);
    if (!_lexer._skip) {
      _advance();
    } else {
      _next = _TokenType.dictionaryEnd;
    }
    return str;
  }

  bool _checkForPreamble(String text) {
    return text != null &&
        text.length > 1 &&
        text.codeUnitAt(0) == 254 &&
        text.codeUnitAt(1) == 255;
  }

  bool _checkUnicodePreamble(String text) {
    return text != null &&
        text.length > 1 &&
        text.codeUnitAt(0) == 255 &&
        text.codeUnitAt(1) == 254;
  }

  String _processEscapes(String text, bool isComplete) {
    if (!isComplete) {
      text = text.replaceAll('\r', '');
    }
    if (_isPassword) {
      text = text.replaceAll('\n', '');
    }
    String sb = '';
    bool escape = false;
    for (int i = 0; i < text.length; ++i) {
      String c = text[i];

      if (!escape) {
        if (c == '\\') {
          escape = true;
        } else {
          if (c != '\u0000' ||
              _encrypted ||
              _isColorSpace ||
              (c == '\u0000' && _isPassword)) {
            if (isComplete &&
                c.codeUnitAt(0) < 32 &&
                i - 1 >= 0 &&
                text[i - 1] == ' ') {
              final List<int> unicodeBytes = <int>[
                ' '.codeUnitAt(0).toUnsigned(8),
                c.codeUnitAt(0).toUnsigned(8)
              ];
              final String originalText =
                  _decodeBigEndian(unicodeBytes, 0, unicodeBytes.length);
              c = originalText[0];
              sb = sb.substring(0, sb.length - 1);
            }
            sb += c;
          }
        }
      } else {
        switch (c[0]) {
          case 'r':
            sb += '\r';
            break;
          case 'n':
            sb += '\n';
            break;
          case 't':
            sb += '\t';
            break;
          case 'b':
            sb += '\b';
            break;
          case 'f':
            sb += '\f';
            break;
          case '(':
          case ')':
          case '\\':
            sb += c;
            break;
          default:
            if (c.codeUnitAt(0) <= '7'.codeUnitAt(0) &&
                c.codeUnitAt(0) >= '0'.codeUnitAt(0)) {
              final Map<String, dynamic> result = _processOctal(text, i);
              c = result['value'];
              i = result['index'];
              i--;
            }
            final int value = c.codeUnitAt(0);
            if (value < 256) {
              if (isComplete &&
                  (c != '\u0000' ||
                      _encrypted ||
                      _isColorSpace ||
                      (c == '\u0000' && _isPassword))) {
                if (c == '\r' && i + 1 < text.length && text[i + 1] == '\n') {
                  i++;
                } else {
                  sb += c;
                }
              } else {
                sb += c;
              }
            }
            break;
        }
        escape = false;
      }
    }
    return sb;
  }

  Map<String, dynamic> _processOctal(String text, int i) {
    final int length = text.length;
    int count = 0;
    int value = 0;
    String octalText = '';

    while (i < length && count < 3) {
      if (text.codeUnitAt(i) <= '7'.codeUnitAt(0) &&
          text.codeUnitAt(i) >= '0'.codeUnitAt(0)) {
        octalText += text[i];
      }
      ++i;
      ++count;
    }
    value = double.tryParse(octalText).toInt();
    return <String, dynamic>{'value': String.fromCharCode(value), 'index': i};
  }

  _IPdfPrimitive _hexString() {
    _match(_next, _TokenType.hexStringStart);
    _advance();
    String sb = '';
    while (_next != _TokenType.hexStringEnd) {
      String text = _lexer.text;
      if (_next == _TokenType.hexStringWeirdEscape) {
        text = text.substring(1);
      }
      sb += text;
      _advance();
    }
    _match(_next, _TokenType.hexStringEnd);
    _advance();
    final _PdfString result = _PdfString(sb);
    return result;
  }

  _IPdfPrimitive _array() {
    _match(_next, _TokenType.arrayStart);
    _advance();
    _IPdfPrimitive obj;
    final _PdfArray array = _PdfArray();
    _lexer.isArray = true;
    while ((obj = _simple()) != null) {
      array._add(obj);
      if (array[0] is _PdfName && (array[0] as _PdfName)._name == 'Indexed') {
        _isColorSpace = true;
      } else {
        _isColorSpace = false;
      }
      if (_next == _TokenType.unknown) {
        _advance();
      }
    }
    _match(_next, _TokenType.arrayEnd);
    _advance();
    _lexer.isArray = false;
    array.freezeChanges(this);
    return array;
  }

  _IPdfPrimitive _dictionary() {
    _match(_next, _TokenType.dictionaryStart);
    _advance();
    final _PdfDictionary dic = _PdfDictionary();
    _Pair pair = _readPair();
    while (pair != null && pair._name != null && pair._value != null) {
      if (pair._value != null) {
        dic[pair._name] = pair._value;
      }
      pair = _readPair();
    }
    if (_next != _TokenType.dictionaryEnd) {
      _next = _TokenType.dictionaryEnd;
    }
    _match(_next, _TokenType.dictionaryEnd);
    if (!_lexer._skip) {
      _advance();
    } else {
      _next = _TokenType.objectEnd;
      _lexer._skip = false;
    }
    _IPdfPrimitive result;
    if (_next == _TokenType.streamStart) {
      result = _readStream(dic);
    } else {
      result = dic;
    }
    (result as _IPdfChangable).freezeChanges(this);
    return result;
  }

  _IPdfPrimitive _readStream(_PdfDictionary dic) {
    _match(_next, _TokenType.streamStart);
    _lexer._skipToken();
    _lexer._skipNewLine();

    _IPdfPrimitive obj = dic[_DictionaryProperties.length];
    _PdfNumber length;
    _PdfReferenceHolder reference;
    if (obj is _PdfNumber) {
      length = obj;
    }
    if (obj is _PdfReferenceHolder) {
      reference = obj;
    }
    if (length == null && reference == null) {
      final int lexerPosition = _lexer.position;
      final int position = _reader.position;
      _reader.position = lexerPosition;
      final int end = _reader._searchForward('endstream');
      int streamLength;
      if (end > lexerPosition) {
        streamLength = end - lexerPosition;
      } else {
        streamLength = lexerPosition - end;
      }
      _reader.position = position;
      final List<int> buffer = _lexer._readBytes(streamLength);
      final _PdfStream innerStream = _PdfStream(dic, buffer);
      _advance();
      if (_next != _TokenType.streamEnd) {
        _next = _TokenType.streamEnd;
      }
      _match(_next, _TokenType.streamEnd);
      _advance();
      if (_next != _TokenType.objectEnd) {}
      return innerStream;
    } else if (reference != null) {
      final _PdfReferenceHolder reference = obj as _PdfReferenceHolder;
      final _PdfLexer lex = _lexer;
      final int position = _reader.position;
      _lexer = _PdfLexer(_reader);
      obj = _cTable._getObject(reference.reference);
      length = obj as _PdfNumber;
      _reader.position = position;
      _lexer = lex;
    }
    final int intLength = length.value.toInt();
    final bool check = _checkStreamLength(_lexer.position, intLength);
    _PdfStream stream;
    if (check) {
      final List<int> buf = _lexer._readBytes(intLength);
      stream = _PdfStream(dic, buf);
    } else {
      final int lexerPosition = _lexer.position;
      final int position = _reader.position;
      _reader.position = lexerPosition;
      final int end = _reader._searchForward('endstream');
      int streamLength;
      if (end > lexerPosition) {
        streamLength = end - lexerPosition;
      } else {
        streamLength = lexerPosition - end;
      }
      _reader.position = position;
      final List<int> buf = _lexer._readBytes(streamLength);
      stream = _PdfStream(dic, buf);
    }
    _advance();
    if (_next != _TokenType.streamEnd) {
      _next = _TokenType.streamEnd;
    }
    _match(_next, _TokenType.streamEnd);
    _advance();
    if (_next != _TokenType.objectEnd) {
      _next = _TokenType.objectEnd;
    }
    return stream;
  }

  String _getObjectFlag() {
    _match(_next, _TokenType.objectType);
    final String type = _lexer.text[0];
    _advance();
    return type;
  }

  bool _checkStreamLength(int lexPosition, int value) {
    String line = '';
    bool check = true;
    final int position = _reader.position;
    _reader.position = lexPosition + value;
    final List<String> buff = List<String>.filled(20, '');
    _reader._readBlock(buff, 0, 20);
    for (int i = 0; i < buff.length; i++) {
      line += buff[i];
    }
    if (!line.startsWith('\nendstream') &&
        !line.startsWith('\r\nendstream') &&
        !line.startsWith('\rendstream') &&
        !line.startsWith('endstream')) {
      check = false;
    }
    _reader.position = position;
    return check;
  }

  _Pair _readPair() {
    _IPdfPrimitive obj;
    try {
      obj = _simple();
    } catch (e) {
      obj = null;
    }
    if (obj == null) {
      return _Pair.empty;
    }
    final _PdfName name = obj as _PdfName;
    if (name == null) {
      _error(_ErrorType.badlyFormedDictionary, 'next should be a name.');
    }
    if (name._name == _DictionaryProperties.u ||
        name._name == _DictionaryProperties.o) {
      _isPassword = true;
    }
    obj = _simple();
    _isPassword = false;
    return _Pair(name, obj);
  }

  int startCrossReference() {
    _advance();
    _match(_next, _TokenType.startXRef);
    _advance();
    final _PdfNumber number = _number() as _PdfNumber;
    if (number != null) {
      return number.value.toInt();
    } else {
      return 0;
    }
  }

  void _match(_TokenType token, _TokenType match) {
    if (token != match) {
      _error(_ErrorType.unexpected, token.toString());
    }
  }

  void _error(_ErrorType error, String additional) {
    String message;

    switch (error) {
      case _ErrorType.unexpected:
        message = 'Unexpected token ';
        break;

      case _ErrorType.badlyFormedReal:
        message = 'Badly formed real number ';
        break;

      case _ErrorType.badlyFormedInteger:
        message = 'Badly formed integer number ';
        break;

      case _ErrorType.unknownStreamLength:
        message = 'Unknown stream length';
        break;

      case _ErrorType.badlyFormedDictionary:
        message = 'Badly formed dictionary ';
        break;

      case _ErrorType.none:
      case _ErrorType.badlyFormedHexString:
      default:
        message = 'Internal error.';
        break;
    }

    if (additional != null) {
      message = message + additional + ' before ' + _lexer.position.toString();
    }

    throw ArgumentError.value(error, message);
  }

  void _advance() {
    if (_cTable != null && _cTable.validateSyntax) {
      _lexer._getNextToken();
    }
    _next = _lexer._getNextToken();
  }
}

enum _ErrorType {
  none,
  unexpected,
  badlyFormedReal,
  badlyFormedInteger,
  badlyFormedHexString,
  badlyFormedDictionary,
  unknownStreamLength,
}

class _Pair {
  //constructor
  _Pair(_PdfName name, _IPdfPrimitive value) {
    _name = name;
    _value = value;
  }

  static _Pair get empty => _Pair(null, null);

  //Fields
  _PdfName _name;
  _IPdfPrimitive _value;
}
