part of pdf;

/// Represents specification of embedded file.
class _PdfEmbeddedFileSpecification extends _PdfFileSpecificationBase {
  //Constructor
  /// Initializes a new instance of the [PdfEmbeddedFileSpecification] class
  _PdfEmbeddedFileSpecification(String fileName, List<int> data) : super() {
    _embeddedFile = _EmbeddedFile(fileName, data);
    description = fileName;
  }

  //Fields
  late _EmbeddedFile _embeddedFile;
  String _description = '';
  final _PdfDictionary _dict = _PdfDictionary();
  // ignore: prefer_final_fields
  PdfAttachmentRelationship _relationship = PdfAttachmentRelationship.source;

  //Properties.
  /// Gets the description.
  String get description => _description;

  /// Sets the description.
  set description(String value) {
    if (_description != value) {
      _description = value;
      _dictionary._setString(_DictionaryProperties.description, _description);
    }
  }

  //Implementations.
  //Initializes instance.
  @override
  void _initialize() {
    super._initialize();
    _dictionary.setProperty(_DictionaryProperties.ef, _dict);
  }

  String _getEnumName(dynamic text) {
    text = text.toString();
    final int index = text.indexOf('.');
    final String name = text.substring(index + 1);
    return name[0].toUpperCase() + name.substring(1);
  }

  //Saves object state.
  @override
  void _save() {
    _dict[_DictionaryProperties.f] = _PdfReferenceHolder(_embeddedFile);
    final _PdfString str =
        _PdfString(_formatFileName(_embeddedFile.fileName, false));
    _dictionary.setProperty(_DictionaryProperties.f, str);
    _dictionary.setProperty(_DictionaryProperties.uf, str);
  }
}
