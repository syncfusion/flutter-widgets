/// internal class
class PdfStreamReader {
  //Constructor
  /// internal constructor
  PdfStreamReader([this.data]) {
    _position = 0;
  }

  //Fields
  /// internal field
  List<int>? data;
  int? _position;

  //Properties
  /// internal property
  int? get length => data!.length;

  /// internal property
  int get position => _position!;
  set position(int value) {
    if (value < 0) {
      throw ArgumentError.value(value, 'position', 'Invalid position');
    }
    _position = value;
  }

  //Implementation
  /// internal method
  int? readByte() {
    if (_position != length) {
      final int result = data![position];
      _position = _position! + 1;
      return result;
    } else {
      return -1;
    }
  }

  /// internal method
  int? read(List<int> buffer, int offset, int length) {
    _position = offset;
    int pos = offset;
    final int end = _position! + length;
    while (_position! < end) {
      final int byte = readByte()!;
      if (byte == -1) {
        break;
      }
      buffer[pos++] = byte;
    }
    return pos - offset;
  }
}
