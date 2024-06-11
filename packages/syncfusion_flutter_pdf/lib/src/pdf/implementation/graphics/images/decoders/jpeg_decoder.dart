import 'dart:convert';

import '../../../io/pdf_constants.dart';
import '../../../primitives/pdf_boolean.dart';
import '../../../primitives/pdf_dictionary.dart';
import '../../../primitives/pdf_name.dart';
import '../../../primitives/pdf_number.dart';
import '../../../primitives/pdf_stream.dart';
import '../enum.dart';
import 'image_decoder.dart';

/// internal class
class JpegDecoder extends ImageDecoder {
  //Constructors
  /// internal constructor
  JpegDecoder(List<int> imageData) {
    _isContainsLittleEndian = false;
    this.imageData = List<int>.from(imageData);
    format = ImageType.jpeg;
    readHeader();
  }

  //Constants
  /// internal field
  final List<int> jpegSegmentPreambleBytes = <int>[
    104,
    116,
    116,
    112,
    58,
    47,
    47,
    110,
    115,
    46,
    97,
    100,
    111,
    98,
    101,
    46,
    99,
    111,
    109,
    47,
    120,
    97,
    112,
    47,
    49,
    46,
    48,
    47,
    0
  ];

  //Fields
  PdfStream? _imageStream;
  late bool _isContainsLittleEndian;
  int? _noOfComponents = -1;

  //Implementation
  @override
  void readHeader() {
    reset();
    bitsPerComponent = 8;
    int? imageOrientation = 0;
    final Map<String, dynamic> returnValue = _checkForExifData();
    final bool hasOrientation = returnValue['hasOrientation'] as bool;
    imageOrientation = returnValue['imageOrientation'] as int?;
    jpegDecoderOrientationAngle = 0;
    if (hasOrientation) {
      switch (imageOrientation) {
        case 3:
          jpegDecoderOrientationAngle = 180;
          break;
        case 6:
          jpegDecoderOrientationAngle = 90;
          break;
        case 8:
          jpegDecoderOrientationAngle = 270;
          break;
        default:
          jpegDecoderOrientationAngle = 0;
          break;
      }
    }
    reset();
    bitsPerComponent = 8;
    int i = 4;
    bool isLengthExceed = false;
    int length = imageData[i] * 256 + imageData[i + 1];
    while (i < imageData.length) {
      i += length;
      if (i < imageData.length) {
        if (imageData[i + 1] == 192) {
          width = imageData[i + 7] * 256 + imageData[i + 8];
          height = imageData[i + 5] * 256 + imageData[i + 6];
          _noOfComponents = imageData[i + 9];
          if (width != 0 && height != 0) {
            return;
          }
        } else {
          i += 2;
          length = imageData[i] * 256 + imageData[i + 1];
        }
      } else {
        isLengthExceed = true;
        break;
      }
    }
    if (isLengthExceed) {
      reset();
      seek(2);
      _readExceededJpegImage();
    }
  }

  @override
  PdfStream? getImageDictionary() {
    _imageStream = PdfStream();
    _imageStream!.data = imageData;
    _imageStream!.compress = false;

    _imageStream![PdfDictionaryProperties.type] =
        PdfName(PdfDictionaryProperties.xObject);
    _imageStream![PdfDictionaryProperties.subtype] =
        PdfName(PdfDictionaryProperties.image);
    _imageStream![PdfDictionaryProperties.width] = PdfNumber(width);
    _imageStream![PdfDictionaryProperties.height] = PdfNumber(height);
    _imageStream![PdfDictionaryProperties.bitsPerComponent] =
        PdfNumber(bitsPerComponent!);
    _imageStream![PdfDictionaryProperties.filter] =
        PdfName(PdfDictionaryProperties.dctDecode);
    _imageStream![PdfDictionaryProperties.colorSpace] =
        PdfName(_getColorSpace());
    _imageStream![PdfDictionaryProperties.decodeParms] = _getDecodeParams();

    return _imageStream;
  }

  PdfDictionary _getDecodeParams() {
    final PdfDictionary decodeParams = PdfDictionary();
    decodeParams[PdfDictionaryProperties.columns] = PdfNumber(width);
    decodeParams[PdfDictionaryProperties.blackIs1] = PdfBoolean(true);
    decodeParams[PdfDictionaryProperties.k] = PdfNumber(-1);
    decodeParams[PdfDictionaryProperties.predictor] = PdfNumber(15);
    decodeParams[PdfDictionaryProperties.bitsPerComponent] =
        PdfNumber(bitsPerComponent!);
    return decodeParams;
  }

