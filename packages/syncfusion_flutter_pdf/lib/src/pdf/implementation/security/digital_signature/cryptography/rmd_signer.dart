part of pdf;

class _RmdSigner implements _ISigner {
  _RmdSigner(String digest) {
    _digest = getDigest(digest);
    _output = AccumulatorSink<Digest>();
    _input = _digest.startChunkedConversion(_output);
    _rsaEngine = _Pkcs1Encoding(_RsaAlgorithm());
    _id = _Algorithms(map![digest], _DerNull.value);
  }
  Map<String, _DerObjectID>? _map;
  late _ICipherBlock _rsaEngine;
  _Algorithms? _id;
  late dynamic _digest;
  late dynamic _output;
  dynamic _input;
  late bool _isSigning;
  //Properties
  Map<String, _DerObjectID>? get map {
    if (_map == null) {
      _map = <String, _DerObjectID>{};
      _map![_DigestAlgorithms.sha1] = _X509Objects.idSha1;
      _map![_DigestAlgorithms.sha256] = _NistObjectIds.sha256;
      _map![_DigestAlgorithms.sha384] = _NistObjectIds.sha384;
      _map![_DigestAlgorithms.sha512] = _NistObjectIds.sha512;
    }
    return _map;
  }

  dynamic getDigest(String digest) {
    dynamic result;
    if (digest == _DigestAlgorithms.sha1) {
      result = sha1;
    } else if (digest == _DigestAlgorithms.sha256) {
      result = sha256;
    } else if (digest == _DigestAlgorithms.sha384) {
      result = sha384;
    } else if (digest == _DigestAlgorithms.sha512) {
      result = sha512;
    } else {
      throw ArgumentError.value(digest, 'digest', 'Invalid digest');
    }
    return result;
  }

  @override
  void initialize(bool isSigning, _ICipherParameter? parameters) {
    _isSigning = isSigning;
    final _CipherParameter? k = parameters as _CipherParameter?;
    if (isSigning && !k!.isPrivate!) {
      throw ArgumentError.value('Private key required.');
    }
    if (!isSigning && k!.isPrivate!) {
      throw ArgumentError.value('Public key required.');
    }
    reset();
    _rsaEngine.initialize(isSigning, parameters);
  }

  @override
  void blockUpdate(List<int> input, int inOff, int length) {
    _input.add(input.sublist(inOff, inOff + length));
  }

  @override
  List<int>? generateSignature() {
    if (!_isSigning) {
      throw ArgumentError.value('Invalid entry');
    }
    _input.close();
    final List<int>? hash = _output.events.single.bytes;
    final List<int> data = derEncode(hash)!;
    return _rsaEngine.processBlock(data, 0, data.length);
  }

  List<int>? derEncode(List<int>? hash) {
    if (_id == null) {
      return hash;
    }
    return _DigestInformation(_id, hash).getDerEncoded();
  }

  @override
  void reset() {
    _output = AccumulatorSink<Digest>();
    _input = _digest.startChunkedConversion(_output);
  }
}
