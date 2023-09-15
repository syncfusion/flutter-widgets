import 'enums.dart';
import 'pdf_reader.dart';

/// internal class
class PdfLexer {
  //Constructor
  /// internal constructor
  PdfLexer(PdfReader reader) {
    _initialize(reader);
  }

  //Constants
  /// internal field
  final int bufferSize = 8192;

  /// internal field
  final int f = -1;

  /// internal field
  final int noState = -1;

  /// internal field
  final int notAccept = 0;

  /// internal field
  final int start = 1;

  /// internal field
  final int end = 2;

  /// internal field
  final int noAnchor = 4;

  /// internal field
  final int bol = 256;

  /// internal field
  final int eof = 257;

  /// internal field
  final String prefix = '<<';

  //Fields
  late PdfReader _reader;

  /// internal field
  late int bufferIndex;

  /// internal field
  late int bufferRead;

  /// internal field
  late int bufferStart;

  /// internal field
  late int bufferEnd;

  /// internal field
  late List<int> buffer;

  /// internal field
  bool _lastWasCr = false;

  /// internal field
  late int line;

  /// internal field
  late bool atBool;

  /// internal field
  late _State lexicalState;

  /// internal field
  List<int> stateTrans = <int>[0, 81, 83];

  /// internal field
  late List<int> accept;

  /// internal field
  String? objectName;

  /// internal field
  bool isArray = false;

  /// internal field
  int paren = 0;

  /// internal field
  String stringText = '';

  /// internal field
  bool skip = false;

  //Properties
  /// internal property
  int get position {
    return _reader.position - bufferRead + bufferIndex;
  }

  /// internal property
  String get text => _text();

  /// internal property
  late List<int> cMap;

  /// internal property
  late List<int> rMap;

  /// internal property
  late List<List<int>> next;

  //Implementation
  void _initialize(PdfReader reader) {
    _reader = reader;
    buffer = List<int>.filled(bufferSize, 0);
    bufferRead = 0;
    bufferIndex = 0;
    bufferStart = 0;
    bufferEnd = 0;
    line = 0;
    atBool = true;
    lexicalState = _State.initial;
    accept = <int>[
      notAccept,
      noAnchor,
      noAnchor,
      noAnchor,
      noAnchor,
      noAnchor,
      noAnchor,
      noAnchor,
      noAnchor,
      noAnchor,
      noAnchor,
      noAnchor,
      noAnchor,
      noAnchor,
      noAnchor,
      noAnchor,
      noAnchor,
      noAnchor,
      noAnchor,
      noAnchor,
      noAnchor,
      noAnchor,
      noAnchor,
      noAnchor,
      noAnchor,
      noAnchor,
      noAnchor,
      noAnchor,
      noAnchor,
      noAnchor,
      noAnchor,
      noAnchor,
      noAnchor,
      noAnchor,
      noAnchor,
      noAnchor,
      notAccept,
      noAnchor,
      noAnchor,
      noAnchor,
      noAnchor,
      notAccept,
      noAnchor,
      notAccept,
      noAnchor,
      notAccept,
      noAnchor,
      notAccept,
      noAnchor,
      notAccept,
      noAnchor,
      notAccept,
      noAnchor,
      notAccept,
      noAnchor,
      notAccept,
      notAccept,
      notAccept,
      notAccept,
      notAccept,
      notAccept,
      notAccept,
      notAccept,
      notAccept,
      notAccept,
      notAccept,
      notAccept,
      notAccept,
      notAccept,
      notAccept,
      notAccept,
      notAccept,
      notAccept,
      notAccept,
      notAccept,
      notAccept,
      notAccept,
      notAccept,
      notAccept,
      notAccept,
      notAccept,
      notAccept,
      notAccept,
      notAccept,
      notAccept,
      notAccept,
      notAccept,
      notAccept
    ];
    cMap = _unpackFromString(1, 258,
        '3,17:8,3,11,17,3,4,17:18,3,17:4,1,17:2,7,2,17,26,17,26,28,16,27:10,17:2,5,17,6,17:2,13:6,17:11,35,17:8,14,12,15,17:3,23,30,13,33,21,22,17:2,36,31,17,24,34,32,29,17:2,19,25,18,20,17:2,37,17:2,10,17,10,17:128,8,9,0:2')[0];
    rMap = _unpackFromString(1, 88,
        '0,1,2,1:2,3,4,1:2,5,6,7,1:3,8,1:18,9,1,10,11,12,13,14,15,16,17,18,19,20,21,7,8:2,22,23,24,25,13,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57')[0];
    next = _unpackFromString(58, 38,
        '1,2,3,4:2,5,37,6,3:3,4,3:2,7,8,9,3,42,3:2,44,10,3:2,46,48,11,50,52,3:2,38,3:2,12,3,54,-1:39,2:3,-1,2:6,-1,2:26,-1:5,13,-1:40,36,-1:37,9:2,-1:2,9:2,-1:3,9:21,-1:23,45,-1:41,11,49,-1:36,15,-1:11,35:3,84,35:33,-1:9,55,-1:34,14,-1:51,85,-1:18,63,17,63:8,64,63:26,-1,30:3,82,30:33,-1:20,56,-1:2,57,-1:33,41,-1:51,58,-1:36,43,-1:29,59,-1:31,47,-1:38,86,-1:3,60,-1:45,16,-1:36,51,-1:28,62,-1:35,53,-1:39,18,-1:52,65,-1:26,66,-1:3,67,-1:33,56,-1:31,87,-1:42,19,-1:35,20,-1:16,55:3,-1,55:6,-1,-1:26,-1,64,39,64,63,64:33,-1:24,69,-1:31,70,-1:49,71,-1:30,72,-1:35,74,-1:35,75,-1:49,21,-1:40,22,-1:40,76,-1:19,23,-1:39,77,-1:35,78,-1:41,79,-1:35,80,-1:50,24,-1:25,25,-1:15,1,26:2,27:2,26,28,26:4,27,40,29,26:7,29:3,26:3,29,26:2,29,26:2,29,26:4,-1:11,30,-1:26,1,31,32,31:4,33,31:4,34,31:25,-1:11,35,-1:50,61,-1:34,68,-1:34,73,-1:19');
  }

