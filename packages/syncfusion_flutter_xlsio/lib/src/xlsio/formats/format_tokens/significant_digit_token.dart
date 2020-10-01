part of xlsio;

/// <summary>
/// Class used for Significant Digit Token.
/// </summary>
class SignificantDigitToken extends DigitToken {
  /// <summary>
  /// Format character.
  /// </summary>
  final _defaultFormatChar = '0';

  /// <summary>
  /// Tries to parse format string.
  /// </summary>
  @override
  int tryParse(String strFormat, int iIndex) {
    if (strFormat == null) throw ('strFormat');

    final int iFormatLength = strFormat.length;

    if (iFormatLength == 0) throw ('strFormat - string cannot be empty');

    if (iIndex < 0 || iIndex > iFormatLength - 1) {
      throw ('iIndex-Value cannot be less than 0 and greater than format length - 1.');
    }

    final String chCurrent = strFormat[iIndex];

    if (isNumeric(chCurrent)) {
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
  bool isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return double.parse(s, (e) => null) != null;
  }

  /// <summary>
  /// Format character. Read-only.
  /// </summary>
  @override
  String get formatChar {
    if (_strFormat == null) return _defaultFormatChar;
    return _strFormat;
  }

  /// <summary>
  /// Gets type of the token. Read-only.
  /// </summary>
  @override
  TokenType get tokenType {
    return TokenType.significantDigit;
  }
}
