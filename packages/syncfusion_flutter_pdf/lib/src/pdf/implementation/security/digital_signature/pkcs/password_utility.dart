part of pdf;

class _PasswordUtility {
  _PasswordUtility() {
    _cipherUtils = _CipherUtils();
    _pkcs12 = 'Pkcs12';
    _algorithms = <String?, String>{};
    _type = <String, String?>{};
    _ids = <String, _DerObjectID>{};
    _algorithms['PBEWITHSHAAND40BITRC4'] = 'PBEwithSHA-1and40bitRC4';
    _algorithms['PBEWITHSHA1AND40BITRC4'] = 'PBEwithSHA-1and40bitRC4';
    _algorithms['PBEWITHSHA-1AND40BITRC4'] = 'PBEwithSHA-1and40bitRC4';
    _algorithms[_PkcsObjectId.pbeWithShaAnd40BitRC4._id] =
        'PBEwithSHA-1and40bitRC4';
    _algorithms['PBEWITHSHAAND3-KEYDESEDE-CBC'] =
        'PBEwithSHA-1and3-keyDESEDE-CBC';
    _algorithms['PBEWITHSHAAND3-KEYTRIPLEDES-CBC'] =
        'PBEwithSHA-1and3-keyDESEDE-CBC';
    _algorithms['PBEWITHSHA1AND3-KEYDESEDE-CBC'] =
        'PBEwithSHA-1and3-keyDESEDE-CBC';
    _algorithms['PBEWITHSHA1AND3-KEYTRIPLEDES-CBC'] =
        'PBEwithSHA-1and3-keyDESEDE-CBC';
    _algorithms['PBEWITHSHA-1AND3-KEYDESEDE-CBC'] =
        'PBEwithSHA-1and3-keyDESEDE-CBC';
    _algorithms['PBEWITHSHA-1AND3-KEYTRIPLEDES-CBC'] =
        'PBEwithSHA-1and3-keyDESEDE-CBC';
    _algorithms[_PkcsObjectId.pbeWithShaAnd3KeyTripleDesCbc._id] =
        'PBEwithSHA-1and3-keyDESEDE-CBC';
    _algorithms['PBEWITHSHAAND40BITRC2-CBC'] = 'PBEwithSHA-1and40bitRC2-CBC';
    _algorithms['PBEWITHSHA1AND40BITRC2-CBC'] = 'PBEwithSHA-1and40bitRC2-CBC';
    _algorithms['PBEWITHSHA-1AND40BITRC2-CBC'] = 'PBEwithSHA-1and40bitRC2-CBC';
    _algorithms[_PkcsObjectId.pbewithShaAnd40BitRC2Cbc._id] =
        'PBEwithSHA-1and40bitRC2-CBC';
    _algorithms['PBEWITHSHAAND128BITAES-CBC-BC'] =
        'PBEwithSHA-1and128bitAES-CBC-BC';
    _algorithms['PBEWITHSHA1AND128BITAES-CBC-BC'] =
        'PBEwithSHA-1and128bitAES-CBC-BC';
    _algorithms['PBEWITHSHA-1AND128BITAES-CBC-BC'] =
        'PBEwithSHA-1and128bitAES-CBC-BC';
    _algorithms['PBEWITHSHAAND192BITAES-CBC-BC'] =
        'PBEwithSHA-1and192bitAES-CBC-BC';
    _algorithms['PBEWITHSHA1AND192BITAES-CBC-BC'] =
        'PBEwithSHA-1and192bitAES-CBC-BC';
    _algorithms['PBEWITHSHA-1AND192BITAES-CBC-BC'] =
        'PBEwithSHA-1and192bitAES-CBC-BC';
    _algorithms['PBEWITHSHAAND256BITAES-CBC-BC'] =
        'PBEwithSHA-1and256bitAES-CBC-BC';
    _algorithms['PBEWITHSHA1AND256BITAES-CBC-BC'] =
        'PBEwithSHA-1and256bitAES-CBC-BC';
    _algorithms['PBEWITHSHA-1AND256BITAES-CBC-BC'] =
        'PBEwithSHA-1and256bitAES-CBC-BC';
    _algorithms['PBEWITHSHA256AND128BITAES-CBC-BC'] =
        'PBEwithSHA-256and128bitAES-CBC-BC';
    _algorithms['PBEWITHSHA-256AND128BITAES-CBC-BC'] =
        'PBEwithSHA-256and128bitAES-CBC-BC';
    _algorithms['PBEWITHSHA256AND192BITAES-CBC-BC'] =
        'PBEwithSHA-256and192bitAES-CBC-BC';
    _algorithms['PBEWITHSHA-256AND192BITAES-CBC-BC'] =
        'PBEwithSHA-256and192bitAES-CBC-BC';
    _algorithms['PBEWITHSHA256AND256BITAES-CBC-BC'] =
        'PBEwithSHA-256and256bitAES-CBC-BC';
    _algorithms['PBEWITHSHA-256AND256BITAES-CBC-BC'] =
        'PBEwithSHA-256and256bitAES-CBC-BC';
    _type['Pkcs12'] = _pkcs12;
    _type['PBEwithSHA-1and128bitRC4'] = _pkcs12;
    _type['PBEwithSHA-1and40bitRC4'] = _pkcs12;
    _type['PBEwithSHA-1and3-keyDESEDE-CBC'] = _pkcs12;
    _type['PBEwithSHA-1and2-keyDESEDE-CBC'] = _pkcs12;
    _type['PBEwithSHA-1and128bitRC2-CBC'] = _pkcs12;
    _type['PBEwithSHA-1and40bitRC2-CBC'] = _pkcs12;
    _type['PBEwithSHA-1and256bitAES-CBC-BC'] = _pkcs12;
    _type['PBEwithSHA-256and128bitAES-CBC-BC'] = _pkcs12;
    _type['PBEwithSHA-256and192bitAES-CBC-BC'] = _pkcs12;
    _type['PBEwithSHA-256and256bitAES-CBC-BC'] = _pkcs12;
    _ids['PBEwithSHA-1and128bitRC4'] = _PkcsObjectId.pbeWithShaAnd128BitRC4;
    _ids['PBEwithSHA-1and40bitRC4'] = _PkcsObjectId.pbeWithShaAnd40BitRC4;
    _ids['PBEwithSHA-1and3-keyDESEDE-CBC'] =
        _PkcsObjectId.pbeWithShaAnd3KeyTripleDesCbc;
    _ids['PBEwithSHA-1and2-keyDESEDE-CBC'] =
        _PkcsObjectId.pbeWithShaAnd2KeyTripleDesCbc;
    _ids['PBEwithSHA-1and128bitRC2-CBC'] =
        _PkcsObjectId.pbeWithShaAnd128BitRC2Cbc;
    _ids['PBEwithSHA-1and40bitRC2-CBC'] =
        _PkcsObjectId.pbewithShaAnd40BitRC2Cbc;
  }

