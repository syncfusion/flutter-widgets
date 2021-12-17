/// Specfies the status of the IPdfPrmitive.
/// Status is registered if it has a reference or else none.
enum PdfObjectStatus {
  /// internal enumerator
  none,

  /// internal enumerator
  registered
}

/// Represents a type of an object.
enum PdfObjectType {
  /// internal enumerator
  free,

  /// internal enumerator
  normal,
// ignore: unused_field
  /// internal enumerator
  packed
}

/// internal enumerator
enum PdfTokenType {
  /// internal enumerator
  unknown,

  /// internal enumerator
  dictionaryStart,

  /// internal enumerator
  dictionaryEnd,

  /// internal enumerator
  streamStart,

  /// internal enumerator
  streamEnd,

  /// internal enumerator
  hexStringStart,

  /// internal enumerator
  hexStringEnd,

  /// internal enumerator
  string,

  /// internal enumerator
  unicodeString,

  /// internal enumerator
  number,

  /// internal enumerator
  real,

  /// internal enumerator
  name,

  /// internal enumerator
  arrayStart,

  /// internal enumerator
  arrayEnd,

  /// internal enumerator
  reference,

  /// internal enumerator
  objectStart,

  /// internal enumerator
  objectEnd,

  /// internal enumerator
  boolean,

  /// internal enumerator
  hexDigit,

  /// internal enumerator
  eof,

  /// internal enumerator
  trailer,

  /// internal enumerator
  startXRef,

  /// internal enumerator
  xRef,

  /// internal enumerator
  nullType,

  /// internal enumerator
  objectType,

  /// internal enumerator
  hexStringWeird,

  /// internal enumerator
  hexStringWeirdEscape,

  /// internal enumerator
  whiteSpace
}
