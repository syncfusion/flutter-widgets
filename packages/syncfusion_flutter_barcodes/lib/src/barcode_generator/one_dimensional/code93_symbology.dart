part of barcodes;

/// The [Code93] was designed to complement and improve [Code39]. It is used to
/// represent the full ASCII character set by using combinations of two
/// characters.
/// [Code93] can encode uppercase letters, numeric digits, and a handful of
/// special characters.
class Code93 extends Symbology {
  /// Create a [Code93] symbology with the default or required properties.
  ///
  /// The arguments [module] must be non-negative and greater than 0.
  ///
  /// [Code93] always includes two check characters that requiring an extremely
  /// high level of accuracy.
  /// The checksum character is the modulo 47 remainder of the sum of the
  /// weighted value of the data characters.
  Code93({int module}) : super(module: module) {
    _character = _getCode93Character();
  }

  /// Represents the input value
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

  /// Returns the weight for the supported input character
  Map<String, String> _getCharacterWeight() {
    return <String, String>{
      '0': '0',
      '1': '1',
      '2': '2',
      '3': '3',
      '4': '4',
      '5': '5',
      '6': '6',
      '7': '7',
      '8': '8',
      '9': '9',
      'A': '10',
      'B': '11',
      'C': '12',
      'D': '13',
      'E': '14',
      'F': '15',
      'G': '16',
      'H': '17',
      'I': '18',
      'J': '19',
      'K': '20',
      'L': '21',
      'M': '22',
      'N': '23',
      'O': '24',
      'P': '25',
      'Q': '26',
      'R': '27',
      'S': '28',
      'T': '29',
      'U': '30',
      'V': '31',
      'W': '32',
      'X': '33',
      'Y': '34',
      'Z': '35',
      '-': '36',
      '.': '37',
      ' ': '38',
      '\$': '39',
      '/': '40',
      '+': '41',
      '%': '42',
      '(\$)': '43',
      '(/)': '44',
      '(+)': '45',
      '(%)': '46',
    };
  }

  /// Returns the byte value of the supported input symbol
  Map<String, String> _getCodeValue() {
    return <String, String>{
      '0': '100010100',
      '1': '101001000',
      '2': '101000100',
      '3': '101000010',
      '4': '100101000',
      '5': '100100100',
      '6': '100100010',
      '7': '101010000',
      '8': '100010010',
      '9': '100001010',
      'A': '110101000',
      'B': '110100100',
      'C': '110100010',
      'D': '110010100',
      'E': '110010010',
      'F': '110001010',
      'G': '101101000',
      'H': '101100100',
      'I': '101100010',
      'J': '100110100',
      'K': '100011010',
      'L': '101011000',
      'M': '101001100',
      'N': '101000110',
      'O': '100101100',
      'P': '100010110',
      'Q': '110110100',
      'R': '110110010',
      'S': '110101100',
      'T': '110100110',
      'U': '110010110',
      'V': '110011010',
      'W': '101101100',
      'X': '101100110',
      'Y': '100110110',
      'Z': '100111010',
      '-': '100101110',
      '.': '111010100',
      ' ': '111010010',
      '\$': '111001010',
      '/': '101101110',
      '+': '101110110',
      '%': '110101110',
      '(\$)': '100100110',
      '(/)': '111010110',
      '(+)': '100110010',
      '(%)': '111011010',
    };
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
      //Calculates the bar length based on number of individual bar codes
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
        //Draws the barcode when the corresponding bar value is one
        final bool canDraw = codeValue[j] == '1' ? true : false;
        if (canDraw &&
            (left >= barCodeRect.left && left + ratio < barCodeRect.right)) {
          final Rect individualBarRect = Rect.fromLTRB(
              left, offset.dy, left + ratio, offset.dy + barHeight);
          canvas.drawRect(individualBarRect, paint);
        }
        left += ratio;
      }
    }
    if (showValue) {
      _drawText(canvas, offset, size, value, textStyle, textSpacing, textAlign);
    }
  }

  /// Represents the pattern collection based on the provided input
  List<String> _getPatternCollection(String givenCharacter,
      Map<String, String> codes, List<String> encodingValue) {
    final List<String> codeKey = codes.keys.toList();
    for (int i = 0; i < givenCharacter.length; i++) {
      final int index = codeKey.indexOf(givenCharacter[i]);
      encodingValue.add(codes.entries.elementAt(index).value);
    }
    return encodingValue;
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

  /// Calculates the check sum value
  String _getCheckSum(String givenCharacter) {
    final String value = givenCharacter;
    int weightSum = 0;
    int j = 0;
    int moduleValue;
    String appendSymbol;
    final Map<String, String> codes = _getCharacterWeight();
    final List<String> codeKey = codes.keys.toList();
    for (int i = value.length; i > 0; i--) {
      final int index = codeKey.indexOf(value[j]);
      final int characterValue =
          int.parse(codes.entries.elementAt(index).value) * i;
      weightSum += characterValue;
      j++;
    }
    moduleValue = weightSum % 47;
    final List<String> objectValue = codes.keys.toList();
    appendSymbol = objectValue[moduleValue];
    return appendSymbol;
  }

  /// Returns the encoded value
  List<String> _getCodeValues(String value) {
    final Map<String, String> codes = _getCodeValue();
    List<String> encodingValue = <String>[];
    String givenCharacter = value;
    const String startStopCharacter = '101011110';
    const String terminationBar = '1';

    givenCharacter += _getCheckSum(givenCharacter);
    givenCharacter += _getCheckSum(givenCharacter);

    encodingValue.add(startStopCharacter);
    encodingValue = _getPatternCollection(givenCharacter, codes, encodingValue);
    encodingValue.add(startStopCharacter);
    encodingValue.add(terminationBar);
    return encodingValue;
  }

  /// Retuns the supported input symbol
  String _getCode93Character() {
    const String code93Character =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ-. *\$/+%';
    return code93Character;
  }
}
