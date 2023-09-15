import '../../../../interfaces/pdf_interface.dart';
import '../../../compression/deflate/deflate_stream.dart';
import '../../../io/pdf_constants.dart';
import '../../../primitives/pdf_array.dart';
import '../../../primitives/pdf_dictionary.dart';
import '../../../primitives/pdf_name.dart';
import '../../../primitives/pdf_number.dart';
import '../../../primitives/pdf_reference_holder.dart';
import '../../../primitives/pdf_stream.dart';
import '../../../primitives/pdf_string.dart';
import '../enum.dart';
import 'image_decoder.dart';

/// internal class
class PngDecoder extends ImageDecoder {
  /// internal constructor
  PngDecoder(List<int> imageData, int offset) {
    this.imageData = List<int>.from(imageData);
    format = ImageType.png;
    _issRGB = false;
    isDecode = false;
    _shades = false;
    _ideateDecode = true;
    _colors = 0;
    _bitsPerPixel = 0;
    _idatLength = 0;
    _inputBands = 0;
    this.offset = offset;
    _initialize();
    jpegDecoderOrientationAngle = 0;
  }

  //Fields
  late int _currentChunkLength;
  late _PngHeader _header;
  late bool _issRGB;
  late bool _shades;
  late bool _ideateDecode;
  late int _colors;
  late int _bitsPerPixel;
  late int _idatLength;
  late int _inputBands;
  List<int>? _maskData;
  late List<int> _alpha;
  List<int>? _iDatStream;
  late List<int> _dataStream;
  int? _dataStreamOffset;
  List<int>? _decodedImageData;

  /// internal field
  PdfArray? colorSpace;

  /// internal field
  late bool isDecode;

  //Implementation
  void _initialize() {
    _PngChunkTypes? header;
    dynamic result = _hasValidChunkType(header);
    while (result['hasValidChunk'] as bool) {
      header = result['type'] as _PngChunkTypes?;
      switch (header) {
        case _PngChunkTypes.iHDR:
          readHeader();
          break;
        case _PngChunkTypes.iDAT:
          _readImageData();
          break;
        case _PngChunkTypes.sRGB:
          _issRGB = true;
          _ignoreChunk();
          break;
        case _PngChunkTypes.pLTE:
          _readPLTE();
          break;
        case _PngChunkTypes.iEND:
          _decodeImageData();
          break;
        case _PngChunkTypes.tRNS:
          _readTRNS();
          break;
        case _PngChunkTypes.tEXt:
        case _PngChunkTypes.iTXt:
        case _PngChunkTypes.zTXt:
        case _PngChunkTypes.hIST:
        case _PngChunkTypes.sBIT:
        case _PngChunkTypes.iCCP:
        case _PngChunkTypes.pHYs:
        case _PngChunkTypes.tIME:
        case _PngChunkTypes.bKGD:
        case _PngChunkTypes.gAMA:
        case _PngChunkTypes.cHRM:
        case _PngChunkTypes.unknown:
          _ignoreChunk();
          break;
        // ignore: no_default_cases
        default:
          break;
      }
      result = _hasValidChunkType(header);
    }
  }

  Map<String, dynamic> _hasValidChunkType(_PngChunkTypes? type) {
    type = _PngChunkTypes.unknown;
    if (offset + 8 <= imageData.length) {
      _currentChunkLength = readUInt32(imageData, offset);
      seek(4);
      final String chunk = readString(imageData, 4);
      final _PngChunkTypes? header = _getChunkType(chunk);
      if (header != null) {
        type = header;
        return <String, dynamic>{'type': type, 'hasValidChunk': true};
      }
      if (imageData.length == offset) {
        return <String, dynamic>{'type': type, 'hasValidChunk': false};
      } else {
        return <String, dynamic>{'type': type, 'hasValidChunk': true};
      }
    } else {
      return <String, dynamic>{'type': type, 'hasValidChunk': false};
    }
  }

