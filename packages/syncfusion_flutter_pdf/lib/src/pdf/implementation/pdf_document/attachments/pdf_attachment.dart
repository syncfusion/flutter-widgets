part of pdf;

/// Represents the attachments of the PDF document.
class PdfAttachment extends _PdfEmbeddedFileSpecification {
  //Constructor.
  /// Initializes a new instance of the [PdfAttachment] class with specified
  /// file name and byte data to be attached.
  PdfAttachment(String fileName, List<int> data,
      {String description, String mimeType})
      : super(fileName, data) {
    _updateValues(description, mimeType);
  }

  /// Initializes a new instance of the [PdfAttachment] class with specified
  /// file name and byte data as base64 String to be attached.
  PdfAttachment.fromBase64String(String fileName, String base64String,
      {String description, String mimeType})
      : super(fileName, base64.decode(base64String)) {
    _updateValues(description, mimeType);
  }

  //Properties.
  /// Gets the description.
  @override
  String get description => super.description;

  /// Sets the description.
  @override
  set description(String value) => super.description = value;

  /// Gets the file name.
  @override
  String get fileName => _embeddedFile.fileName;

  /// Sets the file name.
  @override
  set fileName(String value) => _embeddedFile.fileName = value;

  /// Gets the data.
  List<int> get data => _embeddedFile.data;

  /// Sets the data.
  set data(List<int> value) => _embeddedFile.data = value;

  /// Gets the MIME type of the embedded file.
  String get mimeType => _embeddedFile.mimeType;

  /// Sets the MIME type of the embedded file.
  set mimeType(String value) => _embeddedFile.mimeType = value;

  /// Gets creation date.
  DateTime get creationDate => _embeddedFile._params._creationDate;

  /// Sets creation date.
  set creationDate(DateTime value) =>
      _embeddedFile._params._creationDate = value;

  /// Gets modification date.
  DateTime get modificationDate => _embeddedFile._params._modificationDate;

  /// Sets modification date.
  set modificationDate(DateTime value) =>
      _embeddedFile._params._modificationDate = value;

  /// Get the file relationship.
  PdfAttachmentRelationship get relationship => _relationship;

  /// Set the file relationship.
  set relationship(PdfAttachmentRelationship value) {
    _relationship = value;
    _dictionary.setProperty(_DictionaryProperties.afRelationship,
        _PdfName(_getEnumName(_relationship)));
  }

  void _updateValues(String desc, String mime) {
    if (mime != null) {
      mimeType = mime;
    }
    if (desc != null) {
      description = desc;
    }
  }
}
