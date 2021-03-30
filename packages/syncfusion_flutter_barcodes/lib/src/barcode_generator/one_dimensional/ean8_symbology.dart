import '../base/symbology_base.dart';

/// The [EAN8] is equivalent to the [UPCE] for small packaging details.
/// It is shorter than the [EAN13] barcode and longer than [UPCE].
///
/// It encodes 7 digits of numeric data with the check digit at its end.
///
class EAN8 extends Symbology {
  /// Create a [EAN8] symbology with the default or required properties.
  ///
  /// The arguments [module] must be non-negative and greater than 0.
  ///
  /// [EAN8] allows either 7 or 8 digits of numeric data otherwise
  /// there is an exception.
  ///
  /// If the input is 7 digits of the numeric data, the check digit is
  /// calculated automatically.
  ///
  /// If the input is 8 digits of the numeric data, the last digit must be
  /// valid check digit otherwise remove it, since it has been calculated
  /// automatically.
  ///
  EAN8({int? module}) : super(module: module);
}
