part of pdf;

class _PfxData extends _Asn1Encode {
  _PfxData(_Asn1Sequence sequence) {
    _contentInformation = _ContentInformation.getInformation(sequence[1]);
    if (sequence.count == 3) {
      _macInformation = _MacInformation.getInformation(sequence[2]);
    }
  }
  _ContentInformation? _contentInformation;
  _MacInformation? _macInformation;
  @override
  _Asn1 getAsn1() {
    final _Asn1EncodeCollection collection =
        _Asn1EncodeCollection(<_Asn1Encode?>[
      _DerInteger(_bigIntToBytes(BigInt.from(3))),
      _contentInformation
    ]);
    if (_macInformation != null) {
      collection._encodableObjects.add(_macInformation);
    }
    return _BerSequence(collection: collection);
  }
}

class _ContentInformation extends _Asn1Encode {
  _ContentInformation(_Asn1Sequence sequence) {
    if (sequence.count < 1 || sequence.count > 2) {
      throw ArgumentError.value(
          sequence, 'sequence', 'Invalid length in sequence');
    }
    _contentType = sequence[0] as _DerObjectID?;
    if (sequence.count > 1) {
      final _Asn1Tag tagged = sequence[1]! as _Asn1Tag;
      if (!tagged._isExplicit! || tagged.tagNumber != 0) {
        throw ArgumentError.value(tagged, 'tagged', 'Invalid tag');
      }
      _content = tagged.getObject();
    }
  }
  //Fields
  _DerObjectID? _contentType;
  _Asn1Encode? _content;
  //Implementation
  static _ContentInformation? getInformation(dynamic obj) {
    _ContentInformation? result;
    if (obj == null || obj is _ContentInformation) {
      result = obj as _ContentInformation?;
    } else if (obj is _Asn1Sequence) {
      result = _ContentInformation(obj);
    } else {
      throw ArgumentError.value(obj, 'obj', 'Invalid entry');
    }
    return result;
  }

  @override
  _Asn1 getAsn1() {
    final _Asn1EncodeCollection collection =
        _Asn1EncodeCollection(<_Asn1Encode?>[_contentType]);
    if (_content != null) {
      collection._encodableObjects.add(_DerTag(0, _content));
    }
    return _BerSequence(collection: collection);
  }
}

class _MacInformation extends _Asn1Encode {
  _MacInformation(_Asn1Sequence sequence) {
    _digest = _DigestInformation.getDigestInformation(sequence[0]);
    _value = (sequence[1]! as _Asn1Octet).getOctets();
    if (sequence.count == 3) {
      _count = (sequence[2]! as _DerInteger).value;
    } else {
      _count = BigInt.one;
    }
  }
  //Fields
  _DigestInformation? _digest;
  List<int>? _value;
  BigInt? _count;
  //Implementation
  static _MacInformation getInformation(dynamic obj) {
    _MacInformation result;
    if (obj is _MacInformation) {
      result = obj;
    } else if (obj is _Asn1Sequence) {
      result = _MacInformation(obj);
    } else {
      throw ArgumentError.value(obj, 'obj', 'Invalid entry');
    }
    return result;
  }

  @override
  _Asn1 getAsn1() {
    final _Asn1EncodeCollection collection =
        _Asn1EncodeCollection(<_Asn1Encode?>[_digest, _DerOctet(_value!)]);
    if (_count != BigInt.one) {
      collection._encodableObjects.add(_DerInteger.fromNumber(_count));
    }
    return _DerSequence(collection: collection);
  }
}

class _Algorithms extends _Asn1Encode {
  _Algorithms(_DerObjectID? objectID, [_Asn1Encode? parameters]) {
    _objectID = objectID;
    if (parameters != null) {
      _parameters = parameters;
      _parametersDefined = true;
    }
  }
  _Algorithms.fromSequence(_Asn1Sequence sequence) {
    if (sequence.count < 1 || sequence.count > 2) {
      throw ArgumentError.value('Invalid length in sequence');
    }
    _objectID = _DerObjectID.getID(sequence[0]);
    _parametersDefined = sequence.count == 2;
    if (_parametersDefined) {
      _parameters = sequence[1] as _Asn1Encode?;
    }
  }
  static _Algorithms? getAlgorithms(dynamic obj) {
    if (obj == null || obj is _Algorithms) {
      return obj as _Algorithms?;
    }
    if (obj is _DerObjectID) {
      return _Algorithms(obj);
    }
    if (obj is String) {
      return _Algorithms(_DerObjectID(obj));
    }
    return _Algorithms.fromSequence(_Asn1Sequence.getSequence(obj)!);
  }

