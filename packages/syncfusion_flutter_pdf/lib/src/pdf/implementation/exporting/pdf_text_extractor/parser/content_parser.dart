part of pdf;

class _ContentParser {
  // Constructor
  _ContentParser(List<int> contentStream) {
    _lexer = _ContentLexer(contentStream);
    _operatorParams = _lexer._operatorParams;
    _recordCollection = _PdfRecordCollection();
    _isTextExtractionProcess = false;
  }

  // Fields
  _ContentLexer _lexer;
  StringBuffer _operatorParams;
  _PdfRecordCollection _recordCollection;
  bool _isByteOperands = false;
  bool _isTextExtractionProcess;
  final bool _conformanceEnabled = false;

  static const List<String> _operators = <String>[
    'b',
    'B',
    'bx',
    'Bx',
    'BDC',
    'BI',
    'BMC',
    'BT',
    'BX',
    'c',
    'cm',
    'CS',
    'cs',
    'd',
    'd0',
    'd1',
    'Do',
    'DP',
    'EI',
    'EMC',
    'ET',
    'EX',
    'f',
    'F',
    'fx',
    'G',
    'g',
    'gs',
    'h',
    'i',
    'ID',
    'j',
    'J',
    'K',
    'k',
    'l',
    'm',
    'M',
    'MP',
    'n',
    'q',
    'Q',
    're',
    'RG',
    'rg',
    'ri',
    's',
    'S',
    'SC',
    'sc',
    'SCN',
    'scn',
    'sh',
    'f*',
    'Tx',
    'Tc',
    'Td',
    'TD',
    'Tf',
    'Tj',
    'TJ',
    'TL',
    'Tm',
    'Tr',
    'Ts',
    'Tw',
    'Tz',
    'v',
    'w',
    'W',
    'W*',
    'Wx',
    'y',
    'T*',
    'b*',
    'B*',
    '\'',
    '\'',
    'true'
  ];

  // Implementation
  _PdfRecordCollection _readContent() {
    _parseObject(_PdfTokenType.eof);
    if (_isTextExtractionProcess) {
      _lexer._dispose();
    }
    return _recordCollection;
  }

  void _parseObject(_PdfTokenType stop) {
    _PdfTokenType symbol;
    final List<String> _operands = <String>[];

    while ((symbol = _getNextToken()) != _PdfTokenType.eof) {
      if (symbol == stop || symbol == _PdfTokenType.nullType) {
        return;
      }
      switch (symbol) {
        case _PdfTokenType.comment:
          break;

        case _PdfTokenType.integer:
          _operands.add(_operatorParams.toString());
          break;

        case _PdfTokenType.real:
          _operands.add(_operatorParams.toString());
          break;

        case _PdfTokenType.string:
        case _PdfTokenType.hexString:
        case _PdfTokenType.unicodeString:
        case _PdfTokenType.unicodeHexString:
          _operands.add(_operatorParams.toString());
          break;

        case _PdfTokenType.name:
          if (_operatorParams.toString() == '/Artifact') {
            _lexer._isContainsArtifacts = true;
          }
          _operands.add(_operatorParams.toString());
          break;

        case _PdfTokenType.operators:
          if (_operatorParams.toString() == 'true') {
            _operands.add(_operatorParams.toString());
            break;
          } else if (_operatorParams.toString() == 'ID') {
            _createRecord(_operands);
            _operands.clear();
            _consumeValue(_operands);
            break;
          } else {
            _createRecord(_operands);
            _operands.clear();
            break;
          }
          break;

        case _PdfTokenType.beginArray:
          break;

        case _PdfTokenType.endArray:
          ArgumentError.value('Error while parsing content');
          break;

        default:
          break;
      }
    }
  }

  _PdfTokenType _getNextToken() {
    return _lexer._getNextToken();
  }

  void _createRecord(List<String> operands, [List<int> inlineImageBytes]) {
    final String operand = _operatorParams.toString();
    final int occurence = _operators.indexOf(operand);
    if (occurence < 0) {
      ArgumentError.value('Invalid operand');
    }
    _PdfRecord record;
    final List<String> op = operands.isNotEmpty
        ? List<String>.filled(operands.length, '', growable: true)
        : <String>[];
    if (operands.isNotEmpty) {
      List.copyRange(op, 0, operands);
    }
    if (!_isByteOperands) {
      record = _PdfRecord(operand, op);
    } else {
      final List<int> imBytes = inlineImageBytes.isNotEmpty
          ? List<int>(inlineImageBytes.length)
          : <int>[];
      if (inlineImageBytes.isNotEmpty) {
        List.copyRange(imBytes, 0, inlineImageBytes);
      }
      record = _PdfRecord.fromImage(operand, imBytes);
    }
    _recordCollection._add(record);
  }

