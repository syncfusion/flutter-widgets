import '../../interfaces/pdf_interface.dart';
import '../io/pdf_constants.dart';
import '../primitives/pdf_dictionary.dart';
import '../primitives/pdf_name.dart';
import '../primitives/pdf_reference_holder.dart';

/// Represents base class for all action types.
abstract class PdfAction implements IPdfWrapper {
  //Fields
  final PdfActionHelper _helper = PdfActionHelper();

  // properties
  /// Gets the next action
  /// to be performed after the action represented by this instance.
  PdfAction? get next => _helper.action;

  /// Sets the next action
  /// to be performed after the action represented by this instance.
  set next(PdfAction? value) {
    if (value != null && _helper.action != value) {
      _helper.action = value;
      _helper.dictionary.setArray(PdfDictionaryProperties.next,
          <IPdfPrimitive>[PdfReferenceHolder(_helper.action)]);
    }
  }
}

/// [PdfAction] helper
class PdfActionHelper {
  /// initialize a new instance
  PdfActionHelper() {
    initialize();
  }

  /// internal field
  PdfAction? action;

  /// internal field
  IPdfPrimitive? element;

  /// internal field
  final PdfDictionary dictionary = PdfDictionary();

  /// internal method
  void initialize() {
    dictionary.setProperty(PdfName(PdfDictionaryProperties.type),
        PdfName(PdfDictionaryProperties.action));
    element = dictionary;
  }

  /// Get dictionary
  static PdfActionHelper getHelper(PdfAction action) {
    return action._helper;
  }
}
