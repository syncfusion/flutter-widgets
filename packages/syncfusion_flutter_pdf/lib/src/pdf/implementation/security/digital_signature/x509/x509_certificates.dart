part of pdf;

class _IX509Extension {
  _Asn1Octet? getExtension(_DerObjectID id) => null;
}

class _X509Certificates {
  _X509Certificates(_X509Certificate certificate) {
    _certificate = certificate;
  }
  //Fields
  _X509Certificate? _certificate;
  //Properties
  _X509Certificate? get certificate => _certificate;
  @override
  int get hashCode => _certificate.hashCode;
  @override
  bool operator ==(Object other) {
    if (other is _X509Certificates) {
      return _certificate == other._certificate;
    } else {
      return false;
    }
  }
}

abstract class _X509ExtensionBase implements _IX509Extension {
  _X509Extensions? getX509Extensions();
  @override
  _Asn1Octet? getExtension(_DerObjectID oid) {
    final _X509Extensions? exts = getX509Extensions();
    if (exts != null) {
      final _X509Extension? ext = exts.getExtension(oid);
      if (ext != null) {
        return ext._value;
      }
    }
    return null;
  }
}

class _X509Extension {
  _X509Extension(bool critical, _Asn1Octet? value) {
    _critical = critical;
    _value = value;
  }
  //Fields
  bool? _critical;
  _Asn1Octet? _value;
  //Implementation
  static _Asn1? convertValueToObject(_X509Extension ext) {
    return _Asn1Stream(_StreamReader(ext._value!.getOctets())).readAsn1();
  }

  @override
  bool operator ==(Object other) {
    if (other is _X509Extension) {
      return _value == other._value && _critical == other._critical;
    } else {
      return false;
    }
  }

  @override
  int get hashCode => _critical! ? _value.hashCode : ~_value.hashCode;
}

class _X509Extensions extends _Asn1Encode {
  _X509Extensions(Map<_DerObjectID, _X509Extension> extensions,
      [List<_DerObjectID?>? ordering]) {
    _extensions = <_DerObjectID?, _X509Extension?>{};
    if (ordering == null) {
      final List<_DerObjectID?> der = <_DerObjectID?>[];
      extensions.keys.forEach((col) {
        der.add(col);
      });
      _ordering = der;
    } else {
      _ordering = ordering;
    }
    _ordering.forEach((oid) {
      _extensions[oid] = extensions[oid!];
    });
  }
  _X509Extensions.fromSequence(_Asn1Sequence seq) {
    _ordering = <_DerObjectID?>[];
    _extensions = <_DerObjectID?, _X509Extension?>{};
    for (int i = 0; i < seq._objects!.length; i++) {
      final _Asn1Encode ae = seq._objects![i];
      final _Asn1Sequence s = _Asn1Sequence.getSequence(ae.getAsn1())!;
      if (s.count < 2 || s.count > 3) {
        throw ArgumentError.value(
            seq, 'count', 'Bad sequence size: ' + s.count.toString());
      }
      final _DerObjectID? oid = _DerObjectID.getID(s[0]!.getAsn1());
      final bool isCritical =
          s.count == 3 && (s[1]!.getAsn1() as _DerBoolean).isTrue;
      final _Asn1Octet? octets =
          _Asn1Octet.getOctetStringFromObject(s[s.count - 1]!.getAsn1());
      _extensions[oid] = _X509Extension(isCritical, octets);
      _ordering.add(oid);
    }
  }
  static _X509Extensions? getInstance(dynamic obj, [bool? explicitly]) {
    _X509Extensions? result;
    if (explicitly == null) {
      if (obj == null || obj is _X509Extensions) {
        result = obj;
      } else if (obj is _Asn1Sequence) {
        result = _X509Extensions.fromSequence(obj);
      } else if (obj is _Asn1Tag) {
        result = getInstance(obj.getObject());
      } else {
        throw ArgumentError.value(obj, 'obj', 'unknown object in factory');
      }
    } else {
      result = getInstance(_Asn1Sequence.getSequence(obj, explicitly));
    }
    return result;
  }

