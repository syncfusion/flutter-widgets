part of xlsio;

/// <summary>
/// Class used for character token.
/// </summary>
abstract class SingleCharToken extends FormatTokenBase {
  /// <summary>
  /// Gets format character. Read-only.
  /// </summary>
  String formatChar = '';

  /// <summary>
  /// Tries to parse format string.
  /// </summary>
  @override
  int tryParse(String strFormat, int iIndex) {
    if (strFormat == null) throw ('strFormat - string cannot be null');

    final int iFormatLength = strFormat.length;

    if (iFormatLength == 0) throw ('strFormat - string cannot be empty');

    if (iIndex < 0 || iIndex > iFormatLength - 1) {
      throw ('iIndex - Value cannot be less than 0 and greater than than format length - 1.');
    }

    final String chCurrent = strFormat[iIndex];

    if (chCurrent == formatChar) {
      iIndex++;
      _strFormat = chCurrent;
    } else if (strFormat[iIndex] == '\\' &&
        strFormat[iIndex + 1] == formatChar) {
      _strFormat = strFormat[iIndex + 1].toString();
      iIndex = iIndex + 2;
    }
    return iIndex;
  }
}