  //Fields
  String? _pkcs12;
  late Map<String?, String> _algorithms;
  late Map<String, String?> _type;
  late Map<String, _DerObjectID> _ids;
  late _CipherUtils _cipherUtils;

  //Implementation
  dynamic createEncoder(dynamic obj) {
    dynamic result;
    if (obj is _Algorithms) {
      result = createEncoder(obj._objectID!._id);
    } else if (obj is _DerObjectID) {
      result = createEncoder(obj._id);
    } else if (obj is String) {
      final String lower = obj.toLowerCase();
      String? mechanism;
      bool isContinue = true;
      _algorithms.forEach((String? key, String value) {
        if (isContinue && lower == key!.toLowerCase()) {
          mechanism = _algorithms[key];
          isContinue = false;
        }
      });

      if (mechanism != null && mechanism!.startsWith('PBEwithMD2') ||
          mechanism!.startsWith('PBEwithMD5') ||
          mechanism!.startsWith('PBEwithSHA-1') ||
          mechanism!.startsWith('PBEwithSHA-256')) {
        if (mechanism!.endsWith('AES-CBC-BC') ||
            mechanism!.endsWith('AES-CBC-OPENSSL')) {
          result = _cipherUtils.getCipher('AES/CBC');
        } else if (mechanism!.endsWith('DES-CBC')) {
          result = _cipherUtils.getCipher('DES/CBC');
        } else if (mechanism!.endsWith('DESEDE-CBC')) {
          result = _cipherUtils.getCipher('DESEDE/CBC');
        } else if (mechanism!.endsWith('RC2-CBC')) {
          result = _cipherUtils.getCipher('RC2/CBC');
        } else if (mechanism!.endsWith('RC4')) {
          result = _cipherUtils.getCipher('RC4');
        }
      }
    }
    return result;
  }

