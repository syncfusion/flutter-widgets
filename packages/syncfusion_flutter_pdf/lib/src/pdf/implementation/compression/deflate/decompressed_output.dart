import 'dart:math';

import 'in_buffer.dart';

/// internal class
class DecompressedOutput {
  /// internal constructor
  DecompressedOutput() {
    _dOutput = List<int>.filled(_dOutSize, 0);
    _end = 0;
    _usedBytes = 0;
  }

  //Fields
  static const int _dOutSize = 32768;
  static const int _dOutMask = 32767;
  List<int>? _dOutput;
  int _end = 0;
  int _usedBytes = 0;

  //Properties
  /// internal property
  int get unusedBytes => _dOutSize - _usedBytes;

  /// internal property
  int? get usedBytes => _usedBytes;

  //Implementation
  /// internal method
  void write(int b) {
    _dOutput![_end++] = b;
    _end &= _dOutMask;
    ++_usedBytes;
  }

  /// internal method
  void writeLD(int length, int distance) {
    _usedBytes += length;
    int copyStart = (_end - distance) & _dOutMask;
    final int border = _dOutSize - length;
    if (copyStart <= border && _end < border) {
      if (length <= distance) {
        List.copyRange(
            _dOutput!, _end, _dOutput!, copyStart, copyStart + length);
        _end += length;
      } else {
        while (length-- > 0) {
          _dOutput![_end++] = _dOutput![copyStart++];
        }
      }
    } else {
      while (length-- > 0) {
        _dOutput![_end++] = _dOutput![copyStart++];
        _end &= _dOutMask;
        copyStart &= _dOutMask;
      }
    }
  }

  /// internal method
  int copyFrom(InBuffer input, int length) {
    length = min(min(length, _dOutSize - _usedBytes), input.bytes);
    int copied;
    final int tailLen = _dOutSize - _end;
    if (length > tailLen) {
      copied = input.copyTo(_dOutput, _end, tailLen);
      if (copied == tailLen) {
        copied += input.copyTo(_dOutput, 0, length - tailLen);
      }
    } else {
      copied = input.copyTo(_dOutput, _end, length);
    }
    _end = (_end + copied) & _dOutMask;
    _usedBytes += copied;
    return copied;
  }

  /// internal method
  Map<String, dynamic> copyTo(List<int> output, int offset, int length) {
    int? end;
    if (length > _usedBytes) {
      end = _end;
      length = _usedBytes;
    } else {
      end = (_end - _usedBytes + length) & _dOutMask;
    }
    final int copied = length;
    final int tailLen = length - end;
    int sourceStart = _dOutSize - tailLen;
    if (tailLen > 0) {
      for (int i = 0;
          i < tailLen &&
              i + sourceStart < _dOutput!.length &&
              i + offset < output.length;
          i++) {
        output[offset + i] = _dOutput![sourceStart + i];
      }
      final int sourceStartIndex = _dOutSize - tailLen;
      List.copyRange(output, offset, _dOutput!, sourceStartIndex,
          sourceStartIndex + tailLen);
      offset += tailLen;
      length = end;
    }
    sourceStart = end - length;
    final int sourceStartIndex = end - length;
    List.copyRange(output, offset, _dOutput!, sourceStartIndex, end);
    _usedBytes -= copied;
    return <String, dynamic>{'count': copied, 'data': output};
  }
}
