part of barcodes;

/// Define the barcode symbology that will be used to encode the input value
/// to the visual barcode representation.
///
/// The specification of a symbology includes the encoding of the value into
/// bars and spaces, the required start and stop characters, the size of the
/// quiet zone needed to be before and after the barcode, and the computing of
/// the checksum digit.
abstract class Symbology {
  /// Create a symbology with the default or required properties.
  ///
  /// The arguments [module] must be non-negative and greater than 0.
  ///
  Symbology({this.module})
      : assert(
            (module != null && module > 0) || module == null,
            'Module must'
            ' not be a non-negative value or else it must be equal to null.');

  /// Specifies the size of the smallest line or dot of the barcode.
  ///
  /// This property is measured in a logical pixels.
  ///
  /// Both the one dimensional and the two dimensional symbology support the
  /// [module] property.
  /// This property is used to define the size of the smallest line or dot
  /// of the barcode.
  ///
  /// For one dimensional barcode, if this property is not set, the size of
  /// the smallest bar line is determined depending on the width available.
  ///
  /// Example: Result of the total computed inputs(0’s and 1’s) divided by the
  /// available width.
  ///
  /// For two dimensional barcode , if the [module] property is not set,
  /// the size of smallest dot is calculated based on the minimum of available
  /// width or height.
  ///
  /// Defaults to null.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfBarcodeGenerator(value:'123456',
  ///        symbology: UPCE(module: 2)));
  ///}
  /// ```dart
  final int module;

  /// Specifies the value with start and the stop symbol
  String _valueWithStartAndStopSymbol;

  /// Specifies the text size
  Size _textSize;

  /// Method to valid whether the provided input character is supported
  /// by corresponding symbology
  bool _getIsValidateInput(String value);

  /// Method to render the barcode value
  void _renderBarcode(
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
  Paint _getBarPaint(Color foregroundColor) {
    return Paint()
      ..color = foregroundColor
      ..strokeWidth = 1
      ..style = PaintingStyle.fill;
  }

  /// Calculates the left value of the initial bar code
  double _getLeftPosition(
      int barWidth, int module, double width, double offsetX) {
    final int calculatedWidth = barWidth * module;
    // Calculates the left position of the barcode based on the provided
    // module value
    double diffInWidth = (width - calculatedWidth) / 2;
    diffInWidth += offsetX;
    return diffInWidth;
  }

  /// Method to render the input value of the barcode
  void _drawText(Canvas canvas, Offset offset, Size size, String value,
      TextStyle textStyle, double textSpacing, TextAlign textAlign,
      [Offset actualOffset, Size actualSize]) {
    final TextSpan span = TextSpan(text: value, style: textStyle);
    final TextPainter textPainter = TextPainter(
        text: span, textDirection: TextDirection.ltr, textAlign: textAlign);
    textPainter.layout();
    double x;
    double y;
    if ((this is UPCA || this is EAN13 || this is UPCE) && value.length == 1) {
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

    if (this is UPCE || this is UPCA || this is EAN8 || this is EAN13) {
      // Checks whether the calculated x value is present inside the control
      // size
      if (x >= actualOffset.dx &&
          x + textPainter.width <= actualOffset.dx + actualSize.width) {
        textPainter.paint(canvas, Offset(x, y));
      }
    } else {
      textPainter.paint(canvas, Offset(x, y));
    }
  }

  /// Calculates whether the corresponding type has extra height barcode
  bool _getHasExtraHeight(int currentItemIndex, List<String> code) {
    if (((currentItemIndex == 0 || currentItemIndex == code.length - 1) &&
            (this is Code39 || this is Code39Extended)) ||
        ((this is EAN8 || this is EAN13) &&
            (currentItemIndex == 0 ||
                currentItemIndex == 2 ||
                currentItemIndex == code.length - 1)) ||
        this is UPCA &&
            (currentItemIndex == 1 ||
                currentItemIndex == code.length - 2 ||
                currentItemIndex == code.length - 4) ||
        this is UPCE &&
            (currentItemIndex == 1 ||
                currentItemIndex == code.length - 2 ||
                currentItemIndex == code.length - 4)) {
      return true;
    } else {
      return false;
    }
  }
}
