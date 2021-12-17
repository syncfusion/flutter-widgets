import 'in_flatter.dart';

/// internal class
class DeflateStream {
  /// internal constructor
  DeflateStream(List<int> data, int offset, bool leaveOpen) {
    _offset = offset;
    _data = data;
    _leaveOpen = leaveOpen;
    _inflater = Inflater();
    _buffer = List<int>.filled(8192, 0);
  }

  //Fields
  late List<int> _data;
  // ignore: unused_field
  bool? _leaveOpen;
  late int _offset;
  List<int>? _buffer;
  late Inflater _inflater;

  /// internal method
  Map<String, dynamic> read(List<int>? array, int offset, int count) {
    int? length;
    int cOffset = offset;
    int rCount = count;
    while (true) {
      final Map<String, dynamic> inflateResult =
          _inflater.inflate(array!, cOffset, rCount);
      length = inflateResult['count'] as int?;
      array = inflateResult['data'] as List<int>;
      cOffset += length!;
      rCount -= length;
      if (rCount == 0) {
        break;
      }
      if (_inflater.finished) {
        break;
      }
      final Map<String, dynamic> result = _readBytes();
      final int? bytes = result['count'] as int?;
      _buffer = result['buffer'] as List<int>;
      if (bytes == 0) {
        break;
      }
      _inflater.setInput(_buffer, 0, bytes!);
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
