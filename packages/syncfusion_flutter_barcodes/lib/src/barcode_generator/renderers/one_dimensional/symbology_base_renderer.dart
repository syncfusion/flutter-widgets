import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../../base/symbology_base.dart';
import 'code39_extended_renderer.dart';
import 'code39_renderer.dart';
import 'ean13_renderer.dart';
import 'ean8_renderer.dart';
import 'upca_renderer.dart';
import 'upce_renderer.dart';

/// Represents the symbology renderer
abstract class SymbologyRenderer {
  /// Creates the symbology renderer
  SymbologyRenderer({this.symbology});

  /// Specifies symbology corresponding to this renderer
  final Symbology? symbology;

  /// Specifies the value with start and the stop symbol
  late String valueWithStartAndStopSymbol;

  /// Specifies the text size
  Size? textSize;

  /// Method to valid whether the provided input character is supported
  /// by corresponding symbology
  bool getIsValidateInput(String value);

  /// Method to render the barcode value
  void renderBarcode(
      Canvas canvas,
      Size size,
      Offset offset,
      String value,
      Color foregroundColor,
      TextStyle textStyle,
      double textSpacing,
      TextAlign textAlign,
      bool showValue);

  /// Renders the paint for the bar code
  Paint getBarPaint(Color foregroundColor) {
    return Paint()
      ..color = foregroundColor
      ..strokeWidth = 1
      ..style = PaintingStyle.fill;
  }

  /// Calculates the left value of the initial bar code
  double getLeftPosition(
      int barWidth, int? module, double width, double offsetX) {
    final int calculatedWidth = barWidth * module!;
    // Calculates the left position of the barcode based on the provided
    // module value
    double diffInWidth = (width - calculatedWidth) / 2;
    diffInWidth += offsetX;
    return diffInWidth;
  }

  /// Method to render the input value of the barcode
  void drawText(Canvas canvas, Offset offset, Size size, String value,
      TextStyle textStyle, double textSpacing, TextAlign textAlign,
      [Offset? actualOffset, Size? actualSize]) {
    final TextSpan span = TextSpan(text: value, style: textStyle);
    final TextPainter textPainter = TextPainter(
        text: span, textDirection: TextDirection.ltr, textAlign: textAlign);
    textPainter.layout();
    double x;
    double y;
    if ((this is UPCARenderer ||
            this is EAN13Renderer ||
            this is UPCERenderer) &&
        value.length == 1) {
      x = offset.dx;
      y = offset.dy;
    } else {
      switch (textAlign) {
        case TextAlign.justify:
        case TextAlign.center:
          {
            x = (offset.dx + size.width / 2) - textPainter.width / 2;
            y = offset.dy + size.height + textSpacing;
          }
          break;
        case TextAlign.left:
        case TextAlign.start:
          {
            x = offset.dx;
            y = offset.dy + size.height + textSpacing;
          }
          break;
        case TextAlign.right:
        case TextAlign.end:
          {
            x = offset.dx + (size.width - textPainter.width);
            y = offset.dy + size.height + textSpacing;
          }
          break;
      }
    }

    if (this is UPCERenderer ||
        this is UPCARenderer ||
        this is EAN8Renderer ||
        this is EAN13Renderer) {
      // Checks whether the calculated x value is present inside the control
      // size
      if (x >= actualOffset!.dx &&
          x + textPainter.width <= actualOffset.dx + actualSize!.width) {
        textPainter.paint(canvas, Offset(x, y));
      }
    } else {
      textPainter.paint(canvas, Offset(x, y));
    }
  }

  /// Calculates whether the corresponding type has extra height barcode
  bool getHasExtraHeight(int currentItemIndex, List<String> code) {
    if (((currentItemIndex == 0 || currentItemIndex == code.length - 1) &&
            (this is Code39Renderer || this is Code39ExtendedRenderer)) ||
        ((this is EAN8Renderer || this is EAN13Renderer) &&
            (currentItemIndex == 0 ||
                currentItemIndex == 2 ||
                currentItemIndex == code.length - 1)) ||
        this is UPCARenderer &&
            (currentItemIndex == 1 ||
                currentItemIndex == code.length - 2 ||
                currentItemIndex == code.length - 4) ||
        this is UPCERenderer &&
            (currentItemIndex == 1 ||
                currentItemIndex == code.length - 2 ||
                currentItemIndex == code.length - 4)) {
      return true;
    } else {
      return false;
    }
  }
}
