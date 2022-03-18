import 'dart:math';

import '../asn1/asn1.dart';
import 'ipadding.dart';

/// internal class
abstract class BufferedBlockPaddingBase implements IBufferedCipher {
  /// internal constructor
  BufferedBlockPaddingBase();
  //Fields
  /// internal field
  static List<int> emptyBuffer = <int>[];

  //Implementation
  @override
  String? get algorithmName => null;
  @override
  void initialize(bool forEncryption, ICipherParameter? parameters);
  @override
  int? get blockSize => null;
  @override
  int? getOutputSize(int inputLen) => null;
  @override
  int? getUpdateOutputSize(int inputLen) => null;
  @override
  void reset() {}
  @override
  List<int>? processByte(int intput) => null;
  @override
  Map<String, dynamic>? copyBytes(int input, List<int> output, int outOff) {
    final List<int>? outBytes = processByte(input);
    if (outBytes == null) {
      return <String, dynamic>{'length': 0, 'output': output};
    }
    if (outOff + outBytes.length > output.length) {
      throw ArgumentError.value(output, 'output', 'output buffer too short');
    }
    int j = 0;
    for (int i = outOff; i < output.length && j < outBytes.length; i++) {
      output[i] = outBytes[j];
      j++;
    }
    return <String, dynamic>{'length': outBytes.length, 'output': output};
  }

  @override
  List<int>? readBytesFromInput(List<int> input) {
    return readBytes(input, 0, input.length);
  }

  @override
  List<int>? readBytes(List<int> input, int inOff, int length);
  @override
  Map<String, dynamic> processByteFromValues(
      List<int> input, List<int> output, int outOff) {
    return processBytes(input, 0, input.length, output, outOff);
  }

  @override
  Map<String, dynamic> processBytes(
      List<int> input, int inOff, int length, List<int>? output, int outOff) {
    final List<int>? outBytes = readBytes(input, inOff, length);
    if (outBytes == null) {
      return <String, dynamic>{'length': 0, 'output': output};
    }
    if (outOff + outBytes.length > output!.length) {
      throw ArgumentError.value(output, 'output', 'output buffer too short');
    }
    int j = 0;
    for (int i = outOff; i < output.length && j < outBytes.length; i++) {
      output[i] = outBytes[j];
      j++;
    }
    return <String, dynamic>{'length': outBytes.length, 'output': output};
  }

  @override
  List<int>? doFinal();
  @override
  List<int>? readFinal(List<int>? input, int inOff, int length);
  @override
  List<int>? doFinalFromInput(List<int>? input) {
    return readFinal(input, 0, input!.length);
  }

  @override
  Map<String, dynamic> writeFinal(List<int> output, int outOff) {
    final List<int> outBytes = doFinal()!;
    if (outOff + outBytes.length > output.length) {
      throw ArgumentError.value(output, 'output', 'output buffer too short');
    }
    int j = 0;
    for (int i = outOff; i < output.length && j < outBytes.length; i++) {
      output[i] = outBytes[j];
      j++;
    }
    return <String, dynamic>{'length': outBytes.length, 'output': output};
  }

  @override
  Map<String, dynamic> copyFinal(
      List<int> input, List<int> output, int outOff) {
    return readFinalValues(input, 0, input.length, output, outOff);
  }

  @override
  Map<String, dynamic> readFinalValues(
      List<int> input, int inOff, int length, List<int>? output, int outOff) {
    Map<String, dynamic> result =
        processBytes(input, inOff, length, output, outOff);
    int len = result['length'] as int;
    output = result['output'] as List<int>?;
    result = writeFinal(output!, outOff + len);
    len += result['length']! as int;
    output = result['output'] as List<int>?;
    return <String, dynamic>{'length': len, 'output': output};
  }
}

/// internal class
class BufferedCipher extends BufferedBlockPaddingBase {
  /// internal constructor
  BufferedCipher(ICipher cipher) : super() {
    _cipher = cipher;
    _bytes = List<int>.generate(cipher.blockSize!, (int i) => 0);
    _offset = 0;
  }
  //Fields
  List<int>? _bytes;
  int? _offset;
  late bool _isEncryption;
  late ICipher _cipher;