  _PngChunkTypes? _getChunkType(String chunk) {
    switch (chunk) {
      case 'IHDR':
        return _PngChunkTypes.iHDR;
      case 'PLTE':
        return _PngChunkTypes.pLTE;
      case 'IDAT':
        return _PngChunkTypes.iDAT;
      case 'IEND':
        return _PngChunkTypes.iEND;
      case 'bKGD':
        return _PngChunkTypes.bKGD;
      case 'cHRM':
        return _PngChunkTypes.cHRM;
      case 'gAMA':
        return _PngChunkTypes.gAMA;
      case 'hIST':
        return _PngChunkTypes.hIST;
      case 'pHYs':
        return _PngChunkTypes.pHYs;
      case 'sBIT':
        return _PngChunkTypes.sBIT;
      case 'tEXt':
        return _PngChunkTypes.tEXt;
      case 'tIME':
        return _PngChunkTypes.tIME;
      case 'tRNS':
        return _PngChunkTypes.tRNS;
      case 'zTXt':
        return _PngChunkTypes.zTXt;
      case 'sRGB':
        return _PngChunkTypes.sRGB;
      case 'iCCP':
        return _PngChunkTypes.iCCP;
      case 'iTXt':
        return _PngChunkTypes.iTXt;
      case 'Unknown':
        return _PngChunkTypes.unknown;
      default:
        return null;
    }
  }

  _PngFilterTypes _getFilterType(int? type) {
    switch (type) {
      case 1:
        return _PngFilterTypes.sub;
      case 2:
        return _PngFilterTypes.up;
      case 3:
        return _PngFilterTypes.average;
      case 4:
        return _PngFilterTypes.paeth;
      default:
        return _PngFilterTypes.none;
    }
  }

  void _initializeBase() {
    width = _header.width;
    height = _header.height;
    bitsPerComponent = _header.bitDepth;
  }

  void _setBitsPerPixel() {
    _bitsPerPixel = _header.bitDepth == 16 ? 2 : 1;
    if (_header.colorType == 0) {
      _idatLength = ((bitsPerComponent! * width + 7) / 8 * height).toInt();
      _inputBands = 1;
    } else if (_header.colorType == 2) {
      _idatLength = width * height * 3;
      _inputBands = 3;
      _bitsPerPixel *= 3;
    } else if (_header.colorType == 3) {
      if (_header.interlace == 1) {
        _idatLength = ((_header.bitDepth * width + 7) / 8 * height).toInt();
      }
      _inputBands = 1;
      _bitsPerPixel = 1;
    } else if (_header.colorType == 4) {
      _idatLength = width * height;
      _inputBands = 2;
      _bitsPerPixel *= 2;
    } else if (_header.colorType == 6) {
      _idatLength = width * 3 * height;
      _inputBands = 4;
      _bitsPerPixel *= 4;
    }
  }

  void _ignoreChunk() {
    if (_currentChunkLength > 0) {
      seek(_currentChunkLength + 4);
    }
  }

  void _readImageData() {
    _iDatStream ??= <int>[];
    if (_currentChunkLength <= imageData.length &&
        imageData.length - offset >= _currentChunkLength) {
      for (int i = 0; i < _currentChunkLength; i++) {
        _iDatStream!.add(imageData[offset]);
        offset = offset + 1;
      }
    }
    seek(4);
  }

  void _decodeImageData() {
    isDecode = (_header.interlace == 1) ||
        (_header.bitDepth == 16) ||
        ((_header.colorType & 4) != 0) ||
        _shades;
    if (isDecode) {
      if ((_header.colorType & 4) != 0 || _shades) {
        final int length = width * height;
        _maskData = <int>[];
        for (int i = 0; i < length; i++) {
          _maskData!.add(0);
        }
      }
      if (_iDatStream != null) {
        _dataStream = _getDeflatedData(_iDatStream!);
        _dataStreamOffset = 0;
      }
      _decodedImageData = List<int>.filled(_idatLength, 0, growable: true);
      _readDecodeData();

      if (_decodedImageData != null && _decodedImageData!.isEmpty && _shades) {
        _ideateDecode = false;
        _decodedImageData = _iDatStream!.toList(growable: true);
      }
    } else {
      _ideateDecode = false;
      _decodedImageData = _iDatStream!.toList(growable: true);
    }
  }

  List<int> _getDeflatedData(List<int> data) {
    final List<int> idatData = data.sublist(2, data.length - 4);
    final DeflateStream deflateStream = DeflateStream(idatData, 0, true);
    List<int> buffer = List<int>.filled(4096, 0);
    int? numRead = 0;
    final List<int> outputData = <int>[];
    do {
      final Map<String, dynamic> result =
          deflateStream.read(buffer, 0, buffer.length);
      numRead = result['count'] as int?;
      buffer = result['data'] as List<int>;
      for (int i = 0; i < numRead!; i++) {
        outputData.add(buffer[i]);
      }
    } while (numRead > 0);
    return outputData;
  }

