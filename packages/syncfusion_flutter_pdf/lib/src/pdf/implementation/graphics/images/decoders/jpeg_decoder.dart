part of pdf;

class _JpegDecoder extends _ImageDecoder {
  //Constructors
  _JpegDecoder(List<int> imageData) {
    _isContainsLittleEndian = false;
    this.imageData = List<int>.from(imageData);
    format = _ImageType.jpeg;
    readHeader();
  }

  //Constants
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
  _PdfStream? _imageStream;
  late bool _isContainsLittleEndian;
  int? _noOfComponents = -1;

  //Implementation
  @override
  void readHeader() {
    _reset();
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
    _reset();
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
      _reset();
      _seek(2);
      _readExceededJpegImage();
    }
  }

  @override
  _PdfStream? getImageDictionary() {
    _imageStream = _PdfStream();
    _imageStream!._dataStream = imageData;
    _imageStream!.compress = false;

    _imageStream![_DictionaryProperties.type] =
        _PdfName(_DictionaryProperties.xObject);
    _imageStream![_DictionaryProperties.subtype] =
        _PdfName(_DictionaryProperties.image);
    _imageStream![_DictionaryProperties.width] = _PdfNumber(width);
    _imageStream![_DictionaryProperties.height] = _PdfNumber(height);
    _imageStream![_DictionaryProperties.bitsPerComponent] =
        _PdfNumber(bitsPerComponent!);
    _imageStream![_DictionaryProperties.filter] =
        _PdfName(_DictionaryProperties.dctDecode);
    _imageStream![_DictionaryProperties.colorSpace] =
        _PdfName(_getColorSpace());
    _imageStream![_DictionaryProperties.decodeParms] = _getDecodeParams();

    return _imageStream;
  }

  _PdfDictionary _getDecodeParams() {
    final _PdfDictionary decodeParams = _PdfDictionary();
    decodeParams[_DictionaryProperties.columns] = _PdfNumber(width);
    decodeParams[_DictionaryProperties.blackIs1] = _PdfBoolean(true);
    decodeParams[_DictionaryProperties.k] = _PdfNumber(-1);
    decodeParams[_DictionaryProperties.predictor] = _PdfNumber(15);
    decodeParams[_DictionaryProperties.bitsPerComponent] =
        _PdfNumber(bitsPerComponent!);
    return decodeParams;
  }

  Map<String, dynamic> _checkForExifData() {
    int? imageOrientation = 0;
    _reset();
    if (_convertToUShort(_readJpegBytes(2)) != 0xFFD8) {
      return <String, dynamic>{
        'hasOrientation': false,
        'imageOrientation': imageOrientation
      };
    }
    int? jpegMarkerStart;
    int? jpegMarkerNum = 0;
    while ((jpegMarkerStart = _readByte()) == 0xFF &&
        (jpegMarkerNum = _readByte()) != 0xE1) {
      final int jpegDataLength = _convertToUShort(_readJpegBytes(2));
      final int jpegOffset = jpegDataLength - 2;
      final int jpegPosition = offset + jpegOffset;
      _seek(jpegOffset);
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
      _seek(2);
      if (utf8.decode(_readJpegBytes(4)) != 'Exif' ||
          _convertToUShort(_readJpegBytes(2)) != 0) {
        return <String, dynamic>{
          'hasOrientation': false,
          'imageOrientation': imageOrientation
        };
      }
      final int tiffTypeHeaderStart = offset.toInt();
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
        _seek(10);
      }
      if (orientationPosition >= 0) {
        offset = orientationPosition;
        if (_convertToUShort(_readJpegBytes(2)) != 274) {
          return <String, dynamic>{
            'hasOrientation': false,
            'imageOrientation': imageOrientation
          };
        }
        _seek(6);
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
          _seek(3);
          height = imageData[offset] << 8 | imageData[offset + 1];
          _seek(2);
          width = imageData[offset] << 8 | imageData[offset + 1];
          _noOfComponents = imageData[offset];
          _seek(1);
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
    return _readUInt16(data, 0);
  }

  int _convertToUInt(List<int> data) {
    if (_isContainsLittleEndian) {
      data = List<int>.from(data.reversed);
    }
    return _readUInt32(data, 0);
  }

  List<int> _readJpegBytes(int byteCount) {
    final List<int> value = _readBytes(byteCount);
    if (value.length != byteCount) {
      throw RangeError('Invalid count');
    }
    return value;
  }

  int _getMarker() {
    int skippedByte = 0;
    int? marker = _readByte();
    while (marker != 255) {
      skippedByte++;
      marker = _readByte();
    }
    do {
      marker = _readByte();
    } while (marker == 255);
    if (skippedByte != 0) {
      throw UnsupportedError('Error decoding JPEG image');
    }
    return marker.toUnsigned(16);
  }

  void _skipStream() {
    final int length = imageData[offset] << 8 | imageData[offset + 1];
    _seek(2);
    if (length < 2) {
      throw UnsupportedError('Error decoding JPEG image');
    } else if (length > 0) {
      _seek(length - 2);
    }
  }

  String _getColorSpace() {
    const String colorSpace = _DictionaryProperties.deviceRGB;
    if (_noOfComponents == 1 || _noOfComponents == 3 || _noOfComponents == 4) {
      switch (_noOfComponents) {
        case 1:
          return _DictionaryProperties.deviceGray;
        case 3:
          return _DictionaryProperties.deviceRGB;
        case 4:
          return _DictionaryProperties.deviceCMYK;
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
                    result = _DictionaryProperties.deviceGray;
                  }
                  return result;
                case 3:
                  return colorSpace;
                case 4:
                  return _DictionaryProperties.deviceCMYK;
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