  late _Asn1Sequence _sequence;
  _DerObjectID? _objectID;
  _Asn1Encode? _parameters;
  bool _parametersDefined = false;
  //Implementation
  List<int>? asnEncode() {
    return _sequence.asnEncode();
  }

  @override
  _Asn1 getAsn1() {
    final _Asn1EncodeCollection collection =
        _Asn1EncodeCollection(<_Asn1Encode?>[_objectID]);
    if (_parametersDefined) {
      collection._encodableObjects.add(_parameters ?? _DerNull.value);
    }
    return _DerSequence(collection: collection);
  }
}

class _DigestInformation extends _Asn1Encode {
  _DigestInformation(_Algorithms? algorithms, List<int>? bytes) {
    _bytes = bytes;
    _algorithms = algorithms;
  }
  _DigestInformation.fromSequence(_Asn1Sequence sequence) {
    if (sequence.count != 2) {
      throw ArgumentError.value('Invalid length in sequence');
    }
    _algorithms = _Algorithms.getAlgorithms(sequence[0]);
    _bytes = _Asn1Octet.getOctetStringFromObject(sequence[1])!.getOctets();
  }

  //Fields
  _Algorithms? _algorithms;
  List<int>? _bytes;

  static _DigestInformation getDigestInformation(dynamic obj) {
    _DigestInformation result;
    if (obj is _DigestInformation) {
      result = obj;
    } else if (obj is _Asn1Sequence) {
      result = _DigestInformation.fromSequence(obj);
    } else {
      throw ArgumentError.value(obj, 'obj', 'Invalid entry');
    }
    return result;
  }

  @override
  _Asn1 getAsn1() {
    return _DerSequence(array: <_Asn1Encode?>[_algorithms, _DerOctet(_bytes!)]);
  }
}

class _EncryptedPrivateKey extends _Asn1Encode {
  _EncryptedPrivateKey(_Asn1Sequence sequence) {
    if (sequence.count != 2) {
      throw ArgumentError.value(
          sequence, 'sequence', 'Invalid length in sequence');
    }
    _algorithms = _Algorithms.getAlgorithms(sequence[0]);
    _octet = _Asn1Octet.getOctetStringFromObject(sequence[1]);
  }

  //Fields
  _Algorithms? _algorithms;
  _Asn1Octet? _octet;

  //Implementation
  @override
  _Asn1 getAsn1() {
    return _DerSequence(array: <_Asn1Encode?>[_algorithms, _octet]);
  }

  static _EncryptedPrivateKey getEncryptedPrivateKeyInformation(dynamic obj) {
    if (obj is _EncryptedPrivateKey) {
      return obj;
    }
    if (obj is _Asn1Sequence) {
      return _EncryptedPrivateKey(obj);
    }
    throw ArgumentError.value(obj, 'obj', 'Invalid entry in sequence');
  }
}

class _KeyInformation extends _Asn1Encode {
  _KeyInformation(_Algorithms algorithms, _Asn1 privateKey,
      [_Asn1Set? attributes]) {
    _privateKey = privateKey;
    _algorithms = algorithms;
    if (attributes != null) {
      _attributes = attributes;
    }
  }
  _KeyInformation.fromSequence(_Asn1Sequence? sequence) {
    if (sequence != null) {
      final List<dynamic> objects = sequence._objects!;
      if (objects.length >= 3) {
        _algorithms = _Algorithms.getAlgorithms(objects[1]);
        final dynamic privateKeyValue = objects[2];
        try {
          _privateKey = _Asn1Stream(_StreamReader(privateKeyValue.getOctets()))
              .readAsn1();
        } catch (e) {
          throw ArgumentError.value(sequence, 'sequence', 'Invalid sequence');
        }
        if (objects.length > 3) {
          _attributes = _Asn1Set.getAsn1Set(objects[3]! as _Asn1Tag?, false);
        }
      } else {
        throw ArgumentError.value(sequence, 'sequence', 'Invalid sequence');
      }
    }
  }