  _ICipherParameter? generateCipherParameters(String algorithm, String password,
      bool isWrong, _Asn1Encode? pbeParameters) {
    final String mechanism = getAlgorithmFromUpeerInvariant(algorithm)!;
    late List<int> keyBytes;
    List<int>? salt;
    int iterationCount = 0;
    if (isPkcs12(mechanism)) {
      final _Pkcs12PasswordParameter pbeParams =
          _Pkcs12PasswordParameter.getPbeParameter(pbeParameters);
      salt = pbeParams._octet!.getOctets();
      iterationCount = pbeParams._iterations!.value.toSigned(32).toInt();
      keyBytes = _PasswordGenerator.toBytes(password, isWrong);
    }
    _ICipherParameter? parameters;
    _PasswordGenerator generator;
    if (mechanism.startsWith('PBEwithSHA-1')) {
      generator = getEncoder(_type[mechanism], _DigestAlgorithms.sha1, keyBytes,
          salt!, iterationCount, password);
      if (mechanism == 'PBEwithSHA-1and128bitAES-CBC-BC') {
        parameters = generator.generateParam(128, 'AES', 128);
      } else if (mechanism == 'PBEwithSHA-1and192bitAES-CBC-BC') {
        parameters = generator.generateParam(192, 'AES', 128);
      } else if (mechanism == 'PBEwithSHA-1and256bitAES-CBC-BC') {
        parameters = generator.generateParam(256, 'AES', 128);
      } else if (mechanism == 'PBEwithSHA-1and128bitRC4') {
        parameters = generator.generateParam(128, 'RC4');
      } else if (mechanism == 'PBEwithSHA-1and40bitRC4') {
        parameters = generator.generateParam(40, 'RC4');
      } else if (mechanism == 'PBEwithSHA-1and3-keyDESEDE-CBC') {
        parameters = generator.generateParam(192, 'DESEDE', 64);
      } else if (mechanism == 'PBEwithSHA-1and2-keyDESEDE-CBC') {
        parameters = generator.generateParam(128, 'DESEDE', 64);
      } else if (mechanism == 'PBEwithSHA-1and128bitRC2-CBC') {
        parameters = generator.generateParam(128, 'RC2', 64);
      } else if (mechanism == 'PBEwithSHA-1and40bitRC2-CBC') {
        parameters = generator.generateParam(40, 'RC2', 64);
      } else if (mechanism == 'PBEwithSHA-1andDES-CBC') {
        parameters = generator.generateParam(64, 'DES', 64);
      } else if (mechanism == 'PBEwithSHA-1andRC2-CBC') {
        parameters = generator.generateParam(64, 'RC2', 64);
      }
    } else if (mechanism.startsWith('PBEwithSHA-256')) {
      generator = getEncoder(_type[mechanism], _DigestAlgorithms.sha256,
          keyBytes, salt!, iterationCount, password);
      if (mechanism == 'PBEwithSHA-256and128bitAES-CBC-BC') {
        parameters = generator.generateParam(128, 'AES', 128);
      } else if (mechanism == 'PBEwithSHA-256and192bitAES-CBC-BC') {
        parameters = generator.generateParam(192, 'AES', 128);
      } else if (mechanism == 'PBEwithSHA-256and256bitAES-CBC-BC') {
        parameters = generator.generateParam(256, 'AES', 128);
      }
    } else if (mechanism.startsWith('PBEwithHmac')) {
      final String digest =
          getDigest(mechanism.substring('PBEwithHmac'.length));
      generator = getEncoder(
          _type[mechanism], digest, keyBytes, salt!, iterationCount, password);
      final int? bitLen = getBlockSize(digest);
      parameters = generator.generateParam(bitLen);
    }
    keyBytes = List<int>.generate(keyBytes.length, (i) => 0);
    return fixDataEncryptionParity(mechanism, parameters);
  }

  static int getByteLength(String digest) {
    return (digest == _DigestAlgorithms.md5 ||
            digest == _DigestAlgorithms.sha1 ||
            digest == _DigestAlgorithms.sha256 ||
            digest.contains('Hmac'))
        ? 64
        : 128;
  }

