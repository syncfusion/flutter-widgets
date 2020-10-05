part of xlsio;

/// <summary>
/// Class used for Character Token.
/// </summary>
class _CharacterToken extends _FormatTokenBase {
  /// <summary>
  /// Start of the token.
  /// </summary>
  static const String _defaultStart = '\\';
  static const String _defaultFormatChar = '@';
  static const String _defaultChar = '-';
  static const String _defaultCharSpace = ' ';

  /// <summary>
  /// Tries to parse format string.
  /// </summary>
  @override
  int _tryParse(String strFormat, int iIndex) {
    if (strFormat == null) throw ('strFormat - string cannot be null.');

    final int iFormatLength = strFormat.length;

    if (iFormatLength == 0) throw ('strFormat - string cannot be empty.');

    if (strFormat[iIndex] == _defaultChar) {
      _strFormat = strFormat[iIndex];
      iIndex++;
    } else if (strFormat[iIndex] == _defaultCharSpace) {
      _strFormat = strFormat[iIndex];
      iIndex++;
    } else if (strFormat[iIndex] == _defaultStart) {
      _strFormat = strFormat[iIndex + 1].toString();
      if (_strFormat != _defaultFormatChar.toString()) {
        iIndex += 2;
      } else {
        _strFormat = _defaultFormatChar.toString();
      }
    } else if (strFormat[iIndex] == '[' && strFormat[iIndex + 2] == '\$') {
      _strFormat = strFormat[iIndex + 1].toString();
      iIndex = strFormat.indexOf(']', iIndex + 3) + 1;
    }

    return iIndex;
  }

  /// <summary>
  /// Applies format to the value.
  /// </summary>
  @override
  String _applyFormat(double value, bool bShowHiddenSymbols,
      CultureInfo culture, _FormatSection section) {
    return _strFormat;
  }

  /// <summary>
  /// Applies format to the value.
  /// </summary>
  @override
  // ignore: unused_element
  String _applyFormatString(String value, bool bShowHiddenSymbols) {
    return _strFormat;
  }

  /// <summary>
  /// Gets type of the token. Read-only.
  /// </summary>
  @override
  _TokenType get _tokenType {
    return _TokenType.character;
  }
}
