part of pdf;

/// Specfies the status of the IPdfPrmitive.
/// Status is registered if it has a reference or else none.
enum _ObjectStatus { none, registered }

/// Represents a type of an object.
enum _ObjectType {
  free,
  normal,
// ignore: unused_field
  packed
}

enum _TokenType {
  unknown,
  dictionaryStart,
  dictionaryEnd,
  streamStart,
  streamEnd,
  hexStringStart,
  hexStringEnd,
  string,
  unicodeString,
  number,
  real,
  name,
  arrayStart,
  arrayEnd,
  reference,
  objectStart,
  objectEnd,
  boolean,
  hexDigit,
  eof,
  trailer,
  startXRef,
  xRef,
  nullType,
  objectType,
  hexStringWeird,
  hexStringWeirdEscape,
  whiteSpace
}
