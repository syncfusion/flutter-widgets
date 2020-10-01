part of barcodes;

/// Create barcode to generate and display data in a machine-readable
/// industry-standard 1D and 2D barcodes.
///
/// ## One-dimensional barcodes
///
/// [SfBarcodeGenerator] supports different one-dimensional barcode symbologies
/// such as [Code128], [EAN8], [EAN13], [UPCA], [UPCE], [Code39],
/// [Code39Extended], [Code93], and [Codabar].
///
/// ## Two-dimensional barcodes
///
/// [SfBarcodeGenerator] supports popular [QRCode] and [DataMatrix].
///
/// Customize the visual appearance of barcodes using the [backgroundColor]
/// and [barColor] properties and adjust the size of smallest line or dot of
/// the code using the [Symbology.module] property.
///
/// Configure to display the human readable text and can customize it's
/// position and style.
///
/// ```dart
/// Widget build(BuildContext context) {
///   return MaterialApp(
///      home: Scaffold(
///          backgroundColor: Colors.white,
///          body: Center(
///              child: Container(
///            height: 200,
///            child: SfBarcodeGenerator(
///              value: 'www.syncfusion.com',
///              symbology: QRCode(),
///              showValue: true,
///              textStyle: TextStyle(fontSize: 15),
///            ),
///          ))),
///    );
///  }
/// ```dart
class SfBarcodeGenerator extends StatefulWidget {
  /// Generate the barcode using supported symbology types based on input
  /// values.
  ///
  /// The [value] property is required to generate the barcode and [value]
  /// must not be null or empty.
  ///
  /// Default symbology is [Code128].
  SfBarcodeGenerator(
      {Key key,
      @required this.value,
      Symbology symbology,
      this.barColor,
      this.backgroundColor,
      this.showValue = false,
      this.textSpacing = 2,
      this.textAlign = TextAlign.center,
      this.textStyle = const TextStyle()})
      : symbology = symbology ?? Code128(),
        super(key: key);

  /// Defines the value of the barcode to be rendered.
  ///
  /// The [value] property is required to generate a barcode. The input value
  /// is accepted as a string and encoded in a machine readable format.
  ///
  /// The length and characters type of the value can be varied on the basis
  /// of the [Symbology].
  ///
  /// Defaults to null.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfBarcodeGenerator(value:'123456'));
  ///}
  /// ```dart
  final String value;

