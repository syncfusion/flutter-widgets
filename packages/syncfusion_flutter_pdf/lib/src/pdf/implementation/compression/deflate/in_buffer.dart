part of pdf;

class _InBuffer {
  //Constructor
  _InBuffer() {
    _bBuffer = 0;
    _bInBuffer = 0;
    _begin = 0;
    _end = 0;
  }

  //Fields
  List<int> _buffer;
  int _begin;
  int _end;
  int _bBuffer;
  int _bInBuffer;

  //Properties
  int get bytes => (_end - _begin) + (_bInBuffer ~/ 8);
  int get bits => _bInBuffer;

  //Implementation
  bool _availableBits(int count) {
    if (_bInBuffer < count) {
      if (_needsInput()) {
        return false;
      }
      _bBuffer |= _buffer[_begin++].toUnsigned(32) << _bInBuffer;
      _bInBuffer += 8;
      if (_bInBuffer < count) {
        if (_needsInput()) {
          return false;
        }
        _bBuffer |= _buffer[_begin++].toUnsigned(32) << _bInBuffer;
        _bInBuffer += 8;
      }
    }
    return true;
  }

  int _load16Bits() {
    if (_bInBuffer < 8) {
      if (_begin < _end) {
        _bBuffer |= _buffer[_begin++].toUnsigned(32) << _bInBuffer;
        _bInBuffer += 8;
      }
      if (_begin < _end) {
        _bBuffer |= _buffer[_begin++].toUnsigned(32) << _bInBuffer;
        _bInBuffer += 8;
      }
    } else if (_bInBuffer < 16) {
      if (_begin < _end) {
        _bBuffer |= _buffer[_begin++].toUnsigned(32) << _bInBuffer;
        _bInBuffer += 8;
      }
    }
    return _bBuffer;
  }

  int _getBitMask(int count) {
    return (1.toUnsigned(32) << count) - 1;
  }

  int _getBits(int count) {
    if (!_availableBits(count)) {
      return -1;
    }
    final int result = (_bBuffer & _getBitMask(count)).toInt();
    _bBuffer >>= count;
    _bInBuffer -= count;
    return result;
  }

  int _copyTo(List<int> output, int offset, int length) {
    int bitBuffer = 0;
    while (_bInBuffer > 0 && length > 0) {
      output[offset++] = _bBuffer.toUnsigned(8);
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
        i < length && i + _begin < _buffer.length && i + offset < output.length;
        i++) {
      output[offset + i] = _buffer[_begin + i];
    }
    _begin += length;
    return bitBuffer + length;
  }

  bool _needsInput() {
    return _begin == _end;
  }

  void _setInput(List<int> buffer, int offset, int length) {
    _buffer = buffer;
    _begin = offset;
    _end = offset + length;
  }

  void _skipBits(int n) {
    _bBuffer >>= n;
    _bInBuffer -= n;
  }

  void _skipByteBoundary() {
    _bBuffer >>= _bInBuffer % 8;
    _bInBuffer = _bInBuffer - (_bInBuffer % 8);
  }
}
