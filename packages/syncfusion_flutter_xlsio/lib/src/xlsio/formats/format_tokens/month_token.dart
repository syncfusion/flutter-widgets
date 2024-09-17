import 'package:intl/intl.dart';

import '../../formats/format_tokens/enums.dart';
import '../../general/culture_info.dart';
import '../../range/range.dart';
import '../format_section.dart';
import 'format_token_base.dart';

/// Class used for Month Token.

class MonthToken extends FormatTokenBase {
  /// Regular expression for minutes part of the format:

  final RegExp _monthRegex = RegExp('[Mm]{3,}');

  /// Tries to parse format string.

  @override
  int tryParse(String strFormat, int iIndex) {
    return tryParseRegex(_monthRegex, strFormat, iIndex);
  }

  /// Applies format to the value.

  @override
  String applyFormat(double value, bool bShowHiddenSymbols, CultureInfo culture,
      FormatSection section) {
    final DateTime date = Range.fromOADate(value);
    final DateFormat formatter = DateFormat(strFormat.toUpperCase());
    final String formatted = formatter.format(date);
    return formatted;
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
    return TokenType.month;
  }
}
