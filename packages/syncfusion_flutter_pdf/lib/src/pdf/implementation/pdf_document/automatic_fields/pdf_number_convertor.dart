part of pdf;

class _PdfNumberConvertor {
  // fields
  static const double _letterLimit = 26.0;
  static const int _acsiiStartIndex = 65 - 1;

  // methods
  static String _convert(int intArabic, PdfNumberStyle numberStyle) {
    switch (numberStyle) {
      case PdfNumberStyle.none:
        return '';

      case PdfNumberStyle.numeric:
        return intArabic.toString();

      case PdfNumberStyle.lowerLatin:
        return _arabicToLetter(intArabic).toLowerCase();

      case PdfNumberStyle.lowerRoman:
        return _arabicToRoman(intArabic).toLowerCase();

      case PdfNumberStyle.upperLatin:
        return _arabicToLetter(intArabic);

      case PdfNumberStyle.upperRoman:
        return _arabicToRoman(intArabic);
    }

    return '';
  }

  static String _arabicToRoman(int intArabic) {
    final StringBuffer retval = StringBuffer();
    List<Object> result = _generateNumber(intArabic, 1000, 'M');
    retval.write(result.elementAt(0));
    result = _generateNumber(result.elementAt(1), 900, 'CM');
    retval.write(result.elementAt(0));
    result = _generateNumber(result.elementAt(1), 500, 'D');
    retval.write(result.elementAt(0));
    result = _generateNumber(result.elementAt(1), 400, 'CD');
    retval.write(result.elementAt(0));
    result = _generateNumber(result.elementAt(1), 100, 'C');
    retval.write(result.elementAt(0));
    result = _generateNumber(result.elementAt(1), 90, 'XC');
    retval.write(result.elementAt(0));
    result = _generateNumber(result.elementAt(1), 50, 'L');
    retval.write(result.elementAt(0));
    result = _generateNumber(result.elementAt(1), 40, 'XL');
    retval.write(result.elementAt(0));
    result = _generateNumber(result.elementAt(1), 10, 'X');
    retval.write(result.elementAt(0));
    result = _generateNumber(result.elementAt(1), 9, 'IX');
    retval.write(result.elementAt(0));
    result = _generateNumber(result.elementAt(1), 5, 'V');
    retval.write(result.elementAt(0));
    result = _generateNumber(result.elementAt(1), 4, 'IV');
    retval.write(result.elementAt(0));
    result = _generateNumber(result.elementAt(1), 1, 'I');
    retval.write(result.elementAt(0));
    return retval.toString();
  }

  static List<Object> _generateNumber(int value, int magnitude, String letter) {
    final StringBuffer numberString = StringBuffer();
    while (value >= magnitude) {
      value -= magnitude;
      numberString.write(letter);
    }
    final List<Object> result = <Object>[];
    result.add(numberString.toString());
    result.add(value);
    return result;
  }

  static String _arabicToLetter(int arabic) {
    final List<int> stack = _convertToLetter(arabic.toDouble());
    final StringBuffer result = StringBuffer();

    while (stack.isNotEmpty) {
      final int n = stack.removeLast();
      _appendChar(result, n);
    }
    return result.toString();
  }

  static List<int> _convertToLetter(double arabic) {
    if (arabic <= 0) {
      throw ArgumentError.value('arabic value can not be less 0');
    }
    final List<int> stack = <int>[];
    while ((arabic.toInt()) > _letterLimit) {
      double remainder = arabic % _letterLimit;

      if (remainder == 0.0) {
        arabic = arabic / _letterLimit - 1;
        remainder = _letterLimit;
      } else {
        arabic /= _letterLimit;
      }

      stack.add(remainder.toInt());
    }
    if (arabic > 0) {
      stack.add(arabic.toInt());
    }
    return stack;
  }

  static void _appendChar(StringBuffer result, int number) {
    if (result == null) {
      throw ArgumentError.notNull('result');
    }
    if (number <= 0 || number > 26) {
      throw ArgumentError.value('Value can not be less 0 and greater 26');
    }
    final String letter = (_acsiiStartIndex + number).toString();
    result.write(String.fromCharCode(int.parse(letter)));
  }
}
