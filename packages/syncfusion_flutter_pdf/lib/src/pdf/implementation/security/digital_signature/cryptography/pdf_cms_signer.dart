part of pdf;

class _PdfCmsSigner {
  _PdfCmsSigner(
      _ICipherParameter? privateKey,
      List<_X509Certificate?> certChain,
      String hashAlgorithm,
      bool hasRSAdata) {
    _digestAlgorithm = _MessageDigestAlgorithms();
    _digestAlgorithmOid = _digestAlgorithm.getAllowedDigests(hashAlgorithm);
    if (_digestAlgorithmOid == null) {
      throw ArgumentError.value(
          hashAlgorithm, 'hashAlgorithm', 'Unknown Hash Algorithm');
    }
    _version = 1;
    _signerVersion = 1;
    _certificates = List<_X509Certificate?>.generate(
        certChain.length, (int i) => certChain[i]);
    _digestOid = <String?, Object?>{};
    _digestOid[_digestAlgorithmOid] = null;
    _signCert = _certificates[0];
    if (privateKey != null) {
      if (privateKey is _RsaKeyParam) {
        _encryptionAlgorithmOid = _DigitalIdentifiers.rsa;
      } else {
        throw ArgumentError.value(
            privateKey, 'privateKey', 'Unknown key algorithm');
      }
    }
    if (hasRSAdata) {
      _rsaData = <int>[];
    }
  }

  //Fields
  late _MessageDigestAlgorithms _digestAlgorithm;
  late int _version;
  late int _signerVersion;
  late List<_X509Certificate?> _certificates;
  late Map<String?, Object?> _digestOid;
  String? _digestAlgorithmOid;
  _X509Certificate? _signCert;
  late String _encryptionAlgorithmOid;
  String? _hashAlgorithm;
  List<int>? _rsaData;
  List<int>? _signedData;
  List<int>? _signedRsaData;
  List<int>? _digest;

  //Properties
  String? get hashAlgorithm {
    _hashAlgorithm ??= _digestAlgorithm.getDigest(_digestAlgorithmOid);
    return _hashAlgorithm;
  }

  //Implementation
  _DerSet getSequenceDataSet(List<int> secondDigest, List<int>? ocsp,
      List<List<int>>? crlBytes, CryptographicStandard? sigtype) {
    final _Asn1EncodeCollection attribute = _Asn1EncodeCollection();
    _Asn1EncodeCollection v = _Asn1EncodeCollection();
    v._encodableObjects.add(_DerObjectID(_DigitalIdentifiers.contentType));
    v._encodableObjects.add(_DerSet(
        array: <_Asn1Encode>[_DerObjectID(_DigitalIdentifiers.pkcs7Data)]));
    attribute._encodableObjects.add(_DerSequence(collection: v));
    v = _Asn1EncodeCollection();
    v._encodableObjects.add(_DerObjectID(_DigitalIdentifiers.messageDigest));
    v._encodableObjects
        .add(_DerSet(array: <_Asn1Encode>[_DerOctet(secondDigest)]));
    attribute._encodableObjects.add(_DerSequence(collection: v));
    if (sigtype == CryptographicStandard.cades) {
      v = _Asn1EncodeCollection();
      v._encodableObjects
          .add(_DerObjectID(_DigitalIdentifiers.aaSigningCertificateV2));
      final _Asn1EncodeCollection aaV2 = _Asn1EncodeCollection();
      final _MessageDigestAlgorithms alg = _MessageDigestAlgorithms();
      final String? sha256Oid =
          alg.getAllowedDigests(_MessageDigestAlgorithms.secureHash256);
      if (sha256Oid != _digestAlgorithmOid) {
        aaV2._encodableObjects
            .add(_Algorithms(_DerObjectID(_digestAlgorithmOid!)));
      }
      final List<int> dig = alg
          .getMessageDigest(hashAlgorithm!)
          .convert(_signCert!._c!.getEncoded(_Asn1.der))
          .bytes as List<int>;
      aaV2._encodableObjects.add(_DerOctet(dig));
      v._encodableObjects.add(_DerSet(array: <_Asn1Encode>[
        _DerSequence.fromObject(
            _DerSequence.fromObject(_DerSequence(collection: aaV2)))
      ]));
      attribute._encodableObjects.add(_DerSequence(collection: v));
    }
    return _DerSet(collection: attribute);
  }

