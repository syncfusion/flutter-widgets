part of xlsio;

/// Class used for MilliSecond Token.
class _MilliSecondToken extends _FormatTokenBase {
  /// Long format.
  static const String _defaultFormatLong = '000';

  /// Maximum format length.
  static const int _defaultMaxLen = _defaultFormatLong.length;

  /// Tries to parse format string.
  @override
  int _tryParse(String strFormat, int iIndex) {
    final Error error = ArgumentError('NotImplementedException');
    throw error;
  }

  /// Applies format to the value.
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

  /// Applies format to the value.
  @override
  // ignore: unused_element
  String _applyFormatString(String value, bool bShowHiddenSymbols) {
    return '';
  }

  /// Gets type of the token. Read-only.
  @override
  _TokenType get _tokenType {
    return _TokenType.milliSecond;
  }
}
