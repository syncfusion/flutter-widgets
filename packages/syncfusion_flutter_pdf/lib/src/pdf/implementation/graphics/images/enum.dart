part of pdf;

/// Image format
enum _ImageType {
  /// JPEG image format
  jpeg,

  /// PNG image format
  png
}

enum _PngChunkTypes {
  iHDR,
  pLTE,
  iDAT,
  iEND,
  bKGD,
  cHRM,
  gAMA,
  hIST,
  pHYs,
  sBIT,
  tEXt,
  tIME,
  tRNS,
  zTXt,
  sRGB,
  iCCP,
  iTXt,
  unknown
}

enum _PngFilterTypes { none, sub, up, average, paeth }
