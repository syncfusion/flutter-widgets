import '../../../primitives/pdf_stream.dart';
import '../enum.dart';
import 'jpeg_decoder.dart';
import 'png_decoder.dart';

/// internal class
abstract class ImageDecoder {
  //Fields
  /// internal field
  late List<int> imageData;

  /// internal field
  int width = 0;

  /// internal field
  int height = 0;

  /// internal field
  ImageType? format;

  /// internal field
  late int offset;

  /// internal field
  int? bitsPerComponent;

  /// internal field
  double? jpegDecoderOrientationAngle;

  //Static methods
  /// internal method
  static ImageDecoder? getDecoder(List<int> data) {
    ImageDecoder? decoder;
    if (_isPng(data)) {
      decoder = PngDecoder(data, _pngSignature.length);
    } else if (_isJpeg(data)) {
      decoder = JpegDecoder(data);
    }
    return decoder;
  }

  //Implementation
  /// internal method
  int readByte() {
    if (offset < imageData.length) {
      final int value = imageData[offset];
      offset = offset + 1;
      return value;
    } else {
      throw RangeError('invalid offset');
    }
  }

  /// internal method
  void reset() {
    offset = 0;
  }

  /// internal method
  void seek(int increment) {
    offset = offset + increment;
  }

  /// internal method
  List<int> readBytes(int count) {
    final List<int> value = <int>[];
    for (int i = 0; i < count; i++) {
      value.add(readByte());
    }
    return value;
  }

  /// internal method
  int readUInt16(List<int> data, int offset) {
    final int i1 = data[offset];
    final int i2 = data[offset + 1];
    return (i1 << 8) | i2;
  }

  /// internal method
  int readUInt32(List<int> data, int offset) {
    final int i1 = data[offset + 3];
    final int i2 = data[offset + 2];
    final int i3 = data[offset + 1];
    final int i4 = data[offset];
    return i1 | (i2 << 8) | (i3 << 16) | (i4 << 24);
  }

  /// internal method
  String readString(List<int>? imageData, int len) {
    String result = '';
    for (int i = 0; i < len; i++) {
      result += String.fromCharCode(readByte());
    }
    return result;
  }

  /// internal method
  Map<String, dynamic> read(
      List<int> stream, int? streamOffset, List<int>? buffer, int length) {
    int result = 0;
    if (length <= stream.length && stream.length - streamOffset! >= length) {
      for (int i = 0; i < length; i++) {
        buffer![i] = stream[streamOffset!];
        streamOffset++;
        result++;
      }
    }
    return <String, dynamic>{
      'offset': streamOffset,
      'outputBuffer': buffer,
      'length': result
    };
  }

  //Abstract methods
  /// internal method
  void readHeader();

  /// internal method
  PdfStream? getImageDictionary();

  //Utilities
  static const List<int> _jpegSignature = <int>[255, 216];
  static const List<int> _pngSignature = <int>[137, 80, 78, 71, 13, 10, 26, 10];
  static bool _isPng(List<int> imageData) {
    if (imageData.length >= _pngSignature.length) {
      for (int i = 0; i < _pngSignature.length; i++) {
        if (_pngSignature[i] != imageData[i]) {
          return false;
        }
      }
      return true;
    } else {
      return false;
    }
  }

  static bool _isJpeg(List<int> imageData) {
    if (imageData.length >= _jpegSignature.length) {
      for (int i = 0; i < _jpegSignature.length; i++) {
        if (_jpegSignature[i] != imageData[i]) {
          return false;
        }
      }
      return true;
    } else {
      return false;
    }
  }
}