  /// Define the barcode symbology that will be used to encode the input value
  /// to the visual barcode representation.
  ///
  /// You can generate one-dimensional barcode symbologies such as [Code128],
  /// [Code128A], [Code128B], [Code128C], [EAN8], [EAN13],
  /// [UPCA], [UPCE], [Code39], [Code39Extended], [Code93], and [Codabar].
  ///
  /// Also, you can generate two-dimensional barcode symbologies such as
  /// [QRCode] and [DataMatrix].
  ///
  /// The specification of a symbology includes the encoding of the value
  /// into bars and spaces, the required start and stop characters, the size of
  /// the quiet zone needed to be before and after the barcode, and the
  /// computing of the checksum digit.
  ///
  /// Default symbology is [Code128].
  ///
  /// Also refer [Symbology].
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfBarcodeGenerator(value:'123456',
  ///        symbology: UPCE()));
  ///}
  /// ```dart
  final Symbology symbology;

  /// Define the color for barcode elements.
  ///
  /// Color to be used when painting a vertical bar on a one-dimensional
  /// barcode and a dot on a two-dimensional barcode. This color is not used
  /// when painting a human readable text.
  ///
  /// Defaults to null.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfBarcodeGenerator(value:'123456',
  ///        barColor : Colors.red));
  ///}
  /// ```dart
  final Color barColor;

  /// The background color to fill the background of the [SfBarcodeGenerator].
  ///
  /// If it is not null, the color to be applied to the background of the
  /// [SfBarcodeGenerator].
  ///
  /// Defaults to null.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfBarcodeGenerator(value:'123456',
  ///        backgroundColor : Colors.red));
  ///}
  /// ```dart
  final Color backgroundColor;

  /// Whether to show a human readable text (input value) along with a barcode.
  ///
  /// If it is true, the value shown at the bottom of the barcode and the
  /// barcode height will be adjusted depending on the height of the text.
  ///
  /// The spacing between text and barcode is controlled by the [textSpacing]
  /// property.
  ///
  /// Defaults to false.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfBarcodeGenerator(value:'123456',
  ///        showValue : true));
  ///}
  /// ```dart
  final bool showValue;

  /// Specifies the space between the text and the barcode.
  ///
  /// Based on space, the barcode height is to be reduced and the space unit is
  /// to be determined by logical pixels.
  ///
  /// Defaults to 2 logical pixels.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfBarcodeGenerator(value:'123456',
  ///        textSpacing: 10));
  ///}
  /// ```dart
  final double textSpacing;

  /// How the text should be aligned horizontally in barcode.
  ///
  /// The barcode [textAlign] property accepts only three enum values as
  /// [TextAlign.center], [TextAlign.left] and [TextAlign.right].
  ///
  /// * [TextAlign.center] - Align the text in the center of the barcode.
  /// * [TextAlign.left]   - Align the text on the left edge of the barcode.
  /// * [TextAlign.right]  - Align the text on the right edge of the barcode.
  ///
  /// Defaults to [TextAlign.center].
  ///
  /// Also refer [TextAlign].
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfBarcodeGenerator(value:'123456',
  ///        textAlign: TextAlign.right));
  ///}
  /// ```dart
  final TextAlign textAlign;

  /// The style to use for the human readable text in barcode.
  ///
  /// Using [TextStyle] to add the style to the human readable text.
  ///
  /// Defaults to the style that use for [TextStyle].
  ///
  /// Also refer [TextStyle]
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfBarcodeGenerator(value:'123456',
  ///        textStyle: TextStyle(fontSize: 16));
  ///}
  /// ```dart
  final TextStyle textStyle;

  @override
  State<StatefulWidget> createState() {
    return _SfBarcodeGeneratorState();
  }
}

/// Represents the barcode generator state
class _SfBarcodeGeneratorState extends State<SfBarcodeGenerator> {
  /// Specifies the theme data
  SfBarcodeThemeData _barcodeTheme;

  /// Specifies the text size
  Size _textSize;

  @override
  void didChangeDependencies() {
    _barcodeTheme = SfBarcodeTheme.of(context);
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(SfBarcodeGenerator oldWidget) {
    if (widget.showValue &&
        (oldWidget.value != widget.value ||
            oldWidget.textStyle != widget.textStyle)) {
      _textSize = _measureText(widget.value.toString(), widget.textStyle);
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.showValue && _textSize == null) {
      _textSize = _measureText(widget.value.toString(), widget.textStyle);
    }
    widget.symbology._getIsValidateInput(widget.value);
    widget.symbology._textSize = _textSize;
    return Container(
      color: widget.backgroundColor ?? _barcodeTheme.backgroundColor,
      child: _SfBarcodeGeneratorRenderObjectWidget(
          value: widget.value,
          symbology: widget.symbology,
          foregroundColor: widget.barColor ?? _barcodeTheme.barColor,
          showText: widget.showValue,
          textSpacing: widget.textSpacing,
          textStyle: TextStyle(
              backgroundColor: widget.textStyle.backgroundColor,
              color: widget.textStyle.color ?? _barcodeTheme.textColor,
              fontSize: widget.textStyle.fontSize,
              fontFamily: widget.textStyle.fontFamily,
              fontStyle: widget.textStyle.fontStyle,
              fontWeight: widget.textStyle.fontWeight,
              textBaseline: widget.textStyle.textBaseline),
          textSize: _textSize,
          textAlign: widget.textAlign),
    );
  }
}
