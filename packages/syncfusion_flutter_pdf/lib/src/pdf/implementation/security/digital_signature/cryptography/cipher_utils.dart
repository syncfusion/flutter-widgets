part of pdf;

class _CipherUtils {
  _CipherUtils() {
    _algorithms = <String, String>{};
  }
  //Fields
  late Map<String, String> _algorithms;
  //Implementation
  _IBufferedCipher getCipher(String algorithm) {
    String? value;
    if (_algorithms.isNotEmpty) {
      value = _algorithms[algorithm];
    }
    if (value != null) {
      algorithm = value;
    }
    final List<String> parts = algorithm.split('/');
    _ICipher? blockCipher;
    _ICipherBlock? asymBlockCipher;
    String algorithmName = parts[0];
    if (_algorithms.isNotEmpty) {
      value = _algorithms[algorithmName];
    }
    if (value != null) {
      algorithmName = value;
    }
    final _CipherAlgorithm cipherAlgorithm = getAlgorithm(algorithmName);
    switch (cipherAlgorithm) {
      case _CipherAlgorithm.des:
        blockCipher = _DataEncryption();
        break;
      case _CipherAlgorithm.desede:
        blockCipher = _DesEdeAlogorithm();
        break;
      case _CipherAlgorithm.rc2:
        blockCipher = _Rc2Algorithm();
        break;
      case _CipherAlgorithm.rsa:
        asymBlockCipher = _RsaAlgorithm();
        break;
      default:
        throw ArgumentError.value(
            cipherAlgorithm, 'algorithm', 'Invalid cipher algorithm');
    }
    bool isPadded = true;
    _IPadding? padding;
    if (parts.length > 2) {
      final String paddingName = parts[2];
      _CipherPaddingType cipherPadding;
      if (paddingName.isEmpty) {
        cipherPadding = _CipherPaddingType.raw;
      } else if (paddingName == 'X9.23PADDING') {
        cipherPadding = _CipherPaddingType.x923Padding;
      } else {
        cipherPadding = getPaddingType(paddingName);
      }
      switch (cipherPadding) {
        case _CipherPaddingType.noPadding:
          isPadded = false;
          break;
        case _CipherPaddingType.raw:
        case _CipherPaddingType.withCipherTextStealing:
          break;
        case _CipherPaddingType.pkcs1:
        case _CipherPaddingType.pkcs1Padding:
          asymBlockCipher = _Pkcs1Encoding(asymBlockCipher);
          break;
        case _CipherPaddingType.pkcs5:
        case _CipherPaddingType.pkcs5Padding:
        case _CipherPaddingType.pkcs7:
        case _CipherPaddingType.pkcs7Padding:
          padding = _Pkcs7Padding();
          break;
        default:
          throw ArgumentError.value(cipherPadding, 'cpiher padding algorithm',
              'Invalid cipher algorithm');
      }
    }
    String mode = '';
    if (parts.length > 1) {
      mode = parts[1];
      int digitIngex = -1;
      for (int i = 0; i < mode.length; ++i) {
        if (isDigit(mode[i])) {
          digitIngex = i;
          break;
        }
      }
      final String modeName =
          digitIngex >= 0 ? mode.substring(0, digitIngex) : mode;
      final _CipherMode cipherMode =
          modeName == '' ? _CipherMode.none : getCipherMode(modeName);
      switch (cipherMode) {
        case _CipherMode.ecb:
        case _CipherMode.none:
          break;
        case _CipherMode.cbc:
          blockCipher = _CipherBlockChainingMode(blockCipher);
          break;
        case _CipherMode.cts:
          blockCipher = _CipherBlockChainingMode(blockCipher);
          break;
        default:
          throw ArgumentError.value(
              cipherMode, 'CipherMode', 'Invalid cipher algorithm');
      }
    }
    if (blockCipher != null) {
      if (padding != null) {
        return _BufferedBlockPadding(blockCipher, padding);
      }
      if (!isPadded || blockCipher.isBlock!) {
        return _BufferedCipher(blockCipher);
      }
      return _BufferedBlockPadding(blockCipher);
    }
    throw ArgumentError.value(
        blockCipher, 'Cipher Algorithm', 'Invalid cipher algorithm');
  }

