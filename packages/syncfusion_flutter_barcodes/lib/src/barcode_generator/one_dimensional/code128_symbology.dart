part of barcodes;

/// The [Code128] is a highly efficient, high-density linear barcode symbology
/// that allows the encoding of alphanumeric data. It is capable of encoding
/// full ASCII character set and extended character sets.
/// This symbology contains the checksum digit for verification and the barcode
/// can also be verified character-by-character for the parity
/// of each data byte.
class Code128 extends Symbology {
  /// Create a [Code128] symbology with the default or required properties.
  ///
  /// The arguments [module] must be non-negative and greater than 0.
  ///
  /// The Code128 symbology encodes the input symbols supported by [Code128A],
  /// [Code128B], [Code128C]. The default symbology type of barcode
  /// generator is [Code128].
  ///
  /// This is a very large method. This method could be
  /// refactor to a smaller methods, but it degrades the performance.Since it
  /// adds the character corresponding to this symbology is added in to the list
  Code128({int module})
      : super(
          module: module,
        ) {
    _code128ACharacterSets = <String>[];

    _code128ACharacterSets.add(' ');
    _code128ACharacterSets.add('!');
    _code128ACharacterSets.add('"');
    _code128ACharacterSets.add('#');
    _code128ACharacterSets.add('\$');
    _code128ACharacterSets.add('%');
    _code128ACharacterSets.add('&');
    _code128ACharacterSets.add('\'');
    _code128ACharacterSets.add('(');
    _code128ACharacterSets.add(')');
    _code128ACharacterSets.add('*');
    _code128ACharacterSets.add('+');
    _code128ACharacterSets.add(',');
    _code128ACharacterSets.add('-');
    _code128ACharacterSets.add('.');
    _code128ACharacterSets.add('/');
    _code128ACharacterSets.add('0');
    _code128ACharacterSets.add('1');
    _code128ACharacterSets.add('2');
    _code128ACharacterSets.add('3');
    _code128ACharacterSets.add('4');
    _code128ACharacterSets.add('5');
    _code128ACharacterSets.add('6');
    _code128ACharacterSets.add('7');
    _code128ACharacterSets.add('8');
    _code128ACharacterSets.add('9');
    _code128ACharacterSets.add(':');
    _code128ACharacterSets.add(';');
    _code128ACharacterSets.add('<');
    _code128ACharacterSets.add('=');
    _code128ACharacterSets.add('>');
    _code128ACharacterSets.add('?');
    _code128ACharacterSets.add('@');
    _code128ACharacterSets.add('A');
    _code128ACharacterSets.add('B');
    _code128ACharacterSets.add('C');
    _code128ACharacterSets.add('D');
    _code128ACharacterSets.add('E');
    _code128ACharacterSets.add('F');
    _code128ACharacterSets.add('G');
    _code128ACharacterSets.add('H');
    _code128ACharacterSets.add('I');
    _code128ACharacterSets.add('J');
    _code128ACharacterSets.add('K');
    _code128ACharacterSets.add('L');
    _code128ACharacterSets.add('M');
    _code128ACharacterSets.add('N');
    _code128ACharacterSets.add('O');
    _code128ACharacterSets.add('P');
    _code128ACharacterSets.add('Q');
    _code128ACharacterSets.add('R');
    _code128ACharacterSets.add('S');
    _code128ACharacterSets.add('T');
    _code128ACharacterSets.add('U');
    _code128ACharacterSets.add('V');
    _code128ACharacterSets.add('W');
    _code128ACharacterSets.add('X');
    _code128ACharacterSets.add('Y');
    _code128ACharacterSets.add('Z');
    _code128ACharacterSets.add('[');
    _code128ACharacterSets.add('\\');
    _code128ACharacterSets.add(']');
    _code128ACharacterSets.add('^');
    _code128ACharacterSets.add('_');
    _code128ACharacterSets.add('\0');
    _code128ACharacterSets.add('\u0001');
    _code128ACharacterSets.add('\u0002');
    _code128ACharacterSets.add('\u0003');
    _code128ACharacterSets.add('\u0004');
    _code128ACharacterSets.add('\u0005');
    _code128ACharacterSets.add('\u0006');
    _code128ACharacterSets.add('\a');
    _code128ACharacterSets.add('\b');
    _code128ACharacterSets.add('\t');
    _code128ACharacterSets.add('\n');
    _code128ACharacterSets.add('\v');
    _code128ACharacterSets.add('\f');
    _code128ACharacterSets.add('\r');
    _code128ACharacterSets.add('\u000e');
    _code128ACharacterSets.add('\u000f');
    _code128ACharacterSets.add('\u0010');
    _code128ACharacterSets.add('\u0011');
    _code128ACharacterSets.add('\u0012');
    _code128ACharacterSets.add('\u0013');
    _code128ACharacterSets.add('\u0014');
    _code128ACharacterSets.add('\u0015');
    _code128ACharacterSets.add('\u0016');
    _code128ACharacterSets.add('\u0017');
    _code128ACharacterSets.add('\u0018');
    _code128ACharacterSets.add('\u0019');
    _code128ACharacterSets.add('\u001a');
    _code128ACharacterSets.add('\u001b');
    _code128ACharacterSets.add('\u001c');
    _code128ACharacterSets.add('\u001d');
    _code128ACharacterSets.add('\u001e');
    _code128ACharacterSets.add('\u001f');
    _code128ACharacterSets.add('ù');
    _code128ACharacterSets.add('ø');
    _code128ACharacterSets.add('û');
    _code128ACharacterSets.add('ö');
    _code128ACharacterSets.add('õ');
    _code128ACharacterSets.add('ú');
    _code128ACharacterSets.add('÷');
    _code128ACharacterSets.add('ü');
    _code128ACharacterSets.add('ý');
    _code128ACharacterSets.add('þ');
    _code128ACharacterSets.add('ÿ');

    _code128BCharacterSets = <String>[];
    _code128BCharacterSets.add(' ');
    _code128BCharacterSets.add('!');
    _code128BCharacterSets.add('"');
    _code128BCharacterSets.add('#');
    _code128BCharacterSets.add('\$');
    _code128BCharacterSets.add('%');
    _code128BCharacterSets.add('&');
    _code128BCharacterSets.add('\'');
    _code128BCharacterSets.add('(');
    _code128BCharacterSets.add(')');
    _code128BCharacterSets.add('*');
    _code128BCharacterSets.add('+');
    _code128BCharacterSets.add(',');
    _code128BCharacterSets.add('-');
    _code128BCharacterSets.add('.');
    _code128BCharacterSets.add('/');
    _code128BCharacterSets.add('0');
    _code128BCharacterSets.add('1');
    _code128BCharacterSets.add('2');
    _code128BCharacterSets.add('3');
    _code128BCharacterSets.add('4');
    _code128BCharacterSets.add('5');
    _code128BCharacterSets.add('6');
    _code128BCharacterSets.add('7');
    _code128BCharacterSets.add('8');
    _code128BCharacterSets.add('9');
    _code128BCharacterSets.add(':');
    _code128BCharacterSets.add(';');
    _code128BCharacterSets.add('<');
    _code128BCharacterSets.add('=');
    _code128BCharacterSets.add('>');
    _code128BCharacterSets.add('?');
    _code128BCharacterSets.add('@');
    _code128BCharacterSets.add('A');
    _code128BCharacterSets.add('B');
    _code128BCharacterSets.add('C');
    _code128BCharacterSets.add('D');
    _code128BCharacterSets.add('E');
    _code128BCharacterSets.add('F');
    _code128BCharacterSets.add('G');
    _code128BCharacterSets.add('H');
    _code128BCharacterSets.add('I');
    _code128BCharacterSets.add('J');
    _code128BCharacterSets.add('K');
    _code128BCharacterSets.add('L');
    _code128BCharacterSets.add('M');
    _code128BCharacterSets.add('N');
    _code128BCharacterSets.add('O');
    _code128BCharacterSets.add('P');
    _code128BCharacterSets.add('Q');
    _code128BCharacterSets.add('R');
    _code128BCharacterSets.add('S');
    _code128BCharacterSets.add('T');
    _code128BCharacterSets.add('U');
    _code128BCharacterSets.add('V');
    _code128BCharacterSets.add('W');
    _code128BCharacterSets.add('X');
    _code128BCharacterSets.add('Y');
    _code128BCharacterSets.add('Z');
    _code128BCharacterSets.add('[');
    _code128BCharacterSets.add('\\');
    _code128BCharacterSets.add(']');
    _code128BCharacterSets.add('^');
    _code128BCharacterSets.add('_');
    _code128BCharacterSets.add('`');
    _code128BCharacterSets.add('a');
    _code128BCharacterSets.add('b');
    _code128BCharacterSets.add('c');
    _code128BCharacterSets.add('d');
    _code128BCharacterSets.add('e');
    _code128BCharacterSets.add('f');
    _code128BCharacterSets.add('g');
    _code128BCharacterSets.add('h');
    _code128BCharacterSets.add('i');
    _code128BCharacterSets.add('j');
    _code128BCharacterSets.add('k');
    _code128BCharacterSets.add('l');
    _code128BCharacterSets.add('m');
    _code128BCharacterSets.add('n');
    _code128BCharacterSets.add('o');
    _code128BCharacterSets.add('p');
    _code128BCharacterSets.add('q');
    _code128BCharacterSets.add('r');
    _code128BCharacterSets.add('s');
    _code128BCharacterSets.add('t');
    _code128BCharacterSets.add('u');
    _code128BCharacterSets.add('v');
    _code128BCharacterSets.add('w');
    _code128BCharacterSets.add('x');
    _code128BCharacterSets.add('y');
    _code128BCharacterSets.add('z');
    _code128BCharacterSets.add('{');
    _code128BCharacterSets.add('|');
    _code128BCharacterSets.add('}');
    _code128BCharacterSets.add('~');
    _code128BCharacterSets.add('\u007f');
    _code128BCharacterSets.add('ù');
    _code128BCharacterSets.add('ø');
    _code128BCharacterSets.add('û');
    _code128BCharacterSets.add('ö');
    _code128BCharacterSets.add('ú');
    _code128BCharacterSets.add('ô');
    _code128BCharacterSets.add('÷');
    _code128BCharacterSets.add('ü');
    _code128BCharacterSets.add('ý');
    _code128BCharacterSets.add('þ');
    _code128BCharacterSets.add('ÿ');

    _code128CCharacterSets = <String>[];
    _code128CCharacterSets.add('0');
    _code128CCharacterSets.add('1');
    _code128CCharacterSets.add('2');
    _code128CCharacterSets.add('3');
    _code128CCharacterSets.add('4');
    _code128CCharacterSets.add('5');
    _code128CCharacterSets.add('6');
    _code128CCharacterSets.add('7');
    _code128CCharacterSets.add('8');
    _code128CCharacterSets.add('9');
    _code128CCharacterSets.add('õ');
    _code128CCharacterSets.add('ô');
    _code128CCharacterSets.add('÷');
    _code128CCharacterSets.add('ü');
    _code128CCharacterSets.add('ý');
    _code128CCharacterSets.add('þ');
    _code128CCharacterSets.add('ÿ');
  }

