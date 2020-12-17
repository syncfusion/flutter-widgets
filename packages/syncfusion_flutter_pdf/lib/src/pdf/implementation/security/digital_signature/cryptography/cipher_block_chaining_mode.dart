part of pdf;

class _CipherBlockChainingMode {
  //Constructor
  _CipherBlockChainingMode(_AesEngine cipher) {
    _cipher = cipher;
    _size = _cipher.blockSize;
    _bytes = List<int>.filled(_size, 0, growable: true);
    _cbcBytes = List<int>.filled(_size, 0, growable: true);
    _cbcNextBytes = List<int>.filled(_size, 0, growable: true);
    _isEncryption = false;
  }

  //Fields
  _AesEngine _cipher;
  int _size;
  List<int> _bytes;
  List<int> _cbcBytes;
  List<int> _cbcNextBytes;
  bool _isEncryption;

  //Fields
  int get blockSize => _cipher.blockSize;

  //Implementation
  void _initialize(bool isEncryption, _ICipherParameter parameters) {
    final bool oldEncryption = _isEncryption;
    _isEncryption = isEncryption;
    if (parameters is _InvalidParameter) {
      final List<int> bytes = parameters.keys;
      if (bytes.length != _size) {
        throw ArgumentError.value(parameters, 'Invalid size in block');
      }
      List.copyRange(_bytes, 0, bytes, 0, bytes.length);
      parameters = (parameters as _InvalidParameter)._parameters;
    }
    _reset();
    if (parameters != null) {
      _cipher._initialize(_isEncryption, parameters);
    } else if (oldEncryption != _isEncryption) {
      throw ArgumentError.value(oldEncryption,
          'cannot change encrypting state without providing key.');
    }
  }

  void _reset() {
    _cbcBytes = List<int>.from(_bytes);
    _cbcNextBytes = List<int>.filled(_size, 0, growable: true);
  }

  Map<String, dynamic> _processBlock(List<int> inputBytes, int inputOffset,
      List<int> outputBytes, int outputOffset) {
    return _isEncryption
        ? _encryptBlock(inputBytes, inputOffset, outputBytes, outputOffset)
        : _decryptBlock(inputBytes, inputOffset, outputBytes, outputOffset);
  }

  Map<String, dynamic> _encryptBlock(List<int> inputBytes, int inputOffset,
      List<int> outputBytes, int outputOffset) {
    if ((inputOffset + _size) > inputBytes.length) {
      throw ArgumentError.value('Invalid length in input bytes');
    }
    for (int i = 0; i < _size; i++) {
      _cbcBytes[i] ^= inputBytes[inputOffset + i];
    }
    final Map<String, dynamic> result =
        _cipher._processBlock(_cbcBytes, 0, outputBytes, outputOffset);
    outputBytes = result['output'] as List<int>;
    List.copyRange(_cbcBytes, 0, outputBytes, outputOffset,
        outputOffset + _cbcBytes.length);
    return result;
  }

  Map<String, dynamic> _decryptBlock(List<int> inputBytes, int inputOffset,
      List<int> outputBytes, int outputOffset) {
    if ((inputOffset + _size) > inputBytes.length) {
      throw ArgumentError.value('Invalid length in input bytes');
    }
    List.copyRange(
        _cbcNextBytes, 0, inputBytes, inputOffset, inputOffset + _size);
    final Map<String, dynamic> result = _cipher._processBlock(
        inputBytes, inputOffset, outputBytes, outputOffset);
    outputBytes = result['output'] as List<int>;
    for (int i = 0; i < _size; i++) {
      outputBytes[outputOffset + i] ^= _cbcBytes[i];
    }
    final List<int> tempBytes = _cbcBytes;
    _cbcBytes = _cbcNextBytes;
    _cbcNextBytes = tempBytes;
    return <String, dynamic>{'length': result['length'], 'output': outputBytes};
  }
}

class _InvalidParameter implements _ICipherParameter {
  //Constructor
  _InvalidParameter(_ICipherParameter parameter, List<int> bytes,
      [int offset, int length]) {
    _parameters = parameter;
    length ??= bytes.length;
    offset ??= 0;
    _bytes = List<int>.filled(length, 0, growable: true);
    List.copyRange(_bytes, 0, bytes, offset, offset + length);
  }

  //Fields
  _ICipherParameter _parameters;
  List<int> _bytes;

  //Properties
  @override
  List<int> get keys => List<int>.from(_bytes);
  @override
  set keys(List<int> value) {
    _bytes = value;
  }
}

class _KeyParameter implements _ICipherParameter {
  //Constructor
  _KeyParameter(List<int> bytes) {
    _bytes = List<int>.from(bytes);
  }

  //Fields
  List<int> _bytes;

  //Properties
  @override
  List<int> get keys => List<int>.from(_bytes);
  @override
  set keys(List<int> value) {
    _bytes = value;
  }
}

class _ICipherParameter {
  List<int> keys;
}
