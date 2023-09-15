import 'dart:collection';

import '../../interfaces/pdf_interface.dart';
import '../primitives/pdf_array.dart';
import '../primitives/pdf_boolean.dart';
import '../primitives/pdf_dictionary.dart';
import '../primitives/pdf_name.dart';
import '../primitives/pdf_null.dart';
import '../primitives/pdf_number.dart';
import '../primitives/pdf_reference.dart';
import '../primitives/pdf_reference_holder.dart';
import '../primitives/pdf_stream.dart';
import '../primitives/pdf_string.dart';
import 'cross_table.dart';
import 'decode_big_endian.dart';
import 'enums.dart';
import 'pdf_constants.dart';
import 'pdf_cross_table.dart';
import 'pdf_lexer.dart';
import 'pdf_reader.dart';

/// internal class
class PdfParser {
  //Constructor
  /// internal constructor
  PdfParser(CrossTable cTable, PdfReader reader, PdfCrossTable crossTable) {
    _isColorSpace = false;
    _isPassword = false;
    _reader = reader;
    _cTable = cTable;
    _crossTable = crossTable;
    _lexer = PdfLexer(reader);
  }

  //Fields
  CrossTable? _cTable;
  late PdfReader _reader;
  PdfLexer? _lexer;
  PdfTokenType? _next;
  PdfCrossTable? _crossTable;

  /// internal field
  Queue<int> integerQueue = Queue<int>();
  late bool _isPassword;
  late bool _isColorSpace;
  List<String>? _windows1252MapTable;

  //Properties
  /// internal property
  List<String>? get windows1252MapTable {
    _windows1252MapTable ??= <String>[
      '\u007f',
      '€',
      '\u0081',
      '‚',
      'ƒ',
      '„',
      '…',
      '†',
      '‡',
      'ˆ',
      '‰',
      'Š',
      '‹',
      'Œ',
      '\u008d',
      'Ž',
      '\u008f',
      '\u0090',
      '‘',
      '’',
      '“',
      '”',
      '•',
      '–',
      '—',
      '˜',
      '™',
      'š',
      '›',
      'œ',
      '\u009d',
      'ž',
      'Ÿ',
      ' ',
      '¡',
      '¢',
      '£'
    ];
    return _windows1252MapTable;
  }

  //Implementation
  /// internal method
  void setOffset(int offset) {
    _reader.position = offset;
    if (integerQueue.isNotEmpty) {
      integerQueue = Queue<int>();
    }
    _lexer!.reset();
  }

  PdfNumber? _parseInteger() {
    final double? value = double.tryParse(_lexer!.text);
    PdfNumber? integer;
    if (value != null) {
      integer = PdfNumber(value);
    } else {
      _error(_ErrorType.badlyFormedInteger, _lexer!.text);
    }
    _advance();
    return integer;
  }

  IPdfPrimitive? _number() {
    IPdfPrimitive? obj;
    PdfNumber? integer;
    if (integerQueue.isNotEmpty) {
      integer = PdfNumber(integerQueue.removeFirst());
    } else {
      _match(_next, PdfTokenType.number);
      integer = _parseInteger();
    }
    obj = integer;
    if (_next == PdfTokenType.number) {
      final PdfNumber? integer2 = _parseInteger();
      if (_next == PdfTokenType.reference) {
        final PdfReference reference =
            PdfReference(integer!.value!.toInt(), integer2!.value!.toInt());
        obj = PdfReferenceHolder.fromReference(reference, _crossTable);
        _advance();
      } else {
        integerQueue.addLast(integer2!.value!.toInt());
      }
    }
    return obj;
  }

  void _parseOldXRef(CrossTable cTable, Map<int, ObjectInformation>? objects) {
    _advance();
    while (_isSubsection()) {
      cTable.parseSubsection(this, objects);
    }
  }

  bool _isSubsection() {
    bool result = false;
    if (_next == PdfTokenType.trailer) {
      result = false;
    } else if (_next == PdfTokenType.number) {
      result = true;
    } else {
      throw ArgumentError.value(result, 'Invalid format');
    }
    return result;
  }