  /// Represents the start symbol of code128A
  static const int _codeAStartSymbol = 103;

  /// Represents the start symbol for Code128B
  static const int _codeBStartSymbol = 104;

  /// Represents the start symbol for Code128C
  static const int _codeCStartSymbol = 105;

  /// Specifies the value for code128A
  static const int _codeA = 101;

  /// Specifies the value for code128B
  static const int _codeB = 100;

  /// Specifies the value for code128C
  static const int _codeC = 99;

  /// Specifies  the stop symbol
  static const int _codeStopSymbol = 106;

  /// Represents the index value of FNC1 special character
  static const int _codeFNC1 = 102;

  /// Represents the index value of FNC2 special character
  static const int _codeFNC2 = 97;

  /// Represents the index value of FNC3 special character
  static const int _codeFNC3 = 96;

  /// Represents the index value of FNC4A special character
  static const int _codeFNC4A = 101;

  /// Represents the index value of FNC4B special character
  static const int _codeFNC4B = 100;

  /// Represents the FNC1 special character
  static const String _fnc1 = '\u00f1';

  /// Represents the FNC2 special character
  static const String _fnc2 = '\u00f2';

  /// Represents the FNC3 special character
  static const String _fnc3 = '\u00f3';

  /// Represents the FNC4 special character
  static const String _fnc4 = '\u00f4';

