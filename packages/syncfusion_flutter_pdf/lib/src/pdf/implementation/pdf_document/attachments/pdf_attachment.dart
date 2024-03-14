import 'dart:convert';

import '../../general/embedded_file.dart';
import '../../general/embedded_file_specification.dart';
import '../../general/file_specification_base.dart';
import '../../io/pdf_constants.dart';
import '../../primitives/pdf_name.dart';
import '../enums.dart';

/// Represents the attachments of the PDF document.
class PdfAttachment extends PdfEmbeddedFileSpecification {
  //Constructor.
  /// Initializes a new instance of the [PdfAttachment] class with specified
  /// file name and byte data to be attached.
  PdfAttachment(super.fileName, super.data,
      {String? description, String? mimeType}) {
    _embeddedFile =
        PdfEmbeddedFileSpecificationHelper.getHelper(this).embeddedFile;
    _updateValues(description, mimeType);
  }

  /// Initializes a new instance of the [PdfAttachment] class with specified
  /// file name and byte data as base64 String to be attached.
  PdfAttachment.fromBase64String(String fileName, String base64String,
      {String? description, String? mimeType})
      : super(fileName, base64.decode(base64String)) {
    _embeddedFile =
        PdfEmbeddedFileSpecificationHelper.getHelper(this).embeddedFile;
    _updateValues(description, mimeType);
  }

  //Fields
  late EmbeddedFile _embeddedFile;

  //Properties.
  /// Gets the description.
  String get description =>
      PdfEmbeddedFileSpecificationHelper.getHelper(this).description;

  /// Sets the description.
  set description(String value) =>
      PdfEmbeddedFileSpecificationHelper.getHelper(this).description = value;

  /// Gets the file name.
  String get fileName => _embeddedFile.fileName;

  /// Sets the file name.
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
  DateTime get creationDate => _embeddedFile.params.creationDate;

  /// Sets creation date.
  set creationDate(DateTime value) => _embeddedFile.params.creationDate = value;

  /// Gets modification date.
  DateTime get modificationDate => _embeddedFile.params.modificationDate;

  /// Sets modification date.
  set modificationDate(DateTime value) =>
      _embeddedFile.params.modificationDate = value;

  /// Get the file relationship.
  PdfAttachmentRelationship get relationship =>
      PdfEmbeddedFileSpecificationHelper.getHelper(this).relationship;

  /// Set the file relationship.
  set relationship(PdfAttachmentRelationship value) {
    PdfEmbeddedFileSpecificationHelper.getHelper(this).relationship = value;
    PdfFileSpecificationBaseHelper.getHelper(this).dictionary!.setProperty(
        PdfDictionaryProperties.afRelationship,
        PdfName(PdfEmbeddedFileSpecificationHelper.getHelper(this).getEnumName(
            PdfEmbeddedFileSpecificationHelper.getHelper(this).relationship)));
  }

  void _updateValues(String? desc, String? mime) {
    if (mime != null) {
      mimeType = mime;
    }
    if (desc != null) {
      description = desc;
    }
  }
}
