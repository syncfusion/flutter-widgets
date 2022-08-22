import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../../base/symbology_base.dart';
import '../../utils/helper.dart';
import 'symbology_base_renderer.dart';

/// Represents the UPCA renderer class
class UPCARenderer extends SymbologyRenderer {
  /// Creates the upca renderer
  UPCARenderer({Symbology? symbology}) : super(symbology: symbology);

  /// Represents the encoded input value
  late String _encodedValue;

  @override
  bool getIsValidateInput(String value) {
    if (value.contains(RegExp(r'^(?=.*?[0-9]).{11}$'))) {
      _encodedValue = value + _getCheckSumData(value).toString();
    } else if (value.contains(RegExp(r'^(?=.*?[0-9]).{12}$'))) {
      if (int.parse(value[11]) == _getCheckSumData(value)) {
        _encodedValue = value;
      } else {
        throw ArgumentError('Invalid check digit at the trailing end.'
            ' Provide the valid check digit or remove it.'
            ' Since, it has been calculated automatically.');
      }
    } else {
      throw ArgumentError('UPCA supports only numeric characters. '
          'The provided value should have 11 digits (without check digit) '
          'or with 12 digits.');
    }
    return true;
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
    final List<String> code = _getCodeValues();
    final int barTotalLength = _getTotalLength(code);
    const int additionalWidth = 2;

    /// _singleDigitValues[0] specifies left value of start digit
    /// _singleDigitValues[1] specifies width of start digit
    /// _singleDigitValues[2] specifies left value of end digit
    /// _singleDigitValues[3] specifies width of end digit
    final List<double?> singleDigitValues = List<double?>.filled(4, null);

    ///  _positions[0] specifies end position of start  bar
    ///  _positions[1] specifies start position of middle  bar
    ///  _positions[2] specifies end position of middle bar
    ///  _positions[3] specifies start position of end bar
    final List<double?> positions = List<double?>.filled(4, null);
    if (showValue) {
      singleDigitValues[1] = measureText(_encodedValue[0], textStyle).width;
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
        ? offset.dx + singleDigitValues[1]!
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
    positions[0] = left + ratio;
    for (int i = 0; i < code.length; i++) {
      final String codeValue = code[i];
      final bool hasExtraHeight = getHasExtraHeight(i, code);
      final double additionalHeight = i == code.length - 4 ? 0.4 : 0.5;
      final double barHeight = hasExtraHeight
          ? size.height +
              (showValue
                  ? (textSize!.height * additionalHeight) + textSpacing
                  : 0)
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

        if (i == 0 && j == codeLength - 1) {
          // Calculates the left value for the first input digit
          singleDigitValues[0] = left - singleDigitValues[1]!;
        } else if (i == 1 && j == codeLength - 1) {
          // Finds the end position of first extra height bar
          positions[0] = left;
        } else if (i == 3 && j == 0) {
          // Finds the start position of second extra height bar
          positions[1] = left;
        } else if (i == 3 && j == codeLength - 1) {
          // Finds the end position of second extra height bar
          positions[2] = left;
        } else if (i == 4 && j == codeLength - 1) {
          // Finds the start position of third extra height bar
          positions[3] = left;
        } else if (i == 5 && j == codeLength - 1) {
          // Finds the end position of fourth extra height bar
          singleDigitValues[2] = left + additionalWidth;
        }
      }
    }

    if (showValue) {
      _paintText(canvas, offset, size, _encodedValue, textStyle, textSpacing,
          textAlign, positions, singleDigitValues);
    }
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

  /// Returns the encoded value
  List<String> _getCodeValues() {
    const String endDigits = '00000000';
    const String middleBar = '01010';
    final List<String> code = <String>[];
    code.add(endDigits);
    code.add('101${_getLeftValue(true, 'L', _encodedValue[0])}');
    code.add(_getLeftValue(true, 'LLLLL', _encodedValue.substring(1, 6)));
    code.add(middleBar);
    code.add(_getLeftValue(true, 'RRRRR', _encodedValue.substring(6, 11)));
    code.add('${_getLeftValue(true, 'R', _encodedValue[11])}101');
    code.add(endDigits);
    return code;
  }

  /// Returns the binary values for the supported input symbol
  Map<String, List<String>> _getBinaries() {
    final Map<String, List<String>> codes = <String, List<String>>{
      'L': <String>[
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
      'R': <String>[
        '1110010',
        '1100110',
        '1101100',
        '1000010',
        '1011100',
        '1001110',
        '1010000',
        '1000100',
        '1001000',
        '1110100'
      ]
    };

    return codes;
  }

  /// Returns the encoded value of digits present at left side
  String _getLeftValue(bool isLeft, String structure, String leftString) {
    late String code;
    List<String> tempValue;
    final Map<String, List<String>> codes = _getBinaries();
    for (int i = 0; i < leftString.length; i++) {
      if (structure[i] == 'R') {
        tempValue = codes.entries.elementAt(1).value;
      } else {
        tempValue = codes.entries.elementAt(0).value;
      }

      final int currentValue = int.parse(leftString[i]);
      if (i == 0) {
        code = tempValue[currentValue];
      } else {
        code += tempValue[currentValue];
      }
    }
    return code;
  }

  /// Method to calculate the check sum digit
  int _getCheckSumData(String value) {
    final int sum1 = 3 *
        (int.parse(value[0]) +
            int.parse(value[2]) +
            int.parse(value[4]) +
            int.parse(value[6]) +
            int.parse(value[8]) +
            int.parse(value[10]));
    final int sum2 = int.parse(value[9]) +
        int.parse(value[7]) +
        int.parse(value[5]) +
        int.parse(value[3]) +
        int.parse(value[1]);
    final int checkSumValue = sum1 + sum2;
    return (10 - checkSumValue % 10) % 10;
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
    final String value1 = value[0];
    final String value2 = value.substring(1, 6);
    final String value3 = value.substring(6, 11);

    final double secondTextWidth = positions[1]! - positions[0]!;
    final double thirdTextWidth = positions[3]! - positions[2]!;

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

    // Renders the first five digits of encoded input value
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

    // Renders the second five digits of encoded input value
    drawText(
        canvas,
        Offset(positions[2]!, offset.dy),
        Size(thirdTextWidth, size.height),
        value3,
        textStyle,
        textSpacing,
        textAlign,
        offset,
        size);

    // Renders the last digit of the encoded input value
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
}