  /// internal method
  Map<String, dynamic> parseCrossReferenceTable(
      Map<int, ObjectInformation>? objects, CrossTable cTable) {
    IPdfPrimitive? obj;
    _advance();
    if (_next == PdfTokenType.xRef) {
      _parseOldXRef(cTable, objects);
      obj = _trailer();
      final PdfDictionary trailerDic = obj as PdfDictionary;
      if (trailerDic.containsKey('Size')) {
        final int size = (trailerDic['Size']! as PdfNumber).value!.toInt();
        int initialNumber = 0;
        if (cTable.initialSubsectionCount == cTable.initialNumberOfSubsection) {
          initialNumber = cTable.initialNumberOfSubsection;
        } else {
          initialNumber = cTable.initialSubsectionCount;
        }
        int total = 0;
        total = cTable.totalNumberOfSubsection;
        if (size < initialNumber + total &&
            initialNumber > 0 &&
            size == total) {
          final int difference = initialNumber + total - size;
          final Map<int, ObjectInformation> newObjects =
              <int, ObjectInformation>{};
          final List<int> keys = objects!.keys.toList();
          for (int i = 0; i < keys.length; i++) {
            newObjects[keys[i] - difference] = objects[keys[i]]!;
          }
          objects = newObjects;
          cTable.objects = newObjects;
        }
      }
    } else {
      obj = _parse();
      objects = cTable.parseNewTable(obj as PdfStream?, objects);
    }
    if (obj is PdfDictionary &&
        _crossTable != null &&
        obj.containsKey('XRefStm')) {
      try {
        int xrefStreamPosition = 0;
        final PdfDictionary trailerDictionary = obj;
        final IPdfPrimitive? pdfNumber =
            PdfCrossTable.dereference(trailerDictionary['XRefStm']);
        if (pdfNumber != null && pdfNumber is PdfNumber) {
          xrefStreamPosition = pdfNumber.value!.toInt();
        }
        cTable.parser.setOffset(xrefStreamPosition);
        final IPdfPrimitive? xrefStream =
            cTable.parser.parseOffset(xrefStreamPosition);
        if (xrefStream != null && xrefStream is PdfStream) {
          objects = cTable.parseNewTable(xrefStream, objects);
        }
      } catch (e) {
        //exception may occurs if offest is not correct/crosstable is corrupted.
      }
    }
    return <String, dynamic>{'object': obj, 'objects': objects};
  }

  IPdfPrimitive _trailer() {
    _match(_next, PdfTokenType.trailer);
    _advance();
    return _dictionary();
  }

  /// internal method
  IPdfPrimitive? parseOffset(int offset) {
    setOffset(offset);
    _advance();
    return _parse();
  }

  IPdfPrimitive? _parse() {
    _match(_next, PdfTokenType.number);
    simple();
    simple();
    _match(_next, PdfTokenType.objectStart);
    _advance();
    final IPdfPrimitive? obj = simple();
    if (_next != PdfTokenType.objectEnd) {
      _next = PdfTokenType.objectEnd;
    }
    _match(_next, PdfTokenType.objectEnd);
    if (!_lexer!.skip) {
      _advance();
    } else {
      _lexer!.skip = false;
    }
    return obj;
  }

  /// internal method
  IPdfPrimitive? simple() {
    IPdfPrimitive? obj;
    if (integerQueue.isNotEmpty) {
      obj = _number();
    } else {
      switch (_next) {
        case PdfTokenType.dictionaryStart:
          obj = _dictionary();
          break;
        case PdfTokenType.arrayStart:
          obj = _array();
          break;
        case PdfTokenType.hexStringStart:
          obj = _hexString();
          break;
        case PdfTokenType.string:
          obj = _readString();
          break;
        case PdfTokenType.unicodeString:
          obj = _readUnicodeString();
          break;
        case PdfTokenType.name:
          obj = _readName();
          break;
        case PdfTokenType.boolean:
          obj = _readBoolean();
          break;
        case PdfTokenType.real:
          obj = _real();
          break;
        case PdfTokenType.number:
          obj = _number();
          break;
        case PdfTokenType.nullType:
          obj = PdfNull();
          _advance();
          break;
        // ignore: no_default_cases
        default:
          obj = null;
          break;
      }
    }
    return obj;
  }