  void _readDecodeData() {
    if (_header.interlace != 1) {
      _decodeData(0, 0, 1, 1, width, height);
    } else {
      _decodeData(0, 0, 8, 8, (width + 7) ~/ 8, (height + 7) ~/ 8);
      _decodeData(4, 0, 8, 8, (width + 3) ~/ 8, (height + 7) ~/ 8);
      _decodeData(0, 4, 4, 8, (width + 3) ~/ 4, (height + 3) ~/ 8);
      _decodeData(2, 0, 4, 4, (width + 1) ~/ 4, (height + 3) ~/ 4);
      _decodeData(0, 2, 2, 4, (width + 1) ~/ 2, (height + 1) ~/ 4);
      _decodeData(1, 0, 2, 2, width ~/ 2, (height + 1) ~/ 2);
      _decodeData(0, 1, 1, 2, width, height ~/ 2);
    }
  }

  void _decodeData(
      int xOffset, int yOffset, int xStep, int yStep, int? width, int? height) {
    if ((width == 0) || (height == 0)) {
      return;
    } else {
      final int bytesPerRow =
          (_inputBands * width! * _header.bitDepth + 7) ~/ 8;
      List<int> current = List<int>.filled(bytesPerRow, 0);
      List<int> prior = List<int>.filled(bytesPerRow, 0);
      for (int sourceY = 0, destinationY = yOffset;
          sourceY < height!;
          sourceY++, destinationY += yStep) {
        final int filter = _dataStream[_dataStreamOffset!];
        _dataStreamOffset = _dataStreamOffset! + 1;
        _dataStreamOffset =
            _readStream(_dataStream, _dataStreamOffset, current, bytesPerRow);
        switch (_getFilterType(filter)) {
          case _PngFilterTypes.none:
            break;
          case _PngFilterTypes.sub:
            _decompressSub(current, bytesPerRow, _bitsPerPixel);
            break;
          case _PngFilterTypes.up:
            _decompressUp(current, prior, bytesPerRow);
            break;
          case _PngFilterTypes.average:
            _decompressAverage(current, prior, bytesPerRow, _bitsPerPixel);
            break;
          case _PngFilterTypes.paeth:
            _decompressPaeth(current, prior, bytesPerRow, _bitsPerPixel);
            break;
          // ignore: no_default_cases
          default:
            throw Exception('Unknown PNG filter');
        }
        _processPixels(current, xOffset, xStep, destinationY, width);
        final List<int> tmp = prior;
        prior = current;
        current = tmp;
      }
    }
  }

  int? _readStream(
      List<int> stream, int? streamOffset, List<int>? data, int count) {
    final dynamic result = read(stream, streamOffset, data, count);
    data = result['outputBuffer'] as List<int>?;
    streamOffset = result['offset'] as int?;
    final int n = result['length'] as int;
    if (n <= 0) {
      throw Exception('Insufficient data');
    }
    return streamOffset;
  }

  void _processPixels(List<int> data, int x, int step, int y, int? width) {
    int sourceX, destX, size = 0;
    final List<int> pixel = _getPixel(data);
    if (_header.colorType == 0 ||
        _header.colorType == 3 ||
        _header.colorType == 4) {
      size = 1;
    } else if (_header.colorType == 2 || _header.colorType == 6) {
      size = 3;
    }
    if (_decodedImageData != null && _decodedImageData!.isNotEmpty) {
      destX = x;
      final int depth = (_header.bitDepth == 16) ? 8 : _header.bitDepth;
      final int yStep = (size * width! * depth + 7) ~/ 8;
      for (sourceX = 0; sourceX < width; sourceX++) {
        _decodedImageData = _setPixel(_decodedImageData, pixel,
            _inputBands * sourceX, size, destX, y, _header.bitDepth, yStep);
        destX += step;
      }
    }
    final bool shades = (_header.colorType & 4) != 0 || _shades;
    if (shades) {
      if ((_header.colorType & 4) != 0) {
        if (_header.bitDepth == 16) {
          for (int i = 0; i < width!; ++i) {
            final int temp = i * _inputBands + size;
            pixel[temp] = (pixel[temp].toUnsigned(32) >> 8).toSigned(32);
          }
        }
        final int? yStep = width;
        destX = x;
        for (sourceX = 0; sourceX < width!; sourceX++) {
          _maskData = _setPixel(_maskData, pixel, _inputBands * sourceX + size,
              1, destX, y, 8, yStep);
          destX += step;
        }
      } else {
        final int? yStep = width;
        final List<int> dt = List<int>.filled(1, 0, growable: true);
        destX = x;
        for (sourceX = 0; sourceX < width!; sourceX++) {
          final int index = pixel[sourceX];
          if (index < _alpha.length) {
            dt[0] = _alpha[index];
          } else {
            dt[0] = 255;
          }
          _maskData = _setPixel(_maskData, dt, 0, 1, destX, y, 8, yStep);
          destX += step;
        }
      }
    }
  }

