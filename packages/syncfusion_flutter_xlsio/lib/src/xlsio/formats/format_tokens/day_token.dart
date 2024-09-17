import 'package:intl/intl.dart';

import '../../formats/format_tokens/enums.dart';
import '../../general/culture_info.dart';
import '../../general/enums.dart';
import '../../range/range.dart';
import '../format_section.dart';
import 'format_token_base.dart';

/// Class used for describing Day Tokens.
class DayToken extends FormatTokenBase {
  /// Regular expression for minutes part of the format:
  final RegExp _dayRegex = RegExp('[Dd]+');

  /// Format string in lower case.
  String _strFormatLower = '';

  @override

  /// Tries to parse format string.
  int tryParse(String stringFormat, int iIndex) {
    final int iResult = tryParseRegex(_dayRegex, stringFormat, iIndex);

    if (iResult != iIndex) {
      _strFormatLower = strFormat.toLowerCase();
    }

    return iResult;
  }

  /// Applies format to the value.
  @override
  String applyFormat(double value, bool bShowHiddenSymbols, CultureInfo culture,
      FormatSection section) {
    double tempValue = value;

    if (_strFormatLower.length > 2 &&
        tempValue < 60 &&
        section.formatType == ExcelFormatType.dateTime) {
      tempValue = tempValue - 1;
    }

    final DateTime date = Range.fromOADate(tempValue);
    return DateFormat(' $_strFormatLower').format(date).substring(1);
  }

  @override

  /// Applies format to the value.
  // ignore: unused_element
  String applyFormatString(String value, bool bShowHiddenSymbols) {
    return '';
  }

  @override

  /// Gets type of the token. Read-only.
  TokenType get tokenType {
    return TokenType.day;
  }
}
