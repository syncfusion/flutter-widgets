import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../../base/symbology_base.dart';
import '../../one_dimensional/code128b_symbology.dart';
import '../../one_dimensional/code128c_symbology.dart';
import '../../utils/enum.dart';
import 'symbology_base_renderer.dart';

/// Represents the code128 renderer class
class Code128Renderer extends SymbologyRenderer {
  /// Creates the code128 renderer
  Code128Renderer({Symbology? symbology}) : super(symbology: symbology) {
    code128ACharacterSets = <String>[];

    code128ACharacterSets.add(' ');
    code128ACharacterSets.add('!');
    code128ACharacterSets.add('"');
    code128ACharacterSets.add('#');
    code128ACharacterSets.add('\$');
    code128ACharacterSets.add('%');
    code128ACharacterSets.add('&');
    // ignore: avoid_escaping_inner_quotes
    code128ACharacterSets.add('\'');
    code128ACharacterSets.add('(');
    code128ACharacterSets.add(')');
    code128ACharacterSets.add('*');
    code128ACharacterSets.add('+');
    code128ACharacterSets.add(',');
    code128ACharacterSets.add('-');
    code128ACharacterSets.add('.');
    code128ACharacterSets.add('/');
    code128ACharacterSets.add('0');
    code128ACharacterSets.add('1');
    code128ACharacterSets.add('2');
    code128ACharacterSets.add('3');
    code128ACharacterSets.add('4');
    code128ACharacterSets.add('5');
    code128ACharacterSets.add('6');
    code128ACharacterSets.add('7');
    code128ACharacterSets.add('8');
    code128ACharacterSets.add('9');
    code128ACharacterSets.add(':');
    code128ACharacterSets.add(';');
    code128ACharacterSets.add('<');
    code128ACharacterSets.add('=');
    code128ACharacterSets.add('>');
    code128ACharacterSets.add('?');
    code128ACharacterSets.add('@');
    code128ACharacterSets.add('A');
    code128ACharacterSets.add('B');
    code128ACharacterSets.add('C');
    code128ACharacterSets.add('D');
    code128ACharacterSets.add('E');
    code128ACharacterSets.add('F');
    code128ACharacterSets.add('G');
    code128ACharacterSets.add('H');
    code128ACharacterSets.add('I');
    code128ACharacterSets.add('J');
    code128ACharacterSets.add('K');
    code128ACharacterSets.add('L');
    code128ACharacterSets.add('M');
    code128ACharacterSets.add('N');
    code128ACharacterSets.add('O');
    code128ACharacterSets.add('P');
    code128ACharacterSets.add('Q');
    code128ACharacterSets.add('R');
    code128ACharacterSets.add('S');
    code128ACharacterSets.add('T');
    code128ACharacterSets.add('U');
    code128ACharacterSets.add('V');
    code128ACharacterSets.add('W');
    code128ACharacterSets.add('X');
    code128ACharacterSets.add('Y');
    code128ACharacterSets.add('Z');
    code128ACharacterSets.add('[');
    code128ACharacterSets.add('\\');
    code128ACharacterSets.add(']');
    code128ACharacterSets.add('^');
    code128ACharacterSets.add('_');
    code128ACharacterSets.add('0');
    code128ACharacterSets.add('\u0001');
    code128ACharacterSets.add('\u0002');
    code128ACharacterSets.add('\u0003');
    code128ACharacterSets.add('\u0004');
    code128ACharacterSets.add('\u0005');
    code128ACharacterSets.add('\u0006');
    code128ACharacterSets.add('a');
    code128ACharacterSets.add('\b');
    code128ACharacterSets.add('\t');
    code128ACharacterSets.add('\n');
    code128ACharacterSets.add('\v');
    code128ACharacterSets.add('\f');
    code128ACharacterSets.add('\r');
    code128ACharacterSets.add('\u000e');
    code128ACharacterSets.add('\u000f');
    code128ACharacterSets.add('\u0010');
    code128ACharacterSets.add('\u0011');
    code128ACharacterSets.add('\u0012');
    code128ACharacterSets.add('\u0013');
    code128ACharacterSets.add('\u0014');
    code128ACharacterSets.add('\u0015');
    code128ACharacterSets.add('\u0016');
    code128ACharacterSets.add('\u0017');
    code128ACharacterSets.add('\u0018');
    code128ACharacterSets.add('\u0019');
    code128ACharacterSets.add('\u001a');
    code128ACharacterSets.add('\u001b');
    code128ACharacterSets.add('\u001c');
    code128ACharacterSets.add('\u001d');
    code128ACharacterSets.add('\u001e');
    code128ACharacterSets.add('\u001f');
    code128ACharacterSets.add('ù');
    code128ACharacterSets.add('ø');
    code128ACharacterSets.add('û');
    code128ACharacterSets.add('ö');
    code128ACharacterSets.add('õ');
    code128ACharacterSets.add('ú');
    code128ACharacterSets.add('÷');
    code128ACharacterSets.add('ü');
    code128ACharacterSets.add('ý');
    code128ACharacterSets.add('þ');
    code128ACharacterSets.add('ÿ');

    code128BCharacterSets = <String>[];
    code128BCharacterSets.add(' ');
    code128BCharacterSets.add('!');
    code128BCharacterSets.add('"');
    code128BCharacterSets.add('#');
    code128BCharacterSets.add('\$');
    code128BCharacterSets.add('%');
    code128BCharacterSets.add('&');
    // ignore: avoid_escaping_inner_quotes
    code128BCharacterSets.add('\'');
    code128BCharacterSets.add('(');
    code128BCharacterSets.add(')');
    code128BCharacterSets.add('*');
    code128BCharacterSets.add('+');
    code128BCharacterSets.add(',');
    code128BCharacterSets.add('-');
    code128BCharacterSets.add('.');
    code128BCharacterSets.add('/');
    code128BCharacterSets.add('0');
    code128BCharacterSets.add('1');
    code128BCharacterSets.add('2');
    code128BCharacterSets.add('3');
    code128BCharacterSets.add('4');
    code128BCharacterSets.add('5');
    code128BCharacterSets.add('6');
    code128BCharacterSets.add('7');
    code128BCharacterSets.add('8');
    code128BCharacterSets.add('9');
    code128BCharacterSets.add(':');
    code128BCharacterSets.add(';');
    code128BCharacterSets.add('<');
    code128BCharacterSets.add('=');
    code128BCharacterSets.add('>');
    code128BCharacterSets.add('?');
    code128BCharacterSets.add('@');
    code128BCharacterSets.add('A');
    code128BCharacterSets.add('B');
    code128BCharacterSets.add('C');
    code128BCharacterSets.add('D');
    code128BCharacterSets.add('E');
    code128BCharacterSets.add('F');
    code128BCharacterSets.add('G');
    code128BCharacterSets.add('H');
    code128BCharacterSets.add('I');
    code128BCharacterSets.add('J');
    code128BCharacterSets.add('K');
    code128BCharacterSets.add('L');
    code128BCharacterSets.add('M');
    code128BCharacterSets.add('N');
    code128BCharacterSets.add('O');
    code128BCharacterSets.add('P');
    code128BCharacterSets.add('Q');
    code128BCharacterSets.add('R');
    code128BCharacterSets.add('S');
    code128BCharacterSets.add('T');
    code128BCharacterSets.add('U');
    code128BCharacterSets.add('V');
    code128BCharacterSets.add('W');
    code128BCharacterSets.add('X');
    code128BCharacterSets.add('Y');
    code128BCharacterSets.add('Z');
    code128BCharacterSets.add('[');
    code128BCharacterSets.add('\\');
    code128BCharacterSets.add(']');
    code128BCharacterSets.add('^');
    code128BCharacterSets.add('_');
    code128BCharacterSets.add('`');
    code128BCharacterSets.add('a');
    code128BCharacterSets.add('b');
    code128BCharacterSets.add('c');
    code128BCharacterSets.add('d');
    code128BCharacterSets.add('e');
    code128BCharacterSets.add('f');
    code128BCharacterSets.add('g');
    code128BCharacterSets.add('h');
    code128BCharacterSets.add('i');
    code128BCharacterSets.add('j');
    code128BCharacterSets.add('k');
    code128BCharacterSets.add('l');
    code128BCharacterSets.add('m');
    code128BCharacterSets.add('n');
    code128BCharacterSets.add('o');
    code128BCharacterSets.add('p');
    code128BCharacterSets.add('q');
    code128BCharacterSets.add('r');
    code128BCharacterSets.add('s');
    code128BCharacterSets.add('t');
    code128BCharacterSets.add('u');
    code128BCharacterSets.add('v');
    code128BCharacterSets.add('w');
    code128BCharacterSets.add('x');
    code128BCharacterSets.add('y');
    code128BCharacterSets.add('z');
    code128BCharacterSets.add('{');
    code128BCharacterSets.add('|');
    code128BCharacterSets.add('}');
    code128BCharacterSets.add('~');
    code128BCharacterSets.add('\u007f');
    code128BCharacterSets.add('ù');
    code128BCharacterSets.add('ø');
    code128BCharacterSets.add('û');
    code128BCharacterSets.add('ö');
    code128BCharacterSets.add('ú');
    code128BCharacterSets.add('ô');
    code128BCharacterSets.add('÷');
    code128BCharacterSets.add('ü');
    code128BCharacterSets.add('ý');
    code128BCharacterSets.add('þ');
    code128BCharacterSets.add('ÿ');

    code128CCharacterSets = <String>[];
    code128CCharacterSets.add('0');
    code128CCharacterSets.add('1');
    code128CCharacterSets.add('2');
    code128CCharacterSets.add('3');
    code128CCharacterSets.add('4');
    code128CCharacterSets.add('5');
    code128CCharacterSets.add('6');
    code128CCharacterSets.add('7');
    code128CCharacterSets.add('8');
    code128CCharacterSets.add('9');
    code128CCharacterSets.add('õ');
    code128CCharacterSets.add('ô');
    code128CCharacterSets.add('÷');
    code128CCharacterSets.add('ü');
    code128CCharacterSets.add('ý');
    code128CCharacterSets.add('þ');
    code128CCharacterSets.add('ÿ');
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
  late List<String> code128ACharacterSets;

  /// Represents the supported symbol character of code128B
  late List<String> code128BCharacterSets;

  /// Represents the supported symbol character of code128C
  late List<String> code128CCharacterSets;

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
  bool getIsValidateInput(String value) {
    // ignore: dead_code
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
        throw ArgumentError(
            'The provided input cannot be encoded : ${value[i]}');
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
    final int? currentCodeType =
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
  int? _getValidatedCodeTypes(
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
  void renderBarcode(
      Canvas canvas,
      Size size,
      Offset offset,
      String value,
      Color foregroundColor,
      TextStyle textStyle,
      double textSpacing,
      TextAlign textAlign,
      bool showValue) {
    final Paint paint = getBarPaint(foregroundColor);
    final List<List<int>> encodedValue = _getEncodedValue(value);
    final int totalBarLength = _getTotalBarLength(encodedValue);
    double left = symbology?.module == null
        ? offset.dx
        : getLeftPosition(
            totalBarLength, symbology?.module, size.width, offset.dx);
    double ratio = 0;
    if (symbology?.module != null) {
      ratio = symbology!.module!.toDouble();
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
      drawText(canvas, offset, size, value, textStyle, textSpacing, textAlign);
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