  void setSignedData(
      List<int> digest, List<int>? rsaData, String? digestEncryptionAlgorithm) {
    _signedData = digest;
    _signedRsaData = rsaData;
    if (digestEncryptionAlgorithm != null) {
      if (digestEncryptionAlgorithm == 'RSA') {
        _encryptionAlgorithmOid = _DigitalIdentifiers.rsa;
      } else if (digestEncryptionAlgorithm == 'DSA') {
        _encryptionAlgorithmOid = _DigitalIdentifiers.dsa;
      } else if (digestEncryptionAlgorithm == 'ECDSA') {
        _encryptionAlgorithmOid = _DigitalIdentifiers.ecdsa;
      } else {
        throw ArgumentError.value(
            digestEncryptionAlgorithm, 'algorithm', 'Invalid entry');
      }
    }
  }

  List<int>? sign(
      List<int> secondDigest,
      dynamic server,
      List<int>? timeStampResponse,
      List<int>? ocsp,
      List<List<int>>? crls,
      CryptographicStandard? sigtype,
      String? hashAlgorithm) {
    if (_signedData != null) {
      _digest = _signedData;
      if (_rsaData != null) {
        _rsaData = _signedRsaData;
      }
    }
    final _Asn1EncodeCollection digestAlgorithms = _Asn1EncodeCollection();
    final List<String?> keys = _digestOid.keys.toList();
    // ignore: avoid_function_literals_in_foreach_calls
    keys.forEach((String? dal) {
      final _Asn1EncodeCollection algos = _Asn1EncodeCollection();
      algos._encodableObjects.add(_DerObjectID(dal!));
      algos._encodableObjects.add(_DerNull.value);
      digestAlgorithms._encodableObjects.add(_DerSequence(collection: algos));
    });
    _Asn1EncodeCollection v = _Asn1EncodeCollection();
    v._encodableObjects.add(_DerObjectID(_DigitalIdentifiers.pkcs7Data));
    if (_rsaData != null) {
      v._encodableObjects.add(_DerTag(0, _DerOctet(_rsaData!)));
    }
    final _DerSequence contentinfo = _DerSequence(collection: v);

    v = _Asn1EncodeCollection();
    // ignore: avoid_function_literals_in_foreach_calls
    _certificates.forEach((_X509Certificate? xcert) {
      v._encodableObjects.add(
          _Asn1Stream(_StreamReader(xcert!._c!.getEncoded(_Asn1.der)))
              .readAsn1());
    });
    final _DerSet dercertificates = _DerSet(collection: v);
    final _Asn1EncodeCollection signerinfo = _Asn1EncodeCollection();
    signerinfo._encodableObjects
        .add(_DerInteger(_bigIntToBytes(BigInt.from(_signerVersion))));
    v = _Asn1EncodeCollection();
    v._encodableObjects
        .add(getIssuer(_signCert!._c!.tbsCertificate!.getEncoded(_Asn1.der)));
    v._encodableObjects
        .add(_DerInteger(_bigIntToBytes(_signCert!._c!.serialNumber!.value)));
    signerinfo._encodableObjects.add(_DerSequence(collection: v));
    v = _Asn1EncodeCollection();
    v._encodableObjects.add(_DerObjectID(_digestAlgorithmOid!));
    v._encodableObjects.add(_DerNull.value);
    signerinfo._encodableObjects.add(_DerSequence(collection: v));
    signerinfo._encodableObjects.add(_DerTag(
        0, getSequenceDataSet(secondDigest, ocsp, crls, sigtype), false));
    v = _Asn1EncodeCollection();
    v._encodableObjects.add(_DerObjectID(_encryptionAlgorithmOid));
    v._encodableObjects.add(_DerNull.value);
    signerinfo._encodableObjects.add(_DerSequence(collection: v));
    signerinfo._encodableObjects.add(_DerOctet(_digest!));
    final _Asn1EncodeCollection body = _Asn1EncodeCollection();
    body._encodableObjects
        .add(_DerInteger(_bigIntToBytes(BigInt.from(_version))));
    body._encodableObjects.add(_DerSet(collection: digestAlgorithms));
    body._encodableObjects.add(contentinfo);
    body._encodableObjects.add(_DerTag(0, dercertificates, false));
    body._encodableObjects.add(
        _DerSet(array: <_Asn1Encode>[_DerSequence(collection: signerinfo)]));
    final _Asn1EncodeCollection whole = _Asn1EncodeCollection();
    whole._encodableObjects
        .add(_DerObjectID(_DigitalIdentifiers.pkcs7SignedData));
    whole._encodableObjects.add(_DerTag(0, _DerSequence(collection: body)));
    final _Asn1DerStream dout = _Asn1DerStream(<int>[]);
    dout.writeObject(_DerSequence(collection: whole));
    return dout._stream;
  }

  _Asn1? getIssuer(List<int>? data) {
    final _Asn1Sequence seq =
        _Asn1Stream(_StreamReader(data)).readAsn1()! as _Asn1Sequence;
    return seq[seq[0] is _Asn1Tag ? 3 : 2] as _Asn1?;
  }
}