  //Fields
  late Map<_DerObjectID?, _X509Extension?> _extensions;
  late List<_DerObjectID?> _ordering;
  static _DerObjectID authorityKeyIdentifier = _DerObjectID('2.5.29.35');
  //Implementation
  @override
  _Asn1 getAsn1() {
    final _Asn1EncodeCollection vec = _Asn1EncodeCollection();
    _ordering.forEach((oid) {
      final _X509Extension ext = _extensions[oid]!;
      final _Asn1EncodeCollection v =
          _Asn1EncodeCollection(<_Asn1Encode?>[oid]);
      if (ext._critical!) {
        v._encodableObjects.add(_DerBoolean(true));
      }
      v._encodableObjects.add(ext._value);
      vec._encodableObjects.add(_DerSequence(collection: v));
    });
    return _DerSequence(collection: vec);
  }

  _X509Extension? getExtension(_DerObjectID oid) {
    return (_extensions.containsKey(oid)) ? _extensions[oid] : null;
  }
}

class _X509Certificate extends _X509ExtensionBase {
  _X509Certificate(_X509CertificateStructure? c) {
    _c = c;
    try {
      final _Asn1Octet? str = getExtension(_DerObjectID('2.5.29.15'));
      if (str != null) {
        final _DerBitString bits = _DerBitString.getDetBitString(
            _Asn1Stream(_StreamReader(str.getOctets())).readAsn1())!;
        final List<int> bytes = bits.getBytes()!;
        final int length = (bytes.length * 8) - bits._extra!;
        _keyUsage =
            List<bool>.generate((length < 9) ? 9 : length, (i) => false);
        for (int i = 0; i != length; i++) {
          _keyUsage![i] = (bytes[i ~/ 8] & (0x80 >> (i % 8))) != 0;
        }
      } else {
        _keyUsage = null;
      }
    } catch (e) {
      throw ArgumentError.value(
          e, 'ArgumentError', 'cannot construct KeyUsage');
    }
  }
  //Fields
  _X509CertificateStructure? _c;
  List<bool>? _keyUsage;
  //Implementation
  @override
  _X509Extensions? getX509Extensions() {
    return _c!.version == 3 ? _c!.tbsCertificate!.extensions : null;
  }

  _CipherParameter getPublicKey() {
    return createKey(_c!.subjectPublicKeyInfo!);
  }

  _CipherParameter createKey(_PublicKeyInformation keyInfo) {
    _CipherParameter result;
    final _Algorithms algID = keyInfo.algorithm!;
    final _DerObjectID algOid = algID._objectID!;
    if (algOid._id == _PkcsObjectId.rsaEncryption._id ||
        algOid._id == _X509Objects.idEARsa._id) {
      final _RsaPublicKey pubKey =
          _RsaPublicKey.getPublicKey(keyInfo.getPublicKey())!;
      result = _RsaKeyParam(false, pubKey.modulus, pubKey.publicExponent);
    } else {
      throw ArgumentError.value(
          keyInfo, 'keyInfo', 'algorithm identifier in key not recognised');
    }
    return result;
  }
}

class _X509CertificateStructure extends _Asn1Encode {
  _X509CertificateStructure(_Asn1Sequence seq) {
    _tbsCert = _SingnedCertificate.getCertificate(seq[0]);
    _sigAlgID = _Algorithms.getAlgorithms(seq[1]);
    _sig = _DerBitString.getDetBitString(seq[2]);
  }
  //Fields
  _SingnedCertificate? _tbsCert;
  _Algorithms? _sigAlgID;
  _DerBitString? _sig;
  //Properties
  _SingnedCertificate? get tbsCertificate => _tbsCert;
  int get version => _tbsCert!.version;
  _DerInteger? get serialNumber => _tbsCert!.serialNumber;
  _X509Name? get issuer => _tbsCert!.issuer;
  _X509Time? get startDate => _tbsCert!.startDate;
  _X509Time? get endDate => _tbsCert!.endDate;
  _X509Name? get subject => _tbsCert!.subject;
  _PublicKeyInformation? get subjectPublicKeyInfo =>
      _tbsCert!.subjectPublicKeyInfo;
  _Algorithms? get signatureAlgorithm => _sigAlgID;
  _DerBitString? get signature => _sig;
  //Implementation
  static _X509CertificateStructure? getInstance(dynamic obj) {
    if (obj is _X509CertificateStructure) {
      return obj;
    }
    if (obj != null) {
      return _X509CertificateStructure(_Asn1Sequence.getSequence(obj)!);
    }
    return null;
  }

  @override
  _Asn1 getAsn1() {
    return _DerSequence(array: <_Asn1Encode?>[_tbsCert, _sigAlgID, _sig]);
  }
}