  List<List<int>> _unpackFromString(int size1, int size2, String text) {
    int colonIndex = -1;
    String lengthString;
    int sequenceLength = 0;
    int sequenceInteger = 0;
    int commaIndex;
    String workString;
    final List<List<int>> res = List<List<int>>.generate(
        size1, (int i) => List<int>.generate(size2, (int j) => 0));
    for (int i = 0; i < size1; ++i) {
      for (int j = 0; j < size2; ++j) {
        if (sequenceLength != 0) {
          res[i][j] = sequenceInteger;
          --sequenceLength;
          continue;
        }
        commaIndex = text.indexOf(',');
        workString = (commaIndex == -1) ? text : text.substring(0, commaIndex);
        text = text.substring(commaIndex + 1);
        colonIndex = workString.indexOf(':');

        if (colonIndex == -1) {
          res[i][j] = int.tryParse(workString)!;
          continue;
        }
        lengthString = workString.substring(colonIndex + 1);
        final int? sl = int.tryParse(lengthString);
        if (sl != null) {
          sequenceLength = sl;
        }
        workString = workString.substring(0, colonIndex);
        final int? si = int.tryParse(workString);
        if (si != null) {
          sequenceInteger = si;
        }
        res[i][j] = sequenceInteger;
        --sequenceLength;
      }
    }
    return res;
  }

  /// internal method
  void reset() {
    buffer = List<int>.filled(bufferSize, 0);
    bufferRead = 0;
    bufferIndex = 0;
    bufferStart = 0;
    bufferEnd = 0;
    line = 0;
    atBool = true;
    lexicalState = _State.initial;
  }

  void _markStart() {
    for (int i = bufferStart; i < bufferIndex; ++i) {
      if (10 == buffer[i] && !_lastWasCr) {
        ++line;
      }
      if (13 == buffer[i]) {
        ++line;
        _lastWasCr = true;
      } else {
        _lastWasCr = false;
      }
    }
    bufferStart = bufferIndex;
  }

  void _markEnd() {
    bufferEnd = bufferIndex;
  }

