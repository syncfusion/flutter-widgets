part of xlsio;

/// <summary>
/// Class used for UnknownToken.
/// </summary>
class _UnknownToken extends _FormatTokenBase {
  /// <summary>
  /// Tries to parse format string.
  /// </summary>
  @override
  int _tryParse(String strFormat, int iIndex) {
    final int iFormatLength = strFormat.length;

    if (iFormatLength == 0) throw ('strFormat - string cannot be empty');

    _strFormat = strFormat[iIndex].toString();
    return iIndex + 1;
  }

  /// <summary>
  /// Applies format to the value.
  /// </summary>
  @override
  String _applyFormat(double value, bool bShowHiddenSymbols,
      CultureInfo culture, _FormatSection section) {
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
  // ignore: unused_element
  String _applyFormatString(String value, bool bShowHiddenSymbols) {
    return _strFormat;
  }

  /// <summary>
  /// Gets type of the token. Read-only.
  /// </summary>
  @override
  _TokenType get _tokenType {
    return _TokenType.unknown;
  }
}
