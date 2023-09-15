import '../base/symbology_base.dart';

/// The [Code93] was designed to complement and improve [Code39]. It is used to
/// represent the full ASCII character set by using combinations of two
/// characters.
/// [Code93] can encode uppercase letters, numeric digits, and a handful of
/// special characters.
class Code93 extends Symbology {
  /// Create a [Code93] symbology with the default or required properties.
  ///
  /// The arguments [module] must be non-negative and greater than 0.
  ///
  /// [Code93] always includes two check characters that requiring an extremely
  /// high level of accuracy.
  /// The checksum character is the modulo 47 remainder of the sum of the
  /// weighted value of the data characters.
  Code93({int? module}) : super(module: module);
}
