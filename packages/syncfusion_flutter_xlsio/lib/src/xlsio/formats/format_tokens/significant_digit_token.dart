part of xlsio;

/// <summary>
/// Class used for Significant Digit Token.
/// </summary>
class _SignificantDigitToken extends _DigitToken {
  /// <summary>
  /// Format character.
  /// </summary>
  final _defaultFormatChar = '0';

  /// <summary>
  /// Tries to parse format string.
  /// </summary>
  @override
  int _tryParse(String strFormat, int iIndex) {
    if (strFormat == null) throw ('strFormat');

    final int iFormatLength = strFormat.length;

    if (iFormatLength == 0) throw ('strFormat - string cannot be empty');

    if (iIndex < 0 || iIndex > iFormatLength - 1) {
      throw ('iIndex-Value cannot be less than 0 and greater than format length - 1.');
    }

    final String chCurrent = strFormat[iIndex];

    if (_isNumeric(chCurrent)) {
      iIndex++;
      _strFormat = chCurrent;
    } else if (strFormat[iIndex] == '\\' &&
        strFormat[iIndex + 1] == formatChar) {
      _strFormat = strFormat[iIndex + 1];
      iIndex = iIndex + 2;
    }
    return iIndex;
  }

  ///Checking the string is numeric or not.
  bool _isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return double.parse(s, (e) => null) != null;
  }

  /// <summary>
  /// Format character. Read-only.
  /// </summary>
  // ignore: unused_element
  String get _formatChar {
    if (_strFormat == null) return _defaultFormatChar;
    return _strFormat;
  }

  /// <summary>
  /// Gets type of the token. Read-only.
  /// </summary>
  @override
  _TokenType get _tokenType {
    return _TokenType.significantDigit;
  }
}
