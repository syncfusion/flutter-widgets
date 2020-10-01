part of barcodes;

/// The [EAN13] is based on the [UPCA] standard. As with [UPCA], it supports
/// only numeric characters.
///
/// It encodes the 12 digits of input data with the check digit at its end.
/// The difference between [UPCA] and
/// [EAN13] is that the number system used in [EAN13] is in two-digit ranges
/// from 00 to 99, whereas the number system used in [UPCA]
/// is in single digits from 0 to 9.
class EAN13 extends Symbology {
  /// Create a [EAN13] symbology with the default or required properties.
  ///
  /// The arguments [module] must be non-negative and greater than 0.
  ///
  /// [EAN13] allows either 12 or 13 digits of numeric data otherwise there
  /// is an exception.
  ///
  /// If the input is 12 digits of the numeric data, the check digit is
  /// calculated automatically.
  ///
  /// If the input is 13 digits of the numeric data, the last digit must be
  /// valid check digit otherwise remove it, since it has been calculated
  /// automatically.
  ///
  EAN13({int module}) : super(module: module);

  /// Represents the encoded input vale
  String _encodedValue;

  @override
  bool _getIsValidateInput(String value) {
    if (value.contains(RegExp(r'^(?=.*?[0-9]).{13}$'))) {
      if (int.parse(value[12]) == _getCheckSumData(value)) {
        _encodedValue = value;
      } else {
        throw 'Invalid check digit at the trailing end. '
            'Provide the valid check digit or remove it. '
            'Since, it has been calculated automatically.';
      }
    } else if (value.contains(RegExp(r'^(?=.*?[0-9]).{12}$'))) {
      _encodedValue = value + _getCheckSumData(value).toString();
    } else {
      throw 'EAN13 supports only numeric characters. '
          'The provided value should have 12 digits (without check digit) or'
          ' with 13 digits.';
    }
    return true;
  }

  /// This is quite a large method. This method could not be
  /// refactored to a smaller methods, since it requires multiple parameters
  /// to be passed
  @override
  void _renderBarcode(
      Canvas canvas,
      Size size,
      Offset offset,
      String value,
      Color foregroundColor,
      TextStyle textStyle,
      double textSpacing,
      TextAlign textAlign,
      bool showValue) {
    /// _singleDigitValues[0] specifies left value of start digit
    /// _singleDigitValues[1] specifies width of start digit
    final List<double> singleDigitValues = List<double>(2);

    ///  _positions[0] specifies end position of start  bar
    ///  _positions[1] specifies start position of middle  bar
    ///  _positions[2] specifies end position of middle bar
    ///  _positions[3] specifies start position of end bar
    final List<double> positions = List<double>(4);
    final Paint paint = _getBarPaint(foregroundColor);
    final List<String> code = _getCodeValues();
    final int barTotalLength = _getTotalLength(code);
    singleDigitValues[1] =
        showValue ? _measureText(_encodedValue[0], textStyle).width : 0;
    const int additionalWidth = 2;
    singleDigitValues[1] += additionalWidth;
    final double width = size.width - singleDigitValues[1];
    double left = module == null
        ? offset.dx + singleDigitValues[1]
        : _getLeftPosition(
            barTotalLength, module, width, offset.dx + singleDigitValues[1]);
    final Rect barCodeRect = Rect.fromLTRB(
        offset.dx, offset.dy, offset.dx + size.width, offset.dy + size.height);
    double ratio = 0;
    if (module != null) {
      ratio = module.toDouble();
    } else {
      // Calculates the bar length based on number of individual bar codes
      final int singleModule = (width ~/ barTotalLength).toInt();
      ratio = singleModule.toDouble();
      final double leftPadding = (width - (barTotalLength * ratio)) / 2;
      left += leftPadding;
    }
    left = left.roundToDouble();
    singleDigitValues[0] = left - singleDigitValues[1];
    for (int i = 0; i < code.length; i++) {
      final String codeValue = code[i];
      final bool hasExtraHeight = _getHasExtraHeight(i, code);
      final double additionalHeight = i == 2 ? 0.4 : 0.5;
      final double barHeight = hasExtraHeight
          ? size.height +
              (showValue
                  ? (_textSize.height * additionalHeight) + textSpacing
                  : 0)
          : size.height;
      final int codeLength = codeValue.length;
      for (int j = 0; j < codeLength; j++) {
        // Draw the barcode when the current code value is 1
        final bool canDraw = codeValue[j] == '1' ? true : false;
        if (canDraw &&
            (left >= barCodeRect.left && left + ratio < barCodeRect.right)) {
          final Rect individualBarRect = Rect.fromLTRB(
              left, offset.dy, left + ratio, offset.dy + barHeight);
          canvas.drawRect(individualBarRect, paint);
        }
        left += ratio;
        if (i == 0 && j == codeLength - 1) {
          // Checks the end position of first extra height bar
          positions[0] = left;
        } else if (i == 1 && j == codeLength - 1) {
          // Checks the start position of second extra height bar
          positions[1] = left;
        } else if (i == 2 && j == codeLength - 1) {
          // Checks the end position of second extra height bar
          positions[2] = left;
        } else if (i == 4 && j == codeLength - 1) {
          // Checks the start position of third extra height bar
          positions[3] = left;
        }
      }
    }
    if (showValue) {
      _paintText(canvas, offset, size, _encodedValue, textStyle, textSpacing,
          textAlign, positions, singleDigitValues);
    }
  }

