import '../../interfaces/pdf_interface.dart';
import '../io/pdf_constants.dart';
import '../primitives/pdf_dictionary.dart';
import '../primitives/pdf_name.dart';
import 'embedded_file_specification.dart';

/// Represents base class for file specification objects.
abstract class PdfFileSpecificationBase implements IPdfWrapper {
  //Constructor.
  /// Initializes a new instance of the [PdfFileSpecificationBase] class.
  PdfFileSpecificationBase() {
    _helper = PdfFileSpecificationBaseHelper(this);
    _helper.initialize();
  }

  //Fields
  late PdfFileSpecificationBaseHelper _helper;
}

/// [PdfFileSpecificationBase] helper
class PdfFileSpecificationBaseHelper {
  /// internal constructor
  PdfFileSpecificationBaseHelper(this.base);

  /// internal field
  PdfFileSpecificationBase base;

  /// internal field
  PdfDictionary? dictionary;

  /// internal method
  static PdfFileSpecificationBaseHelper getHelper(
      PdfFileSpecificationBase base) {
    return base._helper;
  }

  /// internal property
  IPdfPrimitive? get element => dictionary;
  set element(IPdfPrimitive? value) {
    throw ArgumentError("Primitive element can't be set");
  }

  /// internal method

  void initialize() {
    dictionary = PdfDictionary();
    dictionary!.setProperty(PdfDictionaryProperties.type,
        PdfName(PdfDictionaryProperties.filespec));
    dictionary!.beginSave = _dictionaryBeginSave;
  }

  //Handles the BeginSave event of the m_dictionary control.
  void _dictionaryBeginSave(Object sender, SavePdfPrimitiveArgs? ars) {
    PdfFileSpecificationBaseHelper.save(base);
  }

  /// internal method
  String formatFileName(String fileName, bool flag) {
    const String oldSlash = r'\';
    const String newSlash = '/';
    const String driveDelimiter = ':';
    if (fileName.isEmpty) {
      throw ArgumentError('fileName, String can not be empty');
    }
    String formated = fileName.replaceAll(oldSlash, newSlash);
    formated = formated.replaceAll(driveDelimiter, '');
    if (formated.substring(0, 2) == oldSlash) {
      formated = formated[0] + formated.substring(2, formated.length);
    }
    if (formated.substring(0, 1) != newSlash && flag == false) {
      formated = formated;
    }
    return formated;
  }

  /// internal method
  static void save(PdfFileSpecificationBase base) {
    if (base is PdfEmbeddedFileSpecification) {
      PdfEmbeddedFileSpecificationHelper.getHelper(base).save();
    }
  }
}
