part of xlsio;

/// <summary>
/// Class used for describing DecimalSeparatorToken.
/// </summary>
class DecimalPointToken extends SingleCharToken {
  /// <summary>
  /// Format character.
  /// </summary>
  static const String _defaultFormat = '.';

  /// <summary>
  /// Applies format to the value.
  /// </summary>
  @override
  String applyFormat(double value, bool bShowHiddenSymbols, CultureInfo culture,
      FormatSection section) {
    return _strFormat;
  }

  /// <summary>
  /// Tries to parse format string.
  /// </summary>
  @override
  int tryParse(String strFormat, int iIndex) {
    if (strFormat == null) throw ('strFormat - string cannot be null');

    final int iFormatLength = strFormat.length;

    if (iFormatLength == 0) throw ('strFormat - string cannot be empty');

    if (iIndex < 0 || iIndex > iFormatLength - 1) {
      throw ('iIndex - Value cannot be less than 0 and greater than than format length - 1.');
    }

    final String chCurrent = strFormat[iIndex];

    if (chCurrent == _defaultFormat) {
      iIndex++;
      _strFormat = chCurrent;
    } else if (strFormat[iIndex] == '\\' &&
        strFormat[iIndex + 1] == _defaultFormat) {
      _strFormat = strFormat[iIndex + 1].toString();
      iIndex = iIndex + 2;
    }
    return iIndex;
  }

  /// <summary>
  /// Applies format to the value.
  /// </summary>
  @override
  String applyFormatString(String value, bool bShowHiddenSymbols) {
    return '';
  }

  /// <summary>
  /// Gets type of the token. Read-only.
  /// </summary>
  @override
  TokenType get tokenType {
    return TokenType.decimalPoint;
  }
}
