part of pdf;

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

enum _InflaterState {
  readingHeader,
  readingBFinal,
  readingBType,
  readingNLCodes,
  readingNDCodes,
  readingNCLCodes,
  readingCLCodes,
  readingTCBefore,
  readingTCAfter,
  decodeTop,
  iLength,
  fLength,
  dCode,
  unCompressedAligning,
  unCompressedByte1,
  unCompressedByte2,
  unCompressedByte3,
  unCompressedByte4,
  decodeUnCompressedBytes,
  srFooter,
  rFooter,
  vFooter,
  done
}

enum _BlockType { unCompressedType, staticType, dynamicType }
