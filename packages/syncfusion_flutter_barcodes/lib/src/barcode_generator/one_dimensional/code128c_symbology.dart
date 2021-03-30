import '../one_dimensional/code128_symbology.dart';

/// The [Code128C] (or chars set C) barcode includes a set of 100 digit pairs
/// from 00 to 99 inclusive, as well as three special characters.
/// This allows numeric data to be encoded as two data digits per symbol
/// character effectively twice the density of standard data.
class Code128C extends Code128 {
  /// Create a [Code128C] symbology with the default or required properties.
  ///
  /// The arguments [module] must be non-negative and greater than 0.
  ///
  Code128C({int? module}) : super(module: module);
}
