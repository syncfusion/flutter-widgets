part of pdf;

/// Represents base class for file specification objects.
abstract class _PdfFileSpecificationBase implements _IPdfWrapper {
  //Constructor.
  /// Initializes a new instance of the [PdfFileSpecificationBase] class.
  _PdfFileSpecificationBase(String fileName) {
    ArgumentError.checkNotNull(fileName, 'fileName');
    _initialize();
  }

  //Fields
  final _PdfDictionary _dictionary = _PdfDictionary();

  /// Gets or sets the name of the file.
  String fileName;

  //Implementations.
  //Initializes instance.
  void _initialize() {
    _dictionary.setProperty(
        _DictionaryProperties.type, _PdfName(_DictionaryProperties.filespec));
    _dictionary._beginSave = _dictionaryBeginSave;
  }

  //Formats file name to Unix format.
  String _formatFileName(String fileName, bool flag) {
    const String oldSlash = '\\';
    const String newSlash = '/';
    const String driveDelimiter = ':';
    ArgumentError.checkNotNull(fileName, 'fileName');
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

  //Handles the BeginSave event of the m_dictionary control.
  void _dictionaryBeginSave(Object sender, _SavePdfPrimitiveArgs ars) {
    _save();
  }

  //Saves an instance.
  void _save();

  //Overrides
  @override
  _IPdfPrimitive get _element => _dictionary;

  @override
  set _element(_IPdfPrimitive value) {
    throw ArgumentError('primitive element can\'t be set');
  }
}