  /// Represents the supported symbol character of code128A
  List<String> _code128ACharacterSets;

  /// Represents the supported symbol character of code128B
  List<String> _code128BCharacterSets;

  /// Represents the supported symbol character of code128C
  List<String> _code128CCharacterSets;

  /// Returns the byte value of supported symbol
  ///
  /// This is quite a large method. This method could not be
  /// refactored to a smaller methods, since the code value corresponds to this
  /// symbology is added into the collection
  List<List<int>> _getCodeValue() {
    return <List<int>>[
      <int>[2, 1, 2, 2, 2, 2],
      <int>[2, 2, 2, 1, 2, 2],
      <int>[2, 2, 2, 2, 2, 1],
      <int>[1, 2, 1, 2, 2, 3],
      <int>[1, 2, 1, 3, 2, 2],
      <int>[1, 3, 1, 2, 2, 2],
      <int>[1, 2, 2, 2, 1, 3],
      <int>[1, 2, 2, 3, 1, 2],
      <int>[1, 3, 2, 2, 1, 2],
      <int>[2, 2, 1, 2, 1, 3],
      <int>[2, 2, 1, 3, 1, 2],
      <int>[2, 3, 1, 2, 1, 2],
      <int>[1, 1, 2, 2, 3, 2],
      <int>[1, 2, 2, 1, 3, 2],
      <int>[1, 2, 2, 2, 3, 1],
      <int>[1, 1, 3, 2, 2, 2],
      <int>[1, 2, 3, 1, 2, 2],
      <int>[1, 2, 3, 2, 2, 1],
      <int>[2, 2, 3, 2, 1, 1],
      <int>[2, 2, 1, 1, 3, 2],
      <int>[2, 2, 1, 2, 3, 1],
      <int>[2, 1, 3, 2, 1, 2],
      <int>[2, 2, 3, 1, 1, 2],
      <int>[3, 1, 2, 1, 3, 1],
      <int>[3, 1, 1, 2, 2, 2],
      <int>[3, 2, 1, 1, 2, 2],
      <int>[3, 2, 1, 2, 2, 1],
      <int>[3, 1, 2, 2, 1, 2],
      <int>[3, 2, 2, 1, 1, 2],
      <int>[3, 2, 2, 2, 1, 1],
      <int>[2, 1, 2, 1, 2, 3],
      <int>[2, 1, 2, 3, 2, 1],
      <int>[2, 3, 2, 1, 2, 1],
      <int>[1, 1, 1, 3, 2, 3],
      <int>[1, 3, 1, 1, 2, 3],
      <int>[1, 3, 1, 3, 2, 1],
      <int>[1, 1, 2, 3, 1, 3],
      <int>[1, 3, 2, 1, 1, 3],
      <int>[1, 3, 2, 3, 1, 1],
      <int>[2, 1, 1, 3, 1, 3],
      <int>[2, 3, 1, 1, 1, 3],
      <int>[2, 3, 1, 3, 1, 1],
      <int>[1, 1, 2, 1, 3, 3],
      <int>[1, 1, 2, 3, 3, 1],
      <int>[1, 3, 2, 1, 3, 1],
      <int>[1, 1, 3, 1, 2, 3],
      <int>[1, 1, 3, 3, 2, 1],
      <int>[1, 3, 3, 1, 2, 1],
      <int>[3, 1, 3, 1, 2, 1],
      <int>[2, 1, 1, 3, 3, 1],
      <int>[2, 3, 1, 1, 3, 1],
      <int>[2, 1, 3, 1, 1, 3],
      <int>[2, 1, 3, 3, 1, 1],
      <int>[2, 1, 3, 1, 3, 1],
      <int>[3, 1, 1, 1, 2, 3],
      <int>[3, 1, 1, 3, 2, 1],
      <int>[3, 3, 1, 1, 2, 1],
      <int>[3, 1, 2, 1, 1, 3],
      <int>[3, 1, 2, 3, 1, 1],
      <int>[3, 3, 2, 1, 1, 1],
      <int>[3, 1, 4, 1, 1, 1],
      <int>[2, 2, 1, 4, 1, 1],
      <int>[4, 3, 1, 1, 1, 1],
      <int>[1, 1, 1, 2, 2, 4],
      <int>[1, 1, 1, 4, 2, 2],
      <int>[1, 2, 1, 1, 2, 4],
      <int>[1, 2, 1, 4, 2, 1],
      <int>[1, 4, 1, 1, 2, 2],
      <int>[1, 4, 1, 2, 2, 1],
      <int>[1, 1, 2, 2, 1, 4],
      <int>[1, 1, 2, 4, 1, 2],
      <int>[1, 2, 2, 1, 1, 4],
      <int>[1, 2, 2, 4, 1, 1],
      <int>[1, 4, 2, 1, 1, 2],
      <int>[1, 4, 2, 2, 1, 1],
      <int>[2, 4, 1, 2, 1, 1],
      <int>[2, 2, 1, 1, 1, 4],
      <int>[4, 1, 3, 1, 1, 1],
      <int>[2, 4, 1, 1, 1, 2],
      <int>[1, 3, 4, 1, 1, 1],
      <int>[1, 1, 1, 2, 4, 2],
      <int>[1, 2, 1, 1, 4, 2],
      <int>[1, 2, 1, 2, 4, 1],
      <int>[1, 1, 4, 2, 1, 2],
      <int>[1, 2, 4, 1, 1, 2],
      <int>[1, 2, 4, 2, 1, 1],
      <int>[4, 1, 1, 2, 1, 2],
      <int>[4, 2, 1, 1, 1, 2],
      <int>[4, 2, 1, 2, 1, 1],
      <int>[2, 1, 2, 1, 4, 1],
      <int>[2, 1, 4, 1, 2, 1],
      <int>[4, 1, 2, 1, 2, 1],
      <int>[1, 1, 1, 1, 4, 3],
      <int>[1, 1, 1, 3, 4, 1],
      <int>[1, 3, 1, 1, 4, 1],
      <int>[1, 1, 4, 1, 1, 3],
      <int>[1, 1, 4, 3, 1, 1],
      <int>[4, 1, 1, 1, 1, 3],
      <int>[4, 1, 1, 3, 1, 1],
      <int>[1, 1, 3, 1, 4, 1],
      <int>[1, 1, 4, 1, 3, 1],
      <int>[3, 1, 1, 1, 4, 1],
      <int>[4, 1, 1, 1, 3, 1],
      <int>[2, 1, 1, 4, 1, 2],
      <int>[2, 1, 1, 2, 1, 4],
      <int>[2, 1, 1, 2, 3, 2],
      <int>[2, 3, 3, 1, 1, 1, 2]
    ];
  }

