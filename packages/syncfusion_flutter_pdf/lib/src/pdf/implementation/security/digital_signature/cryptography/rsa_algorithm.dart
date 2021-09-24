part of pdf;

class _RsaAlgorithm implements _ICipherBlock {
  _RsaAlgorithm() {
    _rsaCoreEngine = _RsaCoreAlgorithm();
  }

  //Fields
  late _RsaCoreAlgorithm _rsaCoreEngine;
  _RsaKeyParam? _key;
  Random? _random;

  //Properties
  @override
  String get algorithmName => _Asn1.rsa;
  @override
  int get inputBlock => _rsaCoreEngine.inputBlockSize;
  @override
  int get outputBlock => _rsaCoreEngine.outputBlockSize;
  //Implementation
  @override
  void initialize(bool isEncryption, _ICipherParameter? parameter) {
    _rsaCoreEngine.initialize(isEncryption, parameter);
    _key = parameter as _RsaKeyParam?;
    _random = Random.secure();
  }

  //Implementation
  @override
  List<int> processBlock(List<int> bytes, int offset, int length) {
    ArgumentError.checkNotNull(_key);
    final BigInt input = _rsaCoreEngine.convertInput(bytes, offset, length);
    BigInt result;
    if (_key is _RsaPrivateKeyParam) {
      final BigInt? e = (_key! as _RsaPrivateKeyParam)._publicExponent;
      if (e != null) {
        final BigInt m = _key!.modulus!;
        final BigInt r =
            createRandomInRange(BigInt.one, m - BigInt.one, _random);
        final BigInt blindedInput = _getMod(r.modPow(e, m) * input, m);
        final BigInt blindedResult = _rsaCoreEngine.processBlock(blindedInput);
        final BigInt reverse = r.modInverse(m);
        result = _getMod(blindedResult * reverse, m);
      } else {
        result = _rsaCoreEngine.processBlock(input);
      }
    } else {
      result = _rsaCoreEngine.processBlock(input);
    }
    return _rsaCoreEngine.convertOutput(result);
  }

  BigInt createRandomInRange(BigInt min, BigInt max, Random? random) {
    final int cmp = min.compareTo(max);
    if (cmp >= 0) {
      if (cmp > 0) {
        throw ArgumentError.value('Invalid range');
      }
      return min;
    }
    if (min.bitLength > max.bitLength / 2) {
      return createRandomInRange(BigInt.zero, max - min, random) + min;
    }
    for (int i = 0; i < 1000; ++i) {
      final BigInt x = _bigIntFromRamdom(max.bitLength, random);
      if (x.compareTo(min) >= 0 && x.compareTo(max) <= 0) {
        return x;
      }
    }
    return _bigIntFromRamdom((max - min).bitLength - 1, random) + min;
  }
}

class _RsaCoreAlgorithm {
  _RsaCoreAlgorithm();

  //Fields
  late _RsaKeyParam _key;
  late bool _isEncryption;
  late int _bitSize;

  //Properties
  int get inputBlockSize {
    if (_isEncryption) {
      return (_bitSize - 1) ~/ 8;
    }
    return (_bitSize + 7) ~/ 8;
  }

  int get outputBlockSize {
    if (_isEncryption) {
      return (_bitSize + 7) ~/ 8;
    }
    return (_bitSize - 1) ~/ 8;
  }

  //Implementation
  void initialize(bool isEncryption, _ICipherParameter? parameters) {
    if (parameters is! _RsaKeyParam) {
      throw ArgumentError.value(parameters, 'parameters', 'Invalid RSA key');
    }
    _key = parameters;
    _isEncryption = isEncryption;
    _bitSize = _key.modulus!.bitLength;
  }

  BigInt convertInput(List<int> bytes, int offset, int length) {
    final int maxLength = (_bitSize + 7) ~/ 8;
    if (length > maxLength) {
      throw ArgumentError.value(length, 'length', 'Invalid length in inputs');
    }
    final BigInt input =
        _bigIntFromBytes(bytes.sublist(offset, offset + length), 1);
    if (input.compareTo(_key.modulus!) >= 0) {
      throw ArgumentError.value(length, 'length', 'Invalid length in inputs');
    }
    return input;
  }

  List<int> convertOutput(BigInt result) {
    List<int> output = _bigIntToBytes(result, false);
    if (_isEncryption) {
      final int outSize = outputBlockSize;
      if (output.length < outSize) {
        final List<int> bytes = List<int>.generate(outSize, (int i) => 0);
        int j = 0;
        for (int i = bytes.length - output.length;
            j < output.length && i < bytes.length;
            i++) {
          bytes[i] = output[j];
          j += 1;
        }
        output = bytes;
      }
    }
    return output;
  }

  BigInt processBlock(BigInt input) {
    if (_key is _RsaPrivateKeyParam) {
      final _RsaPrivateKeyParam privateKey = _key as _RsaPrivateKeyParam;
      final BigInt p = privateKey._p!;
      final BigInt q = privateKey._q!;
      final BigInt dP = privateKey._dP!;
      final BigInt dQ = privateKey._dQ!;
      final BigInt qInv = privateKey._inverse!;
      final BigInt mP = (input.remainder(p)).modPow(dP, p);
      final BigInt mQ = (input.remainder(q)).modPow(dQ, q);
      BigInt h = mP - mQ;
      h = h * qInv;
      h = _getMod(h, p);
      BigInt m = h * q;
      m = m + mQ;
      return m;
    }
    return input.modPow(_key._exponent!, _key._modulus!);
  }
}
