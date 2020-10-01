part of xlsio;

/// <summary>
/// Class used for UnknownToken.
/// </summary>
class UnknownToken extends FormatTokenBase {
  /// <summary>
  /// Tries to parse format string.
  /// </summary>
  @override
  int tryParse(String strFormat, int iIndex) {
    if (strFormat == null) throw ('strFormat');

    final int iFormatLength = strFormat.length;

    if (iFormatLength == 0) throw ('strFormat - string cannot be empty');

    _strFormat = strFormat[iIndex].toString();
    return iIndex + 1;
  }

  /// <summary>
  /// Applies format to the value.
  /// </summary>
  @override
  String applyFormat(double value, bool bShowHiddenSymbols, CultureInfo culture,
      FormatSection section) {
    if (_strFormat == 'g' || _strFormat == 'G') {
      return '';
    } else {
      return _strFormat;
    }
  }

  /// <summary>
  /// Applies format to the value.
  /// </summary>
  @override
  String applyFormatString(String value, bool bShowHiddenSymbols) {
    return _strFormat;
  }

  /// <summary>
  /// Gets type of the token. Read-only.
  /// </summary>
  @override
  TokenType get tokenType {
    return TokenType.unknown;
  }
}