  @override
  bool _getIsValidateInput(String value) {
    for (int i = 0; i < value.length; i++) {
      final int currentCharacter = value[i].codeUnitAt(0);
      if (currentCharacter == _fnc1.codeUnitAt(0) ||
          currentCharacter == _fnc2.codeUnitAt(0) ||
          currentCharacter == _fnc3.codeUnitAt(0) ||
          currentCharacter == _fnc4.codeUnitAt(0)) {
        return true;
      } else if (currentCharacter < 127) {
        return true;
      } else {
        throw 'The provided input cannot be encoded : ' + value[i];
      }
    }
    return false;
  }

  /// Returns the encoded value
  List<List<int>> _getEncodedValue(String value) {
    final List<List<int>> encodedValue = <List<int>>[];
    final List<List<int>> bytes = _getCodeValue();
    int checkDigit = 0;
    int weightValue = 1;
    int codeTypeValue = 0;
    int currentPosition = 0;
    while (currentPosition < value.length) {
      final int currentCodeType =
          _getValidatedCode(currentPosition, codeTypeValue, value);
      int currentIndex;
      if (currentCodeType == codeTypeValue) {
        final int currentValue = value[currentPosition].codeUnitAt(0);
        if (currentValue == _fnc1.codeUnitAt(0)) {
          currentIndex = _codeFNC1;
        } else if (currentValue == _fnc2.codeUnitAt(0)) {
          currentIndex = _codeFNC2;
        } else if (currentValue == _fnc3.codeUnitAt(0)) {
          currentIndex = _codeFNC3;
        } else if (currentValue == _fnc4.codeUnitAt(0)) {
          if (currentCodeType == _codeA) {
            currentIndex = _codeFNC4A;
          } else {
            currentIndex = _codeFNC4B;
          }
        } else {
          // Calculates the current index value based on code128 type
          if (currentCodeType == _codeA) {
            currentIndex =
                value[currentPosition].codeUnitAt(0) - ' '.codeUnitAt(0);
            if (currentIndex < 0) {
              currentIndex += '`'.codeUnitAt(0);
            }
          } else if (currentCodeType == _codeB) {
            currentIndex =
                value[currentPosition].codeUnitAt(0) - ' '.codeUnitAt(0);
          } else {
            currentIndex = int.parse(
                value.substring(currentPosition, currentPosition + 2));
            currentPosition++;
          }
        }
        currentPosition++;
      } else {
        currentIndex = _getCurrentIndex(codeTypeValue, currentCodeType);
        codeTypeValue = currentCodeType;
      }
      encodedValue.add(bytes[currentIndex]);
      checkDigit += currentIndex * weightValue;
      if (currentPosition != 0) {
        weightValue++;
      }
    }
    checkDigit %= 103;
    encodedValue.add(bytes[checkDigit]);
    encodedValue.add(bytes[_codeStopSymbol]);
    return encodedValue;
  }