  static int? getBlockSize(String digest) {
    int? result;
    if (digest == _DigestAlgorithms.md5) {
      result = 16;
    } else if (digest == _DigestAlgorithms.sha1) {
      result = 20;
    } else if (digest == _DigestAlgorithms.sha256) {
      result = 32;
    } else if (digest == _DigestAlgorithms.sha512) {
      result = 64;
    } else if (digest == _DigestAlgorithms.sha384) {
      result = 48;
    } else if (digest.contains('Hmac')) {
      result = 20;
    }
    return result;
  }

  _ICipherParameter? fixDataEncryptionParity(
      String mechanism, _ICipherParameter? parameters) {
    if (!mechanism.endsWith('DES-CBC') & !mechanism.endsWith('DESEDE-CBC')) {
      return parameters;
    }
    if (parameters is _InvalidParameter) {
      return _InvalidParameter(
          fixDataEncryptionParity(mechanism, parameters._parameters),
          parameters._bytes!);
    }
    final _KeyParameter kParam = parameters as _KeyParameter;
    final List<int> keyBytes = kParam.keys;
    for (int i = 0; i < keyBytes.length; i++) {
      final int value = keyBytes[i];
      keyBytes[i] = ((value & 0xfe) |
              ((((value >> 1) ^
                          (value >> 2) ^
                          (value >> 3) ^
                          (value >> 4) ^
                          (value >> 5) ^
                          (value >> 6) ^
                          (value >> 7)) ^
                      0x01) &
                  0x01))
          .toUnsigned(8);
    }
    return _KeyParameter(keyBytes);
  }

  bool isPkcs12(String algorithm) {
    final String? mechanism = getAlgorithmFromUpeerInvariant(algorithm);
    return mechanism != null &&
        _type.containsKey(mechanism) &&
        _pkcs12 == _type[mechanism];
  }

  String getDigest(String algorithm) {
    String? digest = getAlgorithmFromUpeerInvariant(algorithm);
    if (digest == null) {
      digest = algorithm;
    }
    if (digest.contains('sha_1') ||
        digest.contains('sha-1') ||
        digest.contains('sha1')) {
      digest = _DigestAlgorithms.hmacWithSha1;
    } else if (digest.contains('sha_256') ||
        digest.contains('sha-256') ||
        digest.contains('sha256')) {
      digest = _DigestAlgorithms.hmacWithSha256;
    } else if (digest.contains('md5') ||
        digest.contains('md_5') ||
        digest.contains('md-5')) {
      digest = _DigestAlgorithms.hmacWithMd5;
    } else {
      throw ArgumentError.value(algorithm, 'algorithm', 'Invalid message');
    }
    return digest;
  }

  _PasswordGenerator getEncoder(String? type, String digest, List<int> key,
      List<int> salt, int iterationCount, String password) {
    _PasswordGenerator generator;
    if (type == _pkcs12) {
      generator = _Pkcs12AlgorithmGenerator(digest, password);
    } else {
      throw ArgumentError.value(
          type, 'type', 'Invalid Password Based Encryption type');
    }
    generator.init(key, salt, iterationCount);
    return generator;
  }

  String? getAlgorithmFromUpeerInvariant(String algorithm) {
    final String temp = algorithm.toLowerCase();
    String? result;
    bool isContinue = true;
    _algorithms.forEach((String? key, String value) {
      if (isContinue && key!.toLowerCase() == temp) {
        result = value;
        isContinue = false;
      }
    });
    return result;
  }
}

abstract class _PasswordGenerator {
  List<int>? _password;
  List<int>? _value;
  int? _count;
  _ICipherParameter generateParam(int? keySize, [String? algorithm, int? size]);
  void init(List<int> password, List<int> value, int count) {
    _password = _Asn1Constants.clone(password);
    _value = _Asn1Constants.clone(value);
    _count = count;
  }

  static List<int> toBytes(String password, bool isWrong) {
    if (password.length < 1) {
      return isWrong ? List<int>.generate(2, (i) => 0) : <int>[];
    }
    final List<int> bytes =
        List<int>.generate((password.length + 1) * 2, (i) => 0);
    final List<int> tempBytes = _encodeBigEndian(password);
    int i = 0;
    tempBytes.forEach((tempByte) {
      bytes[i] = tempBytes[i];
      i++;
    });
    return bytes;
  }
}

