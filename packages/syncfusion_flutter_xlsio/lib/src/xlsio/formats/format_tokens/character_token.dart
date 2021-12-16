part of xlsio;

// ignore: noop_primitive_operations
/// Class used for Character Token.
class _CharacterToken extends _FormatTokenBase {
  /// Start of the token.
  static const String _defaultStart = r'\\';
  static const String _defaultFormatChar = '@';
  static const String _defaultChar = '-';
  static const String _defaultCharSpace = ' ';

  /// Tries to parse format string.
  @override
  int _tryParse(String strFormat, int iIndex) {
    final int iFormatLength = strFormat.length;

    if (iFormatLength == 0) {
      throw 'strFormat - string cannot be empty.';
    }

    if (strFormat[iIndex] == _defaultChar) {
      _strFormat = strFormat[iIndex];
      iIndex++;
    } else if (strFormat[iIndex] == _defaultCharSpace) {
      _strFormat = strFormat[iIndex];
      iIndex++;
    } else if (strFormat[iIndex] == _defaultStart) {
      // ignore: noop_primitive_operations
      _strFormat = strFormat[iIndex + 1].toString();
      // ignore: noop_primitive_operations
      if (_strFormat != _defaultFormatChar.toString()) {
        iIndex += 2;
      } else {
        // ignore: noop_primitive_operations
        _strFormat = _defaultFormatChar.toString();
      }
    } else if (strFormat[iIndex] == '[' && strFormat[iIndex + 2] == r'\$') {
      // ignore: noop_primitive_operations
      _strFormat = strFormat[iIndex + 1].toString();
      iIndex = strFormat.indexOf(']', iIndex + 3) + 1;
    }

    return iIndex;
  }

  /// Applies format to the value.

  @override
  String _applyFormat(double value, bool bShowHiddenSymbols,
      CultureInfo culture, _FormatSection section) {
    return _strFormat;
  }

  /// Applies format to the value.

  @override
  // ignore: unused_element
  String _applyFormatString(String value, bool bShowHiddenSymbols) {
    return _strFormat;
  }

  /// Gets type of the token. Read-only.

  @override
  _TokenType get _tokenType {
    return _TokenType.character;
  }
}
