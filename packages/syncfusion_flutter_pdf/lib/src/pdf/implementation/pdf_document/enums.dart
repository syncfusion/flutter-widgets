part of pdf;

/// Specifies the available PDF versions to save the PDF document.
enum PdfVersion {
  /// PDF version 1.0.
  version1_0,

  /// PDF version 1.1.
  version1_1,

  /// PDF version 1.2.
  version1_2,

  /// PDF version 1.3. Adobe Acrobat 4.
  version1_3,

  /// PDF version 1.4. Adobe Acrobat 5.
  version1_4,

  /// PDF version 1.5. Adobe Acrobat 6.
  version1_5,

  /// PDF version 1.6. Adobe Acrobat 7.
  version1_6,

  /// PDF version 1.7. Adobe Acrobat 8.
  version1_7,

  /// PDF version 2.0.
  version2_0
}

/// Specifies the type of the PDF cross-reference.
enum PdfCrossReferenceType {
  /// The cross-reference table contains information that permits
  /// random access to indirect objects within the file so that the entire file
  /// need not be read to locate any particular object.
  /// The structure is useful for incremental updates, since it allows
  /// a new cross-reference section to be added to the PDF file,
  /// containing entries only for objects that have been added or deleted.
  /// Cross-reference is represented by cross-reference table.
  /// The cross-reference table is the traditional way of representing
  /// reference type.
  crossReferenceTable,

  /// Cross-reference is represented by cross-reference stream.
  /// Cross-reference streams are stream objects, and contain a dictionary
  /// and a data stream. This leads to more compact representation of the file
  /// data especially along with the compression enabled.
  /// This format is supported by PDF 1.5 version and higher only.
  crossReferenceStream
}
