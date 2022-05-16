part of xlsio;

/// Class used for format parsing.
class _FormatParser {
  /// Initializes a new instance of the FormatParserImpl class.
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

  /// List with all known format tokens.

  // ignore: prefer_final_fields
  List<_FormatTokenBase> _arrFormatTokens = <_FormatTokenBase>[];

  /// Regular expression for checking if specified switch argument present in numberformat.
  static final RegExp _numberFormatRegex =
      // ignore: use_raw_strings
      RegExp('\\[(DBNUM[1-4]{1}|GB[1-4]{1})\\]');

  /// Parses format string.
  // ignore: unused_element
  _FormatSectionCollection _parse(Workbook workbook, String? strFormat) {
    if (strFormat == null) {
      final Error error = ArgumentError('strFormat - string cannot be null');
      throw error;
    }
    strFormat = _numberFormatRegex.hasMatch(strFormat)
        ? strFormat.replaceAll(RegExp(r'strFormat'), '')
        : strFormat;
    final int iFormatLength = strFormat.length;

    if (iFormatLength == 0) {
      final Error error = ArgumentError('strFormat - string cannot be empty');
      throw error;
    }

    final List<_FormatTokenBase> arrParsedExpression = <_FormatTokenBase>[];
    int iPos = 0;

    while (iPos < iFormatLength) {
      final int len = _arrFormatTokens.length;
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