class _SingnedCertificate extends _Asn1Encode {
  _SingnedCertificate(_Asn1Sequence sequence) {
    int seqStart = 0;
    _sequence = sequence;
    if (sequence[0] is _DerTag || sequence[0] is _Asn1Tag) {
      _version = _DerInteger.getNumberFromTag(sequence[0] as _Asn1Tag, true);
    } else {
      seqStart = -1;
      _version = _DerInteger(_bigIntToBytes(BigInt.from(0)));
    }
    _serialNumber = _DerInteger.getNumber(sequence[seqStart + 1]);
    _signature = _Algorithms.getAlgorithms(sequence[seqStart + 2]);
    _issuer = _X509Name.getName(sequence[seqStart + 3]);
    final _Asn1Sequence dates = sequence[seqStart + 4] as _Asn1Sequence;
    _startDate = _X509Time.getTime(dates[0]);
    _endDate = _X509Time.getTime(dates[1]);
    _subject = _X509Name.getName(sequence[seqStart + 5]);
    _publicKeyInformation =
        _PublicKeyInformation.getPublicKeyInformation(sequence[seqStart + 6]);
    for (int extras = sequence.count - (seqStart + 6) - 1;
        extras > 0;
        extras--) {
      final _Asn1Tag extra = sequence[seqStart + 6 + extras] as _Asn1Tag;
      switch (extra.tagNumber) {
        case 1:
          _issuerID = _DerBitString.getDerBitStringFromTag(extra, false);
          break;
        case 2:
          _subjectID = _DerBitString.getDerBitStringFromTag(extra, false);
          break;
        case 3:
          _extensions = _X509Extensions.getInstance(extra);
          break;
      }
    }
  }
  static _SingnedCertificate? getCertificate(dynamic obj) {
    if (obj is _SingnedCertificate) {
      return obj;
    }
    if (obj != null) {
      return _SingnedCertificate(_Asn1Sequence.getSequence(obj)!);
    }
    return null;
  }

  //Fields
  _Asn1Sequence? _sequence;
  _DerInteger? _version;
  _DerInteger? _serialNumber;
  _Algorithms? _signature;
  _X509Name? _issuer;
  _X509Time? _startDate;
  _X509Time? _endDate;
  _X509Name? _subject;
  _PublicKeyInformation? _publicKeyInformation;
  _DerBitString? _issuerID;
  _DerBitString? _subjectID;
  _X509Extensions? _extensions;
  //Properties
  int get version => _version!.value.toSigned(32).toInt() + 1;
  _DerInteger? get serialNumber => _serialNumber;
  _Algorithms? get signature => _signature;
  _X509Name? get issuer => _issuer;
  _X509Time? get startDate => _startDate;
  _X509Time? get endDate => _endDate;
  _X509Name? get subject => _subject;
  _PublicKeyInformation? get subjectPublicKeyInfo => _publicKeyInformation;
  _DerBitString? get issuerUniqueID => _issuerID;
  _DerBitString? get subjectUniqueID => _subjectID;
  _X509Extensions? get extensions => _extensions;
  //Implementation
  @override
  _Asn1? getAsn1() {
    return _sequence;
  }
}

class _PublicKeyInformation extends _Asn1Encode {
  _PublicKeyInformation(_Algorithms algorithms, _Asn1Encode publicKey) {
    _publicKey = _DerBitString.fromAsn1(publicKey);
    _algorithms = algorithms;
  }
  _PublicKeyInformation.fromSequence(_Asn1Sequence sequence) {
    if (sequence.count != 2) {
      throw ArgumentError.value(
          sequence, 'sequence', 'Invalid length in sequence');
    }
    _algorithms = _Algorithms.getAlgorithms(sequence[0]);
    _publicKey = _DerBitString.getDetBitString(sequence[1]);
  }
  static _PublicKeyInformation? getPublicKeyInformation(dynamic obj) {
    if (obj is _PublicKeyInformation) {
      return obj;
    }
    if (obj != null) {
      return _PublicKeyInformation.fromSequence(
          _Asn1Sequence.getSequence(obj)!);
    }
    return null;
  }

  _Algorithms? _algorithms;
  _DerBitString? _publicKey;
  _Algorithms? get algorithm => _algorithms;
  _DerBitString? get publicKey => _publicKey;
  //Implementation
  _Asn1? getPublicKey() {
    return _Asn1Stream(_StreamReader(_publicKey!.getBytes())).readAsn1();
  }