  /// Method to get the current index value
  int _getCurrentIndex(int codeTypeValue, int currentCodeType) {
    int currentIndex;
    if (codeTypeValue == 0) {
      if (currentCodeType == _codeA) {
        currentIndex = _codeAStartSymbol;
      } else if (currentCodeType == _codeB) {
        currentIndex = _codeBStartSymbol;
      } else {
        currentIndex = _codeCStartSymbol;
      }
    } else {
      currentIndex = currentCodeType;
    }

    return currentIndex;
  }

  /// Method to validate the corresponding code set based on the input
  int _getValidatedCode(int start, int previousCodeSet, String value) {
    CodeType codeType = _getCodeType(start, value);
    final int currentCodeType =
        _getValidatedCodeTypes(start, previousCodeSet, value, codeType);
    if (currentCodeType != null) {
      return currentCodeType;
    }
    if (previousCodeSet == _codeB) {
      if (codeType == CodeType.fnc1) {
        return _codeB;
      }
      codeType = _getCodeType(start + 2, value);
      if (codeType == CodeType.uncodable || codeType == CodeType.singleDigit) {
        return _codeB;
      }
      if (codeType == CodeType.fnc1) {
        codeType = _getCodeType(start + 3, value);
        if (codeType == CodeType.doubleDigit) {
          return this is Code128C ? _codeC : _codeB;
        } else {
          return _codeB;
        }
      }
      int currentIndex = start + 4;
      while (_getCodeType(currentIndex, value) == CodeType.doubleDigit) {
        currentIndex += 2;
      }
      if (codeType == CodeType.singleDigit) {
        return _codeB;
      }
      return this is Code128B ? _codeB : _codeC;
    }

    if (codeType == CodeType.fnc1) {
      codeType = _getCodeType(start + 1, value);
    }

    if (codeType == CodeType.doubleDigit) {
      return this is Code128B ? _codeB : _codeC;
    }
    return _codeB;
  }

