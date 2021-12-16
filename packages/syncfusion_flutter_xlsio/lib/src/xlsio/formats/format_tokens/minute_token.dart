part of xlsio;

/// Class used for Minute Token.
class _MinuteToken extends _FormatTokenBase {
  /// Regular expression for minutes part of the format:
  final RegExp _minuteRegex = RegExp('[mM]+');

  /// Tries to parse format string.
  @override
  int _tryParse(String strFormat, int iIndex) {
    return _tryParseRegex(_minuteRegex, strFormat, iIndex);
  }

  /// Applies format to the value.
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

  /// Applies format to the value.
  @override
  // ignore: unused_element
  String _applyFormatString(String value, bool bShowHiddenSymbols) {
    return '';
  }

  /// This method is called after format string was changed.
  @override
  void _onFormatChange() {
    _strFormat = _strFormat.toLowerCase();
  }

  /// Gets type of the token. Read-only.
  @override
  _TokenType get _tokenType {
    return _TokenType.minute;
  }
}
