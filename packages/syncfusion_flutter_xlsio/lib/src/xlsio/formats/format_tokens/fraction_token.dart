part of xlsio;

/// <summary>
/// Class used for Fraction tokens.
/// </summary>
class _FractionToken extends _FormatTokenBase {
  /// <summary>
  /// Format character.
  /// </summary>
  static const String _defaultFormatChar = '/';

  /// <summary>
  /// Applies format to the value.
  /// </summary>
  @override
  String _applyFormat(double value, bool bShowHiddenSymbols,
      CultureInfo culture, _FormatSection section) {
    return (section != null && section.formatType == ExcelFormatType.dateTime)
        ? culture.dateTimeFormat.dateSeparator
        : _strFormat;
  }

  /// <summary>
  /// Tries to parse format string.
  /// </summary>
  @override
  int _tryParse(String strFormat, int iIndex) {
    if (strFormat == null) throw ('strFormat');

    final int iFormatLength = strFormat.length;

    if (iFormatLength == 0) throw ('strFormat - string cannot be empty');

    if (iIndex < 0 || iIndex > iFormatLength - 1) {
      throw ('iIndex - Value cannot be less than 0 and greater than than format length - 1.');
    }

    final String chCurrent = strFormat[iIndex];

    if (chCurrent == _defaultFormatChar) {
      iIndex++;
      _strFormat = chCurrent.toString();
    } else if (strFormat[iIndex] == '\\' &&
        strFormat[iIndex + 1] == _defaultFormatChar) {
      _strFormat = strFormat[iIndex + 1].toString();
      iIndex = iIndex + 2;
    }
    return iIndex;
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
    return _TokenType.fraction;
  }
}