  @override
  _Asn1 getAsn1() {
    return _DerSequence(array: <_Asn1Encode?>[_algorithms, _publicKey]);
  }
}

class _RsaPublicKey extends _Asn1Encode {
  _RsaPublicKey(BigInt? modulus, BigInt? publicExponent) {
    _modulus = modulus;
    _publicExponent = publicExponent;
  }
  _RsaPublicKey.fromSequence(_Asn1Sequence sequence) {
    _modulus = _DerInteger.getNumber(sequence[0])!.positiveValue;
    _publicExponent = _DerInteger.getNumber(sequence[1])!.positiveValue;
  }
  BigInt? _modulus;
  BigInt? _publicExponent;
  BigInt? get modulus => _modulus;
  BigInt? get publicExponent => _publicExponent;
  static _RsaPublicKey? getPublicKey(dynamic obj) {
    _RsaPublicKey? result;
    if (obj == null || obj is _RsaPublicKey) {
      result = obj;
    } else if (obj is _Asn1Sequence) {
      result = _RsaPublicKey.fromSequence(obj);
    } else {
      throw ArgumentError.value(obj, 'obj', 'Invalid entry');
    }
    return result;
  }

  @override
  _Asn1 getAsn1() {
    return _DerSequence(array: <_Asn1Encode>[
      _DerInteger.fromNumber(modulus),
      _DerInteger.fromNumber(publicExponent)
    ]);
  }
}

class _SubjectKeyID extends _Asn1Encode {
  _SubjectKeyID(dynamic obj) {
    if (obj is _Asn1Octet) {
      _bytes = obj.getOctets();
    } else if (obj is _PublicKeyInformation) {
      _bytes = getDigest(obj);
    }
  }

  List<int>? _bytes;
  //Implementation
  static List<int> getDigest(_PublicKeyInformation publicKey) {
    return sha1.convert(publicKey.publicKey!._data as List<int>).bytes;
  }

  @override
  _Asn1 getAsn1() {
    return _DerOctet(_bytes!);
  }
}

class _X509CertificateParser {
  _X509CertificateParser() {}
  //Fields
  _Asn1Set? _sData;
  int? _sDataObjectCount;
  _StreamReader? _currentStream;
  //Implementation
  _X509Certificate? readCertificate(_StreamReader inStream) {
    if (_currentStream == null) {
      _currentStream = inStream;
      _sData = null;
      _sDataObjectCount = 0;
    } else if (_currentStream != inStream) {
      _currentStream = inStream;
      _sData = null;
      _sDataObjectCount = 0;
    }
    if (_sData != null) {
      if (_sDataObjectCount != _sData!._objects.length) {
        return getCertificate();
      }
      _sData = null;
      _sDataObjectCount = 0;
      return null;
    }
    final _PushStream pis = _PushStream(inStream);
    final int tag = pis.readByte()!;
    if (tag < 0) {
      return null;
    }
    pis.unread(tag);
    return readDerCertificate(_Asn1Stream(pis));
  }

  _X509Certificate? getCertificate() {
    if (_sData != null) {
      while (_sDataObjectCount! < _sData!._objects.length) {
        final dynamic obj = _sData![_sDataObjectCount!];
        _sDataObjectCount = _sDataObjectCount! + 1;
        if (obj is _Asn1Sequence) {
          return createX509Certificate(
              _X509CertificateStructure.getInstance(obj));
        }
      }
    }
    return null;
  }

  _X509Certificate? readDerCertificate(_Asn1Stream dIn) {
    final dynamic seq = dIn.readAsn1();
    if (seq != null && seq is _Asn1Sequence) {
      if (seq.count > 1 && seq[0] is _DerObjectID) {
        if ((seq[0] as _DerObjectID)._id == _PkcsObjectId.signedData._id) {
          if (seq.count >= 2) {
            final _Asn1Sequence signedSequence =
                _Asn1Sequence.getSequence(seq[1] as _Asn1Tag?, true)!;
            bool isContinue = true;
            signedSequence._objects!.forEach((o) {
              if (isContinue && o is _Asn1Tag) {
                if (o.tagNumber == 0) {
                  _sData = _Asn1Set.getAsn1Set(o, false);
                  isContinue = false;
                }
              }
            });
          }
          return getCertificate();
        }
      }
    }
    return createX509Certificate(_X509CertificateStructure.getInstance(seq));
  }

  _X509Certificate createX509Certificate(_X509CertificateStructure? c) {
    return _X509Certificate(c);
  }
}