  int? _advance() {
    if (bufferIndex < bufferRead) {
      return buffer[bufferIndex++];
    }

    int nextRead;

    if (0 != bufferStart) {
      int i = bufferStart;
      int j = 0;

      while (i < bufferRead) {
        buffer[j] = buffer[i];
        ++i;
        ++j;
      }

      bufferEnd -= bufferStart;
      bufferStart = 0;
      bufferRead = j;
      bufferIndex = j;

      nextRead = _read();

      if (nextRead <= 0) {
        return eof;
      }
    }

    while (bufferIndex >= bufferRead) {
      if (bufferIndex >= buffer.length) {
        buffer = _double(buffer);
      }

      nextRead = _read();

      if (nextRead <= 0) {
        return eof;
      }
    }
    return buffer[bufferIndex++];
  }

  /// internal method
  void skipNewLine() {
    bufferIndex = bufferStart + 1;

    if (buffer[bufferIndex] == 13) {
      if (buffer[bufferIndex + 1] == 10) {
        bufferIndex += 2;
      }
    } else if (buffer[bufferIndex] == 10) {
      if (buffer[bufferIndex - 1] != 10) {
        bufferIndex += 1;
      }
    }
    _markStart();
  }

  /// internal method
  void skipToken() {
    bufferStart = bufferEnd;
  }

  List<int> _double(List<int> buffer) {
    final int length = buffer.length;
    final List<int> newBuffer = List<int>.filled(2 * length, 0, growable: true);
    List.copyRange(newBuffer, 0, buffer, 0, length);
    return newBuffer;
  }

  int _read() {
    final int nextRead =
        _reader.readData(buffer, bufferRead, buffer.length - bufferRead);
    if (nextRead > 0) {
      bufferRead += nextRead;
    }
    return nextRead;
  }

  /// internal method
  List<int> readBytes(int count) {
    final List<int> list = List<int>.filled(count, 0);
    _markStart();
    if (bufferRead - bufferStart < count) {
      while (buffer.length - bufferStart < count) {
        buffer = _double(buffer);
      }
    }
    final int readCount = _read();
    if (bufferRead - bufferStart < readCount) {
      if (readCount > count) {
        count = readCount;
      }
    }
    int j = 0;
    for (int i = bufferStart; i < bufferStart + count; ++i, bufferIndex = i) {
      list[j++] = buffer[i];
    }
    _markStart();
    _markEnd();
    return list;
  }

  void _moveEnd() {
    if (bufferEnd > bufferStart && 10 == buffer[bufferEnd - 1]) {
      bufferEnd--;
    }
    if (bufferEnd > bufferStart && 13 == buffer[bufferEnd - 1]) {
      bufferEnd--;
    }
  }

  void _toMark() {
    bufferIndex = bufferEnd;
    atBool = (bufferEnd > bufferStart) &&
        (13 == buffer[bufferEnd - 1] ||
            10 == buffer[bufferEnd - 1] ||
            2028 == buffer[bufferEnd - 1] ||
            2029 == buffer[bufferEnd - 1]);
  }

