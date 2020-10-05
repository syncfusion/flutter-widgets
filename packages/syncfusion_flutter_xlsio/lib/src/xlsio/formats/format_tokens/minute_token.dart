part of xlsio;

/// <summary>
/// Class used for Minute Token.
/// </summary>
class _MinuteToken extends _FormatTokenBase {
  /// <summary>
  /// Regular expression for minutes part of the format:
  /// </summary>
  final _minuteRegex = RegExp('[mM]+');

  /// <summary>
  /// Long type of the format.
  /// </summary>
  // ignore: unused_field
  static const String _DEF_FORMAT_LONG = '00';

  /// <summary>
  /// Tries to parse format string.
  /// </summary>
  @override
  int _tryParse(String strFormat, int iIndex) {
    return _tryParseRegex(_minuteRegex, strFormat, iIndex);
  }

  /// <summary>
  /// Applies format to the value.
  /// </summary>
  @override
  String _applyFormat(double value, bool bShowHiddenSymbols,
      CultureInfo culture, _FormatSection section) {
    final DateTime date = Range._fromOADate(value);

    int iMinute = date.minute;
    final int iSecond = date.second;
    final int iMilliSecond = date.millisecond;
    if (iMilliSecond >= _SecondToken._defaultMilliSecondHalf && iSecond == 59) {
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
  // ignore: unused_element
  String _applyFormatString(String value, bool bShowHiddenSymbols) {
    return '';
  }

  /// <summary>
  /// This method is called after format string was changed.
  /// </summary>
  @override
  void _onFormatChange() {
    _strFormat = _strFormat.toLowerCase();
  }

  /// <summary>
  /// Gets type of the token. Read-only.
  /// </summary>
  @override
  _TokenType get _tokenType {
    return _TokenType.minute;
  }
}