  //Fields
  _Asn1? _privateKey;
  _Algorithms? _algorithms;
  _Asn1Set? _attributes;

  //Implementation
  static _KeyInformation? getInformation(dynamic obj) {
    if (obj is _KeyInformation) {
      return obj;
    }
    if (obj != null) {
      return _KeyInformation.fromSequence(_Asn1Sequence.getSequence(obj));
    }
    return null;
  }

  @override
  _Asn1 getAsn1() {
    final _Asn1EncodeCollection v = _Asn1EncodeCollection(<_Asn1Encode?>[
      _DerInteger.fromNumber(BigInt.from(0)),
      _algorithms,
      _DerOctet.fromObject(_privateKey!)
    ]);
    if (_attributes != null) {
      v._encodableObjects.add(_DerTag(0, _attributes, false));
    }
    return _DerSequence(collection: v);
  }
}

class _RsaKey extends _Asn1Encode {
  _RsaKey(
      BigInt modulus,
      BigInt publicExponent,
      BigInt privateExponent,
      BigInt prime1,
      BigInt prime2,
      BigInt exponent1,
      BigInt exponent2,
      BigInt coefficient) {
    _modulus = modulus;
    _publicExponent = publicExponent;
    _privateExponent = privateExponent;
    _prime1 = prime1;
    _prime2 = prime2;
    _exponent1 = exponent1;
    _exponent2 = exponent2;
    _coefficient = coefficient;
  }
  _RsaKey.fromSequence(_Asn1Sequence sequence) {
    final BigInt version = (sequence[0]! as _DerInteger).value;
    if (version.toSigned(32).toInt() != 0) {
      throw ArgumentError.value(sequence, 'sequence', 'Invalid RSA key');
    }
    _modulus = (sequence[1]! as _DerInteger).value;
    _publicExponent = (sequence[2]! as _DerInteger).value;
    _privateExponent = (sequence[3]! as _DerInteger).value;
    _prime1 = (sequence[4]! as _DerInteger).value;
    _prime2 = (sequence[5]! as _DerInteger).value;
    _exponent1 = (sequence[6]! as _DerInteger).value;
    _exponent2 = (sequence[7]! as _DerInteger).value;
    _coefficient = (sequence[8]! as _DerInteger).value;
  }
  BigInt? _modulus;
  BigInt? _publicExponent;
  BigInt? _privateExponent;
  BigInt? _prime1;
  BigInt? _prime2;
  BigInt? _exponent1;
  BigInt? _exponent2;
  BigInt? _coefficient;
  @override
  _Asn1 getAsn1() {
    return _DerSequence(array: <_Asn1Encode>[
      _DerInteger.fromNumber(BigInt.from(0)),
      _DerInteger.fromNumber(_modulus),
      _DerInteger.fromNumber(_publicExponent),
      _DerInteger.fromNumber(_privateExponent),
      _DerInteger.fromNumber(_prime1),
      _DerInteger.fromNumber(_prime2),
      _DerInteger.fromNumber(_exponent1),
      _DerInteger.fromNumber(_exponent2),
      _DerInteger.fromNumber(_coefficient)
    ]);
  }
}

