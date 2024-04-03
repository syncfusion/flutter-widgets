import 'ipadding.dart';

/// internal class
class CipherBlockChainingMode implements ICipher {
  //Constructor
  /// internal constructor
  CipherBlockChainingMode(ICipher? cipher) {
    _cipher = cipher;
    _size = _cipher!.blockSize;
    _bytes = List<int>.filled(_size!, 0, growable: true);
    _cbcBytes = List<int>.filled(_size!, 0, growable: true);
    _cbcNextBytes = List<int>.filled(_size!, 0, growable: true);
    _isEncryption = false;
  }

  //Fields
  ICipher? _cipher;
  int? _size;
  late List<int> _bytes;
  List<int>? _cbcBytes;
  List<int>? _cbcNextBytes;
  bool? _isEncryption;

  //Fields
  @override
  int? get blockSize => _cipher!.blockSize;
  @override
  String get algorithmName => '${_cipher!.algorithmName!}/CBC';
  @override
  bool get isBlock => false;

  //Implementation
  @override
  void initialize(bool? isEncryption, ICipherParameter? parameters) {
    final bool? oldEncryption = _isEncryption;
    _isEncryption = isEncryption;
    if (parameters is InvalidParameter) {
      final List<int> bytes = parameters.keys;
      if (bytes.length != _size) {
        throw ArgumentError.value(parameters, 'Invalid size in block');
      }
      List.copyRange(_bytes, 0, bytes, 0, bytes.length);
      parameters = parameters.parameters;
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

  /// internal method
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

  /// internal method
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

/// internal class
class InvalidParameter implements ICipherParameter {
  //Constructor
  /// internal constructor
  InvalidParameter(this.parameters, List<int> bytes,
      [int? offset, int? length]) {
    length ??= bytes.length;
    offset ??= 0;
    this.bytes = List<int>.filled(length, 0, growable: true);
    List.copyRange(this.bytes!, 0, bytes, offset, offset + length);
  }

  //Fields
  /// internal field
  ICipherParameter? parameters;

  /// internal field
  List<int>? bytes;

  //Properties
  @override
  List<int> get keys => List<int>.from(bytes!);
  @override
  set keys(List<int>? value) {
    bytes = value;
  }
}

/// internal class
class KeyParameter implements ICipherParameter {
  //Constructor
  /// internal constructor
  KeyParameter(List<int> bytes) {
    this.bytes = List<int>.from(bytes);
  }

  /// internal constructor
  KeyParameter.fromLengthValue(List<int> bytes, int offset, int length) {
    if (offset < 0 || offset > bytes.length) {
      throw ArgumentError.value(offset, 'offset', 'Out of range');
    }
    if (length < 0 || (offset + length) > bytes.length) {
      throw ArgumentError.value(length, 'length', 'Out of range');
    }
    this.bytes = List<int>.generate(length, (int i) => 0);
    List.copyRange(this.bytes!, 0, bytes, offset, offset + length);
  }

  //Fields
  /// internal field
  List<int>? bytes;

  //Properties
  @override
  List<int> get keys => List<int>.from(bytes!);
  @override
  set keys(List<int>? value) {
    bytes = value;
  }
}

/// internal class
class CipherParameter implements ICipherParameter {
  /// internal constructor
  CipherParameter(bool privateKey) {
    _privateKey = privateKey;
  }
  //Fields
  bool? _privateKey;

  /// internal property
  bool? get isPrivate => _privateKey;
  @override
  List<int>? get keys => null;
  @override
  set keys(List<int>? value) {}
  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  bool operator ==(Object other) {
    if (other is CipherParameter) {
      return _privateKey == other._privateKey;
    } else {
      return false;
    }
  }

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  int get hashCode => _privateKey.hashCode;
}

/// internal class
class RsaKeyParam extends CipherParameter {
  /// internal constructor
  RsaKeyParam(super.isPrivate, BigInt? modulus, BigInt? exponent) {
    _modulus = modulus;
    _exponent = exponent;
  }
  //Fields
  BigInt? _modulus;
  BigInt? _exponent;
  //Properties
  /// internal property
  BigInt? get modulus => _modulus;

  /// internal property
  BigInt? get exponent => _exponent;
  @override
  List<int>? get keys => null;
  @override
  set keys(List<int>? value) {}
  //Implementation
  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  bool operator ==(Object other) {
    if (other is RsaKeyParam) {
      return other.isPrivate == isPrivate &&
          other.modulus == _modulus &&
          other.exponent == _exponent;
    } else {
      return false;
    }
  }

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  int get hashCode =>
      _modulus.hashCode ^ _exponent.hashCode ^ isPrivate.hashCode;
}

/// internal class
class RsaPrivateKeyParam extends RsaKeyParam {
  /// internal constructor
  RsaPrivateKeyParam(BigInt? modulus, this.publicExponent,
      BigInt? privateExponent, this.p, this.q, this.dP, this.dQ, this.inverse)
      : super(true, modulus, privateExponent) {
    validateValue(publicExponent!);
    validateValue(p!);
    validateValue(q!);
    validateValue(dP!);
    validateValue(dQ!);
    validateValue(inverse!);
  }

  //Fields
  /// internal field
  BigInt? publicExponent;

  /// internal field
  BigInt? p;

  /// internal field
  BigInt? q;

  /// internal field
  BigInt? dP;

  /// internal field
  BigInt? dQ;

  /// internal field
  BigInt? inverse;

  //Implementation
  /// internal method
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
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  bool operator ==(Object other) {
    if (other is RsaPrivateKeyParam) {
      return other.dP == dP &&
          other.dQ == dQ &&
          other._exponent == _exponent &&
          other._modulus == _modulus &&
          other.p == p &&
          other.q == q &&
          other.publicExponent == publicExponent &&
          other.inverse == inverse;
    } else {
      return false;
    }
  }

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  int get hashCode =>
      dP.hashCode ^
      dQ.hashCode ^
      _exponent.hashCode ^
      _modulus.hashCode ^
      p.hashCode ^
      q.hashCode ^
      publicExponent.hashCode ^
      inverse.hashCode;
}
