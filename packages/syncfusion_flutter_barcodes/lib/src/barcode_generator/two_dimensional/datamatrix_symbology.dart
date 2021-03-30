import '../base/symbology_base.dart';
import '../utils/enum.dart';

/// The [DataMatrix] is two-dimensional barcode. The information to be encoded
/// with text or numeric values.
/// Each barcode can store values up to 2335.
///
/// [DataMatrix] barcode consists of a grid of dark and light dots or blocks
/// forming a square or rectangular symbol.
///
/// [DataMatrix] barcode will be mostly used for courier parcel, food industry,
/// etc.
///
class DataMatrix extends Symbology {
  /// Create a [DataMatrix] symbology with the default or required properties.
  ///
  /// The arguments [module] must be non-negative and greater than 0.
  ///
  DataMatrix(
      {int? module,
      this.dataMatrixSize = DataMatrixSize.auto,
      this.encoding = DataMatrixEncoding.auto})
      : super(module: module);

  /// Define the size that is used to encode the amount of data.
  ///
  /// Defaults to [DataMatrixSize.auto].
  ///
  /// Also refer [DataMatrixSize].
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfBarcodeGenerator(value:'123456',
  ///        symbology: DataMatrix( dataMatrixSize: DataMatrixSize.size52x52,
  ///            )));
  ///}
  /// ```dart
  final DataMatrixSize dataMatrixSize;

  /// Defines the encoding type for the [DataMatrix] code.
  ///
  /// Multiple encoding modes are used to store different kinds of messages
  /// in [DataMatrix] barcode.
  ///
  /// When the encoding type is [DataMatrixEncoding.ascii], the codeword will
  /// be calculated as below,
  ///
  /// Codeword = ASCII value + 1, where ASCII value ranges from 0 to 127.
  ///
  /// When the encoding type is [DataMatrixEncoding.base256], the first
  /// codeword will be calculated with the value 235 and
  /// the second code value is calculated as ASCII value - 127.
  /// The base256 value ranges from 128 to 255.
  ///
  /// When the encoding type is [DataMatrixEncoding.asciiNumeric], then the
  /// codeword will be calculated as below,
  ///
  /// Codeword = numerical value pair + 130, where the numerical value pair
  /// will be like 00, 01, 02,.....99.
  ///
  /// Defaults to [DataMatrixEncoding.auto].
  ///
  /// Also refer [DataMatrixEncoding].
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfBarcodeGenerator(value:'123456',
  ///        symbology: DataMatrix(
  ///        encoding: DataMatrixEncoding.base256,
  //            )));
  ///}
  /// ```dart
  final DataMatrixEncoding encoding;
}
