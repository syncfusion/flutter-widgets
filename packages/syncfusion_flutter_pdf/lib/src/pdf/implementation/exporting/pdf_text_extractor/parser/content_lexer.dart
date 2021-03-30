part of pdf;

class _ContentLexer {
  // Constructor
  _ContentLexer(List<int>? contentStream) {
    _contentStream = contentStream;
    _operatorParams = StringBuffer();
  }

  // fields
  List<int>? _contentStream;
  StringBuffer? _operatorParams;
  String _currentChar = '0';
  String _nextChar = '0';
  int _charPointer = 0;
  bool _isArtifactContentEnds = false;
  bool _isContainsArtifacts = false;
  bool _isContentEnded = false;

  // Implementation
  _PdfTokenType _getNextToken() {
    _resetToken();
    final String ch = String.fromCharCode(int.parse(_moveToNextChar()));
    switch (ch) {
      case '%':
        return _getComment();

      case '/':
        return _getName();

      case '+':
      case '-':
        return _getNumber();

      case '[':

      case '(':
        return _getLiteralString();

      case '<':
        return _getHexadecimalString();

      case '.':
        return _getNumber();

      case '"':
      case '\'':
        return _getOperator();
    }
    if (isDigit(ch)) {
      return _getNumber();
    }

    if (isLetter(ch)) {
      return _getOperator();
    }

    if (ch == '65535') {
      return _PdfTokenType.eof;
    }

    return _PdfTokenType.nullType;
  }

  bool isDigit(String s, [int idx = 0]) => (s.codeUnitAt(idx) ^ 0x30) <= 9;

  bool isLetter(String s) {
    if (s.contains(RegExp(r'[A-Z]')) || s.contains(RegExp(r'[a-z]'))) {
      return true;
    } else {
      return false;
    }
  }

  void _resetToken() {
    _operatorParams!.clear();
  }

  String _moveToNextChar() {
    while (_currentChar != '65535') {
      switch (_currentChar) {
        case '0':
        case '9':
        case '10':
        case '12':
        case '13':
        case '8':
        case '32':
        case '20':
          _getNextChar(); // line feeds and spaces
          break;

        default:
          return _currentChar;
      }
    }
    return _currentChar;
  }

  String _getNextChar([bool value = false]) {
    if (value) {
      return _nextChar;
    }
    if (_contentStream!.length <= _charPointer) {
      if (_nextChar == '81' || (_currentChar == '68' && _nextChar == '111')) {
        _currentChar = _nextChar;
        _nextChar = '65535';
        return _currentChar;
      }
      _currentChar = '65535';
      _nextChar = '65535';
    } else {
      _currentChar = _nextChar;
      _nextChar = _contentStream![_charPointer++].toString();
      if (_currentChar == '13') {
        if (_nextChar == '10') {
          _currentChar = _nextChar;
          if (_contentStream!.length <= _charPointer) {
            _nextChar = '65535';
          } else {
            _nextChar = _contentStream![_charPointer++].toString();
          }
        } else {
          _currentChar = '10';
        }
      }
    }
    return _currentChar;
  }

  _PdfTokenType _getComment() {
    _resetToken();
    String ch;
    while ((ch = _consumeValue()) != '10' && ch != '65535') {}
    return _PdfTokenType.comment;
  }

  _PdfTokenType _getName() {
    _resetToken();
    while (true) {
      final String ch = _consumeValue();
      if (_isWhiteSpace(ch) || _isDelimiter(ch)) {
        break;
      }
    }
    return _PdfTokenType.name;
  }

  _PdfTokenType _getNumber() {
    String ch = _currentChar;
    if (ch == '43' || ch == '45') {
      _operatorParams!.write(String.fromCharCode(int.parse(_currentChar)));
      ch = _getNextChar();
    }
    while (true) {
      if (isDigit(String.fromCharCode(int.parse(ch)))) {
        _operatorParams!.write(String.fromCharCode(int.parse(_currentChar)));
      } else if (ch == '46') {
        _operatorParams!.write(String.fromCharCode(int.parse(_currentChar)));
      } else {
        break;
      }
      ch = _getNextChar();
    }
    return _PdfTokenType.integer;
  }

  String _consumeValue() {
    final String data = String.fromCharCode(int.parse(_currentChar));
    _operatorParams!.write(data);
    if (_isContainsArtifacts &&
        _operatorParams.toString().contains('/Contents') &&
        !_isContentEnded) {
      _isArtifactContentEnds = true;
      if (String.fromCharCode(int.parse(_nextChar)) == ')' &&
          String.fromCharCode(int.parse(_currentChar)) != '\\') {
        _isArtifactContentEnds = false;
        _isContentEnded = true;
      }
    }
    return _getNextChar();
  }

