/// internal enumerator
enum InflaterState {
  /// internal enumerator
  readingHeader,

  /// internal enumerator
  readingBFinal,

  /// internal enumerator
  readingBType,

  /// internal enumerator
  readingNLCodes,

  /// internal enumerator
  readingNDCodes,

  /// internal enumerator
  readingNCLCodes,

  /// internal enumerator
  readingCLCodes,

  /// internal enumerator
  readingTCBefore,

  /// internal enumerator
  readingTCAfter,

  /// internal enumerator
  decodeTop,

  /// internal enumerator
  iLength,

  /// internal enumerator
  fLength,

  /// internal enumerator
  dCode,

  /// internal enumerator
  unCompressedAligning,

  /// internal enumerator
  unCompressedByte1,

  /// internal enumerator
  unCompressedByte2,

  /// internal enumerator
  unCompressedByte3,

  /// internal enumerator
  unCompressedByte4,

  /// internal enumerator
  decodeUnCompressedBytes,

  /// internal enumerator
  srFooter,

  /// internal enumerator
  rFooter,

  /// internal enumerator
  vFooter,

  /// internal enumerator
  done
}

/// internal enumerator
enum BlockType {
  /// internal enumerator
  unCompressedType,

  /// internal enumerator
  staticType,

  /// internal enumerator
  dynamicType
}