  IPdfPrimitive? _real() {
    _match(_next, PdfTokenType.real);
    final double? value = double.tryParse(_lexer!.text);
    PdfNumber? real;
    if (value != null) {
      real = PdfNumber(value);
    } else {
      _error(_ErrorType.badlyFormedReal, _lexer!.text);
    }
    _advance();
    return real;
  }

  IPdfPrimitive _readBoolean() {
    _match(_next, PdfTokenType.boolean);
    final bool value = _lexer!.text == 'true';
    final PdfBoolean result = PdfBoolean(value);
    _advance();
    return result;
  }

  IPdfPrimitive _readName() {
    _match(_next, PdfTokenType.name);
    final String name = _lexer!.text.substring(1);
    final PdfName result = PdfName(name);
    _advance();
    return result;
  }

  /// internal method
  void startFrom(int offset) {
    setOffset(offset);
    _advance();
  }

  /// internal method
  void rebuildXrefTable(
      Map<int, ObjectInformation?> newObjects, CrossTable? crosstable) {
    final PdfReader reader = PdfReader(_reader.streamReader.data);
    reader.position = 0;
    newObjects.clear();
    int? objNumber = 0;
    int? marker = 0;
    List<String> previoursToken = <String>['\u0000'];
    while (true) {
      if (reader.position >= reader.length! - 1) {
        break;
      }
      final int previousPosition = reader.position;
      String str = '';
      str = reader.readLine();
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
              if (marker == 0 && words[2] == PdfDictionaryProperties.obj) {
                final ObjectInformation objectInfo =
                    ObjectInformation(previousPosition, null, crosstable);
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

  IPdfPrimitive _readString() {
    _match(_next, PdfTokenType.string);
    String text = _lexer!.stringText;
    bool unicode = false;
    if (_isPassword) {
      text = String.fromCharCodes(_processEscapes(text));
    } else if (!_isColorSpace) {
      if (_checkForPreamble(text)) {
        text = _processUnicodeWithPreamble(text);
        unicode = true;
      } else {
        if (!_checkUnicodePreamble(text)) {
          text = String.fromCharCodes(_processEscapes(text));
        }
        if (_checkForPreamble(text)) {
          text = _processUnicodeWithPreamble(text);
          unicode = true;
        }
        if (_checkUnicodePreamble(text)) {
          text = text.substring(2);
          text = String.fromCharCodes(_processEscapes(text));
        }
      }
    } else {
      if (_isColorSpace) {
        text = String.fromCharCodes(_processEscapes(text));
      }
      text = 'ColorFound$text';
    }
    final PdfString str = PdfString(text);
    if (!unicode) {
      str.encode = ForceEncoding.ascii;
    } else {
      str.encode = ForceEncoding.unicode;
    }
    _advance();
    return str;
  }

  String _processUnicodeWithPreamble(String text) {
    final List<int> data = _processEscapes(text);
    return decodeBigEndian(data, 2, data.length - 2);
  }

  IPdfPrimitive _readUnicodeString([String? validateText]) {
    final String text = validateText ?? _lexer!.text;
    String value = text.substring(0);
    bool unicode = false;
    if (value.length > 2) {
      value = value.substring(1, value.length - 1);
    }
    if (_checkForPreamble(value)) {
      value = _processUnicodeWithPreamble(value);
      unicode = true;
    } else {
      value = String.fromCharCodes(_processEscapes(value));
    }
    final PdfString str = PdfString(value);
    if (!unicode) {
      str.encode = ForceEncoding.ascii;
    } else {
      str.encode = ForceEncoding.unicode;
    }
    if (!_lexer!.skip) {
      _advance();
    } else {
      _next = PdfTokenType.dictionaryEnd;
    }
    return str;
  }

  bool _checkForPreamble(String text) {
    return text.length > 1 &&
        text.codeUnitAt(0) == 254 &&
        text.codeUnitAt(1) == 255;
  }

  bool _checkUnicodePreamble(String text) {
    return text.length > 1 &&
        text.codeUnitAt(0) == 255 &&
        text.codeUnitAt(1) == 254;
  }

  List<int> _processEscapes(String text) {
    final List<int> data = text.codeUnits;
    final List<int> result = <int>[];
    for (int i = 0; i < data.length; i++) {
      if (data[i] == 92) {
        int next = data[++i];
        switch (next) {
          case 110:
            result.add(10);
            break;
          case 114:
            result.add(13);
            break;
          case 116:
            result.add(9);
            break;
          case 98:
            result.add(8);
            break;
          case 102:
            result.add(12);
            break;
          case 13:
            next = data[++i];
            if (next != 10) {
              --i;
            }
            break;
          case 10:
            break;
          case 40:
          case 41:
          case 92:
            result.add(next);
            break;
          default:
            if (next < 48 || next > 55) {
              result.add(next);
              break;
            }
            int octal = next - 48;
            next = data[++i];
            if (next < 48 || next > 55) {
              --i;
              result.add(octal);
              break;
            }
            octal = (octal << 3) + next - 48;
            next = data[++i];
            if (next < 48 || next > 55) {
              --i;
              result.add(octal);
              break;
            }
            octal = (octal << 3) + next - 48;
            result.add(octal & 0xff);
            break;
        }
      } else {
        result.add(data[i]);
      }
    }
    return result;
  }

  // ignore: unused_element
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
    value = double.tryParse(octalText)!.toInt();
    return <String, dynamic>{'value': String.fromCharCode(value), 'index': i};
  }

  IPdfPrimitive _hexString() {
    _match(_next, PdfTokenType.hexStringStart);
    _advance();
    String sb = '';
    bool isHex = true;
    while (_next != PdfTokenType.hexStringEnd) {
      String text = _lexer!.text;
      if (_next == PdfTokenType.hexStringWeird) {
        isHex = false;
      } else if (_next == PdfTokenType.hexStringWeirdEscape) {
        isHex = false;
        text = text.substring(1);
      }
      sb += text;
      _advance();
    }
    _match(_next, PdfTokenType.hexStringEnd);
    _advance();
    final PdfString result = PdfString(sb, !isHex);
    return result;
  }

  IPdfPrimitive _array() {
    _match(_next, PdfTokenType.arrayStart);
    _advance();
    IPdfPrimitive? obj;
    final PdfArray array = PdfArray();
    _lexer!.isArray = true;
    while ((obj = simple()) != null) {
      array.add(obj!);
      if (array[0] is PdfName && (array[0]! as PdfName).name == 'Indexed') {
        _isColorSpace = true;
      } else {
        _isColorSpace = false;
      }
      if (_next == PdfTokenType.unknown) {
        _advance();
      }
    }
    _match(_next, PdfTokenType.arrayEnd);
    _advance();
    _lexer!.isArray = false;
    array.freezeChanges(this);
    return array;
  }

  IPdfPrimitive _dictionary() {
    _match(_next, PdfTokenType.dictionaryStart);
    _advance();
    final PdfDictionary dic = PdfDictionary();
    _Pair pair = _readPair();
    while (pair.name != null && pair._value != null) {
      if (pair._value != null) {
        dic[pair.name] = pair._value;
      }
      pair = _readPair();
    }
    if (_next != PdfTokenType.dictionaryEnd) {
      _next = PdfTokenType.dictionaryEnd;
    }
    _match(_next, PdfTokenType.dictionaryEnd);
    if (!_lexer!.skip) {
      _advance();
    } else {
      _next = PdfTokenType.objectEnd;
      _lexer!.skip = false;
    }
    IPdfPrimitive result;
    if (_next == PdfTokenType.streamStart) {
      result = _readStream(dic);
    } else {
      result = dic;
    }
    (result as IPdfChangable).freezeChanges(this);
    return result;
  }

  IPdfPrimitive _readStream(PdfDictionary dic) {
    _match(_next, PdfTokenType.streamStart);
    _lexer!.skipToken();
    _lexer!.skipNewLine();

    IPdfPrimitive? obj = dic[PdfDictionaryProperties.length];
    PdfNumber? length;
    PdfReferenceHolder? reference;
    if (obj is PdfNumber) {
      length = obj;
    }
    if (obj is PdfReferenceHolder) {
      reference = obj;
    }
    if (length == null && reference == null) {
      final int lexerPosition = _lexer!.position;
      final int position = _reader.position;
      _reader.position = lexerPosition;
      final int end = _reader.searchForward('endstream');
      int streamLength;
      if (end > lexerPosition) {
        streamLength = end - lexerPosition;
      } else {
        streamLength = lexerPosition - end;
      }
      _reader.position = position;
      final List<int> buffer = _lexer!.readBytes(streamLength);
      final PdfStream innerStream = PdfStream(dic, buffer);
      _advance();
      if (_next != PdfTokenType.streamEnd) {
        _next = PdfTokenType.streamEnd;
      }
      _match(_next, PdfTokenType.streamEnd);
      _advance();
      if (_next != PdfTokenType.objectEnd) {}
      return innerStream;
    } else if (reference != null) {
      final PdfReferenceHolder reference = obj! as PdfReferenceHolder;
      final PdfLexer? lex = _lexer;
      final int position = _reader.position;
      _lexer = PdfLexer(_reader);
      obj = _cTable!.getObject(reference.reference);
      length = obj as PdfNumber?;
      _reader.position = position;
      _lexer = lex;
    }
    final int intLength = length!.value!.toInt();
    final bool check = _checkStreamLength(_lexer!.position, intLength);
    PdfStream stream;
    if (check) {
      final List<int> buf = _lexer!.readBytes(intLength);
      stream = PdfStream(dic, buf);
    } else {
      final int lexerPosition = _lexer!.position;
      final int position = _reader.position;
      _reader.position = lexerPosition;
      final int end = _reader.searchForward('endstream');
      int streamLength;
      if (end > lexerPosition) {
        streamLength = end - lexerPosition;
      } else {
        streamLength = lexerPosition - end;
      }
      _reader.position = position;
      final List<int> buf = _lexer!.readBytes(streamLength);
      stream = PdfStream(dic, buf);
    }
    _advance();
    if (_next != PdfTokenType.streamEnd) {
      _next = PdfTokenType.streamEnd;
    }
    _match(_next, PdfTokenType.streamEnd);
    _advance();
    if (_next != PdfTokenType.objectEnd) {
      _next = PdfTokenType.objectEnd;
    }
    return stream;
  }

  /// internal method
  String getObjectFlag() {
    _match(_next, PdfTokenType.objectType);
    final String type = _lexer!.text[0];
    _advance();
    return type;
  }

  bool _checkStreamLength(int lexPosition, int value) {
    String line = '';
    bool check = true;
    final int position = _reader.position;
    _reader.position = lexPosition + value;
    final List<String> buff = List<String>.filled(20, '');
    _reader.readBlock(buff, 0, 20);
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
    IPdfPrimitive? obj;
    try {
      obj = simple();
    } catch (e) {
      obj = null;
    }
    if (obj == null) {
      return _Pair.empty;
    }
    PdfName? name;
    if (obj is PdfName) {
      name = obj;
    } else {
      _error(_ErrorType.badlyFormedDictionary, 'next should be a name.');
    }
    if (name!.name == PdfDictionaryProperties.u ||
        name.name == PdfDictionaryProperties.o) {
      _isPassword = true;
    }
    obj = simple();
    _isPassword = false;
    return _Pair(name, obj);
  }

  /// internal method
  int startCrossReference() {
    _advance();
    _match(_next, PdfTokenType.startXRef);
    _advance();
    final PdfNumber? number = _number() as PdfNumber?;
    if (number != null) {
      return number.value!.toInt();
    } else {
      return 0;
    }
  }

  void _match(PdfTokenType? token, PdfTokenType match) {
    if (token != match) {
      _error(_ErrorType.unexpected, token.toString());
    }
  }

  void _error(_ErrorType error, String? additional) {
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
        message = 'Internal error.';
        break;
    }

    if (additional != null) {
      message = '$message$additional before ${_lexer!.position}';
    }

    throw ArgumentError.value(error, message);
  }

  void _advance() {
    if (_cTable != null && _cTable!.validateSyntax) {
      _lexer!.getNextToken();
    }
    _next = _lexer!.getNextToken();
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
  _Pair(this.name, IPdfPrimitive? value) {
    _value = value;
  }

  static _Pair get empty => _Pair(null, null);

  //Fields
  PdfName? name;
  IPdfPrimitive? _value;
}
