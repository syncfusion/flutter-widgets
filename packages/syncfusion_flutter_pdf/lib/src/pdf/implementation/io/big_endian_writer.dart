part of pdf;

class _BigEndianWriter {
  //Constructor
  _BigEndianWriter(int capacity) {
    _bufferLength = capacity;
    _buffer = List<int>(capacity);
    for (int i = 0; i < capacity; i++) {
      _buffer[i] = 0;
    }
  }

  //Fields
  int _bufferLength;
  List<int> _buffer;
  int _internalPosition;

  //Properties
  List<int> get _data {
    if (_buffer.length < _bufferLength) {
      final int length = _bufferLength - _buffer.length;
      for (int i = 0; i < length; i++) {
        _buffer.add(0);
      }
    }
    return _buffer;
  }

  int get _position {
    _internalPosition ??= 0;
    return _internalPosition;
  }

  //Implementation
  void _writeShort(int value) {
    final List<int> bytes = <int>[
      (value & 0x0000ff00) >> 8,
      value & 0x000000ff
    ];
    _flush(bytes);
  }

  void _writeInt(int value) {
    int i1 = (value & 0xff000000) >> 24;
    i1 = i1 < 0 ? 256 + i1 : i1;
    int i2 = (value & 0x00ff0000) >> 16;
    i2 = i2 < 0 ? 256 + i2 : i2;
    int i3 = (value & 0x0000ff00) >> 8;
    i3 = i3 < 0 ? 256 + i3 : i3;
    int i4 = value & 0x000000ff;
    i4 = i4 < 0 ? 256 + i4 : i4;
    final List<int> bytes = <int>[
      (value & 0xff000000) >> 24,
      (value & 0x00ff0000) >> 16,
      (value & 0x0000ff00) >> 8,
      value & 0x000000ff
    ];
    _flush(bytes);
  }

  void _writeUInt(int value) {
    final List<int> buff = <int>[
      (value & 0xff000000) >> 24,
      (value & 0x00ff0000) >> 16,
      (value & 0x0000ff00) >> 8,
      value & 0x000000ff
    ];
    _flush(buff);
  }

  void _writeString(String value) {
    ArgumentError.checkNotNull(value);
    final List<int> bytes = <int>[];
    for (int i = 0; i < value.length; i++) {
      bytes.add(value.codeUnitAt(i));
    }
    _flush(bytes);
  }

  void _writeBytes(List<int> value) {
    _flush(value);
  }

  void _flush(List<int> buff) {
    ArgumentError.checkNotNull(buff);
    int position = _position;
    for (int i = 0; i < buff.length; i++) {
      _buffer[position] = buff[i];
      position++;
    }
    _internalPosition += buff.length;
  }
}
