part of pdf;

class _DeflateStream {
  //Constructor
  _DeflateStream(List<int> data, int offset, bool leaveOpen) {
    _offset = offset;
    _data = data;
    _leaveOpen = leaveOpen;
    _inflater = _Inflater();
    _buffer = List<int>.filled(8192, 0);
  }

  //Fields
  late List<int> _data;
  // ignore: unused_field
  bool? _leaveOpen;
  late int _offset;
  List<int>? _buffer;
  late _Inflater _inflater;

  //Implementation
  Map<String, dynamic> _read(List<int>? array, int offset, int count) {
    int? length;
    int cOffset = offset;
    int rCount = count;
    while (true) {
      final Map<String, dynamic> inflateResult =
          _inflater._inflate(array!, cOffset, rCount);
      length = inflateResult['count'];
      array = inflateResult['data'];
      cOffset += length!;
      rCount -= length;
      if (rCount == 0) {
        break;
      }
      if (_inflater._finished) {
        break;
      }
      final Map<String, dynamic> result = _readBytes();
      final int? bytes = result['count'];
      _buffer = result['buffer'];
      if (bytes == 0) {
        break;
      }
      _inflater._setInput(_buffer, 0, bytes!);
    }
    return <String, dynamic>{'count': count - rCount, 'data': array};
  }

  Map<String, dynamic> _readBytes() {
    if (_offset >= _data.length) {
      return <String, dynamic>{'buffer': <int>[], 'count': 0};
    } else {
      int count = 0;
      for (int i = 0; i < _buffer!.length && i + _offset < _data.length; i++) {
        _buffer![i] = _data[_offset + i];
        count++;
      }
      _offset += count;
      return <String, dynamic>{'buffer': _buffer, 'count': count};
    }
  }
}
