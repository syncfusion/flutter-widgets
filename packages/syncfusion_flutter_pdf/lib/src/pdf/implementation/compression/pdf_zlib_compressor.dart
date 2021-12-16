import '../pdf_document/enums.dart';
import 'compressed_stream_reader.dart';
import 'deflate/deflate_stream.dart';

/// internal class
class PdfZlibCompressor {
  /// internal constructor
  PdfZlibCompressor() {
    level = PdfCompressionLevel.normal;
  }

  /// internal field
  PdfCompressionLevel? level;

  /// internal field
  int defaultBufferSize = 32;

  /// internal method
  List<int> decompress(List<int> data) {
    List<int> outputStream = <int>[];
    List<int> buffer = List<int>.filled(defaultBufferSize, 0, growable: true);
    final CompressedStreamReader reader = CompressedStreamReader(data);
    int? len = 0;
    try {
      Map<String, dynamic> returnValue = reader.read(buffer, 0, buffer.length);
      len = returnValue['length'] as int?;
      buffer = returnValue['buffer'] as List<int>;
      while (len! > 0) {
        for (int i = 0; i < len; i++) {
          outputStream.add(buffer[i]);
        }
        returnValue = reader.read(buffer, 0, buffer.length);
        len = returnValue['length'] as int?;
        buffer = returnValue['buffer'] as List<int>;
      }
    } on FormatException catch (e1) {
      if (e1.message.contains('Checksum check failed.')) {
        final DeflateStream deflateStream = DeflateStream(data, 2, true);
        buffer = List<int>.filled(4096, 0, growable: true);
        int? numRead = 0;
        outputStream = <int>[];
        do {
          final Map<String, dynamic> result =
              deflateStream.read(buffer, 0, buffer.length);
          numRead = result['count'] as int?;
          buffer = result['data'] as List<int>;
          for (int i = 0; i < numRead!; i++) {
            outputStream.add(buffer[i]);
          }
        } while (numRead > 0);
      }
    } catch (e2) {
      //This catch not throws any exception
    }
    return outputStream;
  }
}

/// internal class
class PdfAscii85Compressor {
  /// internal constructor
  PdfAscii85Compressor() {
    _codeTable = <int>[85 * 85 * 85 * 85, 85 * 85 * 85, 85 * 85, 85, 1];
    _decodedBlock = List<int>.filled(4, 0, growable: true);
    _encodedBlock = List<int>.filled(5, 0, growable: true);
    _tuple = 0;
    _asciiOffset = 33;
  }

  //Fields
  late List<int> _codeTable;
  late List<int> _decodedBlock;
  late List<int> _encodedBlock;
  late int _tuple;
  late int _asciiOffset;

  /// internal method
  List<int> decompress(List<int> data) {
    final List<int> outputData = <int>[];
    int count = 0;
    bool processChar = false;
    for (final int byte in data) {
      final String c = String.fromCharCode(byte);
      switch (c) {
        case 'z':
          if (count != 0) {
            throw ArgumentError.value(c, 'c',
                'The character "z" is invalid inside an ASCII85 block.');
          }
          _decodedBlock = List<int>.filled(4, 0, growable: true);
          for (int i = 0; i < _decodedBlock.length; i++) {
            outputData.add(_decodedBlock[i]);
          }
          processChar = false;
          break;
        case '\n':
        case '\r':
        case '\t':
        case '\f':
        case '\b':
          processChar = false;
          break;
        default:
          if (c == String.fromCharCode(0)) {
            processChar = false;
            break;
          }
          processChar = true;
          break;
      }
      if (processChar) {
        _tuple += (byte - _asciiOffset).toUnsigned(16) * _codeTable[count];
        count++;
        if (count == _encodedBlock.length) {
          _decodeBlock(_decodedBlock.length);
          for (int i = 0; i < _decodedBlock.length; i++) {
            outputData.add(_decodedBlock[i]);
          }
          _tuple = 0;
          count = 0;
        }
      }
    }
    if (count != 0) {
      count--;
      _tuple += _codeTable[count];
      _decodeBlock(count);
      for (int i = 0; i < count; i++) {
        outputData.add(_decodedBlock[i]);
      }
    }
    return outputData;
  }

  void _decodeBlock(int count) {
    for (int i = 0; i < count; i++) {
      _decodedBlock[i] = (_tuple >> 24 - (i * 8)).toUnsigned(8);
    }
  }
}
