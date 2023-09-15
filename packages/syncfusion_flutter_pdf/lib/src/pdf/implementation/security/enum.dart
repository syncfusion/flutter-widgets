/// Specifies the encryption option.
enum PdfEncryptionOptions {
  /// To encrypt all the document contents.
  encryptAllContents,

  /// To encrypt all the document contents except metadata.
  encryptAllContentsExceptMetadata,

  /// To encrypt atttachment files only.
  encryptOnlyAttachments
}

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

/// Specifies the available permissions on certificated document.
enum PdfCertificationFlags {
  /// Restrict any changes to the document.
  forbidChanges,

  /// Only allow form fill-in actions on this document.
  allowFormFill,

  /// Only allow commenting and form fill-in actions on this document.
  allowComments
}

/// Specifies the cryptographic standard.
enum CryptographicStandard {
  /// Cryptographic Message Syntax
  cms,

  /// CMS Advanced Electronic Signatures
  cades
}

/// Specifies the digestion algorithm.
enum DigestAlgorithm {
  /// SHA1 message digest algorithm
  sha1,

  /// SHA256 message digest algorithm
  sha256,

  /// SHA384 message digest algorithm
  sha384,

  /// SHA512 message digest algorithm
  sha512
}
