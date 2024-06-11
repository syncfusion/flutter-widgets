import '../../interfaces/pdf_interface.dart';
import '../io/pdf_constants.dart';
import '../primitives/pdf_dictionary.dart';
import '../primitives/pdf_name.dart';
import '../primitives/pdf_stream.dart';

/// Class which represents embedded file into Pdf document.
class EmbeddedFile implements IPdfWrapper {
  //Constructor.
  ///  Initializes a new instance of the [EmbeddedFile] class.
  EmbeddedFile(String fileName, List<int> data) : super() {
    this.data = data.toList();
    _initialize();
    this.fileName = fileName;
  }

  //Fields.
  /// Gets or sets the data.
  late List<int> data;
  final PdfStream _stream = PdfStream();
  String _fileName = '';
  String _mimeType = '';

  /// internal field
  final EmbeddedFileParams params = EmbeddedFileParams();

  //Properties.
  /// Gets the name of the file.
  String get fileName => _fileName;

  /// Sets the name of the file.
  set fileName(String value) {
    _fileName = _getFileName(value);
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
      _stream.setName(PdfName(PdfDictionaryProperties.subtype), value);
    }
  }

  //Implementations.
  void _initialize() {
    _stream.setProperty(PdfDictionaryProperties.type,
        PdfName(PdfDictionaryProperties.embeddedFile));
    _stream.setProperty(PdfDictionaryProperties.params, params);
    _stream.beginSave = _streamBeginSave;
  }

  String _getFileName(String attachmentName) {
    final List<String> fileName = attachmentName.split(RegExp(r'[/\\]'));
    return fileName[fileName.length - 1];
  }

  void _streamBeginSave(Object sender, SavePdfPrimitiveArgs? ars) {
    _stream.clearStream();
    _stream.compress = false;
    _stream.data = data;
    params.size = data.length;
  }

  //Overrides
  /// internal property
  IPdfPrimitive? get element => _stream;
  set element(IPdfPrimitive? value) {
    throw ArgumentError("Primitive element can't be set");
  }
}

/// Defines additional parameters for the embedded file.
class EmbeddedFileParams implements IPdfWrapper {
  //Constructor.
  /// internal constructor
  EmbeddedFileParams() : super() {
    creationDate = DateTime.now();
    modificationDate = DateTime.now();
  }

  //Fields
  DateTime _cDate = DateTime.now();
  DateTime _mDate = DateTime.now();
  int? _fileSize;

  /// internal field
  PdfDictionary? dictionary = PdfDictionary();

  //Properties.
  /// internal property
  DateTime get creationDate => _cDate;
  set creationDate(DateTime value) {
    _cDate = value;
    dictionary!.setDateTime(PdfDictionaryProperties.creationDate, value);
  }

  /// internal property
  DateTime get modificationDate => _mDate;
  set modificationDate(DateTime value) {
    _mDate = value;
    dictionary!.setDateTime(PdfDictionaryProperties.modificationDate, value);
  }

  // int get _size => _fileSize;
  /// internal property
  // ignore: avoid_setters_without_getters
  set size(int value) {
    if (_fileSize != value) {
      _fileSize = value;
      dictionary!.setNumber(PdfDictionaryProperties.size, _fileSize);
    }
  }

  /// internal property
  IPdfPrimitive? get element => dictionary;
  // ignore: unused_element
  set element(IPdfPrimitive? value) {
    throw ArgumentError("Primitive element can't be set");
  }
}
