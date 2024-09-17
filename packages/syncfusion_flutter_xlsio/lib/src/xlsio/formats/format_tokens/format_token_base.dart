import '../../general/culture_info.dart';
import '../format_section.dart';
import 'enums.dart';

/// Base class for formula tokens.
abstract class FormatTokenBase {
  /// Part of format.
  String strFormat = '';

  /// Tries to parse format string.
  int tryParse(String strFormat, int iIndex);

  /// Tries to parse format string using regular expression.
  int tryParseRegex(RegExp regex, String stringFormat, int iIndex) {
    final int iFormatLength = stringFormat.length;
    if (iFormatLength == 0) {
      final Error error =
          ArgumentError('stringFormat - string cannot be empty');
      throw error;
    }

    if (iIndex < 0 || iIndex > iFormatLength) {
      final Error error = ArgumentError(
          'iIndex - Value cannot be less than 0 or greater than Format Length');
      throw error;
    }
    final Match? m = regex.matchAsPrefix(stringFormat, iIndex);
    if (regex.hasMatch(stringFormat) && m != null && m.start == iIndex) {
      format = regex.stringMatch(stringFormat)!;
      iIndex += strFormat.length;
      if (m.end != iIndex) {
        format = strFormat + strFormat;
        iIndex = m.end;
      }
    }
    return iIndex;
  }

  /// Applies format to the value.
  String applyFormat(double value, bool bShowHiddenSymbols, CultureInfo culture,
      FormatSection section);

  /// Applies format to the value.
  // ignore: unused_element
  String applyFormatString(String value, bool bShowHiddenSymbols);

  /// Gets or sets format of the token.
  String get format {
    return strFormat;
  }

  set format(String value) {
    if (value.isEmpty) {
      final Error error = ArgumentError('value - string cannot be empty.');
      throw error;
    }

    if (strFormat != value) {
      strFormat = value;
      onFormatChange();
    }
  }

  /// Searches for string from strings array in the format starting from the specified position.
  // ignore: unused_element
  int _findString(
      List<String> arrStrings, String strFormat, int iIndex, bool bIgnoreCase) {
    final int iFormatLength = strFormat.length;

    if (iFormatLength == 0) {
      final Error error = ArgumentError('strFormat - string cannot be empty.');
      throw error;
    }

    if (iIndex < 0 || iIndex > iFormatLength - 1) {
      final Error error = ArgumentError(
          'iIndex - Value cannot be less than 0 and greater than than format length - 1.');
      throw error;
    }
    return -1;
  }

  /// This method is called after format string was changed.
  void onFormatChange() {}

  /// Gets type of the token. Read-only.
  TokenType get tokenType {
    return TokenType.general;
  }
}
