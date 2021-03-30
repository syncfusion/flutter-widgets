import 'code39_symbology.dart';

/// The [Code39Extended] is an extended version of [Code39].
/// Lower characters and special characters are additionally supported.
class Code39Extended extends Code39 {
  /// Create a [Code39Extended] symbology with the default or required
  /// properties.
  ///
  /// The arguments [module] must be non-negative and greater than 0.
  ///
  /// Since [Code39Extended] is self-checking, it is not normally necessary
  /// to provide a checksum.
  /// However, in applications requiring an extremely high level of accuracy,
  /// a modulo 43 checksum can be added,
  /// if the [enableCheckSum] is true.
  ///
  /// This is a very large method. This method could be
  /// refactored to a smaller methods, but it degrades the performance.Since it
  /// adds character corresponding to this symbology is added in to the list
  Code39Extended({int? module, bool? enableCheckSum})
      : super(module: module, enableCheckSum: enableCheckSum ?? true);
}
