part of pdf;

class _CipherBlockChainingMode implements _ICipher {
  //Constructor
  _CipherBlockChainingMode(_ICipher? cipher) {
    _cipher = cipher;
    _size = _cipher!.blockSize;
    _bytes = List<int>.filled(_size!, 0, growable: true);
    _cbcBytes = List<int>.filled(_size!, 0, growable: true);
    _cbcNextBytes = List<int>.filled(_size!, 0, growable: true);
    _isEncryption = false;
  }

  //Fields
  _ICipher? _cipher;
  int? _size;
  late List<int> _bytes;
  List<int>? _cbcBytes;
  List<int>? _cbcNextBytes;
  bool? _isEncryption;

  //Fields
  int? get blockSize => _cipher!.blockSize;
  String get algorithmName => _cipher!.algorithmName! + '/CBC';
  bool get isBlock => false;

  //Implementation
  @override
  void initialize(bool? isEncryption, _ICipherParameter? parameters) {
    final bool? oldEncryption = _isEncryption;
    _isEncryption = isEncryption;
    if (parameters is _InvalidParameter) {
      final List<int> bytes = parameters.keys;
      if (bytes.length != _size) {
        throw ArgumentError.value(parameters, 'Invalid size in block');
      }
      List.copyRange(_bytes, 0, bytes, 0, bytes.length);
      parameters = parameters._parameters;
    }
    reset();
    if (parameters != null) {
      _cipher!.initialize(_isEncryption, parameters);
    } else if (oldEncryption != _isEncryption) {
      throw ArgumentError.value(oldEncryption,
          'cannot change encrypting state without providing key.');
    }
  }

  @override
  void reset() {
    _cbcBytes = List<int>.from(_bytes);
    _cbcNextBytes = List<int>.filled(_size!, 0, growable: true);
  }

  @override
  Map<String, dynamic> processBlock(List<int>? inputBytes, int inputOffset,
      List<int>? outputBytes, int? outputOffset) {
    return _isEncryption!
        ? encryptBlock(inputBytes!, inputOffset, outputBytes, outputOffset!)
        : decryptBlock(inputBytes!, inputOffset, outputBytes, outputOffset);
  }

  Map<String, dynamic> encryptBlock(List<int> inputBytes, int inputOffset,
      List<int>? outputBytes, int outputOffset) {
    if ((inputOffset + _size!) > inputBytes.length) {
      throw ArgumentError.value('Invalid length in input bytes');
    }
    for (int i = 0; i < _size!; i++) {
      _cbcBytes![i] ^= inputBytes[inputOffset + i];
    }
    final Map<String, dynamic> result =
        _cipher!.processBlock(_cbcBytes, 0, outputBytes, outputOffset)!;
    outputBytes = result['output'] as List<int>?;
    List.copyRange(_cbcBytes!, 0, outputBytes!, outputOffset,
        outputOffset + _cbcBytes!.length);
    return result;
  }

  Map<String, dynamic> decryptBlock(List<int> inputBytes, int inputOffset,
      List<int>? outputBytes, int? outputOffset) {
    if ((inputOffset + _size!) > inputBytes.length) {
      throw ArgumentError.value('Invalid length in input bytes');
    }
    List.copyRange(
        _cbcNextBytes!, 0, inputBytes, inputOffset, inputOffset + _size!);
    final Map<String, dynamic> result = _cipher!
        .processBlock(inputBytes, inputOffset, outputBytes, outputOffset)!;
    outputBytes = result['output'] as List<int>?;
    for (int i = 0; i < _size!; i++) {
      outputBytes![outputOffset! + i] ^= _cbcBytes![i];
    }
    final List<int>? tempBytes = _cbcBytes;
    _cbcBytes = _cbcNextBytes;
    _cbcNextBytes = tempBytes;
    return <String, dynamic>{'length': result['length'], 'output': outputBytes};
  }
}

class _InvalidParameter implements _ICipherParameter {
  //Constructor
  _InvalidParameter(_ICipherParameter? parameter, List<int> bytes,
      [int? offset, int? length]) {
    _parameters = parameter;
    length ??= bytes.length;
    offset ??= 0;
    _bytes = List<int>.filled(length, 0, growable: true);
    List.copyRange(_bytes!, 0, bytes, offset, offset + length);
  }

  //Fields
  _ICipherParameter? _parameters;
  List<int>? _bytes;

