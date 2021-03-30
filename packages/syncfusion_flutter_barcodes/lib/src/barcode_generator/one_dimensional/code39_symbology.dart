import '../base/symbology_base.dart';

/// The [Code39] is a discrete, variable-length symbology that encodes
/// alphanumeric characters into a series of bars.
/// A special start / stop character is placed at the beginning and ending
/// of each barcode.
///
/// Code 39 is self-checking, a check digit is not usually required for common
/// use. For certain cases, applications requiring an extremely high level of
/// accuracy of the checksum digit can be added.
///
/// Allows character set of digits (0-9), upper case alphabets (A-Z), and
/// symbols like space, minus (-), plus (+), period (.), dollar sign ($),
/// slash (/), and percent (%).
class Code39 extends Symbology {
  /// Create a [Code39] symbology with the default or required properties.
  ///
  /// The arguments [module] must be non-negative and greater than 0.
  ///
  /// Since Code 39 is self-checking, it is not normally necessary to provide
  /// a checksum.
  /// However, in applications requiring an extremely high level of accuracy,
  /// a modulo 43 checksum can be added,
  /// if the [enableCheckSum] is true.
  ///
  Code39({int? module, this.enableCheckSum = true}) : super(module: module);

  /// Whether to add a checksum on the far right side of the barcode.
  ///
  /// The checksum, also known as the check digit, is the number on the far
  /// right side of the barcode.
  /// The purpose of the check digit is to verify that the barcode information
  /// has been provided correctly.
  ///
  /// Defaults to true.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfBarcodeGenerator(value:'123456',
  ///        symbology: Code39(enableCheckSum: false)));
  ///}
  /// ```dart
  final bool enableCheckSum;
}
