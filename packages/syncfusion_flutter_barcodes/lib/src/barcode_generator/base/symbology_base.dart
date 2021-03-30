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
  final int? module;
}