  Map<String, dynamic> _checkForExifData() {
    int? imageOrientation = 0;
    reset();
    if (_convertToUShort(_readJpegBytes(2)) != 0xFFD8) {
      return <String, dynamic>{
        'hasOrientation': false,
        'imageOrientation': imageOrientation
      };
    }
    int? jpegMarkerStart;
    int? jpegMarkerNum = 0;
    while ((jpegMarkerStart = readByte()) == 0xFF &&
        (jpegMarkerNum = readByte()) != 0xE1) {
      final int jpegDataLength = _convertToUShort(_readJpegBytes(2));
      final int jpegOffset = jpegDataLength - 2;
      final int jpegPosition = offset + jpegOffset;
      seek(jpegOffset);
      if (offset != jpegPosition || offset > imageData.length) {
        return <String, dynamic>{
          'hasOrientation': false,
          'imageOrientation': imageOrientation
        };
      }
    }
    if (jpegMarkerStart != 0xFF || jpegMarkerNum != 0xE1) {
      return <String, dynamic>{
        'hasOrientation': false,
        'imageOrientation': imageOrientation
      };
    } else {
      seek(2);
      if (utf8.decode(_readJpegBytes(4)) != 'Exif' ||
          _convertToUShort(_readJpegBytes(2)) != 0) {
        return <String, dynamic>{
          'hasOrientation': false,
          'imageOrientation': imageOrientation
        };
      }
      final int tiffTypeHeaderStart = offset;
      final List<int> byteData = _readJpegBytes(2);
      _isContainsLittleEndian = utf8.decode(byteData) == 'II';
      if (_convertToUShort(_readJpegBytes(2)) != 0x002A) {
        return <String, dynamic>{
          'hasOrientation': false,
          'imageOrientation': imageOrientation
        };
      }
      offset = _convertToUInt(_readJpegBytes(4)) + tiffTypeHeaderStart;
      final int ifdEntryCount = _convertToUShort(_readJpegBytes(2));
      int orientationPosition = 0;
      for (int currentIfdEntry = 0;
          currentIfdEntry < ifdEntryCount;
          currentIfdEntry++) {
        if (_convertToUShort(_readJpegBytes(2)) == 274) {
          orientationPosition = offset - 2;
        }
        seek(10);
      }
      if (orientationPosition >= 0) {
        offset = orientationPosition;
        if (_convertToUShort(_readJpegBytes(2)) != 274) {
          return <String, dynamic>{
            'hasOrientation': false,
            'imageOrientation': imageOrientation
          };
        }
        seek(6);
        final List<int> orientationData = _readJpegBytes(4);
        int? orientationAngle = 0;
        for (int i = 0; i < orientationData.length; i++) {
          if (orientationData[i] != 0) {
            orientationAngle = orientationData[i];
            break;
          }
        }
        if (orientationAngle == 0) {
          return <String, dynamic>{
            'hasOrientation': false,
            'imageOrientation': imageOrientation
          };
        } else {
          imageOrientation = orientationAngle;
        }
      }
    }
    return <String, dynamic>{
      'hasOrientation': true,
      'imageOrientation': imageOrientation
    };
  }

  void _readExceededJpegImage() {
    bool isContinueReading = true;
    while (isContinueReading) {
      final int marker = _getMarker();
      switch (marker) {
        case 0x00C0:
        case 0x00C1:
        case 0x00C2:
        case 0x00C3:
        case 0x00C5:
        case 0x00C6:
        case 0x00C7:
        case 0x00C9:
        case 0x00CA:
        case 0x00CB:
        case 0x00CD:
        case 0x00CE:
        case 0x00CF:
          seek(3);
          height = imageData[offset] << 8 | imageData[offset + 1];
          seek(2);
          width = imageData[offset] << 8 | imageData[offset + 1];
          _noOfComponents = imageData[offset];
          seek(1);
          isContinueReading = false;
          break;
        default:
          _skipStream();
          break;
      }
    }
  }

  int _convertToUShort(List<int> data) {
    if (_isContainsLittleEndian) {
      data = List<int>.from(data.reversed);
    }
    return readUInt16(data, 0);
  }

  int _convertToUInt(List<int> data) {
    if (_isContainsLittleEndian) {
      data = List<int>.from(data.reversed);
    }
    return readUInt32(data, 0);
  }

  List<int> _readJpegBytes(int byteCount) {
    final List<int> value = readBytes(byteCount);
    if (value.length != byteCount) {
      throw RangeError('Invalid count');
    }
    return value;
  }

  int _getMarker() {
    int skippedByte = 0;
    int? marker = readByte();
    while (marker != 255) {
      skippedByte++;
      marker = readByte();
    }
    do {
      marker = readByte();
    } while (marker == 255);
    if (skippedByte != 0) {
      throw UnsupportedError('Error decoding JPEG image');
    }
    return marker.toUnsigned(16);
  }

  void _skipStream() {
    final int length = imageData[offset] << 8 | imageData[offset + 1];
    seek(2);
    if (length < 2) {
      throw UnsupportedError('Error decoding JPEG image');
    } else if (length > 0) {
      seek(length - 2);
    }
  }

  String _getColorSpace() {
    const String colorSpace = PdfDictionaryProperties.deviceRGB;
    if (_noOfComponents == 1 || _noOfComponents == 3 || _noOfComponents == 4) {
      switch (_noOfComponents) {
        case 1:
          return PdfDictionaryProperties.deviceGray;
        case 3:
          return PdfDictionaryProperties.deviceRGB;
        case 4:
          return PdfDictionaryProperties.deviceCMYK;
      }
    } else {
      int i = 0;
      const int step = 2;
      final int soi = _convertToUShort(<int>[imageData[i + 1], imageData[i]]);
      if (soi == 0xD8FF) {
        i += step;
        int jfif = _convertToUShort(<int>[imageData[i + 1], imageData[i]]);
        jfif &= 0xF0FF;
        if (jfif == 0xE0FF) {
          while (true) {
            i += step;
            int markerLength =
                _convertToUShort(<int>[imageData[i + 1], imageData[i]])
                    .toSigned(32);
            markerLength = (markerLength >> 8) | (markerLength << 8) & 0xFFFF;
            i += markerLength;
            final int marker =
                _convertToUShort(<int>[imageData[i + 1], imageData[i]]);
            if (marker == 0xDAFF) {
              i += step + 2;
              switch (imageData[i]) {
                case 1:
                  String result;
                  if (bitsPerComponent == 8) {
                    result = colorSpace;
                  } else {
                    result = PdfDictionaryProperties.deviceGray;
                  }
                  return result;
                case 3:
                  return colorSpace;
                case 4:
                  return PdfDictionaryProperties.deviceCMYK;
              }
            } else if (marker == 0xD9FF) {
              break;
            }
          }
        }
      }
    }
    return colorSpace;
  }
}
