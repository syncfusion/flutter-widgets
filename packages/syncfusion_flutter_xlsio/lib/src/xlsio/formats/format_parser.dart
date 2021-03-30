part of xlsio;

/// <summary>
/// Class used for format parsing.
/// </summary>
class _FormatParser {
  /// <summary>
  /// List with all known format tokens.
  /// </summary>
  List<_FormatTokenBase> _arrFormatTokens = [];

  /// <summary>
  /// Regular expression for checking if specified switch argument present in numberformat.
  /// </summary>
  static final _numberFormatRegex = RegExp('\\[(DBNUM[1-4]{1}|GB[1-4]{1})\\]');

  /// <summary>
  /// Initializes a new instance of the FormatParserImpl class.
  /// </summary>
  // ignore: sort_constructors_first
  _FormatParser() {
    _arrFormatTokens.add(_CharacterToken());
    _arrFormatTokens.add(_YearToken());
    _arrFormatTokens.add(_MonthToken());
    _arrFormatTokens.add(_DayToken());
    _arrFormatTokens.add(_HourToken());
    _arrFormatTokens.add(_Hour24Token());
    _arrFormatTokens.add(_MinuteToken());
    _arrFormatTokens.add(_SecondToken());
    _arrFormatTokens.add(_AmPmToken());
    _arrFormatTokens.add(_SignificantDigitToken());
    _arrFormatTokens.add(_DecimalPointToken());
    _arrFormatTokens.add(_FractionToken());
    _arrFormatTokens.add(_UnknownToken());
  }

  /// <summary>
  /// Parses format string.
  /// </summary>
  // ignore: unused_element
  _FormatSectionCollection _parse(Workbook workbook, String? strFormat) {
    if (strFormat == null) throw ('strFormat - string cannot be null');
    strFormat = _numberFormatRegex.hasMatch(strFormat)
        ? strFormat.replaceAll(RegExp(r'strFormat'), '')
        : strFormat;
    final int iFormatLength = strFormat.length;

    if (iFormatLength == 0) throw ('strFormat - string cannot be empty');

    final List<_FormatTokenBase> arrParsedExpression = [];
    int iPos = 0;

    while (iPos < iFormatLength) {
      final len = _arrFormatTokens.length;
      for (int i = 0; i < len; i++) {
        final _FormatTokenBase token = _arrFormatTokens[i];
        final int iNewPos = token._tryParse(strFormat, iPos);

        if (iNewPos > iPos) {
          // token = ( FormatTokenBase )token.Clone();
          iPos = iNewPos;
          arrParsedExpression.add(token);
          break;
        }
      }
    }
    return _FormatSectionCollection(workbook, arrParsedExpression);
  }

  void _clear() {
    _arrFormatTokens.clear();
  }
}