// ignore: avoid_classes_with_only_static_members
class _PkcsObjectId {
  static const String pkcs1 = '1.2.840.113549.1.1';
  static const String encryptionAlgorithm = '1.2.840.113549.3';
  static const String pkcs7 = '1.2.840.113549.1.7';
  static const String pkcs9 = '1.2.840.113549.1.9';
  static const String pkcs12 = '1.2.840.113549.1.12';
  static const String bagTypes = pkcs12 + '.10.1';
  static const String pkcs12PbeIds = pkcs12 + '.1';
  static const String messageDigestAlgorithm = '1.2.840.113549.2';
  static _DerObjectID rsaEncryption = _DerObjectID(pkcs1 + '.1');
  static _DerObjectID md2WithRsaEncryption = _DerObjectID(pkcs1 + '.2');
  static _DerObjectID sha1WithRsaEncryption = _DerObjectID(pkcs1 + '.5');
  static _DerObjectID sha256WithRsaEncryption = _DerObjectID(pkcs1 + '.11');
  static _DerObjectID sha384WithRsaEncryption = _DerObjectID(pkcs1 + '.12');
  static _DerObjectID sha512WithRsaEncryption = _DerObjectID(pkcs1 + '.13');
  static _DerObjectID desEde3Cbc = _DerObjectID(encryptionAlgorithm + '.7');
  static _DerObjectID rc2Cbc = _DerObjectID(encryptionAlgorithm + '.2');
  static _DerObjectID data = _DerObjectID(pkcs7 + '.1');
  static _DerObjectID signedData = _DerObjectID(pkcs7 + '.2');
  static _DerObjectID encryptedData = _DerObjectID(pkcs7 + '.6');
  static _DerObjectID pkcs9AtEmailAddress = _DerObjectID(pkcs9 + '.1');
  static _DerObjectID pkcs9AtUnstructuredName = _DerObjectID(pkcs9 + '.2');
  static _DerObjectID pkcs9AtUnstructuredAddress = _DerObjectID(pkcs9 + '.8');
  static _DerObjectID pkcs9AtFriendlyName = _DerObjectID(pkcs9 + '.20');
  static _DerObjectID pkcs9AtLocalKeyID = _DerObjectID(pkcs9 + '.21');
  static _DerObjectID keyBag = _DerObjectID(bagTypes + '.1');
  static _DerObjectID pkcs8ShroudedKeyBag = _DerObjectID(bagTypes + '.2');
  static _DerObjectID certBag = _DerObjectID(bagTypes + '.3');
  static _DerObjectID pbeWithShaAnd128BitRC4 =
      _DerObjectID(pkcs12PbeIds + '.1');
  static _DerObjectID pbeWithShaAnd40BitRC4 = _DerObjectID(pkcs12PbeIds + '.2');
  static _DerObjectID pbeWithShaAnd3KeyTripleDesCbc =
      _DerObjectID(pkcs12PbeIds + '.3');
  static _DerObjectID pbeWithShaAnd2KeyTripleDesCbc =
      _DerObjectID(pkcs12PbeIds + '.4');
  static _DerObjectID pbeWithShaAnd128BitRC2Cbc =
      _DerObjectID(pkcs12PbeIds + '.5');
  static _DerObjectID pbewithShaAnd40BitRC2Cbc =
      _DerObjectID(pkcs12PbeIds + '.6');
  static _DerObjectID idAlgCms3DesWrap =
      _DerObjectID('1.2.840.113549.1.9.16.3.6');
  static _DerObjectID idAlgCmsRC2Wrap =
      _DerObjectID('1.2.840.113549.1.9.16.3.7');
  static _DerObjectID md5 = _DerObjectID(messageDigestAlgorithm + '5');
}

// ignore: avoid_classes_with_only_static_members
class _NistObjectIds {
  static _DerObjectID nistAlgorithm = _DerObjectID('2.16.840.1.101.3.4');
  static _DerObjectID hashAlgs = _DerObjectID(nistAlgorithm._id! + '.2');
  static _DerObjectID sha256 = _DerObjectID(hashAlgs._id! + '.1');
  static _DerObjectID sha384 = _DerObjectID(hashAlgs._id! + '.2');
  static _DerObjectID sha512 = _DerObjectID(hashAlgs._id! + '.3');
  static _DerObjectID dsaWithSHA2 = _DerObjectID(nistAlgorithm._id! + '.3');
  static _DerObjectID dsaWithSHA256 = _DerObjectID(dsaWithSHA2._id! + '.2');
  static _DerObjectID tttAlgorithm = _DerObjectID('1.3.36.3');
  static _DerObjectID ripeMD160 = _DerObjectID(tttAlgorithm._id! + '.2.1');
  static _DerObjectID tttRsaSignatureAlgorithm =
      _DerObjectID(tttAlgorithm._id! + '.3.1');
  static _DerObjectID rsaSignatureWithRipeMD160 =
      _DerObjectID(tttRsaSignatureAlgorithm._id! + '.2');
}

// ignore: avoid_classes_with_only_static_members
class _X509Objects {
  static const String id = '2.5.4';
  static _DerObjectID telephoneNumberID = _DerObjectID(id + '.20');
  static _DerObjectID idSha1 = _DerObjectID('1.3.14.3.2.26');
  static _DerObjectID idEARsa = _DerObjectID('2.5.8.1.1');
}
