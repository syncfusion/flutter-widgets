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

/// Specifies the PDF document's conformance-level.
enum PdfConformanceLevel {
  /// Specifies default / no conformance.
  none,

  /// This PDF/A ISO standard (ISO 19005-1:2005) is based on Adobe PDF version 1.4
  /// and This Level B conformance indicates minimal compliance to ensure that the
  /// rendered visual appearance of a conforming file is preservable over the long term.
  a1b,

  /// PDF/A-2 Standard is based on a PDF 1.7 (ISO 32000-1)
  /// which provides support for transparency effects and layers
  /// embedding of OpenType fonts.
  a2b,

  /// PDF/A-3 Standard is based on a PDF 1.7 (ISO 32000-1)
  /// which provides support for embedding the arbitrary file
  /// formats (XML, CSV, CAD, Word Processing documents).
  a3b,
}

/// Specifies the file relationship of attachment.
enum PdfAttachmentRelationship {
  ///The original source material for the associated content
  source,

  ///Represents information used to derive a visual presentation
  data,

  ///Alternative representation of the PDF contents
  alternative,

  ///supplemental representation of the original source or data that may be more easily consumable
  supplement,

  ///Relationship is not known or cannot be described using one of the other values
  unspecified
}

/// Compression level.
enum PdfCompressionLevel {
  /// Pack without compression
  none,

  /// Use high speed compression, reduce of data size is low
  bestSpeed,

  /// Something middle between normal and BestSpeed compressions
  belowNormal,

  /// Use normal compression, middle between speed and size
  normal,

  /// Pack better but require a little more time
  aboveNormal,

  /// Use best compression, slow enough
  best
}