  _CipherAlgorithm getAlgorithm(String name) {
    _CipherAlgorithm result;
    switch (name.toLowerCase()) {
      case 'des':
        result = _CipherAlgorithm.des;
        break;
      case 'desede':
        result = _CipherAlgorithm.desede;
        break;
      case 'rc2':
        result = _CipherAlgorithm.rc2;
        break;
      case 'rsa':
        result = _CipherAlgorithm.rsa;
        break;
      default:
        throw ArgumentError.value(name, 'name', 'Invalid algorithm name');
    }
    return result;
  }

  _CipherMode getCipherMode(String mode) {
    _CipherMode result;
    switch (mode.toLowerCase()) {
      case 'ecb':
        result = _CipherMode.ecb;
        break;
      case 'none':
        result = _CipherMode.none;
        break;
      case 'cbc':
        result = _CipherMode.cbc;
        break;
      case 'cts':
        result = _CipherMode.cts;
        break;
      default:
        throw ArgumentError.value(mode, 'CipherMode', 'Invalid mode');
    }
    return result;
  }

  _CipherPaddingType getPaddingType(String type) {
    _CipherPaddingType result;
    switch (type.toLowerCase()) {
      case 'noPadding':
        result = _CipherPaddingType.noPadding;
        break;
      case 'raw':
        result = _CipherPaddingType.raw;
        break;
      case 'pkcs1':
        result = _CipherPaddingType.pkcs1;
        break;
      case 'pkcs1Padding':
        result = _CipherPaddingType.pkcs1Padding;
        break;
      case 'pkcs5':
        result = _CipherPaddingType.pkcs5;
        break;
      case 'pkcs5Padding':
        result = _CipherPaddingType.pkcs5Padding;
        break;
      case 'pkcs7':
        result = _CipherPaddingType.pkcs7;
        break;
      case 'pkcs7Padding':
        result = _CipherPaddingType.pkcs7Padding;
        break;
      case 'withCipherTextStealing':
        result = _CipherPaddingType.withCipherTextStealing;
        break;
      case 'x923Padding':
        result = _CipherPaddingType.x923Padding;
        break;
      default:
        throw ArgumentError.value(type, 'PaddingType', 'Invalid padding type');
    }
    return result;
  }

  bool isDigit(String s, [int idx = 0]) {
    return (s.codeUnitAt(idx) ^ 0x30) <= 9;
  }
}

enum _CipherAlgorithm { des, desede, rc2, rsa }
enum _CipherMode { ecb, none, cbc, cts }
enum _CipherPaddingType {
  noPadding,
  raw,
  pkcs1,
  pkcs1Padding,
  pkcs5,
  pkcs5Padding,
  pkcs7,
  pkcs7Padding,
  withCipherTextStealing,
  x923Padding
}

class _SignaturePrivateKey {
  _SignaturePrivateKey(String hashAlgorithm, [_ICipherParameter? key]) {
    _key = key;
    final _MessageDigestAlgorithms alg = _MessageDigestAlgorithms();
    _hashAlgorithm = alg.getDigest(alg.getAllowedDigests(hashAlgorithm));
    if (key == null || key is _RsaKeyParam) {
      _encryptionAlgorithm = 'RSA';
    } else {
      throw ArgumentError.value(key, 'key', 'Invalid key');
    }
  }
  //Fields
  _ICipherParameter? _key;
  String? _hashAlgorithm;
  String? _encryptionAlgorithm;
  //Implementation
  List<int>? sign(List<int> bytes) {
    final String signMode = _hashAlgorithm! + 'with' + _encryptionAlgorithm!;
    final _SignerUtilities util = _SignerUtilities();
    final _ISigner signer = util.getSigner(signMode);
    signer.initialize(true, _key);
    signer.blockUpdate(bytes, 0, bytes.length);
    return signer.generateSignature();
  }

  String? getHashAlgorithm() {
    return _hashAlgorithm;
  }

  String? getEncryptionAlgorithm() {
    return _encryptionAlgorithm;
  }
}

