import '../../base/symbology_base.dart';
import 'code128_renderer.dart';

/// Represents the code128A renderer class
class Code128ARenderer extends Code128Renderer {
  /// Creates the code128A renderer
  Code128ARenderer({Symbology? symbology}) : super(symbology: symbology);

  @override
  bool getIsValidateInput(String value) {
    for (int i = 0; i < value.length; i++) {
      if (!code128ACharacterSets.contains(value[i])) {
        throw ArgumentError(
            'The provided input cannot be encoded : ${value[i]}');
      }
    }
    return true;
  }
}
