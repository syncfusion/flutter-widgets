import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../../base/symbology_base.dart';
import 'symbology_base_renderer.dart';

/// Represents codabar renderer
class CodabarRenderer extends SymbologyRenderer {
  /// Creates codabar renderer class
  CodabarRenderer({Symbology? symbology}) : super(symbology: symbology) {
    _codeBarMap = <String, String>{
      '0': '101010011',
      '1': '101011001',
      '2': '101001011',
      '3': '110010101',
      '4': '101101001',
      '5': '110101001',
      '6': '100101011',
      '7': '100101101',
      '8': '100110101',
      '9': '110100101',
      '-': '101001101',
      '\$': '101100101',
      ':': '1101011011',
      '/': '1101101011',
      '.': '1101101101',
      '+': '101100110011',
      'A': '1011001001',
      'B': '1001001011',
      'C': '1010010011',
      'D': '1010011001'
    };
  }

  /// Represents the supported symbol and its byte value
  late Map<String, String> _codeBarMap;

  @override
  bool getIsValidateInput(String value) {
    for (int i = 0; i < value.length; i++) {
      if (!_codeBarMap.containsKey(value[i]) ||
          value[i] == 'A' ||
          value[i] == 'B' ||
          value[i] == 'C' ||
          value[i] == 'D') {
        throw ArgumentError(
            'The provided input cannot be encoded : ${value[i]}');
      }
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
    final Paint paint = getBarPaint(foregroundColor);
    final List<String?> code = _getCodeValues(value);
    final int barTotalLength = _getTotalLength(code);
    double left = symbology!.module == null
        ? offset.dx
        : getLeftPosition(
            barTotalLength, symbology!.module!, size.width, offset.dx);
    final Rect barCodeRect = Rect.fromLTRB(
        offset.dx, offset.dy, offset.dx + size.width, offset.dy + size.height);
    double ratio = 0;
    if (symbology!.module != null) {
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
      final String? codeValue = code[i];
      final double barHeight = size.height;
      final int codeLength = codeValue!.length;
      for (int j = 0; j < codeLength; j++) {
        final bool canDraw = codeValue[j] == '1';

        // Draws the barcode when the corresponding bar value is one
        if (canDraw &&
            (left >= barCodeRect.left && left + ratio < barCodeRect.right)) {
          final Rect individualBarRect = Rect.fromLTRB(
              left, offset.dy, left + ratio, offset.dy + barHeight);
          canvas.drawRect(individualBarRect, paint);
        }
        left += ratio;
      }
      if (i < code.length - 1) {
        left += ratio;
      }
    }
    if (showValue) {
      drawText(canvas, offset, size, value, textStyle, textSpacing, textAlign);
    }
  }

  /// Calculate total bar length from give input value
  int _getTotalLength(List<String?> code) {
    int count = 0;
    for (int i = 0; i < code.length; i++) {
      final int numberOfDigits = code[i]!.length;
      count += numberOfDigits;
    }
    count += code.length - 1;
    return count;
  }

  /// Method to append the start and the stop symbol
  String _getValueWithStartAndStopSymbol(String value) {
    return 'A${value}A';
  }

  /// Returns the encoded value of the provided input value
  List<String?> _getCodeValues(String value) {
    valueWithStartAndStopSymbol = _getValueWithStartAndStopSymbol(value);
    final List<String?> codeBarValues =
        List<String?>.filled(valueWithStartAndStopSymbol.length, null);
    for (int i = 0; i < valueWithStartAndStopSymbol.length; i++) {
      for (int j = 0; j < _codeBarMap.length; j++) {
        if (valueWithStartAndStopSymbol[i] ==
            _codeBarMap.entries.elementAt(j).key) {
          codeBarValues[i] = _codeBarMap.entries.elementAt(j).value;
          break;
        }
      }
    }
    return codeBarValues;
  }
}
