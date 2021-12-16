import '../io/pdf_constants.dart';
import '../pdf_document/enums.dart';
import '../primitives/pdf_dictionary.dart';
import '../primitives/pdf_reference_holder.dart';
import '../primitives/pdf_string.dart';
import 'embedded_file.dart';
import 'file_specification_base.dart';

/// Represents specification of embedded file.
class PdfEmbeddedFileSpecification extends PdfFileSpecificationBase {
  //Constructor
  /// Initializes a new instance of the [PdfEmbeddedFileSpecification] class
  PdfEmbeddedFileSpecification(String fileName, List<int> data) : super() {
    _helper = PdfEmbeddedFileSpecificationHelper(this);
    PdfFileSpecificationBaseHelper.getHelper(this)
        .dictionary!
        .setProperty(PdfDictionaryProperties.ef, _helper._dict);
    _helper.embeddedFile = EmbeddedFile(fileName, data);
    _helper.description = fileName;
  }

  //Fields
  late PdfEmbeddedFileSpecificationHelper _helper;
}

/// [PdfEmbeddedFileSpecification] helper
class PdfEmbeddedFileSpecificationHelper {
  /// internal constructor
  PdfEmbeddedFileSpecificationHelper(this.base);

  /// internal field
  PdfEmbeddedFileSpecification base;

  /// internal method
  static PdfEmbeddedFileSpecificationHelper getHelper(
      PdfEmbeddedFileSpecification base) {
    return base._helper;
  }

  /// internal field
  late EmbeddedFile embeddedFile;

  /// internal field
  // ignore: prefer_final_fields
  PdfAttachmentRelationship relationship = PdfAttachmentRelationship.source;
  String _desc = '';
  final PdfDictionary _dict = PdfDictionary();

  /// Gets the description.
  String get description => _desc;

  /// Sets the description.
  set description(String value) {
    if (_desc != value) {
      _desc = value;
      PdfFileSpecificationBaseHelper.getHelper(base)
          .dictionary!
          .setString(PdfDictionaryProperties.description, _desc);
    }
  }

  /// internal method
  String getEnumName(dynamic text) {
    final int index = text.toString().indexOf('.');
    final String name = text.toString().substring(index + 1);
    return name[0].toUpperCase() + name.substring(1);
  }

  /// internal method
  void save() {
    _dict[PdfDictionaryProperties.f] = PdfReferenceHolder(embeddedFile);
    final PdfString str = PdfString(
        PdfFileSpecificationBaseHelper.getHelper(base)
            .formatFileName(embeddedFile.fileName, false));
    PdfFileSpecificationBaseHelper.getHelper(base)
        .dictionary!
        .setProperty(PdfDictionaryProperties.f, str);
    PdfFileSpecificationBaseHelper.getHelper(base)
        .dictionary!
        .setProperty(PdfDictionaryProperties.uf, str);
  }
}
