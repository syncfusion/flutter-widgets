import 'dart:math';

import 'package:intl/intl.dart';

import '../../formats/format_tokens/enums.dart';
import '../../general/culture_info.dart';
import '../../range/range.dart';
import '../format_section.dart';
import 'format_token_base.dart';

/// Class used for MilliSecond Token.
class MilliSecondToken extends FormatTokenBase {
  /// Long format.
  static const String _defaultFormatLong = '000';

  /// Maximum format length.
  static const int _defaultMaxLen = _defaultFormatLong.length;

  /// Tries to parse format string.
  @override
  int tryParse(String strFormat, int iIndex) {
    final Error error = ArgumentError('NotImplementedException');
    throw error;
  }

  /// Applies format to the value.
  @override
  String applyFormat(double value, bool bShowHiddenSymbols, CultureInfo culture,
      FormatSection section) {
    final DateTime date = Range.fromOADate(value);

    int iMilliSecond = date.millisecond;
    final int iFormatLen = strFormat.length;
    String strNativeFormat = '';
    String strPostfix = '';

    if (iFormatLen < _defaultMaxLen) {
      final int iPow = _defaultMaxLen - iFormatLen;
      iMilliSecond = FormatSection.round(iMilliSecond / pow(10, iPow)).toInt();
      strNativeFormat = strFormat.substring(1, 1 + iFormatLen - 1);
    } else {
      strNativeFormat = _defaultFormatLong;
      strPostfix = strFormat.substring(_defaultMaxLen);
    }

    return culture.numberFormat.numberDecimalSeparator +
        NumberFormat(strNativeFormat).format(iMilliSecond) +
        strPostfix;
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
    return TokenType.milliSecond;
  }
}