  //Properties
  @override
  List<int> get keys => List<int>.from(_bytes!);
  @override
  set keys(List<int>? value) {
    _bytes = value;
  }
}

class _KeyParameter implements _ICipherParameter {
  //Constructor
  _KeyParameter(List<int> bytes) {
    _bytes = List<int>.from(bytes);
  }
  _KeyParameter.fromLengthValue(List<int> bytes, int offset, int length) {
    if (offset < 0 || offset > bytes.length) {
      throw ArgumentError.value(offset, 'offset', 'Out of range');
    }
    if (length < 0 || (offset + length) > bytes.length) {
      throw ArgumentError.value(length, 'length', 'Out of range');
    }
    _bytes = List.generate(length, (i) => 0);
    List.copyRange(_bytes!, 0, bytes, offset, offset + length);
  }

  //Fields
  List<int>? _bytes;

  //Properties
  @override
  List<int> get keys => List<int>.from(_bytes!);
  @override
  set keys(List<int>? value) {
    _bytes = value;
  }
}

class _CipherParameter implements _ICipherParameter {
  _CipherParameter(bool privateKey) {
    _privateKey = privateKey;
  }
  //Fields
  bool? _privateKey;
  bool? get isPrivate => _privateKey;
  @override
  List<int>? get keys => null;
  @override
  set keys(List<int>? value) {}
  @override
  operator ==(Object other) {
    if (other is _CipherParameter) {
      return _privateKey == other._privateKey;
    } else {
      return false;
    }
  }

  @override
  int get hashCode => _privateKey.hashCode;
}

class _RsaKeyParam extends _CipherParameter {
  _RsaKeyParam(bool isPrivate, BigInt? modulus, BigInt? exponent)
      : super(isPrivate) {
    _modulus = modulus;
    _exponent = exponent;
  }
  //Fields
  BigInt? _modulus;
  BigInt? _exponent;
  //Properties
  BigInt? get modulus => _modulus;
  BigInt? get exponent => _exponent;
  @override
  List<int>? get keys => null;
  @override
  set keys(List<int>? value) {}
  //Implementation
  @override
  operator ==(Object other) {
    if (other is _RsaKeyParam) {
      return other.isPrivate == isPrivate &&
          other.modulus == _modulus &&
          other.exponent == _exponent;
    } else {
      return false;
    }
  }

  @override
  int get hashCode =>
      _modulus.hashCode ^ _exponent.hashCode ^ isPrivate.hashCode;
}

class _RsaPrivateKeyParam extends _RsaKeyParam {
  _RsaPrivateKeyParam(
      BigInt? modulus,
      BigInt publicExponent,
      BigInt? privateExponent,
      BigInt p,
      BigInt q,
      BigInt dP,
      BigInt dQ,
      BigInt inverse)
      : super(true, modulus, privateExponent) {
    validateValue(publicExponent);
    validateValue(p);
    validateValue(q);
    validateValue(dP);
    validateValue(dQ);
    validateValue(inverse);
    _publicExponent = publicExponent;
    _p = p;
    _q = q;
    _dP = dP;
    _dQ = dQ;
    _inverse = inverse;
  }

  //Fields
  BigInt? _publicExponent;
  BigInt? _p;
  BigInt? _q;
  BigInt? _dP;
  BigInt? _dQ;
  BigInt? _inverse;

  //Implementation
  void validateValue(BigInt number) {
    if (number.sign <= 0) {
      throw ArgumentError.value(number, 'number', 'Invalid RSA entry');
    }
  }

  @override
  List<int>? get keys => null;
  @override
  set keys(List<int>? value) {}

  @override
  operator ==(Object other) {
    if (other is _RsaPrivateKeyParam) {
      return other._dP == _dP &&
          other._dQ == _dQ &&
          other._exponent == _exponent &&
          other._modulus == _modulus &&
          other._p == _p &&
          other._q == _q &&
          other._publicExponent == _publicExponent &&
          other._inverse == _inverse;
    } else {
      return false;
    }
  }

  @override
  int get hashCode =>
      _dP.hashCode ^
      _dQ.hashCode ^
      _exponent.hashCode ^
      _modulus.hashCode ^
      _p.hashCode ^
      _q.hashCode ^
      _publicExponent.hashCode ^
      _inverse.hashCode;
}
