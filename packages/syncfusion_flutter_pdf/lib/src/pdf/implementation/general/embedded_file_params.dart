part of pdf;

/// Defines additional parameters for the embedded file.
class _EmbeddedFileParams implements _IPdfWrapper {
  //Constructor.
  _EmbeddedFileParams() : super() {
    _creationDate = DateTime.now();
    _modificationDate = DateTime.now();
  }

  //Fields
  DateTime _cDate = DateTime.now();
  DateTime _mDate = DateTime.now();
  final _PdfDictionary _dictionary = _PdfDictionary();
  int? _fileSize;

  //Properties.
  DateTime get _creationDate => _cDate;
  set _creationDate(DateTime value) {
    _cDate = value;
    _dictionary._setDateTime(_DictionaryProperties.creationDate, value);
  }

  DateTime get _modificationDate => _mDate;
  set _modificationDate(DateTime value) {
    _mDate = value;
    _dictionary._setDateTime(_DictionaryProperties.modificationDate, value);
  }

  // int get _size => _fileSize;
  set _size(int value) {
    if (_fileSize != value) {
      _fileSize = value;
      _dictionary._setNumber(_DictionaryProperties.size, _fileSize);
    }
  }

  //Overrides
  @override
  _IPdfPrimitive get _element => _dictionary;

  @override
  // ignore: unused_element
  set _element(_IPdfPrimitive? value) {
    throw ArgumentError('primitive element can\'t be set');
  }
}
