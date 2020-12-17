part of xlsio;

/// <summary>
/// Class used for MilliSecond Token.
/// </summary>
class _MilliSecondToken extends _FormatTokenBase {
  //Class constants
  /// <summary>
  /// Long format.
  /// </summary>
  static const String _defaultFormatLong = '000';

  /// <summary>
  /// Maximum format length.
  /// </summary>
  static const int _defaultMaxLen = _defaultFormatLong.length;

  /// <summary>
  /// Tries to parse format string.
  /// </summary>
  @override
  int _tryParse(String strFormat, int iIndex) {
    throw ('NotImplementedException');
  }

  /// <summary>
  /// Applies format to the value.
  /// </summary>
  @override
  String _applyFormat(double value, bool bShowHiddenSymbols,
      CultureInfo culture, _FormatSection section) {
    final DateTime date = Range._fromOADate(value);

    int iMilliSecond = date.millisecond;
    final int iFormatLen = _strFormat.length;
    String strNativeFormat = '';
    String strPostfix = '';

    if (iFormatLen < _defaultMaxLen) {
      final int iPow = _defaultMaxLen - iFormatLen;
      iMilliSecond =
          _FormatSection._round(iMilliSecond / pow(10, iPow)).toInt();
      strNativeFormat = _strFormat.substring(1, 1 + iFormatLen - 1);
    } else {
      strNativeFormat = _defaultFormatLong;
      strPostfix = _strFormat.substring(_defaultMaxLen);
    }

    return culture.numberFormat.numberDecimalSeparator +
        NumberFormat(strNativeFormat).format(iMilliSecond) +
        strPostfix;
  }

  /// <summary>
  /// Applies format to the value.
  /// </summary>
  @override
  // ignore: unused_element
  String _applyFormatString(String value, bool bShowHiddenSymbols) {
    return '';
  }

  /// <summary>
  /// Gets type of the token. Read-only.
  /// </summary>
  @override
  _TokenType get _tokenType {
    return _TokenType.milliSecond;
  }
}