  /// Returns the encoded value
  List<String> _getCodeValues() {
    const String endBar = '101';
    const String middleBar = '01010';
    final Map<String, String> structureValue = _getStructure();
    final String structure =
        structureValue.entries.elementAt(int.parse(_encodedValue[0])).value;
    final List<String> code = <String>[];
    code.add(endBar);
    String leftString = _encodedValue.substring(1, 7);
    code.add(_getLeftValue(true, structure, leftString));
    code.add(middleBar);
    leftString = _encodedValue.substring(7, 12);
    code.add(_getLeftValue(false, 'RRRRRR', leftString));
    leftString = _encodedValue[12];
    code.add(_getLeftValue(false, 'RRRRRR', leftString));
    code.add(endBar);
    return code;
  }

  /// To return the binary values of the supported input symbol
  Map<String, List<String>> _getBinaries() {
    return <String, List<String>>{
      'L': <String>[
        // The L (left) type of encoding
        '0001101', '0011001', '0010011', '0111101', '0100011',
        '0110001', '0101111', '0111011', '0110111', '0001011'
      ],
      'G': <String>[
        // The G type of encoding
        '0100111', '0110011', '0011011', '0100001', '0011101',
        '0111001', '0000101', '0010001', '0001001', '0010111'
      ],
      'R': <String>[
        // The R (right) type of encoding
        '1110010', '1100110', '1101100', '1000010', '1011100',
        '1001110', '1010000', '1000100', '1001000', '1110100'
      ],
      'O': <String>[
        // The O (odd) encoding for UPC-E
        '0001101', '0011001', '0010011', '0111101', '0100011',
        '0110001', '0101111', '0111011', '0110111', '0001011'
      ],
      'E': <String>[
        // The E (even) encoding for UPC-E
        '0100111', '0110011', '0011011', '0100001', '0011101',
        '0111001', '0000101', '0010001', '0001001', '0010111'
      ]
    };
  }

  /// Calculate total bar length from give input value
  int _getTotalLength(List<String> code) {
    int count = 0;
    for (int i = 0; i < code.length; i++) {
      final int numberOfDigits = code[i].length;
      count += numberOfDigits;
    }
    return count;
  }

  /// Represents the structure of the supported input symbol
  Map<String, String> _getStructure() {
    return <String, String>{
      '0': 'LLLLLL',
      '1': 'LLGLGG',
      '2': 'LLGGLG',
      '3': 'LLGGGL',
      '4': 'LGLLGG',
      '5': 'LGGLLG',
      '6': 'LGGGLL',
      '7': 'LGLGLG',
      '8': 'LGLGGL',
      '9': 'LGGLGL'
    };
  }

  /// Method to calculate the check sum digit
  int _getCheckSumData(String value) {
    final int sum1 = 3 *
        (int.parse(value[11]) +
            int.parse(value[9]) +
            int.parse(value[7]) +
            int.parse(value[5]) +
            int.parse(value[3]) +
            int.parse(value[1]));
    final int sum2 = int.parse(value[10]) +
        int.parse(value[8]) +
        int.parse(value[6]) +
        int.parse(value[4]) +
        int.parse(value[2]) +
        int.parse(value[0]);
    final int checkSumValue = sum1 + sum2;
    final int checkSumDigit = (10 - checkSumValue) % 10;
    return checkSumDigit;
  }

  /// Method to calculate the left value
  String _getLeftValue(bool isLeft, String structure, String leftString) {
    String code;
    List<String> tempCodes;
    final Map<String, List<String>> codes = _getBinaries();
    for (int i = 0; i < leftString.length; i++) {
      if (structure[i] == 'L') {
        tempCodes = codes.entries.elementAt(0).value;
      } else if (structure[i] == 'G') {
        tempCodes = codes.entries.elementAt(1).value;
      } else if (structure[i] == 'R') {
        tempCodes = codes.entries.elementAt(2).value;
      } else if (structure[i] == 'O') {
        tempCodes = codes.entries.elementAt(3).value;
      } else if (structure[i] == 'E') {
        tempCodes = codes.entries.elementAt(4).value;
      }

      final int currentValue = int.parse(leftString[i]);
      if (i == 0) {
        code = tempCodes[currentValue];
      } else {
        code += tempCodes[currentValue];
      }
    }
    return code;
  }

  /// Method to render the input value of the barcode
  void _paintText(
      Canvas canvas,
      Offset offset,
      Size size,
      String value,
      TextStyle textStyle,
      double textSpacing,
      TextAlign textAlign,
      List<double> positions,
      List<double> singleDigitValues) {
    final String value1 = value[0];
    final String value2 = value.substring(1, 7);
    final String value3 = value.substring(7, 13);
    final double secondTextWidth = positions[1] - positions[0];
    final double thirdTextWidth = positions[3] - positions[2];

    // Renders the first digit of the input
    _drawText(
        canvas,
        Offset(singleDigitValues[0], offset.dy + size.height + textSpacing),
        Size(singleDigitValues[1], size.height),
        value1,
        textStyle,
        textSpacing,
        textAlign,
        offset,
        size);

    // Renders the first six digits of encoded text
    _drawText(
        canvas,
        Offset(positions[0], offset.dy),
        Size(secondTextWidth, size.height),
        value2,
        textStyle,
        textSpacing,
        textAlign,
        offset,
        size);

    // Renders the second six digits of encoded text
    _drawText(
        canvas,
        Offset(positions[2], offset.dy),
        Size(thirdTextWidth, size.height),
        value3,
        textStyle,
        textSpacing,
        textAlign,
        offset,
        size);
  }
}
