part of barcodes;

/// The [Code128B] (or chars set B) barcode includes all the standard upper
/// case, alphanumeric keyboard characters and punctuation characters
/// together with lower case alphabetic characters (characters with ASCII
/// values from 32 to 127 inclusive), and seven special characters.
class Code128B extends Code128 {
  /// Create a [Code128B] symbology with the default or required properties.
  ///
  /// The arguments [module] must be non-negative and greater than 0.
  ///
  Code128B({int module}) : super(module: module);

  @override
  bool _getIsValidateInput(String value) {
    for (int i = 0; i < value.length; i++) {
      if (!_code128BCharacterSets.contains(value[i])) {
        throw 'The provided input cannot be encoded : ' + value[i];
      }
    }
    return true;
  }
}