class _SignerUtilities {
  _SignerUtilities() {
    _algms['MD2WITHRSA'] = 'MD2withRSA';
    _algms['MD2WITHRSAENCRYPTION'] = 'MD2withRSA';
    _algms[_PkcsObjectId.md2WithRsaEncryption._id] = 'MD2withRSA';
    _algms[_PkcsObjectId.rsaEncryption._id] = 'RSA';
    _algms['SHA1WITHRSA'] = 'SHA-1withRSA';
    _algms['SHA1WITHRSAENCRYPTION'] = 'SHA-1withRSA';
    _algms[_PkcsObjectId.sha1WithRsaEncryption._id] = 'SHA-1withRSA';
    _algms['SHA-1WITHRSA'] = 'SHA-1withRSA';
    _algms['SHA256WITHRSA'] = 'SHA-256withRSA';
    _algms['SHA256WITHRSAENCRYPTION'] = 'SHA-256withRSA';
    _algms[_PkcsObjectId.sha256WithRsaEncryption._id] = 'SHA-256withRSA';
    _algms['SHA-256WITHRSA'] = 'SHA-256withRSA';
    _algms['SHA1WITHRSAANDMGF1'] = 'SHA-1withRSAandMGF1';
    _algms['SHA-1WITHRSAANDMGF1'] = 'SHA-1withRSAandMGF1';
    _algms['SHA1WITHRSA/PSS'] = 'SHA-1withRSAandMGF1';
    _algms['SHA-1WITHRSA/PSS'] = 'SHA-1withRSAandMGF1';
    _algms['SHA224WITHRSAANDMGF1'] = 'SHA-224withRSAandMGF1';
    _algms['SHA-224WITHRSAANDMGF1'] = 'SHA-224withRSAandMGF1';
    _algms['SHA224WITHRSA/PSS'] = 'SHA-224withRSAandMGF1';
    _algms['SHA-224WITHRSA/PSS'] = 'SHA-224withRSAandMGF1';
    _algms['SHA256WITHRSAANDMGF1'] = 'SHA-256withRSAandMGF1';
    _algms['SHA-256WITHRSAANDMGF1'] = 'SHA-256withRSAandMGF1';
    _algms['SHA256WITHRSA/PSS'] = 'SHA-256withRSAandMGF1';
    _algms['SHA-256WITHRSA/PSS'] = 'SHA-256withRSAandMGF1';
    _algms['SHA384WITHRSA'] = 'SHA-384withRSA';
    _algms['SHA512WITHRSA'] = 'SHA-512withRSA';
    _algms['SHA384WITHRSAENCRYPTION'] = 'SHA-384withRSA';
    _algms[_PkcsObjectId.sha384WithRsaEncryption._id] = 'SHA-384withRSA';
    _algms['SHA-384WITHRSA'] = 'SHA-384withRSA';
    _algms['SHA-512WITHRSA'] = 'SHA-512withRSA';
    _algms['SHA384WITHRSAANDMGF1'] = 'SHA-384withRSAandMGF1';
    _algms['SHA-384WITHRSAANDMGF1'] = 'SHA-384withRSAandMGF1';
    _algms['SHA384WITHRSA/PSS'] = 'SHA-384withRSAandMGF1';
    _algms['SHA-384WITHRSA/PSS'] = 'SHA-384withRSAandMGF1';
    _algms['SHA512WITHRSAANDMGF1'] = 'SHA-512withRSAandMGF1';
    _algms['SHA-512WITHRSAANDMGF1'] = 'SHA-512withRSAandMGF1';
    _algms['SHA512WITHRSA/PSS'] = 'SHA-512withRSAandMGF1';
    _algms['SHA-512WITHRSA/PSS'] = 'SHA-512withRSAandMGF1';
    _algms['DSAWITHSHA256'] = 'SHA-256withDSA';
    _algms['DSAWITHSHA-256'] = 'SHA-256withDSA';
    _algms['SHA256/DSA'] = 'SHA-256withDSA';
    _algms['SHA-256/DSA'] = 'SHA-256withDSA';
    _algms['SHA256WITHDSA'] = 'SHA-256withDSA';
    _algms['SHA-256WITHDSA'] = 'SHA-256withDSA';
    _algms[_NistObjectIds.dsaWithSHA256._id] = 'SHA-256withDSA';
    _algms['RIPEMD160WITHRSA'] = 'RIPEMD160withRSA';
    _algms['RIPEMD160WITHRSAENCRYPTION'] = 'RIPEMD160withRSA';
    _algms[_NistObjectIds.rsaSignatureWithRipeMD160._id] = 'RIPEMD160withRSA';
    _oids['SHA-1withRSA'] = _PkcsObjectId.sha1WithRsaEncryption;
    _oids['SHA-256withRSA'] = _PkcsObjectId.sha256WithRsaEncryption;
    _oids['SHA-384withRSA'] = _PkcsObjectId.sha384WithRsaEncryption;
    _oids['SHA-512withRSA'] = _PkcsObjectId.sha512WithRsaEncryption;
    _oids['RIPEMD160withRSA'] = _NistObjectIds.rsaSignatureWithRipeMD160;
  }
  //Fields
  final Map<String?, String> _algms = <String?, String>{};
  final Map<String, _DerObjectID> _oids = <String, _DerObjectID>{};
  //Implementation
  _ISigner getSigner(String algorithm) {
    _ISigner result;
    final String lower = algorithm.toLowerCase();
    String? mechanism = algorithm;
    bool isContinue = true;
    _algms.forEach((String? key, String value) {
      if (isContinue && key!.toLowerCase() == lower) {
        mechanism = _algms[key];
        isContinue = false;
      }
    });
    if (mechanism == 'SHA-1withRSA') {
      result = _RmdSigner(_DigestAlgorithms.sha1);
    } else if (mechanism == 'SHA-256withRSA') {
      return _RmdSigner(_DigestAlgorithms.sha256);
    } else if (mechanism == 'SHA-384withRSA') {
      return _RmdSigner(_DigestAlgorithms.sha384);
    } else if (mechanism == 'SHA-512withRSA') {
      return _RmdSigner(_DigestAlgorithms.sha512);
    } else {
      throw ArgumentError.value('Signer ' + algorithm + ' not recognised.');
    }
    return result;
  }
}