  List<int> _getPixel(List<int> data) {
    if (_header.bitDepth == 8) {
      final List<int> pixel = List<int>.filled(data.length, 0, growable: true);
      for (int i = 0; i < pixel.length; ++i) {
        pixel[i] = data[i] & 0xff;
      }
      return pixel;
    } else if (_header.bitDepth == 16) {
      final List<int> pixel =
          List<int>.filled(data.length ~/ 2, 0, growable: true);
      for (int i = 0; i < pixel.length; ++i) {
        pixel[i] = ((data[i * 2] & 0xff) << 8) + (data[i * 2 + 1] & 0xff);
      }
      return pixel;
    } else {
      final List<int> pixel = List<int>.filled(
          data.length * 8 ~/ _header.bitDepth, 0,
          growable: true);
      int index = 0;
      final int p = 8 ~/ _header.bitDepth;
      final int mask = (1 << _header.bitDepth) - 1;
      for (int n = 0; n < data.length; ++n) {
        for (int i = p - 1; i >= 0; --i) {
          final int hb = _header.bitDepth * i;
          final int d = data[n];
          pixel[index++] =
              ((hb < 1) ? d : (d.toUnsigned(32) >> hb).toSigned(32)) & mask;
        }
      }
      return pixel;
    }
  }

  List<int>? _setPixel(List<int>? imageData, List<int> data, int offset,
      int size, int x, int y, int? bitDepth, int? bpr) {
    if (bitDepth == 8) {
      final int position = bpr! * y + size * x;
      for (int i = 0; i < size; ++i) {
        imageData![position + i] = data[i + offset].toUnsigned(8);
      }
    } else if (bitDepth == 16) {
      final int position = bpr! * y + size * x;
      for (int i = 0; i < size; ++i) {
        imageData![position + i] = (data[i + offset] >> 8).toUnsigned(8);
      }
    } else {
      final int position = bpr! * y + x ~/ (8 / bitDepth!);
      final int t = data[offset] <<
          (8 - bitDepth * (x % (8 / bitDepth)) - bitDepth).toInt();
      imageData![position] = imageData[position] | t.toUnsigned(8);
    }
    return imageData;
  }

  void _decompressSub(List<int> data, int count, int bpp) {
    for (int i = bpp; i < count; i++) {
      int val = 0;
      val = data[i] & 0xff;
      val += data[i - bpp] & 0xff;
      data[i] = val.toUnsigned(8);
    }
  }

  void _decompressUp(List<int> data, List<int> pData, int count) {
    for (int i = 0; i < count; i++) {
      data[i] = ((data[i] & 0xff) + (pData[i] & 0xff)).toUnsigned(8);
    }
  }

  void _decompressAverage(List<int> data, List<int> pData, int count, int bpp) {
    int val, pp, pr;
    for (int i = 0; i < bpp; i++) {
      data[i] = ((data[i] & 0xff) + (pData[i] & 0xff) ~/ 2).toUnsigned(8);
    }
    for (int i = bpp; i < count; i++) {
      val = data[i] & 0xff;
      pp = data[i - bpp] & 0xff;
      pr = pData[i] & 0xff;
      data[i] = (val + (pp + pr) ~/ 2).toUnsigned(8);
    }
  }

  int _paethPredictor(int a, int b, int c) {
    final int p = a + b - c;
    final int pa = (p - a).abs();
    final int pb = (p - b).abs();
    final int pc = (p - c).abs();
    if ((pa <= pb) && (pa <= pc)) {
      return a;
    } else if (pb <= pc) {
      return b;
    } else {
      return c;
    }
  }

  void _decompressPaeth(List<int> data, List<int> pData, int count, int bpp) {
    int val, pp, pr, prp;
    for (int i = 0; i < bpp; i++) {
      val = data[i] & 0xff;
      pr = pData[i] & 0xff;
      data[i] = (val + pr).toUnsigned(8);
    }
    for (int i = bpp; i < count; i++) {
      val = data[i] & 0xff;
      pp = data[i - bpp] & 0xff;
      pr = pData[i] & 0xff;
      prp = pData[i - bpp] & 0xff;
      data[i] = (val + _paethPredictor(pp, pr, prp)).toUnsigned(8);
    }
  }