class _Pkcs12AlgorithmGenerator extends _PasswordGenerator {
  _Pkcs12AlgorithmGenerator(String digest, String password) {
    _digest = getDigest(digest, password);
    _size = _PasswordUtility.getBlockSize(digest);
    _length = _PasswordUtility.getByteLength(digest);
    _keyMaterial = 1;
    _invaidMaterial = 2;
  }
  late dynamic _digest;
  int? _size;
  late int _length;
  int? _keyMaterial;
  int? _invaidMaterial;
  //Implementes
  dynamic getDigest(String digest, String password) {
    dynamic result;
    if (digest == _DigestAlgorithms.md5) {
      result = md5;
    } else if (digest == _DigestAlgorithms.sha1) {
      result = sha1;
    } else if (digest == _DigestAlgorithms.sha256) {
      result = sha256;
    } else if (digest == _DigestAlgorithms.sha384) {
      result = sha384;
    } else if (digest == _DigestAlgorithms.sha512) {
      result = sha512;
    } else if (digest == _DigestAlgorithms.hmacWithSha1) {
      result = Hmac(sha1, utf8.encode(password));
    } else if (digest == _DigestAlgorithms.hmacWithSha256) {
      result = Hmac(sha256, utf8.encode(password));
    } else if (digest == _DigestAlgorithms.hmacWithMd5) {
      result = Hmac(md5, utf8.encode(password));
    } else {
      throw ArgumentError.value(digest, 'digest', 'Invalid message digest');
    }
    return result;
  }

  @override
  _ICipherParameter generateParam(int? keySize,
      [String? algorithm, int? size]) {
    if (size != null) {
      size = size ~/ 8;
      keySize = keySize! ~/ 8;
      final List<int> bytes = generateDerivedKey(_keyMaterial, keySize);
      final _ParamUtility util = _ParamUtility();
      final _KeyParameter key =
          util.createKeyParameter(algorithm!, bytes, 0, keySize);
      final List<int> iv = generateDerivedKey(_invaidMaterial, size);
      return _InvalidParameter(key, iv, 0, size);
    } else if (algorithm != null) {
      keySize = keySize! ~/ 8;
      final List<int> bytes = generateDerivedKey(_keyMaterial, keySize);
      final _ParamUtility util = _ParamUtility();
      return util.createKeyParameter(algorithm, bytes, 0, keySize);
    } else {
      keySize = keySize! ~/ 8;
      final List<int> bytes = generateDerivedKey(_keyMaterial, keySize);
      return _KeyParameter.fromLengthValue(bytes, 0, keySize);
    }
  }

  List<int> generateDerivedKey(int? id, int length) {
    final List<int> d = List<int>.generate(_length, (index) => 0);
    final List<int> derivedKey = List<int>.generate(length, (index) => 0);
    for (int index = 0; index != d.length; index++) {
      d[index] = id!.toUnsigned(8);
    }
    List<int> s;
    if (_value != null && _value!.length != 0) {
      s = List<int>.generate(
          (_length * ((_value!.length + _length - 1) ~/ _length)),
          (index) => 0);
      for (int index = 0; index != s.length; index++) {
        s[index] = _value![index % _value!.length];
      }
    } else {
      s = <int>[];
    }
    List<int> password;
    if (_password != null && _password!.length != 0) {
      password = List<int>.generate(
          (_length * ((_password!.length + _length - 1) ~/ _length)),
          (index) => 0);
      for (int index = 0; index != password.length; index++) {
        password[index] = _password![index % _password!.length];
      }
    } else {
      password = <int>[];
    }
    List<int> tempBytes =
        List<int>.generate(s.length + password.length, (index) => 0);
    List.copyRange(tempBytes, 0, s, 0, s.length);
    List.copyRange(tempBytes, s.length, password, 0, password.length);
    final List<int> b = List<int>.generate(_length, (index) => 0);
    final int c = (length + _size! - 1) ~/ _size!;
    List<int>? a = List<int>.generate(_size!, (index) => 0);
    for (int i = 1; i <= c; i++) {
      final dynamic output = AccumulatorSink<Digest>();
      final dynamic input = sha1.startChunkedConversion(output);
      input.add(d);
      input.add(tempBytes);
      input.close();
      a = output.events.single.bytes;
      for (int j = 1; j != _count; j++) {
        a = _digest.convert(a).bytes;
      }
      for (int j = 0; j != b.length; j++) {
        b[j] = a![j % a.length];
      }
      for (int j = 0; j != tempBytes.length ~/ _length; j++) {
        tempBytes = adjust(tempBytes, j * _length, b);
      }
      if (i == c) {
        List.copyRange(derivedKey, (i - 1) * _size!, a!, 0,
            derivedKey.length - ((i - 1) * _size!));
      } else {
        List.copyRange(derivedKey, (i - 1) * _size!, a!, 0, a.length);
      }
    }
    return derivedKey;
  }

