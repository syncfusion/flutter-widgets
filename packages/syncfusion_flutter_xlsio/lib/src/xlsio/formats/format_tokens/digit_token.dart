part of xlsio;

/// <summary>
/// Class used for describing Digit Tokens.
/// </summary>
abstract class _DigitToken extends _SingleCharToken {
  /// <summary>
  /// Applies format to the value.
  /// </summary>
  @override
  String _applyFormat(double value, bool bShowHiddenSymbols,
      CultureInfo culture, _FormatSection section) {
    final int iDigit = 0;
    return _getDigitString(value, iDigit, bShowHiddenSymbols);
  }

  /// <summary>
  /// Applies format to the value.
  /// </summary>
  @override
  // ignore: unused_element
  String _applyFormatString(String value, bool bShowHiddenSymbols) {
    return value;
  }

  /// <summary>
  /// Returns string representation according to the current format and digit value.
  /// </summary>
  String _getDigitString(double value, int iDigit, bool bShowHiddenSymbols) {
    if (iDigit > 9) {
      throw ('iDigit - Value cannot be less than -9 and greater than than 9.');
    }

    return iDigit.toString();
  }

  @override
  int _tryParse(String strFormat, int iIndex) {
    return iIndex;
  }
}
