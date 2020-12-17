/// Represents the input character symbol.
enum CodeType {
  ///CodeType.uncodable represents the input symbol is not codable.
  uncodable,

  ///CodeType.singleDigit represents the input symbol is single digit.
  singleDigit,

  ///CodeType.doubleDigit represents the input symbol is double digit.
  doubleDigit,

  ///CodeType.fnc1 represents the input symbol is special character.
  fnc1
}

/// Versions that is used to encode the amount of data.
enum QRCodeVersion {
  ///QRCodeVersion.auto specifies the qr code version is auto
  auto,

  ///QRCodeVersion.version01 specifies the qr code version is 1.
  version01,

  ///QRCodeVersion.version02 specifies the qr code version is 2.
  version02,

  ///QRCodeVersion.version03 specifies the qr code version is 3.
  version03,

  ///QRCodeVersion.version04 specifies the qr code version is 4.
  version04,

  ///QRCodeVersion.version05 specifies the qr code version is 5.
  version05,

  ///QRCodeVersion.version06 specifies the qr code version is 6.
  version06,

  ///QRCodeVersion.version07 specifies the qr code version is 7.
  version07,

  ///QRCodeVersion.version08 specifies the qr code version is 8.
  version08,

  ///QRCodeVersion.version09 specifies the qr code version is 9.
  version09,

  ///QRCodeVersion.version10 specifies the qr code version is 10.
  version10,

  ///QRCodeVersion.version11 specifies the qr code version is 12.
  version11,

  ///QRCodeVersion.version12 specifies the qr code version is 12.
  version12,

  ///QRCodeVersion.version13 specifies the qr code version is 13.
  version13,

  ///QRCodeVersion.version14 specifies the qr code version is 14.
  version14,

  ///QRCodeVersion.version15 specifies the qr code version is 15.
  version15,

  ///QRCodeVersion.version16 specifies the qr code version is 16.
  version16,

  ///QRCodeVersion.version17 specifies the qr code version is 17.
  version17,

  ///QRCodeVersion.version18 specifies the qr code version is 18.
  version18,

  ///QRCodeVersion.version19 specifies the qr code version is 19.
  version19,

  ///QRCodeVersion.version20 specifies the qr code version is 20.
  version20,

  ///QRCodeVersion.version21 specifies the qr code version is 21.
  version21,

  ///QRCodeVersion.version22 specifies the qr code version is 22.
  version22,

  ///QRCodeVersion.version23 specifies the qr code version is 23.
  version23,

  ///QRCodeVersion.version24 specifies the qr code version is 24.
  version24,

  ///QRCodeVersion.version25 specifies the qr code version is 25.
  version25,

  ///QRCodeVersion.version26 specifies the qr code version is 26.
  version26,

  ///QRCodeVersion.version27 specifies the qr code version is 27.
  version27,

  ///QRCodeVersion.version28 specifies the qr code version is 28.
  version28,

  ///QRCodeVersion.version29 specifies the qr code version is 29.
  version29,

  ///QRCodeVersion.version30 specifies the qr code version is 30.
  version30,

  ///QRCodeVersion.version31 specifies the qr code version is 31.
  version31,

  ///QRCodeVersion.version32 specifies the qr code version is 32.
  version32,

  ///QRCodeVersion.version33 specifies the qr code version is 33.
  version33,

  ///QRCodeVersion.version34 specifies the qr code version is 34.
  version34,

  ///QRCodeVersion.version35 specifies the qr code version is 35.
  version35,

  ///QRCodeVersion.version36 specifies the qr code version is 36.
  version36,

  ///QRCodeVersion.version37 specifies the qr code version is 37.
  version37,

  ///QRCodeVersion.version38 specifies the qr code version is 38.
  version38,

  ///QRCodeVersion.version39 specifies the qr code version is 39.
  version39,

  ///QRCodeVersion.version40 specifies the qr code version is 40.
  version40
}

/// Encode recovery capacity of the barcode.
enum ErrorCorrectionLevel {
  ///ErrorCorrectionLevel.low is recover approximately 7% of the codewords.
  low,

