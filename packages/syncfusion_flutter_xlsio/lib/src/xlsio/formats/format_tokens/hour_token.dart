import 'package:intl/intl.dart';

import '../../formats/format_tokens/enums.dart';
import '../../general/culture_info.dart';
import '../../range/range.dart';
import '../format_section.dart';
import 'format_token_base.dart';

// ignore: public_member_api_docs
class HourToken extends FormatTokenBase {
  /// Regular expression for hours part of the format:
  static RegExp hourRegex = RegExp('[hH]+');

  /// Defined 12hr format.
  static const String _defaultFormat = 'h';

  /// Long format.
  static const String _defaultFormatLong = '00';

  /// Indicates whether token should be formatted using am/pm time format.
  // ignore: prefer_final_fields
  bool isAmPm = false;

  @override
  // ignore: prefer_final_fields
  String strFormat = '';

  /// Tries to parse format string.
  @override
  int tryParse(String stringFormat, int iIndex) {
    return tryParseRegex(hourRegex, stringFormat, iIndex);
  }

  /// Applies format to the value.
  @override
  String applyFormat(double value, bool bShowHiddenSymbols, CultureInfo culture,
      FormatSection section) {
    final DateTime date = Range.fromOADate(value);
    int iHour = date.hour;
    if (isAmPm) {
      iHour = int.parse(DateFormat(_defaultFormat).format(date));
    }
    if (strFormat.length > 1) {
      return NumberFormat(_defaultFormatLong).format(iHour);
    } else {
      return iHour.toString();
    }
  }

  /// Applies format to the value.
  @override
  // ignore: unused_element
  String applyFormatString(String value, bool bShowHiddenSymbols) {
    return '';
  }

  /// Gets type of the token. Read-only.
  @override
  TokenType get tokenType {
    return TokenType.hour;
  }
}