  List<int> adjust(List<int> a, int offset, List<int> b) {
    int x = (b[b.length - 1] & 0xff) + (a[offset + b.length - 1] & 0xff) + 1;
    a[offset + b.length - 1] = x.toUnsigned(8);
    x = (x.toUnsigned(32) >> 8).toSigned(32);
    for (int i = b.length - 2; i >= 0; i--) {
      x += (b[i] & 0xff) + (a[offset + i] & 0xff);
      a[offset + i] = x.toUnsigned(8);
      x = (x.toUnsigned(32) >> 8).toSigned(32);
    }
    return a;
  }
}

class _Pkcs12PasswordParameter extends _Asn1Encode {
  _Pkcs12PasswordParameter(_Asn1Sequence sequence) {
    if (sequence.count != 2) {
      throw ArgumentError.value(
          sequence, 'sequence', 'Invalid length in sequence');
    }
    _octet = _Asn1Octet.getOctetStringFromObject(sequence[0]);
    _iterations = _DerInteger.getNumber(sequence[1]);
  }
  //Fields
  _DerInteger? _iterations;
  _Asn1Octet? _octet;
  //Implementation
  static _Pkcs12PasswordParameter getPbeParameter(dynamic obj) {
    _Pkcs12PasswordParameter result;
    if (obj is _Pkcs12PasswordParameter) {
      result = obj;
    } else if (obj is _Asn1Sequence) {
      result = _Pkcs12PasswordParameter(obj);
    } else {
      throw ArgumentError.value(obj, 'obj', 'Invalid entry');
    }
    return result;
  }

  @override
  _Asn1 getAsn1() {
    return _DerSequence(array: <_Asn1Encode?>[_octet, _iterations]);
  }
}

class _KeyEntry {
  _KeyEntry(_CipherParameter? key) {
    _key = key;
  }
  _CipherParameter? _key;
  //Implementation
  @override
  bool operator ==(Object obj) {
    if (obj is _KeyEntry) {
      return _key == obj._key;
    } else {
      return false;
    }
  }

  @override
  int get hashCode => _key.hashCode;
}

class _ParamUtility {
  _ParamUtility() {
    _algorithms = <String, String>{};
    addAlgorithm('DESEDE', <dynamic>[
      'DESEDEWRAP',
      'TDEA',
      _DerObjectID('1.3.14.3.2.17'),
      _PkcsObjectId.idAlgCms3DesWrap
    ]);
    addAlgorithm('DESEDE3', <dynamic>[_PkcsObjectId.desEde3Cbc]);
    addAlgorithm(
        'RC2', <dynamic>[_PkcsObjectId.rc2Cbc, _PkcsObjectId.idAlgCmsRC2Wrap]);
  }

  //Fields
  late Map<String, String> _algorithms;

  //Implementation
  void addAlgorithm(String name, List<dynamic> objects) {
    _algorithms[name] = name;
    objects.forEach((entry) {
      if (entry is String) {
        _algorithms[entry] = name;
      } else {
        _algorithms[entry.toString()] = name;
      }
    });
  }

  _KeyParameter createKeyParameter(
      String algorithm, List<int> bytes, int offset, int? length) {
    String? name;
    final String lower = algorithm.toLowerCase();
    _algorithms.forEach((String key, String value) {
      if (lower == key.toLowerCase()) {
        name = value;
      }
    });
    if (name == null) {
      throw ArgumentError.value(
          algorithm, 'algorithm', 'Invalid entry. Algorithm');
    }
    if (name == 'DES') {
      return _DataEncryptionParameter.fromLengthValue(bytes, offset, length!);
    }
    if (name == 'DESEDE' || name == 'DESEDE3') {
      return _DesedeAlgorithmParameter(bytes, offset, length);
    }
    return _KeyParameter.fromLengthValue(bytes, offset, length!);
  }
}

