import 'dart:typed_data';
import 'ipadding.dart';

/// internal class
class CipherBlockChainingMode extends IBlockCipher {
  //Constructor
  /// internal constructor
  CipherBlockChainingMode(ICipher? cipher) {
    _cipher = cipher;
    _size = _cipher!.blockSize;

    _bytes = Uint8List(_size!);
    _cbcBytes = Uint8List(_size!);
    _cbcNextBytes = Uint8List(_size!);

    _isEncryption = false;
  }

  //Fields
  ICipher? _cipher;
  int? _size;
  late Uint8List _bytes;
  Uint8List? _cbcBytes;
  Uint8List? _cbcNextBytes;
  bool? _isEncryption;

  //Fields
  @override
  int? get blockSize => _cipher!.blockSize;
  @override
  String get algorithmName => '${_cipher!.algorithmName}/CBC';
  @override
  bool get isBlock => false;

  //Implementation
  @override
  void initialize(bool isEncryption, ICipherParameter? parameters) {
    final bool? oldEncryption = _isEncryption;
    _isEncryption = isEncryption;
    if (parameters != null) {
      if (parameters is InvalidParameter) {
        final List<int> iv = parameters.keys!;
        if (iv.length != blockSize) {
          throw ArgumentError.value(
            iv,
            'Initialization vector must be the same length as block size',
          );
        }
        _bytes.setAll(0, iv);
        _cipher!.initialize(isEncryption, parameters.parameters);
      } else {
        _cipher!.initialize(isEncryption, parameters);
      }
      reset();
    } else if (oldEncryption != _isEncryption) {
      throw ArgumentError.value(
        oldEncryption,
        'cannot change encrypting state without providing key.',
      );
    }
  }

  @override
  void reset() {
    _cbcBytes!.setAll(0, _bytes);
    _cbcNextBytes!.fillRange(0, _cbcNextBytes!.length, 0);
    _cipher!.reset();
  }

  @override
  Map<String, dynamic> processBlock(
    List<int>? inBytes,
    int inOffset,
    List<int>? outBytes,
    int? outOffset,
  ) {
    return _isEncryption!
        ? encryptionBlock(inBytes!, inOffset, outBytes, outOffset!)
        : decryptionBlock(inBytes!, inOffset, outBytes, outOffset);
  }

  /// internal method
  Map<String, dynamic> encryptionBlock(
    List<int> inputBytes,
    int inputOffset,
    List<int>? outputBytes,
    int outputOffset,
  ) {
    if ((inputOffset + _size!) > inputBytes.length) {
      throw ArgumentError.value('Invalid length in input bytes');
    }
    for (int i = 0; i < _size!; i++) {
      _cbcBytes![i] ^= inputBytes[inputOffset + i];
    }
    final Map<String, dynamic> result =
        _cipher!.processBlock(_cbcBytes, 0, outputBytes, outputOffset)!;
    outputBytes = result['output'] as List<int>?;
    List.copyRange(
      _cbcBytes!,
      0,
      outputBytes!,
      outputOffset,
      outputOffset + _cbcBytes!.length,
    );
    return result;
  }

  /// internal method
  Map<String, dynamic> decryptionBlock(
    List<int> inputBytes,
    int inputOffset,
    List<int>? outputBytes,
    int? outputOffset,
  ) {
    if ((inputOffset + _size!) > inputBytes.length) {
      throw ArgumentError.value('Invalid length in input bytes');
    }
    List.copyRange(
      _cbcNextBytes!,
      0,
      inputBytes,
      inputOffset,
      inputOffset + _size!,
    );
    final Map<String, dynamic>? result = _cipher!.processBlock(
      inputBytes,
      inputOffset,
      outputBytes,
      outputOffset,
    );
    outputBytes = result!['output'] as List<int>?;
    for (int i = 0; i < _size!; i++) {
      outputBytes![outputOffset! + i] ^= _cbcBytes![i];
    }
    final Uint8List? tempBytes = _cbcBytes;
    _cbcBytes = _cbcNextBytes;
    _cbcNextBytes = tempBytes;
    return <String, dynamic>{'length': result['length'], 'output': outputBytes};
  }

  @override
  int processingBlock(
    Uint8List inputBytes,
    int inputOffset,
    Uint8List outputBytes,
    int outputOffset,
  ) {
    return _isEncryption!
        ? encryptBlock(inputBytes, inputOffset, outputBytes, outputOffset)
        : decryptBlock(inputBytes, inputOffset, outputBytes, outputOffset);
  }

  /// internal method
  int encryptBlock(
    Uint8List? inputBytes,
    int inputOffset,
    Uint8List? outputBytes,
    int outputOffset,
  ) {
    if ((inputOffset + _size!) > inputBytes!.length) {
      throw ArgumentError.value('Invalid length in input bytes');
    }
    for (int i = 0; i < _size!; i++) {
      _cbcBytes![i] ^= inputBytes[inputOffset + i];
    }
    final result = _cipher!.processingBlock(
      _cbcBytes!,
      0,
      outputBytes!,
      outputOffset,
    );
    _cbcBytes!.setRange(
      0,
      _size!,
      Uint8List.view(
        outputBytes.buffer,
        outputBytes.offsetInBytes + outputOffset,
        _size,
      ),
    );
    return result!;
  }

  /// internal method
  int decryptBlock(
    Uint8List inputBytes,
    int inputOffset,
    Uint8List outputBytes,
    int outputOffset,
  ) {
    if ((inputOffset + _size!) > inputBytes.length) {
      throw ArgumentError.value('Invalid length in input bytes');
    }
    _cbcNextBytes!.setRange(
      0,
      _size!,
      Uint8List.view(
        inputBytes.buffer,
        inputBytes.offsetInBytes + inputOffset,
        blockSize,
      ),
    );
    final result = _cipher!.processingBlock(
      inputBytes,
      inputOffset,
      outputBytes,
      outputOffset,
    );
    for (int i = 0; i < _size!; i++) {
      outputBytes[outputOffset + i] ^= _cbcBytes![i];
    }
    final Uint8List? tempBytes = _cbcBytes;
    _cbcBytes = _cbcNextBytes;
    _cbcNextBytes = tempBytes;
    return result!;
  }
}

/// internal class
class InvalidParameter<UnderlyingKeyParameters extends ICipherParameter?>
    implements ICipherParameter {
  //Constructor
  /// internal constructor
  InvalidParameter(this.parameters, this.keys);

  //Fields
  /// internal field
  UnderlyingKeyParameters? parameters;

  /// internal field
  Uint8List? keys;
}

/// internal class
class KeyParameter extends ICipherParameter {
  KeyParameter(this.keys);

  KeyParameter.fromLengthValue(Uint8List keys, int keyOff, int keyLen) {
    this.keys = Uint8List(keyLen);
    copyArray(keys, keyOff, this.keys, 0, keyLen);
  }
  late Uint8List keys;
}

void copyArray(
  Uint8List? sourceArr,
  int sourcePos,
  Uint8List? outArr,
  int outPos,
  int len,
) {
  for (var i = 0; i < len; i++) {
    outArr![outPos + i] = sourceArr![sourcePos + i];
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
  List<int>? get keys => null;
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
  RsaPrivateKeyParam(
    BigInt? modulus,
    this.publicExponent,
    BigInt? privateExponent,
    this.p,
    this.q,
    this.dP,
    this.dQ,
    this.inverse,
  ) : super(true, modulus, privateExponent) {
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
