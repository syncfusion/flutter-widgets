/// internal class
class InBuffer {
  /// internal constructor
  InBuffer() {
    _bBuffer = 0;
    _bInBuffer = 0;
    _begin = 0;
    _end = 0;
  }

  //Fields
  List<int>? _buffer;
  late int _begin;
  late int _end;
  late int _bBuffer;
  late int _bInBuffer;

  //Properties
  /// internal property
  int get bytes => (_end - _begin) + (_bInBuffer ~/ 8);

  /// internal property
  int get bits => _bInBuffer;

  //Implementation
  /// internal method
  bool availableBits(int count) {
    if (_bInBuffer < count) {
      if (_needsInput()) {
        return false;
      }
      _bBuffer |= _buffer![_begin++].toUnsigned(32) << _bInBuffer;
      _bInBuffer += 8;
      if (_bInBuffer < count) {
        if (_needsInput()) {
          return false;
        }
        _bBuffer |= _buffer![_begin++].toUnsigned(32) << _bInBuffer;
        _bInBuffer += 8;
      }
    }
    return true;
  }

  /// internal method
  int? load16Bits() {
    if (_bInBuffer < 8) {
      if (_begin < _end) {
        _bBuffer |= _buffer![_begin++].toUnsigned(32) << _bInBuffer;
        _bInBuffer += 8;
      }
      if (_begin < _end) {
        _bBuffer |= _buffer![_begin++].toUnsigned(32) << _bInBuffer;
        _bInBuffer += 8;
      }
    } else if (_bInBuffer < 16) {
      if (_begin < _end) {
        _bBuffer |= _buffer![_begin++].toUnsigned(32) << _bInBuffer;
        _bInBuffer += 8;
      }
    }
    return _bBuffer;
  }

  int _getBitMask(int count) {
    return (1.toUnsigned(32) << count) - 1;
  }

  /// internal method
  int getBits(int count) {
    if (!availableBits(count)) {
      return -1;
    }
    final int result = _bBuffer & _getBitMask(count);
    _bBuffer >>= count;
    _bInBuffer -= count;
    return result;
  }

  /// internal method
  int copyTo(List<int>? output, int offset, int length) {
    int bitBuffer = 0;
    while (_bInBuffer > 0 && length > 0) {
      output![offset++] = _bBuffer.toUnsigned(8);
      _bBuffer >>= 8;
      _bInBuffer -= 8;
      length--;
      bitBuffer++;
    }
    if (length == 0) {
      return bitBuffer;
    }
    final int avail = _end - _begin;
    if (length > avail) {
      length = avail;
    }
    for (int i = 0;
        i < length &&
            i + _begin < _buffer!.length &&
            i + offset < output!.length;
        i++) {
      output[offset + i] = _buffer![_begin + i];
    }
    _begin += length;
    return bitBuffer + length;
  }

  bool _needsInput() {
    return _begin == _end;
  }

  /// internal method
  void setInput(List<int>? buffer, int offset, int length) {
    _buffer = buffer;
    _begin = offset;
    _end = offset + length;
  }

  /// internal method
  void skipBits(int n) {
    _bBuffer >>= n;
    _bInBuffer -= n;
  }

  /// internal method
  void skipByteBoundary() {
    _bBuffer >>= _bInBuffer % 8;
    _bInBuffer = _bInBuffer - (_bInBuffer % 8);
  }
}