  //Implementation
  @override
  String? get algorithmName => _cipher.algorithmName;
  @override
  int? get blockSize => _cipher.blockSize;

  /// internal method
  @override
  void initialize(bool isEncryption, ICipherParameter? parameters) {
    _isEncryption = isEncryption;
    reset();
    _cipher.initialize(isEncryption, parameters);
  }

  /// internal method
  @override
  int getUpdateOutputSize(int length) {
    final int total = length + _offset!;
    final int leftOver = total % _bytes!.length;
    return total - leftOver;
  }

  /// internal method
  @override
  int getOutputSize(int length) {
    return length + _offset!;
  }

  @override
  void reset() {
    _bytes = List<int>.generate(_bytes!.length, (int i) => 0);
    _offset = 0;
    _cipher.reset();
  }

  /// internal method
  @override
  List<int>? processByte(int input) {
    final int length = getUpdateOutputSize(1);
    List<int>? bytes =
        length > 0 ? List<int>.generate(length, (int i) => 0) : null;
    final Map<String, dynamic> result = copyBytes(input, bytes, 0)!;
    final int? position = result['length'] as int?;
    bytes = result['output'] as List<int>?;
    if (length > 0 && position! < length) {
      final List<int> tempBytes = List<int>.generate(position, (int i) => 0);
      List.copyRange(tempBytes, 0, bytes!, 0, position);
      bytes = tempBytes;
    }
    return bytes;
  }

  @override
  Map<String, dynamic>? copyBytes(int input, List<int>? output, int outOff) {
    _bytes![_offset!] = input;
    _offset = _offset! + 1;
    if (_offset == _bytes!.length) {
      if ((outOff + _bytes!.length) > output!.length) {
        throw ArgumentError.value(output, 'output', 'output buffer too short');
      }
      _offset = 0;
      return _cipher.processBlock(_bytes, 0, output, outOff);
    }
    return <String, dynamic>{'length': 0, 'output': output};
  }

  @override
  List<int>? readBytes(List<int> input, int inOff, int length) {
    if (length < 1) {
      return null;
    }
    final int outLength = getUpdateOutputSize(length);
    List<int>? outBytes =
        outLength > 0 ? List<int>.generate(outLength, (int i) => 0) : null;
    final Map<String, dynamic> result =
        processBytes(input, inOff, length, outBytes, 0);
    final int? position = result['length'] as int?;
    outBytes = result['output'] as List<int>?;
    if (outLength > 0 && position! < outLength) {
      final List<int> tempBytes = List<int>.generate(position, (int i) => 0);
      List.copyRange(tempBytes, 0, outBytes!, 0, position);
      outBytes = tempBytes;
    }
    return outBytes;
  }

  /// internal method
  @override
  Map<String, dynamic> processBytes(List<int>? input, int inOffset, int length,
      List<int>? output, int outOffset) {
    Map<String, dynamic>? result;
    if (length < 1) {
      return <String, dynamic>{'length': 0, 'output': output};
    }
    final int? blockSize = this.blockSize;
    getUpdateOutputSize(length);
    int resultLength = 0;
    final int gapLength = _bytes!.length - _offset!;
    if (length > gapLength) {
      List.copyRange(_bytes!, _offset!, input!, inOffset, inOffset + gapLength);
      result = _cipher.processBlock(_bytes, 0, output, outOffset);
      resultLength = resultLength + result!['length']! as int;
      output = result['output'] as List<int>?;
      _offset = 0;
      length -= gapLength;
      inOffset += gapLength;
      while (length > _bytes!.length) {
        result = _cipher.processBlock(
            input, inOffset, output, outOffset + resultLength);
        resultLength = resultLength + result!['length']! as int;
        output = result['output'] as List<int>?;
        length -= blockSize!;
        inOffset += blockSize;
      }
    }
    List.copyRange(_bytes!, _offset!, input!, inOffset, inOffset + length);
    _offset = _offset! + length;
    if (_offset == _bytes!.length) {
      result =
          _cipher.processBlock(_bytes, 0, output, outOffset + resultLength);
      resultLength = resultLength + result!['length']! as int;
      output = result['output'] as List<int>?;
      _offset = 0;
    }
    return <String, dynamic>{'output': output, 'length': resultLength};
  }

