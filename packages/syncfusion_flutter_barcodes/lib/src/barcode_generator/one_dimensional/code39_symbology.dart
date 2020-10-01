part of barcodes;

/// The [Code39] is a discrete, variable-length symbology that encodes
/// alphanumeric characters into a series of bars.
/// A special start / stop character is placed at the beginning and ending
/// of each barcode.
///
/// Code 39 is self-checking, a check digit is not usually required for common
/// use. For certain cases, applications requiring an extremely high level of
/// accuracy of the checksum digit can be added.
///
/// Allows character set of digits (0-9), upper case alphabets (A-Z), and
/// symbols like space, minus (-), plus (+), period (.), dollar sign ($),
/// slash (/), and percent (%).
class Code39 extends Symbology {
  /// Create a [Code39] symbology with the default or required properties.
  ///
  /// The arguments [module] must be non-negative and greater than 0.
  ///
  /// Since Code 39 is self-checking, it is not normally necessary to provide
  /// a checksum.
  /// However, in applications requiring an extremely high level of accuracy,
  /// a modulo 43 checksum can be added,
  /// if the [enableCheckSum] is true.
  ///
  Code39({int module, this.enableCheckSum = true}) : super(module: module) {
    _code39Symbology = <String>[
      '111221211',
      '211211112',
      '112211112',
      '212211111',
      '111221112',
      '211221111',
      '112221111',
      '111211212',
      '211211211',
      '112211211',
      '211112112',
      '112112112',
      '212112111',
      '111122112',
      '211122111',
      '112122111',
      '111112212',
      '211112211',
      '112112211',
      '111122211',
      '211111122',
      '112111122',
      '212111121',
      '111121122',
      '211121121',
      '112121121',
      '111111222',
      '211111221',
      '112111221',
      '111121221',
      '221111112',
      '122111112',
      '222111111',
      '121121112',
      '221121111',
      '122121111',
      '121111212',
      '221111211',
      '122111211',
      '121121211',
      '121212111',
      '121211121',
      '121112121',
      '111212121'
    ];

    _character = _getCode39Character();
  }

  /// Whether to add a checksum on the far right side of the barcode.
  ///
  /// The checksum, also known as the check digit, is the number on the far
  /// right side of the barcode.
  /// The purpose of the check digit is to verify that the barcode information
  /// has been provided correctly.
  ///
  /// Defaults to true.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfBarcodeGenerator(value:'123456',
  ///        symbology: Code39(enableCheckSum: false)));
  ///}
  /// ```dart
  final bool enableCheckSum;

  /// Represents the code39 symbology
  List<String> _code39Symbology;

  /// Represnts the encoded input character
  String _character;

  @override
  bool _getIsValidateInput(String value) {
    for (int i = 0; i < value.length; i++) {
      if (!_character.contains(value[i])) {
        throw 'The provided input cannot be encoded : ' + value[i];
      }
    }
    return true;
  }

  /// Calculates the check sum value based on the input
  String _getCheckSum(String value, String codeBarCharacters) {
    int checkSum = 0;
    for (int i = 0; i < value.length; i++) {
      final int codeNumber = codeBarCharacters.indexOf(value[i]);
      checkSum += codeNumber;
    }
    checkSum = checkSum % 43;
    return checkSum.toString();
  }

  /// Returns the provided value with start and stop symbol
  String _getValueWithStartAndStopCharacters(String value) {
    return '*' + value + '*';
  }

  /// Returns the pattern collection based on the provided input
  List<String> _getPatternCollection(
      String providedValue, String code39Characters) {
    final List<String> code39Values = <String>[];
    for (int i = 0; i < providedValue.length; i++) {
      final int currentIndex = code39Characters.indexOf(providedValue[i]);
      code39Values.add(_code39Symbology[currentIndex]);
    }
    return code39Values;
  }

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
    final Paint paint = _getBarPaint(foregroundColor);
    final List<String> code = _getCodeValues(value);
    final int barTotalLength = _getTotalLength(code);
    double left = module == null
        ? offset.dx
        : _getLeftPosition(barTotalLength, module, size.width, offset.dx);
    final Rect barCodeRect = Rect.fromLTRB(
        offset.dx, offset.dy, offset.dx + size.width, offset.dy + size.height);
    double ratio = 0;
    if (module != null) {
      ratio = module.toDouble();
    } else {
      // Calculates the bar length based on number of individual bar codes
      final int singleModule = (size.width ~/ barTotalLength).toInt();
      ratio = singleModule.toDouble();
      final double leftPadding = (size.width - (barTotalLength * ratio)) / 2;
      left += leftPadding;
    }
    left = left.roundToDouble();
    for (int i = 0; i < code.length; i++) {
      final String codeValue = code[i];
      const bool hasExtraHeight = false;
      final double barHeight = hasExtraHeight
          ? size.height + _textSize.height + textSpacing
          : size.height;
      final int codeLength = codeValue.length;
      for (int j = 0; j < codeLength; j++) {
        // The current bar is drawn, if its value is divisible by 2
        final bool canDraw = j % 2 == 0 ? true : false;
        final int currentValue = int.parse(codeValue[j]);
        if (canDraw &&
            (left >= barCodeRect.left &&
                left + (currentValue * ratio) < barCodeRect.right)) {
          final Rect individualBarRect = Rect.fromLTRB(left, offset.dy,
              left + (currentValue * ratio), offset.dy + barHeight);
          canvas.drawRect(individualBarRect, paint);
        }
        left += currentValue * ratio;
      }
      if (i < code.length - 1) {
        left += ratio;
      }
    }
    if (showValue) {
      _drawText(canvas, offset, size, value, textStyle, textSpacing, textAlign);
    }
  }

  /// Returns the encoded value
  List<String> _getCodeValues(String value) {
    return _getEncodedValue(value);
  }

  /// Calculate total bar length from give input value
  int _getTotalLength(List<String> code) {
    int count = 0;
    for (int i = 0; i < code.length; i++) {
      final String currentItem = code[i];
      for (int j = 0; j < currentItem.length; j++) {
        count += int.parse(currentItem[j]);
      }
    }
    count += code.length - 1;
    return count;
  }

  /// Represents the encoded value for provided input
  List<String> _getEncodedValue(String providedValue) {
    if (enableCheckSum) {
      final String checkSum = _getCheckSum(providedValue, _character);
      providedValue += checkSum;
    }
    providedValue = _getValueWithStartAndStopCharacters(providedValue);
    return _getPatternCollection(providedValue, _character);
  }

  /// Represents the code bar value
  String _getCode39Character() {
    const String code39Character =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ-. *\$/+%';
    return code39Character;
  }
}
