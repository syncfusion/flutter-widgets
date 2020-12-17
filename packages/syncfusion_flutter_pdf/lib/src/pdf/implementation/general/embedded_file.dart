part of pdf;

/// Class which represents embedded file into Pdf document.
class _EmbeddedFile implements _IPdfWrapper {
  //Constructor.
  ///  Initializes a new instance of the [EmbeddedFile] class.
  _EmbeddedFile(String fileName, List<int> data) : super() {
    ArgumentError.checkNotNull(data, 'data');
    ArgumentError.checkNotNull(fileName, 'fileName');
    this.data = data.toList();
    _initialize();
    this.fileName = fileName;
  }

  //Fields.
  /// Gets or sets the data.
  List<int> data;
  final _PdfStream _stream = _PdfStream();
  String _fileName = '';
  final _EmbeddedFileParams _params = _EmbeddedFileParams();
  String _mimeType = '';

  //Properties.
  /// Gets the name of the file.
  String get fileName => _fileName;

  /// Sets the name of the file.
  set fileName(String value) {
    if (_fileName != null) {
      _fileName = _getFileName(value);
    }
  }

  /// Gets the type of the MIME.
  String get mimeType => _mimeType;

  /// Sets the type of the MIME.
  set mimeType(String value) {
    if (_mimeType != value) {
      _mimeType = value;
      value = value
          .replaceAll('#', '#23')
          .replaceAll(' ', '#20')
          .replaceAll('/', '#2F');
      _stream._setName(_PdfName(_DictionaryProperties.subtype), value);
    }
  }

  //Implementations.
  void _initialize() {
    _stream.setProperty(_DictionaryProperties.type,
        _PdfName(_DictionaryProperties.embeddedFile));
    _stream.setProperty(_DictionaryProperties.params, _params);
    _stream._beginSave = _streamBeginSave;
  }

  String _getFileName(String attachmentName) {
    final List<String> fileName = attachmentName.split(RegExp(r'[/\\]'));
    return fileName[fileName.length - 1];
  }

  void _streamBeginSave(Object sender, _SavePdfPrimitiveArgs ars) {
    _stream._clearStream();
    _stream.compress = false;
    if (data != null) {
      _stream._dataStream = data;
      _params._size = data.length;
    }
  }

  @override
  _IPdfPrimitive get _element => _stream;

  @override
  set _element(_IPdfPrimitive value) {
    throw ArgumentError('primitive element can\'t be set');
  }
}
