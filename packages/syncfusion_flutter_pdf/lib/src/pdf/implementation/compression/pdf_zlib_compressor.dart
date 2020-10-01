part of pdf;

class _PdfZlibCompressor {
  //constructor
  _PdfZlibCompressor() {
    level = PdfCompressionLevel.normal;
  }

  //fields
  PdfCompressionLevel level;

  //const
  int defaultBufferSize = 32;

  //Implementation
  List<int> decompress(List<int> data) {
    ArgumentError.checkNotNull(data, 'data');
    List<int> outputStream = <int>[];
    List<int> buffer = List<int>.filled(defaultBufferSize, 0, growable: true);
    final _CompressedStreamReader reader = _CompressedStreamReader(data);
    int len = 0;
    try {
      Map<String, dynamic> returnValue = reader._read(buffer, 0, buffer.length);
      len = returnValue['length'];
      buffer = returnValue['buffer'];
      while (len > 0) {
        for (int i = 0; i < len; i++) {
          outputStream.add(buffer[i]);
        }
        returnValue = reader._read(buffer, 0, buffer.length);
        len = returnValue['length'];
        buffer = returnValue['buffer'];
      }
    } on FormatException catch (e1) {
      if (e1.message.contains('Checksum check failed.')) {
        final _DeflateStream deflateStream = _DeflateStream(data, 2, true);
        buffer = List<int>.filled(4096, 0, growable: true);
        int numRead = 0;
        outputStream = <int>[];
        do {
          final Map<String, dynamic> result =
              deflateStream._read(buffer, 0, buffer.length);
          numRead = result['count'];
          buffer = result['data'];
          for (int i = 0; i < numRead; i++) {
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