  /// Method to get the validated types
  int _getValidatedCodeTypes(
      int start, int previousCodeSet, String value, CodeType codeType) {
    if (codeType == CodeType.singleDigit) {
      if (previousCodeSet == _codeA) {
        return _codeA;
      }
      return _codeB;
    }

    if (codeType == CodeType.uncodable) {
      if (start < value.length) {
        final int startIndex = value[start].codeUnitAt(0);
        if (startIndex < ' '.codeUnitAt(0) ||
            (previousCodeSet == _codeA &&
                (startIndex < '`'.codeUnitAt(0) ||
                    (startIndex >= _fnc1.codeUnitAt(0) &&
                        startIndex <= _fnc4.codeUnitAt(0))))) {
          return _codeA;
        }
      }
      return _codeB;
    }
    if (previousCodeSet == _codeA && codeType == CodeType.fnc1) {
      return _codeA;
    }
    if (previousCodeSet == _codeC) {
      return _codeC;
    }

    return null;
  }

  /// Returns the code type based on the input
  CodeType _getCodeType(int startIndex, String value) {
    final int length = value.length;
    if (startIndex >= length) {
      return CodeType.uncodable;
    }
    if (String.fromCharCode(value[startIndex].codeUnitAt(0)) ==
        String.fromCharCode(_fnc1.codeUnitAt(0))) {
      return CodeType.fnc1;
    }
    if (value[startIndex].codeUnitAt(0) < '0'.codeUnitAt(0) ||
        value[startIndex].codeUnitAt(0) > '9'.codeUnitAt(0)) {
      return CodeType.uncodable;
    }

    if (startIndex + 1 >= length) {
      return CodeType.singleDigit;
    }

    if (value[startIndex + 1].codeUnitAt(0) < '0'.codeUnitAt(0) ||
        value[startIndex + 1].codeUnitAt(0) > '9'.codeUnitAt(0)) {
      return CodeType.singleDigit;
    }

    return CodeType.doubleDigit;
  }

