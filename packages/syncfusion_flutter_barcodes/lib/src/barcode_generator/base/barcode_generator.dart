import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import '../common/barcode_renderer.dart';
import '../one_dimensional/codabar_symbology.dart';
import '../one_dimensional/code128_symbology.dart';
import '../one_dimensional/code128a_symbology.dart';
import '../one_dimensional/code128b_symbology.dart';
import '../one_dimensional/code128c_symbology.dart';

import '../one_dimensional/code39_extended_symbology.dart';
import '../one_dimensional/code39_symbology.dart';
import '../one_dimensional/code93_symbology.dart';

import '../one_dimensional/ean13_symbology.dart';
import '../one_dimensional/ean8_symbology.dart';
import '../one_dimensional/upca_symbology.dart';
import '../one_dimensional/upce_symbology.dart';

import '../renderers/one_dimensional/codabar_renderer.dart';
import '../renderers/one_dimensional/code128_renderer.dart';
import '../renderers/one_dimensional/code128a_renderer.dart';
import '../renderers/one_dimensional/code128b_renderer.dart';
import '../renderers/one_dimensional/code128c_renderer.dart';
import '../renderers/one_dimensional/code39_extended_renderer.dart';
import '../renderers/one_dimensional/code39_renderer.dart';
import '../renderers/one_dimensional/code93_renderer.dart';
import '../renderers/one_dimensional/ean13_renderer.dart';
import '../renderers/one_dimensional/ean8_renderer.dart';
import '../renderers/one_dimensional/symbology_base_renderer.dart';
import '../renderers/one_dimensional/upca_renderer.dart';
import '../renderers/one_dimensional/upce_renderer.dart';
import '../renderers/two_dimensional/datamatrix_renderer.dart';
import '../renderers/two_dimensional/qr_code_renderer.dart';
import '../theme.dart';
import '../two_dimensional/datamatrix_symbology.dart';
import '../two_dimensional/qr_code_symbology.dart';

import '../utils/helper.dart';
import 'symbology_base.dart';

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
      {Key? key,
      required this.value,
      Symbology? symbology,
      this.barColor,
      this.backgroundColor,
      this.showValue = false,
      this.textSpacing = 2,
      this.textAlign = TextAlign.center,
      this.textStyle})
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
  final String? value;

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
  final Color? barColor;

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
  final Color? backgroundColor;

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
  final TextStyle? textStyle;

  @override
  State<StatefulWidget> createState() {
    return _SfBarcodeGeneratorState();
  }
}

/// Represents the barcode generator state
class _SfBarcodeGeneratorState extends State<SfBarcodeGenerator> {
  /// Specifies the theme data
  late SfBarcodeThemeData _barcodeThemeData;

  /// Specifies the text size
  Size? _textSize;

  late SymbologyRenderer _symbologyRenderer;

  @override
  void didChangeDependencies() {
    _barcodeThemeData =
        _updateThemeData(Theme.of(context), SfBarcodeTheme.of(context));
    super.didChangeDependencies();
  }

  SfBarcodeThemeData _updateThemeData(
      ThemeData themeData, SfBarcodeThemeData barcodeThemeData) {
    final SfBarcodeThemeData effectiveThemeData = BarcodeThemeData(context);
    barcodeThemeData = barcodeThemeData.copyWith(
        backgroundColor: barcodeThemeData.backgroundColor ??
            widget.backgroundColor ??
            effectiveThemeData.backgroundColor,
        barColor: barcodeThemeData.barColor ??
            widget.barColor ??
            effectiveThemeData.barColor,
        textStyle: themeData.textTheme.bodyMedium!
            .copyWith(
                color:
                    barcodeThemeData.textColor ?? effectiveThemeData.textColor)
            .merge(barcodeThemeData.textStyle)
            .merge(widget.textStyle));
    return barcodeThemeData;
  }

  @override
  void didUpdateWidget(SfBarcodeGenerator oldWidget) {
    _barcodeThemeData =
        _updateThemeData(Theme.of(context), SfBarcodeTheme.of(context));

    if (widget.showValue &&
        (oldWidget.value != widget.value ||
            oldWidget.textStyle != widget.textStyle)) {
      _textSize =
          measureText(widget.value.toString(), _barcodeThemeData.textStyle!);
    }

    if (widget.symbology != oldWidget.symbology) {
      _createSymbologyRenderer();
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    _createSymbologyRenderer();
    super.initState();
  }

  void _createSymbologyRenderer() {
    if (widget.symbology is Codabar) {
      _symbologyRenderer = CodabarRenderer(symbology: widget.symbology);
    } else if (widget.symbology is Code39Extended) {
      _symbologyRenderer = Code39ExtendedRenderer(symbology: widget.symbology);
    } else if (widget.symbology is Code39) {
      _symbologyRenderer = Code39Renderer(symbology: widget.symbology);
    } else if (widget.symbology is Code93) {
      _symbologyRenderer = Code93Renderer(symbology: widget.symbology);
    } else if (widget.symbology is Code128) {
      _symbologyRenderer = Code128Renderer(symbology: widget.symbology);
    } else if (widget.symbology is Code128A) {
      _symbologyRenderer = Code128ARenderer(symbology: widget.symbology);
    } else if (widget.symbology is Code128B) {
      _symbologyRenderer = Code128BRenderer(symbology: widget.symbology);
    } else if (widget.symbology is Code128C) {
      _symbologyRenderer = Code128CRenderer(symbology: widget.symbology);
    } else if (widget.symbology is EAN8) {
      _symbologyRenderer = EAN8Renderer(symbology: widget.symbology);
    } else if (widget.symbology is EAN13) {
      _symbologyRenderer = EAN13Renderer(symbology: widget.symbology);
    } else if (widget.symbology is UPCA) {
      _symbologyRenderer = UPCARenderer(symbology: widget.symbology);
    } else if (widget.symbology is UPCE) {
      _symbologyRenderer = UPCERenderer(symbology: widget.symbology);
    } else if (widget.symbology is QRCode) {
      _symbologyRenderer = QRCodeRenderer(symbology: widget.symbology);
    } else if (widget.symbology is DataMatrix) {
      _symbologyRenderer = DataMatrixRenderer(symbology: widget.symbology);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.showValue && _textSize == null) {
      _textSize =
          measureText(widget.value.toString(), _barcodeThemeData.textStyle!);
    }
    _symbologyRenderer.getIsValidateInput(widget.value!);
    _symbologyRenderer.textSize = _textSize;
    return Container(
      color: widget.backgroundColor ?? _barcodeThemeData.backgroundColor,
      child: SfBarcodeGeneratorRenderObjectWidget(
          value: widget.value!,
          symbology: widget.symbology,
          foregroundColor: widget.barColor ?? _barcodeThemeData.barColor,
          showText: widget.showValue,
          textSpacing: widget.textSpacing,
          textStyle: _barcodeThemeData.textStyle!,
          symbologyRenderer: _symbologyRenderer,
          textSize: _textSize,
          textAlign: widget.textAlign),
    );
  }
}