class _KeyIdentifier extends _Asn1Encode {
  _KeyIdentifier(_Asn1Sequence sequence) {
    // ignore: avoid_function_literals_in_foreach_calls
    sequence._objects!.forEach((dynamic entry) {
      if (entry is _Asn1Tag) {
        switch (entry.tagNumber) {
          case 0:
            _keyIdentifier = _Asn1Octet.getOctetStringFromObject(entry);
            break;
          case 1:
            break;
          case 2:
            _serialNumber = _DerInteger.getNumberFromTag(entry, false);
            break;
          default:
            throw ArgumentError.value(
                sequence, 'sequence', 'Invalid entry in sequence');
        }
      }
    });
  }
  //Fields
  _Asn1Octet? _keyIdentifier;
  _DerInteger? _serialNumber;
  //Properties
  List<int>? get keyID =>
      _keyIdentifier == null ? null : _keyIdentifier!.getOctets();
  //Implementation
  static _KeyIdentifier getKeyIdentifier(dynamic obj) {
    _KeyIdentifier result;
    if (obj is _KeyIdentifier) {
      result = obj;
    } else if (obj is _Asn1Sequence) {
      result = _KeyIdentifier(obj);
    } else if (obj is _X509Extension) {
      result = getKeyIdentifier(_X509Extension.convertValueToObject(obj));
    } else {
      throw ArgumentError.value(obj, 'obj', 'Invalid entry');
    }
    return result;
  }

  @override
  _Asn1 getAsn1() {
    final _Asn1EncodeCollection collection = _Asn1EncodeCollection();
    if (_keyIdentifier != null) {
      collection._encodableObjects.add(_DerTag(0, _keyIdentifier, false));
    }
    if (_serialNumber != null) {
      collection._encodableObjects.add(_DerTag(2, _serialNumber, false));
    }
    return _DerSequence(collection: collection);
  }

  @override
  String toString() {
    return 'AuthorityKeyIdentifier: KeyID(' +
        String.fromCharCodes(_keyIdentifier!.getOctets()!) +
        ')';
  }
}

class _DigitalIdentifiers {
  static const String pkcs7Data = '1.2.840.113549.1.7.1';
  static const String pkcs7SignedData = '1.2.840.113549.1.7.2';
  static const String rsa = '1.2.840.113549.1.1.1';
  static const String dsa = '1.2.840.10040.4.1';
  static const String ecdsa = '1.2.840.10045.2.1';
  static const String contentType = '1.2.840.113549.1.9.3';
  static const String messageDigest = '1.2.840.113549.1.9.4';
  static const String aaSigningCertificateV2 = '1.2.840.113549.1.9.16.2.47';
}

class _DigestAlgorithms {
  static const String md5 = 'MD5';
  static const String sha1 = 'SHA-1';
  static const String sha256 = 'SHA-256';
  static const String sha384 = 'SHA-384';
  static const String sha512 = 'SHA-512';
  static const String hmacWithSha1 = 'HmacWithSHA-1';
  static const String hmacWithSha256 = 'HmacWithSHA-256';
  static const String hmacWithMd5 = 'HmacWithMD5';
}
