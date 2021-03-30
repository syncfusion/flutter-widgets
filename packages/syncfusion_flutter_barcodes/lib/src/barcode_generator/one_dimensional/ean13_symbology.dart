import '../base/symbology_base.dart';

/// The [EAN13] is based on the [UPCA] standard. As with [UPCA], it supports
/// only numeric characters.
///
/// It encodes the 12 digits of input data with the check digit at its end.
/// The difference between [UPCA] and
/// [EAN13] is that the number system used in [EAN13] is in two-digit ranges
/// from 00 to 99, whereas the number system used in [UPCA]
/// is in single digits from 0 to 9.
class EAN13 extends Symbology {
  /// Create a [EAN13] symbology with the default or required properties.
  ///
  /// The arguments [module] must be non-negative and greater than 0.
  ///
  /// [EAN13] allows either 12 or 13 digits of numeric data otherwise there
  /// is an exception.
  ///
  /// If the input is 12 digits of the numeric data, the check digit is
  /// calculated automatically.
  ///
  /// If the input is 13 digits of the numeric data, the last digit must be
  /// valid check digit otherwise remove it, since it has been calculated
  /// automatically.
  ///
  EAN13({int? module}) : super(module: module);
}