  void _consumeValue(List<String> operands) {
    String currentChar = '0';
    String nextChar = '0';
    String secondNextChar = '0';
    final List<int> _inlineImageBytes = <int>[];
    if (_conformanceEnabled) {
      List<String> thirdChar;
      while (true) {
        thirdChar = <String>[];
        int contentCount = 0;
        currentChar = _lexer._getNextCharforInlineStream();
        if (String.fromCharCode(int.parse(currentChar)) == 'E') {
          nextChar = _lexer._getNextInlineChar();
          if (String.fromCharCode(int.parse(nextChar)) == 'I') {
            secondNextChar = _lexer._getNextInlineChar();
            final String snc = String.fromCharCode(int.parse(secondNextChar));
            thirdChar.add(_lexer._getNextChar(true));
            if ((snc == ' ' ||
                    snc == '\n' ||
                    secondNextChar == '65535' ||
                    snc == '\r') &&
                thirdChar.isNotEmpty) {
              while (thirdChar[thirdChar.length - 1] == ' ' ||
                  thirdChar[thirdChar.length - 1] == '\r' ||
                  thirdChar[thirdChar.length - 1] == '\n') {
                thirdChar.add(_lexer._getNextChar());
                contentCount++;
              }
            }
            if (!_isTextExtractionProcess) {
              _lexer._resetContentPointer(contentCount);
            }
            if ((snc == ' ' ||
                    snc == '\n' ||
                    secondNextChar == '65535' ||
                    snc == '\r') &&
                thirdChar.isNotEmpty) {
              if (String.fromCharCode(
                          int.parse(thirdChar[thirdChar.length - 1])) ==
                      'Q' ||
                  thirdChar[thirdChar.length - 1] == '65535' ||
                  String.fromCharCode(
                          int.parse(thirdChar[thirdChar.length - 1])) ==
                      'S') {
                _operatorParams.clear();
                _operatorParams
                    .write(String.fromCharCode(int.parse(currentChar)));
                _operatorParams.write(String.fromCharCode(int.parse(nextChar)));
                _isByteOperands = true;
                _createRecord(operands, _inlineImageBytes);
                _isByteOperands = false;
                _inlineImageBytes.clear();
                nextChar = _lexer._getNextInlineChar();
                break;
              } else {
                _inlineImageBytes.add(int.parse(currentChar));
                _inlineImageBytes.add(int.parse(nextChar));
                _inlineImageBytes.add(int.parse(secondNextChar));
                if (thirdChar.length > 1) {
                  thirdChar.removeAt(0);
                  thirdChar.removeAt(thirdChar.length - 1);
                }
                for (final String c in thirdChar) {
                  _inlineImageBytes.add(int.parse(c));
                }
                currentChar = _lexer._getNextCharforInlineStream();
              }
            } else {
              _inlineImageBytes.add(int.parse(currentChar));
              _inlineImageBytes.add(int.parse(nextChar));
              _inlineImageBytes.add(int.parse(secondNextChar));
              if (thirdChar.isNotEmpty) {
                for (final String tc in thirdChar) {
                  _inlineImageBytes.add(int.parse(tc));
                }
              }
              currentChar = _lexer._getNextCharforInlineStream();
            }
          } else {
            _inlineImageBytes.add(int.parse(currentChar));
            _inlineImageBytes.add(int.parse(nextChar));
          }
        } else {
          _inlineImageBytes.add(int.parse(currentChar));
        }
        thirdChar.clear();
      }
    } else {
      String thirdChar;
      while (true) {
        int contentCount = 0;
        currentChar = _lexer._getNextCharforInlineStream();
        if (String.fromCharCode(int.parse(currentChar)) == 'E') {
          nextChar = _lexer._getNextInlineChar();
          if (String.fromCharCode(int.parse(nextChar)) == 'I') {
            secondNextChar = _lexer._getNextInlineChar();
            final String snc = String.fromCharCode(int.parse(secondNextChar));
            thirdChar = _lexer._getNextChar(true);
            while (String.fromCharCode(int.parse(thirdChar)) == ' ' ||
                String.fromCharCode(int.parse(thirdChar)) == '\r' ||
                String.fromCharCode(int.parse(thirdChar)) == '\n') {
              thirdChar = _lexer._getNextChar();
              contentCount++;
            }
            if (!_isTextExtractionProcess) {
              _lexer._resetContentPointer(contentCount);
            }
            if (snc == ' ' ||
                snc == '\n' ||
                secondNextChar == '65535' ||
                snc == '\r') {
              if (String.fromCharCode(int.parse(thirdChar)) == 'Q' ||
                  thirdChar == '65535' ||
                  String.fromCharCode(int.parse(thirdChar)) == 'S') {
                _operatorParams.clear();
                _operatorParams
                    .write(String.fromCharCode(int.parse(currentChar)));
                _operatorParams.write(String.fromCharCode(int.parse(nextChar)));
                _isByteOperands = true;
                _createRecord(operands, _inlineImageBytes);
                _isByteOperands = false;
                _inlineImageBytes.clear();
                nextChar = _lexer._getNextInlineChar();
                break;
              }
            } else {
              _inlineImageBytes.add(int.parse(currentChar));
              _inlineImageBytes.add(int.parse(nextChar));
              _inlineImageBytes.add(int.parse(secondNextChar));
              _inlineImageBytes.add(int.parse(thirdChar));
              currentChar = _lexer._getNextCharforInlineStream();
            }
          } else {
            _inlineImageBytes.add(int.parse(currentChar));
            _inlineImageBytes.add(int.parse(nextChar));
          }
        } else {
          _inlineImageBytes.add(int.parse(currentChar));
        }
      }
    }
  }
}

class _PdfRecordCollection {
  // Constructor
  _PdfRecordCollection() {
    _recordCollection = <_PdfRecord>[];
  }

  // Fields
  List<_PdfRecord> _recordCollection;

  //Properties
  int get _count => _recordCollection.length;

  // Implementation
  void _add(_PdfRecord record) {
    _recordCollection.add(record);
  }
}

class _PdfRecord {
  // Constructor
  _PdfRecord(String name, List<String> operands) {
    _operatorName = name;
    _operands = operands;
  }

  _PdfRecord.fromImage(String name, List<int> imageData) {
    _operatorName = name;
    _inlineImageBytes = imageData;
  }

  // Fields
  String _operatorName;
  List<String> _operands;
  // ignore: unused_field
  List<int> _inlineImageBytes;
}
