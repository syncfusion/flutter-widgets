import '../../base/symbology_base.dart';
import 'code128_renderer.dart';

/// Represents the code128B renderer class
class Code128BRenderer extends Code128Renderer {
  /// Creates the code128B renderer
  Code128BRenderer({Symbology? symbology}) : super(symbology: symbology);

  @override
  bool getIsValidateInput(String value) {
    for (int i = 0; i < value.length; i++) {
      if (!code128BCharacterSets.contains(value[i])) {
        throw ArgumentError(
            'The provided input cannot be encoded : ${value[i]}');
      }
    }
    return true;
  }
}
