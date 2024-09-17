import '../formats/format_tokens/am_pm_token.dart';
import '../formats/format_tokens/character_token.dart';
import '../formats/format_tokens/day_token.dart';
import '../formats/format_tokens/decimal_point_token.dart';
import '../formats/format_tokens/format_token_base.dart';
import '../formats/format_tokens/fraction_token.dart';
import '../formats/format_tokens/hour_24_token.dart';
import '../formats/format_tokens/hour_token.dart';
import '../formats/format_tokens/minute_token.dart';
import '../formats/format_tokens/month_token.dart';
import '../formats/format_tokens/second_token.dart';
import '../formats/format_tokens/significant_digit_token.dart';
import '../formats/format_tokens/unknown_token.dart';
import '../formats/format_tokens/year_token.dart';
import '../general/workbook.dart';
import 'format_section_collection.dart';

/// Class used for format parsing.
class FormatParser {
  /// Initializes a new instance of the FormatParserImpl class.
  FormatParser() {
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

  /// List with all known format tokens.

  // ignore: prefer_final_fields
  List<FormatTokenBase> _arrFormatTokens = <FormatTokenBase>[];

  /// Regular expression for checking if specified switch argument present in numberformat.
  static final RegExp numberFormatRegex =
      // ignore: use_raw_strings
      RegExp('\\[(DBNUM[1-4]{1}|GB[1-4]{1})\\]');

  /// Parses format string.
  // ignore: unused_element
  FormatSectionCollection parse(Workbook workbook, String? strFormat) {
    if (strFormat == null) {
      final Error error = ArgumentError('strFormat - string cannot be null');
      throw error;
    }
    strFormat = numberFormatRegex.hasMatch(strFormat)
        ? strFormat.replaceAll(RegExp(r'strFormat'), '')
        : strFormat;
    final int iFormatLength = strFormat.length;

    if (iFormatLength == 0) {
      final Error error = ArgumentError('strFormat - string cannot be empty');
      throw error;
    }

    final List<FormatTokenBase> arrParsedExpression = <FormatTokenBase>[];
    int iPos = 0;

    while (iPos < iFormatLength) {
      final int len = _arrFormatTokens.length;
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

  void clear() {
    _arrFormatTokens.clear();
  }
}