  ///ErrorCorrectionLevel.medium is recover approximately 15% of the codewords.
  medium,

  ///ErrorCorrectionLevel.quartile is recover approximately 25% of the
  ///codewords.
  quartile,

  ///ErrorCorrectionLevel.high is recover approximately 30% of the codewords.
  high
}

/// Specific set of input mode characters.
enum QRInputMode {
  ///QRInputMode.numeric represents the input data as numeric.
  numeric,

  ///QRInputMode.alphaNumeric represents the input data as alphanumeric.
  alphaNumeric,

  ///QRInputMode.binary represents the input data as binary.
  binary
}

/// Encoding type for the [DataMatrix] code.
enum DataMatrixEncoding {
  /// DataMatrixEncoding.auto represents the auto encoding.
  auto,

  /// DataMatrixEncoding.ascii represents the ascii encoding.
  ascii,

  /// DataMatrixEncoding.asciiNumeric represents the asciiNumeric encoding.
  asciiNumeric,

  /// DataMatrixEncoding.base256 represents the base256 encoding.
  base256
}

/// Sizes that is used to encode the amount of [DataMatrix] data.
enum DataMatrixSize {
  /// DataMatrixSize.auto chooses the matrix size based on the data.
  auto,

  /// DataMatrixSize.size10x10 represents the 10x10 matrix.
  size10x10,

  /// DataMatrixSize.size12x12 represents the 12x12 matrix.
  size12x12,

  /// DataMatrixSize.size14x14 represents the 14x14 matrix.
  size14x14,

  /// DataMatrixSize.size16x16 represents the 16x16 matrix.
  size16x16,

  /// DataMatrixSize.size18x18 represents the 18x18 matrix.
  size18x18,

  /// DataMatrixSize.size20x20 represents the 20x20 matrix.
  size20x20,

  /// DataMatrixSize.size22x22 represents the 22x22 matrix.
  size22x22,

  /// DataMatrixSize.size24x24 represents the 24x24 matrix.
  size24x24,

  /// DataMatrixSize.size26x26 represents the 26x26 matrix.
  size26x26,

  /// DataMatrixSize.size32x32 represents the 32x32 matrix.
  size32x32,

  /// DataMatrixSize.size36x36 represents the 36x36 matrix.
  size36x36,

  /// DataMatrixSize.size40x40 represents the 40x40 matrix.
  size40x40,

  /// DataMatrixSize.size44x44 represents the 44x44 matrix.
  size44x44,

  /// DataMatrixSize.size48x48 represents the 48x48 matrix.
  size48x48,

  /// DataMatrixSize.size52x52 represents the 52x52 matrix.
  size52x52,

  /// DataMatrixSize.size64x64 represents the 64x64 matrix.
  size64x64,

  /// DataMatrixSize.size72x72 represents the 72x72 matrix.
  size72x72,

  /// DataMatrixSize.size80x80 represents the 80x80 matrix.
  size80x80,

  /// DataMatrixSize.size88x88 represents the 88x88 matrix.
  size88x88,

  /// DataMatrixSize.size96x96 represents the 96x96 matrix.
  size96x96,

  /// DataMatrixSize.size104x104 represents the 104x104 matrix.
  size104x104,

  /// DataMatrixSize.size120x120 represents the 120x120 matrix.
  size120x120,

  /// DataMatrixSize.size132x132 represents the 132x132 matrix.
  size132x132,

  /// DataMatrixSize.size144x144 represents the 144x144 matrix.
  size144x144,

  /// DataMatrixSize.size8x18 represents the 8x18 matrix.
  size8x18,

  /// DataMatrixSize.size8x32 represents the 8x32 matrix.
  size8x32,

  /// DataMatrixSize.size12x26 represents the 12x26 matrix.
  size12x26,

  /// DataMatrixSize.size12x36 represents the 12x36 matrix.
  size12x36,

  /// DataMatrixSize.size16x36 represents the 16x36 matrix.
  size16x36,

  /// DataMatrixSize.size16x48 represents the 16x48 matrix.
  size16x48
}
