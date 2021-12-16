import '../base/symbology_base.dart';

/// The [Code128] is a highly efficient, high-density linear barcode symbology
/// that allows the encoding of alphanumeric data. It is capable of encoding
/// full ASCII character set and extended character sets.
/// This symbology contains the checksum digit for verification and the barcode
/// can also be verified character-by-character for the parity
/// of each data byte.
class Code128 extends Symbology {
  /// Create a [Code128] symbology with the default or required properties.
  ///
  /// The arguments [module] must be non-negative and greater than 0.
  ///
  /// The Code128 symbology encodes the input symbols supported by [Code128A],
  /// [Code128B], [Code128C]. The default symbology type of barcode
  /// generator is [Code128].
  ///
  /// This is a very large method. This method could be
  /// refactor to a smaller methods, but it degrades the performance.Since it
  /// adds the character corresponding to this symbology is added in to the list
  Code128({int? module})
      : super(
          module: module,
        );
}
