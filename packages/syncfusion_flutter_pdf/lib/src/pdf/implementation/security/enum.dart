part of pdf;

/// Specifies the type of encryption algorithm.
enum PdfEncryptionAlgorithm {
  /// RC4 encryption algorithm - 40-bit key.
  rc4x40Bit,

  /// RC4 encryption algorithm - 128-bit key.
  rc4x128Bit,

  /// AES encryption algorithm - 128-bit key.
  aesx128Bit,

  /// AES encryption algorithm - 256-bit key.
  aesx256Bit,

  /// AES encryption algorithm - 256-bit key with revision 6.
  aesx256BitRevision6
}

/// Specifies the type of PDF permissions.
enum PdfPermissionsFlags {
  /// Default value.
  none,

  /// Print the document.
  print,

  /// Edit content.
  editContent,

  /// Copy content.
  copyContent,

  /// Add or modify text annotations, fill in interactive form fields.
  editAnnotations,

  /// Fill form fields. (Only for 128 bits key).
  fillFields,

  /// Copy accessibility content.
  accessibilityCopyContent,

  /// Assemble document permission. (Only for 128 bits key).
  assembleDocument,

  /// Full quality print.
  fullQualityPrint
}

/// Specifies the key size of AES.
enum _KeySize {
  /// 128 Bit.
  bits128,

  /// 192 Bit.
  bits192,

  /// 256 Bit.
  bits256
}
