part of xlsio;

/// <summary>
/// Class used for Seconds Token.
/// </summary>
class SecondToken extends FormatTokenBase {
  /// <summary>
  /// Regular expression for minutes part of the format:
  /// </summary>
  final _secondRegex = RegExp('[sS]+');

  /// <summary>
  /// Long type of the format.
  /// </summary>
  static final _defaultFormatLong = '00';

  /// <summary>
  /// Half of possible milliseconds.
  /// </summary>
  static final _defaultMilliSecondHalf = 500;

  /// <summary>
  /// Indicates whether number of seconds must be rounded.
  /// </summary>
  bool roundValue = true;

  /// <summary>
  /// Tries to parse format string.
  /// </summary>
  @override
  int tryParse(String strFormat, int iIndex) {
    return tryParseRegex(_secondRegex, strFormat, iIndex);
  }

  /// <summary>
  /// Applies format to the value.
  /// </summary>
  @override
  String applyFormat(double value, bool bShowHiddenSymbols, CultureInfo culture,
      FormatSection section) {
    final DateTime date = Range.fromOADate(value);

    int iSecond = date.second;
    final int iMilliSecond = date.millisecond;

    if (roundValue && iMilliSecond >= _defaultMilliSecondHalf) iSecond++;

    if (_strFormat.length > 1) {
      /// when second is more than 59, display it as 00.
      return (iSecond > 59) ? _defaultFormatLong : iSecond.toString();
    } else {
      return iSecond.toString();
    }
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
    return TokenType.second;
  }
}