  /// internal method
  PdfTokenType getNextToken() {
    int? lookAhead;
    int anchor = noAnchor;
    int state = stateTrans[lexicalState.index];
    int? nextState = noState;
    int? lastAcceptState = noState;
    bool initial = true;
    int thisAccept;

    _markStart();
    thisAccept = accept[state];

    if (notAccept != thisAccept) {
      lastAcceptState = state;
      _markEnd();
    }

    while (true) {
      if (initial && atBool) {
        lookAhead = bol;
      } else {
        lookAhead = _advance();
      }

      nextState = f;
      nextState = next[rMap[state]][cMap[lookAhead!]];
      if (eof == lookAhead && initial) {
        return PdfTokenType.eof;
      }
      if (f != nextState) {
        state = nextState;
        initial = false;
        thisAccept = accept[state];
        if (notAccept != thisAccept) {
          lastAcceptState = state;
          _markEnd();
        }
      } else {
        if (noState == lastAcceptState) {
          throw ArgumentError.value(noState, 'Lexical Error: Unmatched Input.');
        } else {
          anchor = accept[lastAcceptState!];
          if (0 != (end & anchor)) {
            _moveEnd();
          }
          _toMark();
          switch (lastAcceptState) {
            case 1:
              break;
            case -2:
              break;
            case 2:
              {
                break;
              }
            case -3:
              break;
            case 3:
              {
                break;
              }
            case -4:
              break;
            case 4:
              {
                break;
              }
            case -5:
              break;
            case 5:
              {
                _begin(_State.hexString);
                return PdfTokenType.hexStringStart;
              }
            case -6:
              break;
            case 6:
              {
                _begin(_State.string);
                stringText = '';
                break;
              }
            case -7:
              break;
            case 7:
              {
                return PdfTokenType.arrayStart;
              }
            case -8:
              break;
            case 8:
              {
                return PdfTokenType.arrayEnd;
              }
            case -9:
              break;
            case 9:
              {
                return PdfTokenType.name;
              }
            case -10:
              break;
            case 10:
              {
                return PdfTokenType.objectType;
              }
            case -11:
              break;
            case 11:
              {
                return PdfTokenType.number;
              }
            case -12:
              break;
            case 12:
              {
                return PdfTokenType.reference;
              }
            case -13:
              break;
            case 13:
              {
                return PdfTokenType.dictionaryStart;
              }
            case -14:
              break;
            case 14:
              {
                return PdfTokenType.dictionaryEnd;
              }
            case -15:
              break;
            case 15:
              {
                return PdfTokenType.real;
              }
            case -16:
              break;
            case 16:
              {
                return PdfTokenType.objectStart;
              }
            case -17:
              break;
            case 17:
              {
                return PdfTokenType.unicodeString;
              }
            case -18:
              break;
            case 18:
              {
                return PdfTokenType.boolean;
              }
            case -19:
              break;
            case 19:
              {
                return PdfTokenType.nullType;
              }
            case -20:
              break;
            case 20:
              {
                return PdfTokenType.xRef;
              }
            case -21:
              break;
            case 21:
              {
                return PdfTokenType.objectEnd;
              }
            case -22:
              break;
            case 22:
              {
                return PdfTokenType.streamStart;
              }
            case -23:
              break;
            case 23:
              {
                return PdfTokenType.trailer;
              }
            case -24:
              break;
            case 24:
              {
                return PdfTokenType.streamEnd;
              }
            case -25:
              break;
            case 25:
              {
                return PdfTokenType.startXRef;
              }
            case -26:
              break;
            case 26:
              {
                return PdfTokenType.hexStringWeird;
              }
            case -27:
              break;
            case 27:
              {
                return PdfTokenType.whiteSpace;
              }
            case -28:
              break;
            case 28:
              {
                _begin(_State.initial);
                return PdfTokenType.hexStringEnd;
              }
            case -29:
              break;
            case 29:
              {
                return PdfTokenType.hexDigit;
              }
            case -30:
              break;
            case 30:
              {
                return PdfTokenType.hexStringWeirdEscape;
              }
            case -31:
              break;
            case 31:
              {
                stringText += _text();
                break;
              }
            case -32:
              break;
            case 32:
              {
                if (paren > 0) {
                  stringText += _text();
                  --paren;
                } else {
                  _begin(_State.initial);
                  return PdfTokenType.string;
                }
                break;
              }
            case -33:
              break;
            case 33:
              {
                stringText += _text();
                ++paren;
                break;
              }
            case -34:
              break;
            case 34:
              {
                break;
              }
            case -35:
              break;
            case 35:
              {
                stringText += _text();
                break;
              }
            case -36:
              break;
            case 37:
              {
                _error(_Error.match, true);
                break;
              }
            case -37:
              break;
            case 38:
              {
                return PdfTokenType.objectType;
              }
            case -38:
              break;
            case 39:
              {
                return PdfTokenType.unicodeString;
              }
            case -39:
              break;
            case 40:
              {
                return PdfTokenType.hexStringWeird;
              }
            case -40:
              break;
            case 42:
              {
                return PdfTokenType.unknown;
              }
            case -41:
              break;
            case 44:
              return PdfTokenType.unknown;
            case -42:
              break;
            case 46:
              {
                if (buffer[bufferIndex - 1] == 115 &&
                    (buffer[bufferIndex] == 116 || buffer[bufferIndex] == 37)) {
                  break;
                } else {
                  _error(_Error.match, true);
                  break;
                }
              }
            case -43:
              break;
            case 48:
              {
                _error(_Error.match, true);
                break;
              }
            case -44:
              break;
            case 50:
              {
                if (isArray) {
                  int index = bufferIndex - 2;
                  String text = '';
                  for (int i = 0; i < 2; i++) {
                    text += String.fromCharCode(buffer[index]);
                    index++;
                  }
                  final double? value = double.tryParse(text);
                  if (value != null &&
                      buffer[bufferIndex - 1] == '.'.codeUnitAt(0) &&
                      (buffer[bufferIndex] == ' '.codeUnitAt(0) ||
                          buffer[bufferIndex] == ']'.codeUnitAt(0))) {
                    break;
                  }
                } else {
                  if (buffer[bufferIndex - 1] == '.'.codeUnitAt(0) &&
                      buffer[bufferIndex] == '-'.codeUnitAt(0)) {
                    return PdfTokenType.unknown;
                  }
                }
                _error(_Error.match, true);
                break;
              }
            case -45:
              break;
            case 52:
              {
                break;
              }
            case -46:
              break;
            case 54:
              {
                _error(_Error.match, true);
                break;
              }
            case -47:
              break;
            default:
              _error(_Error.internal, false);
              break;
          }
          initial = true;
          state = stateTrans[lexicalState.index];
          nextState = noState;
          lastAcceptState = noState;
          _markStart();
          thisAccept = accept[state];
          if (notAccept != thisAccept) {
            lastAcceptState = state;
            _markEnd();
          }
        }
      }
    }
  }

