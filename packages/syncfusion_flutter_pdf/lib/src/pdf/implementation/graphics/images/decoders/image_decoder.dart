part of pdf;

abstract class _ImageDecoder {
  //Fields
  late List<int> imageData;
  int width = 0;
  int height = 0;
  _ImageType? format;
  late int offset;
  int? bitsPerComponent;
  double? jpegDecoderOrientationAngle;

  //Static methods
  static _ImageDecoder? getDecoder(List<int> data) {
    _ImageDecoder? decoder;
    if (_PdfUtils.isPng(data)) {
      decoder = _PngDecoder(data, _PdfUtils._pngSignature.length);
    } else if (_PdfUtils.isJpeg(data)) {
      decoder = _JpegDecoder(data);
    }
    return decoder;
  }

  //Implementation
  int _readByte() {
    if (offset < imageData.length) {
      final int value = imageData[offset];
      offset = offset + 1;
      return value;
    } else {
      throw RangeError('invalid offset');
    }
  }

  void _reset() {
    offset = 0;
  }

  void _seek(int increment) {
    offset = offset + increment;
  }

  List<int> _readBytes(int count) {
    final List<int> value = <int>[];
    for (int i = 0; i < count; i++) {
      value.add(_readByte());
    }
    return value;
  }

  int _readUInt16(List<int> data, int offset) {
    final int i1 = data[offset];
    final int i2 = data[offset + 1];
    return (i1 << 8) | i2;
  }

  int _readUInt32(List<int> data, int offset) {
    final int i1 = data[offset + 3];
    final int i2 = data[offset + 2];
    final int i3 = data[offset + 1];
    final int i4 = data[offset];
    return i1 | (i2 << 8) | (i3 << 16) | (i4 << 24);
  }

  String _readString(List<int>? imageData, int len) {
    String result = '';
    for (int i = 0; i < len; i++) {
      result += String.fromCharCode(_readByte());
    }
    return result;
  }

  Map<String, dynamic> _read(
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
  void readHeader();
  _PdfStream? getImageDictionary();
}
