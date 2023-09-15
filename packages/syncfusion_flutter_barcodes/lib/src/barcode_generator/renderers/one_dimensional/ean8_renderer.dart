import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../../base/symbology_base.dart';
import 'symbology_base_renderer.dart';

/// Represents the EAN8 renderer class
class EAN8Renderer extends SymbologyRenderer {
  /// Creates the ean8 renderer
  EAN8Renderer({Symbology? symbology}) : super(symbology: symbology);

  /// Represents the encoded input value
  late String _encodedValue;

  @override
  bool getIsValidateInput(String value) {
    if (value.contains(RegExp(r'^(?=.*?[0-9]).{8}$'))) {
      if (int.parse(value[7]) == _getCheckSumData(value)) {
        _encodedValue = value;
      } else {
        throw ArgumentError('Invalid check digit at the trailing end. '
            'Provide the valid check digit or remove it. '
            'Since, it has been calculated automatically.');
      }
    } else if (value.contains(RegExp(r'^(?=.*?[0-9]).{7}$'))) {
      _encodedValue = value + _getCheckSumData(value).toString();
    } else {
      throw ArgumentError('EAN8 supports only numeric characters.'
          ' The provided value should have 7 digits (without check digit)'
          ' or with 8 digits.');
    }
    return true;
  }

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
    ///  _positions[0] specifies end position of start  bar
    ///  _positions[1] specifies start position of middle  bar
    ///  _positions[2] specifies end position of middle bar
    ///  _positions[3] specifies start position of end bar
    final List<double?> positions = List<double?>.filled(4, null);
    final Paint paint = getBarPaint(foregroundColor);
    final List<String> code = _getCodeValues();
    final int barTotalLength = _getTotalLength(code);
    double left = symbology?.module == null
        ? offset.dx
        : getLeftPosition(
            barTotalLength, symbology?.module, size.width, offset.dx);
    final Rect barCodeRect = Rect.fromLTRB(
        offset.dx, offset.dy, offset.dx + size.width, offset.dy + size.height);

    double ratio = 0;
    if (symbology?.module != null) {
      ratio = symbology!.module!.toDouble();
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
      final bool hasExtraHeight = getHasExtraHeight(i, code);
      final double additionalHeight = i == 2 ? 0.4 : 0.5;
      final double barHeight = hasExtraHeight
          ? size.height +
              (showValue
                  ? (textSize!.height * additionalHeight) + textSpacing
                  : 0)
          : size.height;
      final int codeLength = codeValue.length;
      for (int j = 0; j < codeLength; j++) {
        // Draw the barcode when the current code value is 1
        final bool canDraw = codeValue[j] == '1';
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
        } else if (i == 3 && j == codeLength - 1) {
          // Checks the start position of third extra height bar
          positions[3] = left;
        }
      }
    }
    if (showValue) {
      _paintText(canvas, offset, size, _encodedValue, textStyle, textSpacing,
          textAlign, positions);
    }
  }

  /// Calculate total bar length from given input value
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
    const String endBars = '101';
    const String middleBar = '01010';
    Map<String, String> codes = _getCodeValueRight(true);
    final List<String> code = <String>[];
    code.add(endBars);
    code.add(_getLeftValue(codes, true));
    code.add(middleBar);
    codes = _getCodeValueRight(false);
    code.add(_getLeftValue(codes, false));
    code.add(endBars);
    return code;
  }

  /// Represents the encoded value for the first 6 digits of the input value
  String _getLeftValue(Map<String, String> codes, bool isLeft) {
    String code = '';
    for (int i = isLeft ? 0 : _encodedValue.length - 4;
        i < (isLeft ? _encodedValue.length - 4 : _encodedValue.length);
        i++) {
      final int currentValue = int.parse(_encodedValue[i]);
      if (i == 0 || i == 4) {
        code = codes.entries.elementAt(currentValue).value;
      } else {
        code += codes.entries.elementAt(currentValue).value;
      }
    }
    return code;
  }

  /// Method to calculate the input data
  int _getCheckSumData(String value) {
    // ignore: dead_code
    for (int i = 0; i < value.length; i++) {
      final int sum1 =
          int.parse(value[1]) + int.parse(value[3]) + int.parse(value[5]);
      final int sum2 = 3 *
          (int.parse(value[0]) +
              int.parse(value[2]) +
              int.parse(value[4]) +
              int.parse(value[6]));
      final int checkSumValue = sum1 + sum2;
      final int checkSumDigit = (10 - checkSumValue) % 10;
      return checkSumDigit;
    }
    return 0;
  }

  /// Represents the encoded value for the last 6 digits of the input value
  Map<String, String> _getCodeValueRight(bool isRight) {
    Map<String, String> codes;
    if (isRight) {
      codes = <String, String>{
        '0': '0001101',
        '1': '0011001',
        '2': '0010011',
        '3': '0111101',
        '4': '0100011',
        '5': '0110001',
        '6': '0101111',
        '7': '0111011',
        '8': '0110111',
        '9': '0001011',
      };
    } else {
      codes = <String, String>{
        '0': '1110010',
        '1': '1100110',
        '2': '1101100',
        '3': '1000010',
        '4': '1011100',
        '5': '1001110',
        '6': '1010000',
        '7': '1000100',
        '8': '1001000',
        '9': '1110100'
      };
    }
    return codes;
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
      List<double?> positions) {
    final String value1 = value.substring(0, 4);
    final String value2 = value.substring(4, 8);
    final double firstTextWidth = positions[1]! - positions[0]!;
    final double secondTextWidth = positions[3]! - positions[2]!;

    // Renders the first four digits of input
    drawText(
        canvas,
        Offset(positions[0]!, offset.dy),
        Size(firstTextWidth, size.height),
        value1,
        textStyle,
        textSpacing,
        textAlign,
        offset,
        size);

    // Renders the last four digits of input
    drawText(
        canvas,
        Offset(positions[2]!, offset.dy),
        Size(secondTextWidth, size.height),
        value2,
        textStyle,
        textSpacing,
        textAlign,
        offset,
        size);
  }
}
