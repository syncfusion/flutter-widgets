import '../../base/symbology_base.dart';
import 'code128_renderer.dart';

/// Represents the code128C renderer class
class Code128CRenderer extends Code128Renderer {
  /// Creates the code128C renderer
  Code128CRenderer({Symbology? symbology}) : super(symbology: symbology);

  @override
  bool getIsValidateInput(String value) {
    for (int i = 0; i < value.length; i++) {
      if (!code128CCharacterSets.contains(value[i])) {
        throw ArgumentError(
            'The provided input cannot be encoded : ${value[i]}');
      }
    }
    return true;
  }
}
