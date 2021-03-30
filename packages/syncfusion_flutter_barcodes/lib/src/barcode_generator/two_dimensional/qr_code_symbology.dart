import '../base/symbology_base.dart';
import '../utils/enum.dart';

/// Quick response code ([QRCode]) is a two-dimensional barcode. It can
/// efficiently store more information in a smaller space than 1D barcodes.
/// Each barcode can store values up to 7089 characters.
/// It is mostly used for URLs, business cards, contact information, etc.
///
/// The [QRCode] consists of a grid of dark and light dots or blocks that form
/// a square.
/// The data encoded in the barcode can be numeric, alphanumeric, or Shift
/// JIS characters.
///
/// * The QR Code uses version from 1 to 40. Version 1 measures 21 modules x 21
/// modules, version 2 measures 25 modules x 25 modules, and so on.
/// The number of modules increases in steps of 4 modules per side up to
/// version 40 that measures 177 modules x 177 modules.
/// * Each version has its own capacity. By default, the barcode control
/// automatically sets the version according to the length of the input text.
/// * The [QRCode] is designed for industrial uses and also commonly used
/// in consumer advertising.
///
/// The amount of data that can be stored in the [QRCode] symbol depends on the
/// [inputMode], [codeVersion] (1, ..., 40, indicating the overall dimensions
/// of the symbol, i.e. 4 × version number + 17 dots on each side), and
/// [errorCorrectionLevel]. The maximum storage capacities occur for
/// [codeVersion] 40 and [ErrorCorrectionLevel.low].
class QRCode extends Symbology {
  /// Create a [QRCode] symbology with the default or required properties.
  ///
  /// The arguments [module] must be non-negative and greater than 0.
  ///
  QRCode(
      {this.codeVersion,
      this.errorCorrectionLevel = ErrorCorrectionLevel.high,
      this.inputMode = QRInputMode.binary,
      int? module})
      : super(module: module);

  /// Define the version that is used to encode the amount of data.
  ///
  /// The [QRCode] uses version from 1 to 40. Version 1 measures
  /// 21 modules x 21 modules, version 2 measures 25 modules x 25 modules,
  /// and so on.
  ///
  /// The number of modules increases in steps of 4 modules per side up to
  /// version 40 that measures 177 modules x 177 modules.
  ///
  /// Defaults to [QRCodeVersion.auto].
  ///
  /// Also refer [QRCodeVersion].
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfBarcodeGenerator(value:'123456',
  ///        symbology: QRCode(codeVersion: 4)));
  ///}
  /// ```dart
  final QRCodeVersion? codeVersion;

  /// Define the encode recovery capacity of the barcode.
  ///
  /// Below error correction capability at each of the four levels:
  ///
  /// * [ErrorCorrectionLevel.low] - approximately 7% of the codewords
  /// can be restored.
  ///
  /// * [ErrorCorrectionLevel.medium] - approximately 15% of the codewords
  /// can be restored.
  ///
  /// * [ErrorCorrectionLevel.quartile] - approximately 25% of the codewords
  /// can be restored.
  ///
  /// * [ErrorCorrectionLevel.high] - approximately 30% of the codewords
  /// can be restored.
  ///
  /// Defaults to [ErrorCorrectionLevel.high].
  ///
  /// Also refer [ErrorCorrectionLevel].
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfBarcodeGenerator(value:'123456',
  ///        symbology: QRCode(
  ///         errorCorrectionLevel: ErrorCorrectionLevel.high)));
  ///}
  /// ```dart
  final ErrorCorrectionLevel errorCorrectionLevel;

  /// Define a specific set of input mode characters.
  ///
  /// Defaults to [QRInputMode.binary].
  ///
  ///  Also refer [QRInputMode].
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfBarcodeGenerator(value:'123456',
  ///        symbology: QRCode(inputMode: m QRInputMode.low));
  ///}
  /// ```dart
  final QRInputMode inputMode;
}
