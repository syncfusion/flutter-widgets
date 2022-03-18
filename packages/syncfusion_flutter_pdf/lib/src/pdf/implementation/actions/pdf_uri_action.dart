import '../io/pdf_constants.dart';
import '../primitives/pdf_name.dart';
import 'pdf_action.dart';

/// Represents an action which resolves unique resource identifier.
class PdfUriAction extends PdfAction {
  // constructor
  /// Initializes a new instance of the [PdfUriAction] class.
  ///
  /// [uri] - the unique resource identifier.
  PdfUriAction([String? uri]) : super() {
    if (uri != null) {
      this.uri = uri;
    }
    PdfActionHelper.getHelper(this).dictionary.setProperty(
        PdfName(PdfDictionaryProperties.s),
        PdfName(PdfDictionaryProperties.uri));
  }

  // fields
  String _uri = '';

  // proporties
  /// Gets the unique resource identifier.
  String get uri => _uri;

  /// Sets the unique resource identifier.
  set uri(String value) {
    _uri = value;
    PdfActionHelper.getHelper(this)
        .dictionary
        .setString(PdfDictionaryProperties.uri, _uri);
  }
}
