part of xlsio;

/// <summary>
/// Class used for Minute Token.
/// </summary>
class MinuteToken extends FormatTokenBase {
  /// <summary>
  /// Regular expression for minutes part of the format:
  /// </summary>
  final _minuteRegex = RegExp('[mM]+');

  /// <summary>
  /// Long type of the format.
  /// </summary>
  static const String DEF_FORMAT_LONG = '00';

  /// <summary>
  /// Tries to parse format string.
  /// </summary>
  @override
  int tryParse(String strFormat, int iIndex) {
    return tryParseRegex(_minuteRegex, strFormat, iIndex);
  }

  /// <summary>
  /// Applies format to the value.
  /// </summary>
  @override
  String applyFormat(double value, bool bShowHiddenSymbols, CultureInfo culture,
      FormatSection section) {
    final DateTime date = Range.fromOADate(value);

    int iMinute = date.minute;
    final int iSecond = date.second;
    final int iMilliSecond = date.millisecond;
    if (iMilliSecond >= SecondToken._defaultMilliSecondHalf && iSecond == 59) {
      if (!section._isMilliSecondFormatValue) {
        iMinute++;
      } else {
        section._isMilliSecondFormatValue = false;
      }
    }

    if (_strFormat.length > 1) {
      return iMinute.toString();
    } else {
      return iMinute.toString();
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
  /// This method is called after format string was changed.
  /// </summary>
  @override
  void onFormatChange() {
    _strFormat = _strFormat.toLowerCase();
  }

  /// <summary>
  /// Gets type of the token. Read-only.
  /// </summary>
  @override
  TokenType get tokenType {
    return TokenType.minute;
  }
}
