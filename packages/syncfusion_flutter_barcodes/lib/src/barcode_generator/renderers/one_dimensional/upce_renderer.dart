import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../../base/symbology_base.dart';
import '../../utils/helper.dart';
import 'symbology_base_renderer.dart';

/// Represents the UPCE renderer class
class UPCERenderer extends SymbologyRenderer {
  /// Creates the upce renderer
  UPCERenderer({Symbology? symbology}) : super(symbology: symbology);

  /// Represents the encoded input value
  late String _encodedValue;

  @override
  bool getIsValidateInput(String value) {
    if (value.contains(RegExp(r'^(?=.*?[0-9]).{6}$'))) {
      return true;
    }
    throw ArgumentError('UPCE supports only numeric characters. '
        'The provided value should have 6 digits.');
  }

  /// This is quite a large method. This method could not be
  /// refactored to a smaller methods, since it requires multiple parameters
  /// to be passed
  @override
  void renderBarcode(
      Canvas canvas,
      Size size,
      Offset offset,
      String value,
      Color foregroundColor,
      TextStyle textStyle,
      double textSpacing,
      TextAlign textAlign,
      bool showValue) {
    final Paint paint = getBarPaint(foregroundColor);
    final List<String> code = _getCodeValues(value);
    final int barTotalLength = _getTotalLength(code);

    /// _singleDigitValues[0] specifies left value of start digit
    /// _singleDigitValues[1] specifies width of start digit
    /// _singleDigitValues[2] specifies left value of end digit
    /// _singleDigitValues[3] specifies width of end digit
    final List<double?> singleDigitValues = List<double?>.filled(4, null);

    ///  _positions[0] specifies end position of start  bar
    ///  _positions[1] specifies start position of end  bar
    final List<double?> positions = List<double?>.filled(2, null);
    const int additionalWidth = 2;
    if (showValue) {
      singleDigitValues[1] = measureText('0', textStyle).width;
      singleDigitValues[1] = singleDigitValues[1]! + additionalWidth;
      singleDigitValues[3] =
          measureText(_encodedValue[_encodedValue.length - 1], textStyle).width;
      singleDigitValues[3] = singleDigitValues[3]! + additionalWidth;
    } else {
      singleDigitValues[1] = singleDigitValues[3] = 0;
    }

    final double width =
        size.width - (singleDigitValues[1]! + singleDigitValues[3]!);
    double left = symbology?.module == null
        ? offset.dx
        : getLeftPosition(barTotalLength, symbology?.module, width,
            offset.dx + singleDigitValues[1]!);
    final Rect barCodeRect = Rect.fromLTRB(
        offset.dx, offset.dy, offset.dx + size.width, offset.dy + size.height);
    double ratio = 0;
    if (symbology?.module != null) {
      ratio = symbology!.module!.toDouble();
    } else {
      //Calculates the bar length based on number of individual bar codes
      final int singleModule = (width ~/ barTotalLength).toInt();
      ratio = singleModule.toDouble();
      final double leftPadding = (width - (barTotalLength * ratio)) / 2;
      left += leftPadding;
    }
    left = left.roundToDouble();
    for (int i = 0; i < code.length; i++) {
      final String codeValue = code[i];
      final bool hasExtraHeight = getHasExtraHeight(i, code);
      final double barHeight = hasExtraHeight
          ? size.height +
              (showValue ? (textSize!.height * 0.5) + textSpacing : 0)
          : size.height;
      final int codeLength = codeValue.length;
      for (int j = 0; j < codeLength; j++) {
        final bool canDraw = codeValue[j] == '1';
        if (canDraw &&
            (left >= barCodeRect.left && left + ratio < barCodeRect.right)) {
          final Rect individualBarRect = Rect.fromLTRB(
              left, offset.dy, left + ratio, offset.dy + barHeight);
          canvas.drawRect(individualBarRect, paint);
        }

        left += ratio;

        // Calculates the left value for first digit
        if (i == 0 && j == codeLength - 1) {
          singleDigitValues[0] = left - singleDigitValues[1]!;
        } else if (i == 1 && j == codeLength - 1) {
          // Calculates the start position of intermediate bars
          positions[0] = left;
        } else if (i == 3 && j == 0) {
          // Calculates the end position of intermediate bars
          positions[1] = left;
        } else if (i == 3 && j == codeLength - 1) {
          // Calculates the left value of last digit
          singleDigitValues[2] = left + additionalWidth;
        }
      }
    }
    if (showValue) {
      _paintText(canvas, offset, size, _encodedValue, textStyle, textSpacing,
          textAlign, positions, singleDigitValues);
    }
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
      List<double?> positions,
      List<double?> singleDigitValues) {
    const String value1 = '0';
    final String value2 = value.substring(1, 7);

    final double secondTextWidth = positions[1]! - positions[0]!;

    // Renders the first digit of encoded value
    drawText(
        canvas,
        Offset(singleDigitValues[0]!, offset.dy + size.height + textSpacing),
        Size(singleDigitValues[1]!, size.height),
        value1,
        textStyle,
        textSpacing,
        textAlign,
        offset,
        size);
    //Renders the middle six digits of encoded value
    drawText(
        canvas,
        Offset(positions[0]!, offset.dy),
        Size(secondTextWidth, size.height),
        value2,
        textStyle,
        textSpacing,
        textAlign,
        offset,
        size);
    // Renders the last digit of encoded value
    drawText(
        canvas,
        Offset(singleDigitValues[2]!, offset.dy + size.height + textSpacing),
        Size(singleDigitValues[3]!, size.height),
        value[value.length - 1],
        textStyle,
        textSpacing,
        textAlign,
        offset,
        size);
  }