  String _text() {
    if (buffer.length > 2 && bufferEnd > 2) {
      final String end = String.fromCharCode(buffer[bufferEnd - 1]);
      final String start = String.fromCharCode(buffer[bufferEnd - 2]);
      final int value = bufferEnd - bufferStart;
      if (end == ')' && (start == r'\' || start == '\u0000') && value > 3) {
        int? index = bufferEnd;
        final String text = String.fromCharCodes(buffer);
        index = text.indexOf(end, bufferStart) + 1;
        int prvIndex = 0;
        while (text[index! - 2] == r'\') {
          index = text.indexOf(end, index) + 1;
          if (index > 0) {
            prvIndex = index;
          } else {
            index = prvIndex;
            break;
          }
        }
        if (text[index] == '>' && text[index + 1] == '>') {
          bufferIndex = index;
          skip = false;
        } else if (text.length > index + 2) {
          if (text[index + 2] == '/') {
            bufferIndex = index;
            skip = false;
          } else if (text[index + 1] == '/') {
            bufferIndex = index;
            skip = false;
          } else if (text[index] == '/') {
            bufferIndex = index;
            skip = false;
          } else if (text[index - 1] == ')') {
            bufferIndex = index;
            skip = false;
          } else {
            skip = true;
          }
        } else {
          skip = true;
        }
        final int tempIndex = text.indexOf(')', bufferEnd + 1);
        if (tempIndex >= 0 && text[index - 1] == ')' && bufferEnd < index + 1) {
          bufferEnd = bufferIndex;
        } else {
          bufferEnd = index;
        }
      } else if (end == ')' && value > 3) {
        int? index = bufferEnd;
        final String text = String.fromCharCodes(buffer);
        index = text.indexOf(end, bufferStart) + 1;
        while (text[index! - 2] == r'\') {
          index = text.indexOf(end, index) + 1;
        }
        if (bufferEnd > index + 1) {
          bufferEnd = index;
        }
        if (text[index - 1] == ')') {
          bufferIndex = index - 1;
          skip = false;
        } else {
          skip = true;
        }
      }
    }
    return String.fromCharCodes(buffer.sublist(bufferStart, bufferEnd));
  }

  // ignore: use_setters_to_change_properties
  void _begin(_State state) {
    lexicalState = state;
  }

  void _error(_Error code, bool fatal) {
    if (fatal) {
      if (objectName != null) {
        throw ArgumentError.value(code,
            'Fatal Error occurred at $position.\n When reading object type of ${objectName!}');
      } else {
        throw ArgumentError.value(code, 'Fatal Error occurred at $position');
      }
    }
  }
}

enum _State { initial, hexString, string }

enum _Error { internal, match }