  @override
  List<int>? doFinal() {
    List<int>? bytes = BufferedBlockPaddingBase.emptyBuffer;
    final int length = getOutputSize(0);
    if (length > 0) {
      bytes = List<int>.generate(length, (int i) => 0);
      final Map<String, dynamic> result = writeFinal(bytes, 0);
      final int position = result['length'] as int;
      bytes = result['output'] as List<int>?;
      if (position < bytes!.length) {
        final List<int> tempBytes = List<int>.generate(position, (int i) => 0);
        List.copyRange(tempBytes, 0, bytes, 0, position);
        bytes = tempBytes;
      }
    } else {
      reset();
    }
    return bytes;
  }

  /// internal method
  @override
  List<int>? readFinal(List<int>? input, int inOffset, int inLength) {
    List<int>? outBytes = BufferedBlockPaddingBase.emptyBuffer;
    if (input != null) {
      final int length = getOutputSize(inLength);
      Map<String, dynamic> result;
      if (length > 0) {
        outBytes = List<int>.generate(length, (int i) => 0);
        int? position;
        if (inLength > 0) {
          result = processBytes(input, inOffset, inLength, outBytes, 0);
          position = result['length'] as int?;
          outBytes = result['output'] as List<int>?;
        } else {
          position = 0;
        }
        result = writeFinal(outBytes, position);
        position = position! + result['length']! as int;
        outBytes = result['output'] as List<int>?;
        if (position < outBytes!.length) {
          final List<int> tempBytes =
              List<int>.generate(position, (int i) => 0);
          List.copyRange(tempBytes, 0, outBytes, 0, position);
          outBytes = tempBytes;
        }
      } else {
        reset();
      }
    }
    return outBytes;
  }

  @override
  Map<String, dynamic> writeFinal(List<int>? output, int? outOff) {
    try {
      if (_offset != 0) {
        final Map<String, dynamic> result =
            _cipher.processBlock(_bytes, 0, _bytes, 0)!;
        _bytes = result['output'] as List<int>?;
        List.copyRange(_bytes!, 0, output!, outOff, _offset);
      }
      return <String, dynamic>{'length': _offset, 'output': output};
    } finally {
      reset();
    }
  }
}

/// internal class
class BufferedBlockPadding extends BufferedCipher {
  /// internal constructor
  BufferedBlockPadding(ICipher cipher, [IPadding? padding]) : super(cipher) {
    _cipher = cipher;
    _padding = padding ?? Pkcs7Padding();
    _bytes = List<int>.generate(cipher.blockSize!, (int i) => 0);
    _offset = 0;
  }
  //Fields
  late IPadding _padding;
  //Implemntation
  @override
  void initialize(bool isEncryption, ICipherParameter? parameters) {
    _isEncryption = isEncryption;
    Random? initRandom;
    reset();
    _padding.initialize(initRandom);
    _cipher.initialize(isEncryption, parameters);
  }

  @override
  int getOutputSize(int length) {
    final int total = length + _offset!;
    final int leftOver = total % _bytes!.length;
    if (leftOver == 0) {
      if (_isEncryption) {
        return total + _bytes!.length;
      }
      return total;
    }
    return total - leftOver + _bytes!.length;
  }

  @override
  int getUpdateOutputSize(int length) {
    final int total = length + _offset!;
    final int leftOver = total % _bytes!.length;
    if (leftOver == 0) {
      return total - _bytes!.length;
    }
    return total - leftOver;
  }

  @override
  Map<String, dynamic> copyBytes(int input, List<int>? output, int outOff) {
    int? resultLen = 0;
    if (_offset == _bytes!.length) {
      final Map<String, dynamic> result =
          _cipher.processBlock(_bytes, 0, output, outOff)!;
      resultLen = result['length'] as int?;
      output = result['output'] as List<int>?;
      _offset = 0;
    }
    _bytes![_offset!] = input;
    _offset = _offset! + 1;
    return <String, dynamic>{'length': resultLen, 'output': output};
  }