  /// Calculate the total length from given value
  int _getTotalLength(List<String> code) {
    int count = 0;
    for (int i = 0; i < code.length; i++) {
      final int numberOfDigits = code[i].length;
      count += numberOfDigits;
    }
    return count;
  }

  /// Method to calculate the check sum value
  num _getCheckSum(String value) {
    num result = 0;
    for (int i = 1; i < 11; i += 2) {
      result += int.parse(value[i]);
    }
    for (int i = 0; i < 11; i += 2) {
      result += int.parse(value[i]) * 3;
    }
    return (10 - (result % 10)) % 10;
  }

  /// Returns the supported symbol and its pattern value
  Map<String, String> _getStructure() {
    final Map<String, String> upceSymbology = <String, String>{
      '0': 'EEEOOO',
      '1': 'EEOEOO',
      '2': 'EEOOEO',
      '3': 'EEOOOE',
      '4': 'EOEEOO',
      '5': 'EOOEEO',
      '6': 'EOOOEE',
      '7': 'EOEOEO',
      '8': 'EOEOOE',
      '9': 'EOOEOE'
    };
    return upceSymbology;
  }

  /// Returns the byte value for the supported symbol
  List<String> _getValue() {
    return <String>[
      'XX00000XXX',
      'XX10000XXX',
      'XX20000XXX',
      'XXX00000XX',
      'XXXX00000X',
      'XXXXX00005',
      'XXXXX00006',
      'XXXXX00007',
      'XXXXX00008',
      'XXXXX00009'
    ];
  }

  /// Returns the value for the last digit
  String _getExpansion(String lastDigit) {
    final List<String> value = _getValue();
    final int index = int.parse(lastDigit);
    return value[index];
  }

  /// Returns the calculated UPC value
  String _getUPCValue(String value) {
    final String lastDigit = value[value.length - 1];
    final String expansionValue = _getExpansion(lastDigit);
    String result = '';
    int index = 0;
    for (int i = 0; i < expansionValue.length; i++) {
      final String actualValue = expansionValue[i];
      if (actualValue == 'X') {
        result += value[index++];
      } else {
        result += actualValue;
      }
    }
    result = '0$result';
    String encodingValue = result;
    final String checkSumValue = _getCheckSum(result).toString();
    encodingValue += checkSumValue;
    _encodedValue = '0$value$checkSumValue';
    return encodingValue;
  }

  /// Returns the binary values of the supported symbol
  Map<String, List<String>> _getBinaries() {
    return <String, List<String>>{
      'O': <String>[
        '0001101',
        '0011001',
        '0010011',
        '0111101',
        '0100011',
        '0110001',
        '0101111',
        '0111011',
        '0110111',
        '0001011'
      ],
      'E': <String>[
        // The E (even) encoding for UPC-E
        '0100111', '0110011', '0011011', '0100001', '0011101',
        '0111001', '0000101', '0010001', '0001001', '0010111'
      ]
    };
  }

  /// Returns the encoded input value
  String _encoding(String upceValue, String value, String structure) {
    String code = '';
    List<String> tempValue;
    final Map<String, List<String>> codes = _getBinaries();
    for (int i = 0; i < value.length; i++) {
      if (structure[i] == 'E') {
        tempValue = codes.entries.elementAt(1).value;
      } else {
        tempValue = codes.entries.elementAt(0).value;
      }
      if (i == 0) {
        final int index = int.parse(value[i]);
        code = tempValue[index];
      } else {
        final int index = int.parse(value[i]);
        code += tempValue[index];
      }
    }
    return code;
  }

  /// Returns the encoded value
  List<String> _getCodeValues(String value) {
    const String endBars = '101';
    const String middleBar = '010101';
    const String endDigits = '00000000';
    final List<String> code = <String>[];
    final String upceValue = _getUPCValue(value);
    final Map<String, String> structureValue = _getStructure();
    final int actualValue = int.parse(upceValue[upceValue.length - 1]);
    final String structure =
        structureValue.entries.elementAt(actualValue).value;
    code.add(endDigits);
    code.add(endBars);
    code.add(_encoding(upceValue, value, structure));
    code.add(middleBar);
    code.add(endDigits);
    return code;
  }
}
