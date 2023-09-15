import '../base/symbology_base.dart';

/// As with [UPCA], the [UPCE] symbology supports only numeric characters.
///
/// It is a zero-suppressed version of [UPCA] symbology where it uses only
/// 6 digits of product code and does not use the middle guard.
///
class UPCE extends Symbology {
  /// Create a [UPCE] symbology with the default or required properties.
  ///
  /// The arguments [module] must be non-negative and greater than 0.
  ///
  /// [UPCE] only accepts 6 digits of numeric data otherwise there is an
  /// exception.
  ///
  /// By default, the number system(0) will add at the front and check digit
  /// at the end along with 6 digits of the input product code.
  ///
  UPCE({int? module}) : super(module: module);
}