  @override
  Map<String, dynamic> processBytes(List<int>? input, int inOffset, int length,
      List<int>? output, int outOffset) {
    if (length < 0) {
      throw ArgumentError.value(length, 'length', 'Invalid length');
    }
    final int? blockSize = this.blockSize;
    final int outLength = getUpdateOutputSize(length);
    if (outLength > 0) {
      if ((outOffset + outLength) > output!.length) {
        throw ArgumentError.value(length, 'length', 'Invalid buffer length');
      }
    }
    int resultLength = 0;
    final int gapLength = _bytes!.length - _offset!;
    Map<String, dynamic>? result;
    if (length > gapLength) {
      List.copyRange(_bytes!, _offset!, input!, inOffset, inOffset + gapLength);
      result = _cipher.processBlock(_bytes, 0, output, outOffset);
      resultLength += result!['length']! as int;
      output = result['output'] as List<int>?;
      _offset = 0;
      length -= gapLength;
      inOffset += gapLength;
      while (length > _bytes!.length) {
        result = _cipher.processBlock(
            input, inOffset, output, outOffset + resultLength);
        resultLength += result!['length']! as int;
        output = result['output'] as List<int>?;
        length -= blockSize!;
        inOffset += blockSize;
      }
    }
    List.copyRange(_bytes!, _offset!, input!, inOffset, inOffset + length);
    _offset = _offset! + length;
    return <String, dynamic>{'length': resultLength, 'output': output};
  }

  @override
  Map<String, dynamic> writeFinal(List<int>? output, int? outOff) {
    final int? blockSize = _cipher.blockSize;
    int resultLen = 0;
    Map<String, dynamic>? result;
    if (_isEncryption) {
      if (_offset == blockSize) {
        if ((outOff! + 2 * blockSize!) > output!.length) {
          reset();
          throw ArgumentError.value(
              output, 'output', 'output buffer too short');
        }
        result = _cipher.processBlock(_bytes, 0, output, outOff);
        resultLen = result!['length'] as int;
        output = result['output'] as List<int>?;
        _offset = 0;
      }
      _padding.addPadding(_bytes, _offset);
      result = _cipher.processBlock(_bytes, 0, output, outOff! + resultLen);
      resultLen += result!['length'] as int;
      output = result['output'] as List<int>?;
      reset();
    } else {
      if (_offset == blockSize) {
        result = _cipher.processBlock(_bytes, 0, _bytes, 0);
        resultLen = result!['length'] as int;
        _bytes = result['output'] as List<int>?;
        _offset = 0;
      } else {
        reset();
        throw ArgumentError.value(output, 'output', 'incomplete in decryption');
      }
      try {
        resultLen -= _padding.count(_bytes)!;
        List.copyRange(output!, outOff!, _bytes!, 0, resultLen);
      } finally {
        reset();
      }
    }
    return <String, dynamic>{'length': resultLen, 'output': output};
  }
}

/// internal class
class Pkcs7Padding implements IPadding {
  /// internal constructor
  Pkcs7Padding();
  //Properties
  @override
  String get paddingName => Asn1.pkcs7;
  //Implementation
  @override
  void initialize(Random? random) {}
  @override
  int addPadding(List<int>? bytes, int? offset) {
    final int code = (bytes!.length - offset!).toUnsigned(8);
    while (offset! < bytes.length) {
      bytes[offset] = code;
      offset++;
    }
    return code;
  }

  @override
  int count(List<int>? input) {
    final int count = input![input.length - 1].toSigned(32);
    if (count < 1 || count > input.length) {
      throw ArgumentError.value(input, 'input', 'Invalid pad');
    }
    for (int i = 1; i <= count; i++) {
      if (input[input.length - i] != count) {
        throw ArgumentError.value(input, 'input', 'Invalid pad');
      }
    }
    return count;
  }
}