class _DataEncryptionParameter extends _KeyParameter {
  _DataEncryptionParameter(List<int> keys) : super(keys) {
    if (checkKey(keys, 0)) {
      throw ArgumentError.value(
          keys, 'keys', 'Invalid Data Encryption keys creation');
    }
  }
  _DataEncryptionParameter.fromLengthValue(
      List<int> keys, int offset, int length)
      : super.fromLengthValue(keys, offset, length) {
    if (checkKey(keys, 0)) {
      throw ArgumentError.value(
          keys, 'keys', 'Invalid Data Encryption keys creation');
    }
  }
  static List<int> dataEncryptionWeekKeys = <int>[
    1,
    1,
    1,
    1,
    1,
    1,
    1,
    1,
    31,
    31,
    31,
    31,
    14,
    14,
    14,
    14,
    224,
    224,
    224,
    224,
    241,
    241,
    241,
    241,
    254,
    254,
    254,
    254,
    254,
    254,
    254,
    254,
    1,
    254,
    1,
    254,
    1,
    254,
    1,
    254,
    31,
    224,
    31,
    224,
    14,
    241,
    14,
    241,
    1,
    224,
    1,
    224,
    1,
    241,
    1,
    241,
    31,
    254,
    31,
    254,
    14,
    254,
    14,
    254,
    1,
    31,
    1,
    31,
    1,
    14,
    1,
    14,
    224,
    254,
    224,
    254,
    241,
    254,
    241,
    254,
    254,
    1,
    254,
    1,
    254,
    1,
    254,
    1,
    224,
    31,
    224,
    31,
    241,
    14,
    241,
    14,
    224,
    1,
    224,
    1,
    241,
    1,
    241,
    1,
    254,
    31,
    254,
    31,
    254,
    14,
    254,
    14,
    31,
    1,
    31,
    1,
    14,
    1,
    14,
    1,
    254,
    224,
    254,
    224,
    254,
    241,
    254,
    241
  ];

  static bool checkKey(List<int> bytes, int offset) {
    if (bytes.length - offset < 8) {
      throw ArgumentError.value(bytes, 'bytes', 'Invalid length in bytes');
    }
    for (int i = 0; i < 16; i++) {
      bool isMatch = false;
      for (int j = 0; j < 8; j++) {
        if (bytes[j + offset] != dataEncryptionWeekKeys[i * 8 + j]) {
          isMatch = true;
          break;
        }
      }
      if (!isMatch) {
        return true;
      }
    }
    return false;
  }

  @override
  List<int> get keys => List<int>.from(_bytes!);
  @override
  set keys(List<int>? value) {
    _bytes = value;
  }
}

class _DesedeAlgorithmParameter extends _DataEncryptionParameter {
  _DesedeAlgorithmParameter(List<int> key, int keyOffset, int? keyLength)
      : super(fixKey(key, keyOffset, keyLength)) {}
  //Implementation
  static List<int> fixKey(List<int> key, int keyOffset, int? keyLength) {
    final List<int> tmp = List.generate(24, (i) => 0);
    switch (keyLength) {
      case 16:
        List.copyRange(tmp, 0, key, keyOffset, keyOffset + 16);
        List.copyRange(tmp, 16, key, keyOffset, keyOffset + 8);
        break;
      case 24:
        List.copyRange(tmp, 0, key, keyOffset, keyOffset + 24);
        break;
      default:
        throw ArgumentError.value(
            keyLength, 'keyLen', 'Bad length for DESede key');
    }
    if (checkKeyValue(tmp, 0, tmp.length)) {
      throw ArgumentError.value(
          key, 'key', 'Attempt to create weak DESede key');
    }
    return tmp;
  }

  static bool checkKeyValue(List<int> key, int offset, int length) {
    for (int i = offset; i < length; i += 8) {
      if (_DataEncryptionParameter.checkKey(key, i)) {
        return true;
      }
    }
    return false;
  }

  @override
  List<int> get keys => List<int>.from(_bytes!);
  @override
  set keys(List<int>? value) {
    _bytes = value;
  }
}
