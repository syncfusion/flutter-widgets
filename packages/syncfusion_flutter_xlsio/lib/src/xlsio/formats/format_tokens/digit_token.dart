part of xlsio;

/// <summary>
/// Class used for describing Digit Tokens.
/// </summary>
abstract class DigitToken extends SingleCharToken {
  /// <summary>
  /// Applies format to the value.
  /// </summary>
  @override
  String applyFormat(double value, bool bShowHiddenSymbols, CultureInfo culture,
      FormatSection section) {
    final int iDigit = 0;
    return _getDigitString(value, iDigit, bShowHiddenSymbols);
  }

  /// <summary>
  /// Applies format to the value.
  /// </summary>
  @override
  String applyFormatString(String value, bool bShowHiddenSymbols) {
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
  int tryParse(String strFormat, int iIndex) {
    return iIndex;
  }
}
