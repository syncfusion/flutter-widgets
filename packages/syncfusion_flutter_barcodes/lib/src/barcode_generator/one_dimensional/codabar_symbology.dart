import '../base/symbology_base.dart';

/// The [Codabar] is a discrete numeric symbology that can encode 0-9 digits,
/// six symbols, and plus an additional 4 start and stop characters.
class Codabar extends Symbology {
  /// Create a [Codabar] symbology with the default or required properties.
  ///
  /// The arguments [module] must be non-negative and greater than 0.
  ///
  Codabar({int? module}) : super(module: module);
}