  _PdfTokenType _getLiteralString() {
    String beginChar;
    _resetToken();

    if (String.fromCharCode(int.parse(_currentChar)) == '(') {
      beginChar = _currentChar;
    } else {
      beginChar = _currentChar;
    }
    String literal;
    String ch = _consumeValue();
    while (true) {
      if (String.fromCharCode(int.parse(beginChar)) == '(') {
        literal = _getLiterals(ch);
        _operatorParams!.write(literal);
        ch = String.fromCharCode(int.parse(_getNextChar()));
        break;
      } else {
        if (String.fromCharCode(int.parse(ch)) == '(') {
          ch = _consumeValue();
          literal = _getLiterals(ch);
          _operatorParams!.write(literal);
          ch = _getNextChar();
          continue;
        } else if (String.fromCharCode(int.parse(ch)) == ']') {
          ch = _consumeValue();
          break;
        }
        ch = _consumeValue();
      }
    }
    return _PdfTokenType.string;
  }

  String _getLiterals(String ch) {
    int parenthesesCount = 0;
    String literal = '';
    while (true) {
      ch = String.fromCharCode(int.parse(ch));
      if (ch == '\\') {
        literal += ch;
        ch = String.fromCharCode(int.parse(_getNextChar()));
        literal += ch;
        ch = _getNextChar();
        continue;
      }

      if (ch == '(') {
        parenthesesCount++;
        literal += ch;
        ch = _getNextChar();
        continue;
      }

      if (ch == ')' && parenthesesCount != 0) {
        literal += ch;
        ch = _getNextChar();
        parenthesesCount--;
        continue;
      }

      if (ch == ')' && parenthesesCount == 0) {
        literal += ch;
        return literal;
      }
      literal += ch;
      ch = _getNextChar();
    }
  }

  _PdfTokenType _getHexadecimalString() {
    int parentLevel = 0;
    String ch = String.fromCharCode(int.parse(_consumeValue()));
    while (true) {
      if (ch == '<') {
        parentLevel++;
        ch = String.fromCharCode(int.parse(_consumeValue()));
      } else if (ch == '>' && !_isArtifactContentEnds) {
        if (parentLevel == 0) {
          _consumeValue();
          break;
        } else if (parentLevel == 1) {
          ch = String.fromCharCode(int.parse(_consumeValue()));
          if (ch == '>') {
            parentLevel--;
          }
          if (parentLevel == 1 &&
              (ch == ' ' || (_isContainsArtifacts && ch == 'B'))) {
            break;
          }
        } else {
          if (ch == '>') {
            parentLevel--;
          }
          ch = String.fromCharCode(int.parse(_consumeValue()));
        }
      } else {
        ch = String.fromCharCode(int.parse(_consumeValue()));
      }
    }
    _isContentEnded = false;
    _isContainsArtifacts = false;
    return _PdfTokenType.hexString;
  }

  _PdfTokenType _getOperator() {
    _resetToken();
    String ch = String.fromCharCode(int.parse(_currentChar));

    while (_isOperator(ch)) {
      ch = String.fromCharCode(int.parse(_consumeValue()));
    }
    return _PdfTokenType.operators;
  }

  String _getNextInlineChar() {
    if (_contentStream!.length <= _charPointer) {
      _currentChar = '65535';
      _nextChar = '65535';
    } else {
      _currentChar = _nextChar;
      _nextChar = _contentStream![_charPointer++].toString();
      if (_currentChar == '13') {
        if (_nextChar == '10') {
          _currentChar = '13';
        } else {
          _currentChar = '10';
        }
      }
    }
    return _currentChar;
  }

  String _getNextCharforInlineStream() {
    if (_contentStream!.length <= _charPointer) {
      _currentChar = '65535';
      _nextChar = '65535';
    } else {
      _currentChar = _nextChar;
      _nextChar = _contentStream![_charPointer++].toString();
      if (_currentChar == '13') {
        if (_nextChar == '10') {
          _currentChar = _nextChar;
          if (_contentStream!.length <= _charPointer) {
            _nextChar = '65535';
          } else {
            _nextChar = _contentStream![_charPointer++].toString();
          }
        }
      }
    }
    return _currentChar;
  }

  void _resetContentPointer(int count) {
    _charPointer = _charPointer - count;
  }

  bool _isOperator(String ch) {
    if (isLetter(ch)) {
      return true;
    }
    switch (ch) {
      case '*':
      case '\'':
      case '\"':
      case '1':
      case '0':
        return true;
    }
    return false;
  }

  bool _isWhiteSpace(String ch) {
    switch (ch) {
      case '0':
      case '32':
      case '9':
      case '10':
      case '12':
      case '13':
      case '20':
        return true;
    }
    return false;
  }

  bool _isDelimiter(String ch) {
    switch (ch) {
      case '(':
      case ')':
      case '<':
      case '>':
      case '[':
      case ']':
      case '/':
      case '%':
        return true;
    }
    return false;
  }

  void _dispose() {
    if (_contentStream != null) {
      _contentStream = null;
    }
  }
}

enum _PdfTokenType {
  nullType,
  comment,
  integer,
  real,
  string,
  hexString,
  unicodeString,
  unicodeHexString,
  name,
  operators,
  beginArray,
  endArray,
  eof,
}