  void _readPLTE() {
    if (_header.colorType == 3) {
      colorSpace = PdfArray();
      colorSpace!.add(PdfName(PdfDictionaryProperties.indexed));
      colorSpace!.add(_getPngColorSpace());
      colorSpace!.add(PdfNumber(_currentChunkLength / 3 - 1));
      colorSpace!.add(PdfString.fromBytes(readBytes(_currentChunkLength)));
      seek(4);
    } else {
      _ignoreChunk();
    }
  }

  void _readTRNS() {
    if (_header.colorType == 3) {
      final List<int> alpha = readBytes(_currentChunkLength);
      seek(4);
      _alpha = List<int>.filled(alpha.length, 0, growable: true);
      for (int i = 0; i < alpha.length; i++) {
        _alpha[i] = alpha[i];
        final int sh = alpha[i] & 0xff;
        if (sh != 0 && sh != 255) {
          _shades = true;
        }
      }
    } else {
      _ignoreChunk();
    }
  }

  IPdfPrimitive _getPngColorSpace() {
    if (!_issRGB) {
      if ((_header.colorType & 2) == 0) {
        return PdfName(PdfDictionaryProperties.deviceGray);
      } else {
        return PdfName(PdfDictionaryProperties.deviceRGB);
      }
    } else {
      final PdfArray colorspace = PdfArray();
      final PdfDictionary calRGB = PdfDictionary();
      PdfArray whitePoint = PdfArray();
      whitePoint.add(PdfNumber(1));
      whitePoint.add(PdfNumber(1));
      whitePoint.add(PdfNumber(1));
      final PdfArray gammaArray = PdfArray();
      gammaArray.add(PdfNumber(2.2));
      gammaArray.add(PdfNumber(2.2));
      gammaArray.add(PdfNumber(2.2));
      calRGB.setProperty(PdfName(PdfDictionaryProperties.gamma), gammaArray);
      if (_issRGB) {
        const double wpX = 0.3127;
        const double wpY = 0.329;
        const double redX = 0.64;
        const double redY = 0.33;
        const double greenX = 0.3;
        const double greenY = 0.6;
        const double bX = 0.15;
        const double bY = 0.06;
        const double t = wpY *
            ((greenX - bX) * redY -
                (redX - bX) * greenY +
                (redX - greenX) * bY);
        const double alphaY = redY *
            ((greenX - bX) * wpY - (wpX - bX) * greenY + (wpX - greenX) * bY) /
            t;
        const double alphaX = alphaY * redX / redY;
        const double alphaZ = alphaY * ((1 - redX) / redY - 1);
        const double blueY = -greenY *
            ((redX - bX) * wpY - (wpX - bX) * redY + (wpX - redX) * bY) /
            t;
        const double blueX = blueY * greenX / greenY;
        const double blueZ = blueY * ((1 - greenX) / greenY - 1);
        const double colorY = bY *
            ((redX - greenX) * wpY -
                (wpX - greenX) * wpY +
                (wpX - redX) * greenY) /
            t;
        const double colorX = colorY * bX / bY;
        const double colorZ = colorY * ((1 - bX) / bY - 1);
        const double whiteX = alphaX + blueX + colorX;
        const double whiteY = 1;
        const double whiteZ = alphaZ + blueZ + colorZ;
        final PdfArray whitePointArray = PdfArray();
        whitePointArray.add(PdfNumber(whiteX));
        whitePointArray.add(PdfNumber(whiteY));
        whitePointArray.add(PdfNumber(whiteZ));
        whitePoint = whitePointArray;
        final PdfArray matrix = PdfArray();
        matrix.add(PdfNumber(alphaX));
        matrix.add(PdfNumber(alphaY));
        matrix.add(PdfNumber(alphaZ));
        matrix.add(PdfNumber(blueX));
        matrix.add(PdfNumber(blueY));
        matrix.add(PdfNumber(blueZ));
        matrix.add(PdfNumber(colorX));
        matrix.add(PdfNumber(colorY));
        matrix.add(PdfNumber(colorZ));
        calRGB.setProperty(PdfName(PdfDictionaryProperties.matrix), matrix);
      }
      calRGB.setProperty(
          PdfName(PdfDictionaryProperties.whitePoint), whitePoint);
      colorspace.add(PdfName(PdfDictionaryProperties.calRGB));
      colorspace.add(calRGB);
      return colorspace;
    }
  }

