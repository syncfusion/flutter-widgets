/// internal class
class ContentLexer {
  // Constructor
  /// internal constructor
  ContentLexer(List<int>? contentStream) {
    _contentStream = contentStream;
    operatorParams = StringBuffer();
  }

  // fields
  List<int>? _contentStream;
  String _currentChar = '0';
  String _nextChar = '0';
  int _charPointer = 0;
  bool _isArtifactContentEnds = false;
  bool _isContentEnded = false;

  /// internal field
  bool isContainsArtifacts = false;

  /// internal field
  StringBuffer? operatorParams;

  // Implementation
  /// internal method
  PdfToken getNextToken() {
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
      case "'":
        return _getOperator();
    }
    if (isDigit(ch)) {
      return _getNumber();
    }

    if (isLetter(ch)) {
      return _getOperator();
    }

    if (ch == '65535') {
      return PdfToken.eof;
    }

    return PdfToken.nullType;
  }

  /// internal method
  bool isDigit(String s, [int idx = 0]) => (s.codeUnitAt(idx) ^ 0x30) <= 9;

  /// internal method
  bool isLetter(String s) {
    if (s.contains(RegExp(r'[A-Z]')) || s.contains(RegExp(r'[a-z]'))) {
      return true;
    } else {
      return false;
    }
  }

  void _resetToken() {
    operatorParams!.clear();
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
          getNextChar(); // line feeds and spaces
          break;

        default:
          return _currentChar;
      }
    }
    return _currentChar;
  }

  /// internal method
  String getNextChar([bool value = false]) {
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

  PdfToken _getComment() {
    _resetToken();
    String ch;
    while ((ch = _consumeValue()) != '10' && ch != '65535') {}
    return PdfToken.comment;
  }

  PdfToken _getName() {
    _resetToken();
    while (true) {
      final String ch = _consumeValue();
      if (_isWhiteSpace(ch) || _isDelimiter(ch)) {
        break;
      }
    }
    return PdfToken.name;
  }

  PdfToken _getNumber() {
    String ch = _currentChar;
    if (ch == '43' || ch == '45') {
      operatorParams!.write(String.fromCharCode(int.parse(_currentChar)));
      ch = getNextChar();
    }
    while (true) {
      if (isDigit(String.fromCharCode(int.parse(ch)))) {
        operatorParams!.write(String.fromCharCode(int.parse(_currentChar)));
      } else if (ch == '46') {
        operatorParams!.write(String.fromCharCode(int.parse(_currentChar)));
      } else {
        break;
      }
      ch = getNextChar();
    }
    return PdfToken.integer;
  }

  String _consumeValue() {
    final String data = String.fromCharCode(int.parse(_currentChar));
    operatorParams!.write(data);
    if (isContainsArtifacts &&
        operatorParams.toString().contains('/Contents') &&
        !_isContentEnded) {
      _isArtifactContentEnds = true;
      if (String.fromCharCode(int.parse(_nextChar)) == ')' &&
          String.fromCharCode(int.parse(_currentChar)) != r'\') {
        _isArtifactContentEnds = false;
        _isContentEnded = true;
      }
    }
    return getNextChar();
  }

  PdfToken _getLiteralString() {
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
        operatorParams!.write(literal);
        ch = String.fromCharCode(int.parse(getNextChar()));
        break;
      } else {
        if (String.fromCharCode(int.parse(ch)) == '(') {
          ch = _consumeValue();
          literal = _getLiterals(ch);
          operatorParams!.write(literal);
          ch = getNextChar();
          continue;
        } else if (String.fromCharCode(int.parse(ch)) == ']') {
          ch = _consumeValue();
          break;
        }
        ch = _consumeValue();
      }
    }
    return PdfToken.string;
  }

  String _getLiterals(String ch) {
    int parenthesesCount = 0;
    String literal = '';
    while (true) {
      ch = String.fromCharCode(int.parse(ch));
      if (ch == r'\') {
        literal += ch;
        ch = String.fromCharCode(int.parse(getNextChar()));
        literal += ch;
        ch = getNextChar();
        continue;
      }

      if (ch == '(') {
        parenthesesCount++;
        literal += ch;
        ch = getNextChar();
        continue;
      }

      if (ch == ')' && parenthesesCount != 0) {
        literal += ch;
        ch = getNextChar();
        parenthesesCount--;
        continue;
      }

      if (ch == ')' && parenthesesCount == 0) {
        literal += ch;
        return literal;
      }
      literal += ch;
      ch = getNextChar();
    }
  }

  PdfToken _getHexadecimalString() {
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
              (ch == ' ' || (isContainsArtifacts && ch == 'B'))) {
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
    isContainsArtifacts = false;
    return PdfToken.hexString;
  }

  PdfToken _getOperator() {
    _resetToken();
    String ch = String.fromCharCode(int.parse(_currentChar));

    while (_isOperator(ch)) {
      ch = String.fromCharCode(int.parse(_consumeValue()));
    }
    return PdfToken.operators;
  }

  /// internal method
  String getNextInlineChar() {
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

  /// internal method
  String getNextCharforInlineStream() {
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

  /// internal method
  void resetContentPointer(int count) {
    _charPointer = _charPointer - count;
  }

  bool _isOperator(String ch) {
    if (isLetter(ch)) {
      return true;
    }
    switch (ch) {
      case '*':
      case "'":
      case '"':
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

  /// internal method
  void dispose() {
    if (_contentStream != null) {
      _contentStream = null;
    }
  }
}

/// internal enumerator
enum PdfToken {
  /// internal enumerator
  nullType,

  /// internal enumerator
  comment,

  /// internal enumerator
  integer,

  /// internal enumerator
  real,

  /// internal enumerator
  string,

  /// internal enumerator
  hexString,

  /// internal enumerator
  unicodeString,

  /// internal enumerator
  unicodeHexString,

  /// internal enumerator
  name,

  /// internal enumerator
  operators,

  /// internal enumerator
  beginArray,

  /// internal enumerator
  endArray,

  /// internal enumerator
  eof,
}
