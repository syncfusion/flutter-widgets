part of pdf;

class _StreamReader {
  //Constructor
  _StreamReader([List<int>? data]) {
    _data = data;
    _position = 0;
  }

  //Fields
  List<int>? _data;
  int? _position;

  //Properties
  int? get length => _data!.length;
  int get position => _position!;
  set position(int value) {
    if (value < 0) {
      throw ArgumentError.value(value, 'position', 'Invalid position');
    }
    _position = value;
  }

  //Implementation
  int? readByte() {
    if (_position != length) {
      final int result = _data![position];
      _position = _position! + 1;
      return result;
    } else {
      return -1;
    }
  }

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
