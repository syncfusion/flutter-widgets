import 'content_lexer.dart';

/// internal class
class ContentParser {
  /// internal constructor
  ContentParser(List<int>? contentStream) {
    _lexer = ContentLexer(contentStream);
    _operatorParams = _lexer.operatorParams;
    _recordCollection = PdfRecordCollection();
    isTextExtractionProcess = false;
  }

  // Fields
  late ContentLexer _lexer;
  StringBuffer? _operatorParams;
  PdfRecordCollection? _recordCollection;
  bool _isByteOperands = false;
  final bool _conformanceEnabled = false;

  /// internal field
  late bool isTextExtractionProcess;

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
    "'",
    '"',
    'true'
  ];

  // Implementation
  /// internal method
  PdfRecordCollection? readContent() {
    _parseObject(PdfToken.eof);
    if (isTextExtractionProcess) {
      _lexer.dispose();
    }
    return _recordCollection;
  }

  void _parseObject(PdfToken stop) {
    PdfToken symbol;
    final List<String> operands = <String>[];

    while ((symbol = _getNextToken()) != PdfToken.eof) {
      if (symbol == stop || symbol == PdfToken.nullType) {
        return;
      }
      switch (symbol) {
        case PdfToken.comment:
          break;

        case PdfToken.integer:
          operands.add(_operatorParams.toString());
          break;

        case PdfToken.real:
          operands.add(_operatorParams.toString());
          break;

        case PdfToken.string:
        case PdfToken.hexString:
        case PdfToken.unicodeString:
        case PdfToken.unicodeHexString:
          operands.add(_operatorParams.toString());
          break;

        case PdfToken.name:
          if (_operatorParams.toString() == '/Artifact') {
            _lexer.isContainsArtifacts = true;
          }
          operands.add(_operatorParams.toString());
          break;

        case PdfToken.operators:
          if (_operatorParams.toString() == 'true') {
            operands.add(_operatorParams.toString());
          } else if (_operatorParams.toString() == 'ID') {
            _createRecord(operands);
            operands.clear();
            _consumeValue(operands);
          } else {
            _createRecord(operands);
            operands.clear();
          }
          break;

        case PdfToken.beginArray:
          break;

        case PdfToken.endArray:
          ArgumentError.value('Error while parsing content');
          break;

        // ignore: no_default_cases
        default:
          break;
      }
    }
  }

  PdfToken _getNextToken() {
    return _lexer.getNextToken();
  }

  void _createRecord(List<String> operands, [List<int>? inlineImageBytes]) {
    final String operand = _operatorParams.toString();
    final int occurence = _operators.indexOf(operand);
    if (occurence < 0) {
      ArgumentError.value('Invalid operand');
    }
    PdfRecord record;
    final List<String> op = operands.isNotEmpty
        ? List<String>.filled(operands.length, '', growable: true)
        : <String>[];
    if (operands.isNotEmpty) {
      List.copyRange(op, 0, operands);
    }
    if (!_isByteOperands) {
      record = PdfRecord(operand, op);
    } else {
      final List<int> imBytes = inlineImageBytes!.isNotEmpty
          ? List<int>.filled(inlineImageBytes.length, 0, growable: true)
          : <int>[];
      if (inlineImageBytes.isNotEmpty) {
        List.copyRange(imBytes, 0, inlineImageBytes);
      }
      record = PdfRecord.fromImage(operand, imBytes);
    }
    _recordCollection!.add(record);
  }

  void _consumeValue(List<String> operands) {
    String currentChar = '0';
    String nextChar = '0';
    String secondNextChar = '0';
    final List<int> inlineImageBytes = <int>[];
    if (_conformanceEnabled) {
      List<String> thirdChar;
      while (true) {
        thirdChar = <String>[];
        int contentCount = 0;
        currentChar = _lexer.getNextCharforInlineStream();
        if (String.fromCharCode(int.parse(currentChar)) == 'E') {
          nextChar = _lexer.getNextInlineChar();
          if (String.fromCharCode(int.parse(nextChar)) == 'I') {
            secondNextChar = _lexer.getNextInlineChar();
            final String snc = String.fromCharCode(int.parse(secondNextChar));
            thirdChar.add(_lexer.getNextChar(true));
            if ((snc == ' ' ||
                    snc == '\n' ||
                    secondNextChar == '65535' ||
                    snc == '\r') &&
                thirdChar.isNotEmpty) {
              while (thirdChar[thirdChar.length - 1] == ' ' ||
                  thirdChar[thirdChar.length - 1] == '\r' ||
                  thirdChar[thirdChar.length - 1] == '\n') {
                thirdChar.add(_lexer.getNextChar());
                contentCount++;
              }
            }
            if (!isTextExtractionProcess) {
              _lexer.resetContentPointer(contentCount);
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
                _operatorParams!.clear();
                _operatorParams!
                    .write(String.fromCharCode(int.parse(currentChar)));
                _operatorParams!
                    .write(String.fromCharCode(int.parse(nextChar)));
                _isByteOperands = true;
                _createRecord(operands, inlineImageBytes);
                _isByteOperands = false;
                inlineImageBytes.clear();
                nextChar = _lexer.getNextInlineChar();
                break;
              } else {
                inlineImageBytes.add(int.parse(currentChar));
                inlineImageBytes.add(int.parse(nextChar));
                inlineImageBytes.add(int.parse(secondNextChar));
                if (thirdChar.length > 1) {
                  thirdChar.removeAt(0);
                  thirdChar.removeAt(thirdChar.length - 1);
                }
                for (final String c in thirdChar) {
                  inlineImageBytes.add(int.parse(c));
                }
                currentChar = _lexer.getNextCharforInlineStream();
              }
            } else {
              inlineImageBytes.add(int.parse(currentChar));
              inlineImageBytes.add(int.parse(nextChar));
              inlineImageBytes.add(int.parse(secondNextChar));
              if (thirdChar.isNotEmpty) {
                for (final String tc in thirdChar) {
                  inlineImageBytes.add(int.parse(tc));
                }
              }
              currentChar = _lexer.getNextCharforInlineStream();
            }
          } else {
            inlineImageBytes.add(int.parse(currentChar));
            inlineImageBytes.add(int.parse(nextChar));
          }
        } else {
          inlineImageBytes.add(int.parse(currentChar));
        }
        thirdChar.clear();
      }
    } else {
      String thirdChar;
      while (true) {
        int contentCount = 0;
        currentChar = _lexer.getNextCharforInlineStream();
        if (String.fromCharCode(int.parse(currentChar)) == 'E') {
          nextChar = _lexer.getNextInlineChar();
          if (String.fromCharCode(int.parse(nextChar)) == 'I') {
            secondNextChar = _lexer.getNextInlineChar();
            final String snc = String.fromCharCode(int.parse(secondNextChar));
            thirdChar = _lexer.getNextChar(true);
            while (String.fromCharCode(int.parse(thirdChar)) == ' ' ||
                String.fromCharCode(int.parse(thirdChar)) == '\r' ||
                String.fromCharCode(int.parse(thirdChar)) == '\n') {
              thirdChar = _lexer.getNextChar();
              contentCount++;
            }
            if (!isTextExtractionProcess) {
              _lexer.resetContentPointer(contentCount);
            }
            if (snc == ' ' ||
                snc == '\n' ||
                secondNextChar == '65535' ||
                snc == '\r') {
              if (String.fromCharCode(int.parse(thirdChar)) == 'Q' ||
                  thirdChar == '65535' ||
                  String.fromCharCode(int.parse(thirdChar)) == 'S') {
                _operatorParams!.clear();
                _operatorParams!
                    .write(String.fromCharCode(int.parse(currentChar)));
                _operatorParams!
                    .write(String.fromCharCode(int.parse(nextChar)));
                _isByteOperands = true;
                _createRecord(operands, inlineImageBytes);
                _isByteOperands = false;
                inlineImageBytes.clear();
                nextChar = _lexer.getNextInlineChar();
                break;
              }
            } else {
              inlineImageBytes.add(int.parse(currentChar));
              inlineImageBytes.add(int.parse(nextChar));
              inlineImageBytes.add(int.parse(secondNextChar));
              inlineImageBytes.add(int.parse(thirdChar));
              currentChar = _lexer.getNextCharforInlineStream();
            }
          } else {
            inlineImageBytes.add(int.parse(currentChar));
            inlineImageBytes.add(int.parse(nextChar));
          }
        } else {
          inlineImageBytes.add(int.parse(currentChar));
        }
      }
    }
  }
}

/// internal class
class PdfRecordCollection {
  // Constructor
  /// internal constructor
  PdfRecordCollection() {
    recordCollection = <PdfRecord>[];
  }

  // Fields
  /// internal field
  late List<PdfRecord> recordCollection;

  //Properties
  /// internal property
  int get count => recordCollection.length;

  // Implementation
  /// internal method
  void add(PdfRecord record) {
    recordCollection.add(record);
  }
}

/// internal class
class PdfRecord {
  // Constructor
  /// internal constructor
  PdfRecord(this.operatorName, this.operands);

  /// internal constructor
  PdfRecord.fromImage(this.operatorName, this.inlineImageBytes);

  // Fields
  /// internal field
  String? operatorName;

  /// internal field
  List<String>? operands;

  /// internal field
  // ignore: unused_field
  List<int>? inlineImageBytes;
}
