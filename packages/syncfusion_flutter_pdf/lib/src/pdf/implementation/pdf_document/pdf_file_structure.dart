import 'enums.dart';

/// This class represents a set of the properties that define
/// the internal structure of PDF file.
class PdfFileStructure {
  //Constructor
  /// Initializes a new instance of the [PdfFileStructure] class.
  ///
  /// ```dart
  /// //Create a PDF document instance.
  /// PdfDocument document = PdfDocument();
  /// //Set the PDF document version.
  /// document.fileStructure.version = PdfVersion.version1_7;
  /// //Create page and draw text.
  /// document.pages.add().graphics.drawString(
  ///     'Hello World!', PdfStandardFont(PdfFontFamily.helvetica, 12),
  ///     brush: PdfBrushes.black, bounds: Rect.fromLTWH(0, 0, 0, 0));
  /// //Save and dispose document.
  /// List<int> bytes = await document.save();
  /// document.dispose();
  /// ```
  PdfFileStructure() {
    _version = PdfVersion.version1_7;
    crossReferenceType = PdfCrossReferenceType.crossReferenceTable;
    incrementalUpdate = true;
    _fileID = false;
  }

  //Fields
  late PdfVersion _version;
  late bool _fileID;

  /// Gets or sets a value indicating whether incremental update.
  late bool incrementalUpdate;

  /// The type of PDF cross-reference.
  ///
  /// ```dart
  /// //Create a PDF document.
  /// PdfDocument document = PdfDocument();
  /// //Set the type of the PDF cross reference.
  /// document.fileStructure.crossReferenceType =
  ///     PdfCrossReferenceType.crossReferenceStream;
  /// //Create page and draw text.
  /// document.pages.add().graphics.drawString(
  ///     'Hello World!', PdfStandardFont(PdfFontFamily.helvetica, 12),
  ///     brush: PdfBrushes.black, bounds: Rect.fromLTWH(0, 0, 0, 0));
  /// //Save and dispose document.
  /// List<int> bytes = await document.save();
  /// document.dispose();
  /// ```
  late PdfCrossReferenceType crossReferenceType;

  //Properties
  /// Gets the version of the PDF document.
  ///
  /// ```dart
  /// //Create a PDF document instance.
  /// PdfDocument document = PdfDocument();
  /// //Set the PDF document version.
  /// document.fileStructure.version = PdfVersion.version1_7;
  /// //Create page and draw text.
  /// document.pages.add().graphics.drawString(
  ///     'Hello World!', PdfStandardFont(PdfFontFamily.helvetica, 12),
  ///     brush: PdfBrushes.black, bounds: Rect.fromLTWH(0, 0, 0, 0));
  /// //Save and dispose document.
  /// List<int> bytes = await document.save();
  /// document.dispose();
  /// ```
  PdfVersion get version => _version;

  /// Sets the version of the PDF document.
  ///
  /// ```dart
  /// //Create a PDF document instance.
  /// PdfDocument document = PdfDocument();
  /// //Set the PDF document version.
  /// document.fileStructure.version = PdfVersion.version1_7;
  /// //Create page and draw text.
  /// document.pages.add().graphics.drawString(
  ///     'Hello World!', PdfStandardFont(PdfFontFamily.helvetica, 12),
  ///     brush: PdfBrushes.black, bounds: Rect.fromLTWH(0, 0, 0, 0));
  /// //Save and dispose document.
  /// List<int> bytes = await document.save();
  /// document.dispose();
  set version(PdfVersion value) {
    _version = value;
    if (value.index <= PdfVersion.version1_3.index) {
      crossReferenceType = PdfCrossReferenceType.crossReferenceTable;
    }
  }
}

// ignore: avoid_classes_with_only_static_members
/// [PdfFileStructure] helper
class PdfFileStructureHelper {
  /// internal method
  static bool fileID(PdfFileStructure fileStructure, [bool? value]) {
    if (value != null) {
      fileStructure._fileID = value;
    }
    return fileStructure._fileID;
  }
}