  void _setMask(PdfStream imageStream) {
    if (_maskData != null && _maskData!.isNotEmpty) {
      final PdfStream stream = PdfStream();
      stream.dataStream = _maskData;
      stream[PdfDictionaryProperties.type] =
          PdfName(PdfDictionaryProperties.xObject);
      stream[PdfDictionaryProperties.subtype] =
          PdfName(PdfDictionaryProperties.image);
      stream[PdfDictionaryProperties.width] = PdfNumber(width);
      stream[PdfDictionaryProperties.height] = PdfNumber(height);
      if (bitsPerComponent == 16) {
        stream[PdfDictionaryProperties.bitsPerComponent] = PdfNumber(8);
      } else {
        stream[PdfDictionaryProperties.bitsPerComponent] =
            PdfNumber(bitsPerComponent!);
      }
      stream[PdfDictionaryProperties.colorSpace] =
          PdfName(PdfDictionaryProperties.deviceGray);
      imageStream.setProperty(
          PdfName(PdfDictionaryProperties.sMask), PdfReferenceHolder(stream));
    }
  }

  PdfDictionary _getDecodeParams() {
    final PdfDictionary decodeParams = PdfDictionary();
    decodeParams[PdfDictionaryProperties.columns] = PdfNumber(width);
    decodeParams[PdfDictionaryProperties.colors] = PdfNumber(_colors);
    decodeParams[PdfDictionaryProperties.predictor] = PdfNumber(15);
    decodeParams[PdfDictionaryProperties.bitsPerComponent] =
        PdfNumber(bitsPerComponent!);
    return decodeParams;
  }

  @override
  void readHeader() {
    _header = _PngHeader();
    _header.width = readUInt32(imageData, offset);
    seek(4);
    _header.height = readUInt32(imageData, offset);
    seek(4);
    _header.bitDepth = readByte();
    _header.colorType = readByte();
    _header.compression = readByte();
    _header.filter = _getFilterType(readByte());
    _header.interlace = readByte();
    _colors = (_header.colorType == 3 || (_header.colorType & 2) == 0) ? 1 : 3;
    _initializeBase();
    _setBitsPerPixel();
    seek(4);
  }

  @override
  PdfStream getImageDictionary() {
    final PdfStream imageStream = PdfStream();
    imageStream.dataStream = _decodedImageData;
    if (isDecode && _ideateDecode) {
      imageStream.compress = true;
    } else {
      imageStream.compress = false;
    }
    imageStream[PdfDictionaryProperties.type] =
        PdfName(PdfDictionaryProperties.xObject);
    imageStream[PdfDictionaryProperties.subtype] =
        PdfName(PdfDictionaryProperties.image);
    imageStream[PdfDictionaryProperties.width] = PdfNumber(width);
    imageStream[PdfDictionaryProperties.height] = PdfNumber(height);
    if (bitsPerComponent == 16) {
      imageStream[PdfDictionaryProperties.bitsPerComponent] = PdfNumber(8);
    } else {
      imageStream[PdfDictionaryProperties.bitsPerComponent] =
          PdfNumber(bitsPerComponent!);
    }
    if (!isDecode || !_ideateDecode) {
      imageStream[PdfDictionaryProperties.filter] =
          PdfName(PdfDictionaryProperties.flateDecode);
    }
    if ((_header.colorType & 2) == 0) {
      imageStream[PdfDictionaryProperties.colorSpace] =
          PdfName(PdfDictionaryProperties.deviceGray);
    } else {
      imageStream[PdfDictionaryProperties.colorSpace] =
          PdfName(PdfDictionaryProperties.deviceRGB);
    }
    if (!isDecode || _shades && !_ideateDecode) {
      imageStream[PdfDictionaryProperties.decodeParms] = _getDecodeParams();
    }
    _setMask(imageStream);
    return imageStream;
  }
}

class _PngHeader {
  _PngHeader() {
    width = 0;
    height = 0;
    colorType = 0;
    compression = 0;
    bitDepth = 0;
    interlace = 0;
    filter = _PngFilterTypes.none;
  }
  late int width;
  late int height;
  late int colorType;
  late int compression;
  late int bitDepth;
  late _PngFilterTypes filter;
  late int interlace;
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
