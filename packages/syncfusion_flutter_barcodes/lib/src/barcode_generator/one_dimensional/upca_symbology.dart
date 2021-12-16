import '../base/symbology_base.dart';

/// The universal product code ([UPCA]) is a numeric symbology used in
/// worldwide retail applications.
///
/// [UPCA] symbols consist of 11 data digits and one check digit. The first
/// digit is a number system digit that
/// normally represents the type of product being identified.
class UPCA extends Symbology {
  /// Create a [UPCA] symbology with the default or required properties.
  ///
  /// The arguments [module] must be non-negative and greater than 0.
  ///
  /// [UPCA] allows either 11 or 12 digits of numeric data otherwise there is
  /// an exception.
  ///
  /// If the input is 11 digits of the numeric data, the check digit is
  /// calculated automatically.
  ///
  /// If the input is 12 digits of the numeric data, the last digit must
  /// be valid check digit otherwise remove it, since it has been calculated
  /// automatically.
  ///
  UPCA({int? module}) : super(module: module);
}
