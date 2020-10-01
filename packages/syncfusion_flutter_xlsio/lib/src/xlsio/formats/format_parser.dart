part of xlsio;

/// <summary>
/// Class used for format parsing.
/// </summary>
class FormatParserImpl {
  /// <summary>
  /// List with all known format tokens.
  /// </summary>
  List<FormatTokenBase> _arrFormatTokens = [];

  /// <summary>
  /// Regular expression for checking if specified switch argument present in numberformat.
  /// </summary>
  static final _numberFormatRegex = RegExp('\\[(DBNUM[1-4]{1}|GB[1-4]{1})\\]');

  /// <summary>
  /// Initializes a new instance of the FormatParserImpl class.
  /// </summary>
  // ignore: sort_constructors_first
  FormatParserImpl() {
    _arrFormatTokens.add(CharacterToken());
    _arrFormatTokens.add(YearToken());
    _arrFormatTokens.add(MonthToken());
    _arrFormatTokens.add(DayToken());
    _arrFormatTokens.add(HourToken());
    _arrFormatTokens.add(Hour24Token());
    _arrFormatTokens.add(MinuteToken());
    _arrFormatTokens.add(SecondToken());
    _arrFormatTokens.add(AmPmToken());
    _arrFormatTokens.add(SignificantDigitToken());
    _arrFormatTokens.add(DecimalPointToken());
    _arrFormatTokens.add(FractionToken());
    _arrFormatTokens.add(UnknownToken());
  }

  /// <summary>
  /// Parses format string.
  /// </summary>
  FormatSectionCollection parse(Workbook workbook, String strFormat) {
    if (strFormat == null) throw ('strFormat - string cannot be null');
    strFormat = _numberFormatRegex.hasMatch(strFormat)
        ? strFormat.replaceAll(RegExp(r'strFormat'), '')
        : strFormat;
    final int iFormatLength = strFormat.length;

    if (iFormatLength == 0) throw ('strFormat - string cannot be empty');

    final List<FormatTokenBase> arrParsedExpression = [];
    int iPos = 0;

    while (iPos < iFormatLength) {
      final len = _arrFormatTokens.length;
      for (int i = 0; i < len; i++) {
        final FormatTokenBase token = _arrFormatTokens[i];
        final int iNewPos = token.tryParse(strFormat, iPos);

        if (iNewPos > iPos) {
          // token = ( FormatTokenBase )token.Clone();
          iPos = iNewPos;
          arrParsedExpression.add(token);
          break;
        }
      }
    }
    return FormatSectionCollection(workbook, arrParsedExpression);
  }

  void _clear() {
    if (_arrFormatTokens != null) _arrFormatTokens.clear();

    _arrFormatTokens = null;
  }
}