  @override
  void _renderBarcode(
      Canvas canvas,
      Size size,
      Offset offset,
      String value,
      Color foregroundColor,
      TextStyle textStyle,
      double textSpacing,
      TextAlign textAlign,
      bool showValue) {
    final Paint paint = _getBarPaint(foregroundColor);
    final List<List<int>> encodedValue = _getEncodedValue(value);
    final int totalBarLength = _getTotalBarLength(encodedValue);
    double left = module == null
        ? offset.dx
        : _getLeftPosition(totalBarLength, module, size.width, offset.dx);
    double ratio = 0;
    if (module != null) {
      ratio = module.toDouble();
    } else {
      // Calculates the bar length based on number of individual bar codes
      final int singleModule = (size.width ~/ totalBarLength).toInt();
      ratio = singleModule.toDouble();
      final double leftPadding = (size.width - (totalBarLength * ratio)) / 2;
      left += leftPadding;
    }
    left = left.roundToDouble();
    for (int i = 0; i < encodedValue.length; i++) {
      bool canDraw = true;
      final List<int> currentIndex = encodedValue[i];
      for (int j = 0; j < currentIndex.length; j++) {
        final int currentValue = currentIndex[j];
        // Draws the bar code based on the current value
        for (int k = 0; k < currentValue; k++) {
          if (canDraw) {
            final Rect individualBarRect = Rect.fromLTRB(
                left, offset.dy, left + ratio, offset.dy + size.height);
            canvas.drawRect(individualBarRect, paint);
          }
          left += ratio;
        }
        canDraw = !canDraw;
      }
    }
    if (showValue) {
      _drawText(canvas, offset, size, value, textStyle, textSpacing, textAlign);
    }
  }

  /// Calculate total bar length from give input value
  int _getTotalBarLength(List<List<int>> encodedValue) {
    int length = 0;
    for (int i = 0; i < encodedValue.length; i++) {
      final List<int> currentValue = encodedValue[i];
      for (int j = 0; j < currentValue.length; j++) {
        length += currentValue[j];
      }
    }
    return length;
  }
}
