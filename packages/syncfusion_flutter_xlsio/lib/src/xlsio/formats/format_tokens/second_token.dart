part of xlsio;

/// <summary>
/// Class used for Seconds Token.
/// </summary>
class _SecondToken extends _FormatTokenBase {
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
  // ignore: prefer_final_fields
  bool _roundValue = true;

  /// <summary>
  /// Tries to parse format string.
  /// </summary>
  @override
  int _tryParse(String strFormat, int iIndex) {
    return _tryParseRegex(_secondRegex, strFormat, iIndex);
  }

  /// <summary>
  /// Applies format to the value.
  /// </summary>
  @override
  String _applyFormat(double value, bool bShowHiddenSymbols,
      CultureInfo culture, _FormatSection section) {
    final DateTime date = Range._fromOADate(value);

    int iSecond = date.second;
    final int iMilliSecond = date.millisecond;

    if (_roundValue && iMilliSecond >= _defaultMilliSecondHalf) iSecond++;

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
  // ignore: unused_element
  String _applyFormatString(String value, bool bShowHiddenSymbols) {
    return '';
  }

  /// <summary>
  /// Gets type of the token. Read-only.
  /// </summary>
  @override
  _TokenType get _tokenType {
    return _TokenType.second;
  }
}
