part of pdf;

class _PdfPKCSCertificate {
  _PdfPKCSCertificate(List<int> certificateBytes, String password) {
    _keys = _CertificateTable();
    _certificates = _CertificateTable();
    _localIdentifiers = <String?, String>{};
    _chainCertificates = <_CertificateIdentifier, _X509Certificates>{};
    _keyCertificates = <String, _X509Certificates>{};
    _loadCertificate(certificateBytes, password);
  }

  //Fields
  late _CertificateTable _keys;
  late _CertificateTable _certificates;
  late Map<String?, String> _localIdentifiers;
  late Map<_CertificateIdentifier, _X509Certificates> _chainCertificates;
  late Map<String, _X509Certificates> _keyCertificates;

  //Implementation
  void _loadCertificate(List<int> certificateBytes, String password) {
    final _Asn1Sequence sequence = _Asn1Stream(_StreamReader(certificateBytes))
        .readAsn1()! as _Asn1Sequence;
    final _PfxData pfxData = _PfxData(sequence);
    final _ContentInformation information = pfxData._contentInformation!;
    bool isUnmarkedKey = false;
    final bool isInvalidPassword = password.isEmpty;
    final List<_Asn1SequenceCollection> certificateChain =
        <_Asn1SequenceCollection>[];
    if (information._contentType!._id == _PkcsObjectId.data._id) {
      final List<int>? octs = (information._content! as _Asn1Octet).getOctets();
      final _Asn1Sequence asn1Sequence =
          (_Asn1Stream(_StreamReader(octs)).readAsn1())! as _Asn1Sequence;
      final List<_ContentInformation?> contentInformation =
          <_ContentInformation?>[];
      for (int i = 0; i < asn1Sequence.count; i++) {
        contentInformation
            .add(_ContentInformation.getInformation(asn1Sequence[i]));
      }
      // ignore: avoid_function_literals_in_foreach_calls
      contentInformation.forEach((_ContentInformation? entry) {
        final _DerObjectID type = entry!._contentType!;
        if (type._id == _PkcsObjectId.data._id) {
          final List<int>? octets = (entry._content! as _Asn1Octet).getOctets();
          final _Asn1Sequence asn1SubSequence =
              (_Asn1Stream(_StreamReader(octets)).readAsn1())! as _Asn1Sequence;
          for (int index = 0; index < asn1SubSequence.count; index++) {
            final dynamic subSequence = asn1SubSequence[index];
            if (subSequence != null && subSequence is _Asn1Sequence) {
              final _Asn1SequenceCollection subSequenceCollection =
                  _Asn1SequenceCollection(subSequence);
              if (subSequenceCollection._id!._id ==
                  _PkcsObjectId.pkcs8ShroudedKeyBag._id) {
                final _EncryptedPrivateKey encryptedInformation =
                    _EncryptedPrivateKey.getEncryptedPrivateKeyInformation(
                        subSequenceCollection._value);
                final _KeyInformation privateKeyInformation =
                    createPrivateKeyInfo(
                        password, isInvalidPassword, encryptedInformation)!;
                _RsaPrivateKeyParam? rsaparam;
                if (privateKeyInformation._algorithms!._objectID!._id ==
                        _PkcsObjectId.rsaEncryption._id ||
                    privateKeyInformation._algorithms!._objectID!._id ==
                        _X509Objects.idEARsa._id) {
                  final _RsaKey keyStructure = _RsaKey.fromSequence(
                      _Asn1Sequence.getSequence(
                          privateKeyInformation._privateKey)!);
                  rsaparam = _RsaPrivateKeyParam(
                      keyStructure._modulus,
                      keyStructure._publicExponent!,
                      keyStructure._privateExponent,
                      keyStructure._prime1!,
                      keyStructure._prime2!,
                      keyStructure._exponent1!,
                      keyStructure._exponent2!,
                      keyStructure._coefficient!);
                }
                final _CipherParameter? privateKey = rsaparam;
                final Map<String?, dynamic> attributes = <String?, dynamic>{};
                final _KeyEntry key = _KeyEntry(privateKey);
                String? localIdentifier;
                _Asn1Octet? localId;
                if (subSequenceCollection._attributes != null) {
                  final _Asn1Set sq = subSequenceCollection._attributes!;
                  for (int i = 0; i < sq._objects.length; i++) {
                    final _Asn1Encode? entry = sq._objects[i] as _Asn1Encode?;
                    if (entry is _Asn1Sequence) {
                      final _DerObjectID? algorithmId =
                          _DerObjectID.getID(entry[0]);
                      final _Asn1Set attributeSet = entry[1]! as _Asn1Set;
                      _Asn1Encode? attribute;
                      if (attributeSet._objects.isNotEmpty) {
                        attribute = attributeSet[0];
                        if (attributes.containsKey(algorithmId!._id)) {
                          if (attributes[algorithmId._id] != attribute) {
                            throw ArgumentError.value(attributes, 'attributes',
                                'attempt to add existing attribute with different value');
                          }
                        } else {
                          attributes[algorithmId._id] = attribute;
                        }
                        if (algorithmId._id ==
                            _PkcsObjectId.pkcs9AtFriendlyName._id) {
                          localIdentifier =
                              (attribute! as _DerBmpString).getString();
                          _keys.setValue(localIdentifier!, key);
                        } else if (algorithmId._id ==
                            _PkcsObjectId.pkcs9AtLocalKeyID._id) {
                          localId = attribute as _Asn1Octet?;
                        }
                      }
                    }
                  }
                }
                if (localId != null) {
                  final String name =
                      _PdfString._bytesToHex(localId.getOctets()!);
                  if (localIdentifier == null) {
                    _keys.setValue(name, key);
                  } else {
                    _localIdentifiers[localIdentifier] = name;
                  }
                } else {
                  isUnmarkedKey = true;
                  _keys.setValue('unmarked', key);
                }
              } else if (subSequenceCollection._id!._id ==
                  _PkcsObjectId.certBag._id) {
                certificateChain.add(subSequenceCollection);
              }
            }
          }
        } else if (type._id == _PkcsObjectId.encryptedData._id) {
          final _Asn1Sequence sequence1 = entry._content! as _Asn1Sequence;
          if (sequence1.count != 2) {
            throw ArgumentError.value(
                entry, 'sequence', 'Invalid length of the sequence');
          }
          final int version =
              (sequence1[0]! as _DerInteger).value.toSigned(32).toInt();
          if (version != 0) {
            throw ArgumentError.value(
                version, 'version', 'Invalid sequence version');
          }
          final _Asn1Sequence data = sequence1[1]! as _Asn1Sequence;
          _Asn1Octet? content;
          if (data.count == 3) {
            final _DerTag taggedObject = data[2]! as _DerTag;
            content = _Asn1Octet.getOctetString(taggedObject, false);
          }
          final List<int>? octets = getCryptographicData(
              false,
              _Algorithms.getAlgorithms(data[1])!,
              password,
              isInvalidPassword,
              content!.getOctets());
          final _Asn1Sequence seq =
              _Asn1Stream(_StreamReader(octets)).readAsn1()! as _Asn1Sequence;
          // ignore: avoid_function_literals_in_foreach_calls
          seq._objects!.forEach((dynamic subSequence) {
            final _Asn1SequenceCollection subSequenceCollection =
                _Asn1SequenceCollection(subSequence);
            if (subSequenceCollection._id!._id == _PkcsObjectId.certBag._id) {
              certificateChain.add(subSequenceCollection);
            } else if (subSequenceCollection._id!._id ==
                _PkcsObjectId.pkcs8ShroudedKeyBag._id) {
              final _EncryptedPrivateKey encryptedPrivateKeyInformation =
                  _EncryptedPrivateKey.getEncryptedPrivateKeyInformation(
                      subSequenceCollection._value);
              final _KeyInformation privateInformation = createPrivateKeyInfo(
                  password, isInvalidPassword, encryptedPrivateKeyInformation)!;
              _RsaPrivateKeyParam? rsaParameter;
              if (privateInformation._algorithms!._objectID!._id ==
                      _PkcsObjectId.rsaEncryption._id ||
                  privateInformation._algorithms!._objectID!._id ==
                      _X509Objects.idEARsa._id) {
                final _RsaKey keyStructure = _RsaKey.fromSequence(
                    _Asn1Sequence.getSequence(privateInformation._privateKey)!);
                rsaParameter = _RsaPrivateKeyParam(
                    keyStructure._modulus,
                    keyStructure._publicExponent!,
                    keyStructure._privateExponent,
                    keyStructure._prime1!,
                    keyStructure._prime2!,
                    keyStructure._exponent1!,
                    keyStructure._exponent2!,
                    keyStructure._coefficient!);
              }
              final _CipherParameter? privateKey = rsaParameter;
              final Map<dynamic, dynamic> attributes = <dynamic, dynamic>{};
              final _KeyEntry keyEntry = _KeyEntry(privateKey);
              String? key;
              _Asn1Octet? localIdentity;
              // ignore: avoid_function_literals_in_foreach_calls
              subSequenceCollection._attributes!._objects.forEach((dynamic sq) {
                final _DerObjectID? asn1Id = sq[0] as _DerObjectID?;
                final _Asn1Set attributeSet = sq[1] as _Asn1Set;
                _Asn1Encode? attribute;
                if (attributeSet._objects.isNotEmpty) {
                  attribute = attributeSet._objects[0] as _Asn1Encode?;
                  if (attributes.containsKey(asn1Id!._id)) {
                    if (!(attributes[asn1Id._id] == attribute)) {
                      throw ArgumentError.value(attributes, 'attributes',
                          'attempt to add existing attribute with different value');
                    }
                  } else {
                    attributes[asn1Id._id] = attribute;
                  }
                  if (asn1Id._id == _PkcsObjectId.pkcs9AtFriendlyName._id) {
                    key = (attribute! as _DerBmpString).getString();
                    _keys.setValue(key!, keyEntry);
                  } else if (asn1Id._id ==
                      _PkcsObjectId.pkcs9AtLocalKeyID._id) {
                    localIdentity = attribute as _Asn1Octet?;
                  }
                }
              });
              final String name =
                  _PdfString._bytesToHex(localIdentity!.getOctets()!);
              if (key == null) {
                _keys.setValue(name, keyEntry);
              } else {
                _localIdentifiers[key] = name;
              }
            } else if (subSequenceCollection._id!._id ==
                _PkcsObjectId.keyBag._id) {
              final _KeyInformation privateKeyInformation =
                  _KeyInformation.getInformation(subSequenceCollection._value)!;
              _RsaPrivateKeyParam? rsaParameter;
              if (privateKeyInformation._algorithms!._objectID!._id ==
                      _PkcsObjectId.rsaEncryption._id ||
                  privateKeyInformation._algorithms!._objectID!._id ==
                      _X509Objects.idEARsa._id) {
                final _RsaKey keyStructure = _RsaKey.fromSequence(
                    _Asn1Sequence.getSequence(
                        privateKeyInformation._privateKey)!);
                rsaParameter = _RsaPrivateKeyParam(
                    keyStructure._modulus,
                    keyStructure._publicExponent!,
                    keyStructure._privateExponent,
                    keyStructure._prime1!,
                    keyStructure._prime2!,
                    keyStructure._exponent1!,
                    keyStructure._exponent2!,
                    keyStructure._coefficient!);
              }
              final _CipherParameter? privateKey = rsaParameter;
              String? key;
              _Asn1Octet? localId;
              final Map<dynamic, dynamic> attributes = <dynamic, dynamic>{};
              final _KeyEntry keyEntry = _KeyEntry(privateKey);
              // ignore: avoid_function_literals_in_foreach_calls
              subSequenceCollection._attributes!._objects.forEach((dynamic sq) {
                final _DerObjectID? id = sq[0] as _DerObjectID?;
                final _Asn1Set attributeSet = sq[1] as _Asn1Set;
                _Asn1Encode? attribute;
                if (attributeSet._objects.isNotEmpty) {
                  attribute = attributeSet[0];
                  if (attributes.containsKey(id!._id)) {
                    final _Asn1Encode? attr =
                        attributes[id._id] as _Asn1Encode?;
                    if (attr != null && attr != attribute) {
                      throw ArgumentError.value(sq, 'sequence',
                          'attempt to add existing attribute with different value');
                    }
                  } else {
                    attributes[id._id] = attribute;
                  }
                  if (id._id == _PkcsObjectId.pkcs9AtFriendlyName._id) {
                    key = (attribute! as _DerBmpString).getString();
                    _keys.setValue(key!, keyEntry);
                  } else if (id._id == _PkcsObjectId.pkcs9AtLocalKeyID._id) {
                    localId = attribute as _Asn1Octet?;
                  }
                }
              });
              final String name = _PdfString._bytesToHex(localId!.getOctets()!);
              if (key == null) {
                _keys.setValue(name, keyEntry);
              } else {
                _localIdentifiers[key] = name;
              }
            }
          });
        }
      });
    }
    _certificates = _CertificateTable();
    _chainCertificates = <_CertificateIdentifier, _X509Certificates>{};
    _keyCertificates = <String, _X509Certificates>{};
    // ignore: avoid_function_literals_in_foreach_calls
    certificateChain.forEach((_Asn1SequenceCollection asn1Collection) {
      final _Asn1Sequence asn1Sequence =
          asn1Collection._value! as _Asn1Sequence;
      final _Asn1 certValue = _Asn1Tag.getTag(asn1Sequence[1])!.getObject()!;
      final List<int>? octets = (certValue as _Asn1Octet).getOctets();
      final _X509Certificate certificate =
          _X509CertificateParser().readCertificate(_StreamReader(octets))!;
      final Map<dynamic, dynamic> attributes = <dynamic, dynamic>{};
      _Asn1Octet? localId;
      String? key;
      final _Asn1Set? tempAttributes = asn1Collection._attributes;
      if (tempAttributes != null) {
        for (int i = 0; i < tempAttributes._objects.length; i++) {
          final _Asn1Sequence sq = tempAttributes._objects[i] as _Asn1Sequence;
          final _DerObjectID? aOid = _DerObjectID.getID(sq[0]);
          final _Asn1Set attrSet = sq[1]! as _Asn1Set;
          if (attrSet._objects.isNotEmpty) {
            final _Asn1Encode? attr = attrSet[0];
            if (attributes.containsKey(aOid!._id)) {
              if (attributes[aOid._id] != attr) {
                throw ArgumentError.value(attributes, 'attributes',
                    'attempt to add existing attribute with different value');
              }
            } else {
              attributes[aOid._id] = attr;
            }
            if (aOid._id == _PkcsObjectId.pkcs9AtFriendlyName._id) {
              key = (attr! as _DerBmpString).getString();
            } else if (aOid._id == _PkcsObjectId.pkcs9AtLocalKeyID._id) {
              localId = attr as _Asn1Octet?;
            }
          }
        }
      }
      final _CertificateIdentifier certId =
          _CertificateIdentifier(pubKey: certificate.getPublicKey());
      final _X509Certificates certificateCollection =
          _X509Certificates(certificate);
      _chainCertificates[certId] = certificateCollection;
      if (isUnmarkedKey) {
        if (_keyCertificates.isEmpty) {
          final String name = _PdfString._bytesToHex(certId._id!);
          _keyCertificates[name] = certificateCollection;
          final dynamic temp = _keys['unmarked'];
          _keys.remove('unmarked');
          _keys.setValue('name', temp);
        }
      } else {
        if (localId != null) {
          final String name = _PdfString._bytesToHex(localId.getOctets()!);
          _keyCertificates[name] = certificateCollection;
        }
        if (key != null) {
          _certificates.setValue(key, certificateCollection);
        }
      }
    });
  }

  static List<int>? getCryptographicData(bool forEncryption, _Algorithms id,
      String password, bool isZero, List<int>? data) {
    final _PasswordUtility utility = _PasswordUtility();
    final _IBufferedCipher? cipher =
        utility.createEncoder(id._objectID) as _IBufferedCipher?;
    if (cipher == null) {
      throw ArgumentError.value(id, 'id', 'Invalid encryption algorithm');
    }
    final _Pkcs12PasswordParameter parameter =
        _Pkcs12PasswordParameter.getPbeParameter(id._parameters);
    final _ICipherParameter? parameters = utility.generateCipherParameters(
        id._objectID!._id!, password, isZero, parameter);
    cipher.initialize(forEncryption, parameters);
    return cipher.doFinalFromInput(data);
  }

  _KeyInformation? createPrivateKeyInfo(
      String passPhrase, bool isPkcs12empty, _EncryptedPrivateKey encInfo) {
    final _Algorithms algID = encInfo._algorithms!;
    final _PasswordUtility pbeU = _PasswordUtility();
    final _IBufferedCipher? cipher =
        pbeU.createEncoder(algID) as _IBufferedCipher?;
    if (cipher == null) {
      throw ArgumentError.value(
          cipher, 'cipher', 'Unknown encryption algorithm');
    }
    final _ICipherParameter? cipherParameters = pbeU.generateCipherParameters(
        algID._objectID!._id!, passPhrase, isPkcs12empty, algID._parameters);
    cipher.initialize(false, cipherParameters);
    final List<int>? keyBytes =
        cipher.doFinalFromInput(encInfo._octet!.getOctets());
    return _KeyInformation.getInformation(keyBytes);
  }

  static _SubjectKeyID createSubjectKeyID(_CipherParameter publicKey) {
    _SubjectKeyID result;
    if (publicKey is _RsaKeyParam) {
      final _PublicKeyInformation information = _PublicKeyInformation(
          _Algorithms(_PkcsObjectId.rsaEncryption, _DerNull.value),
          _RsaPublicKey(publicKey.modulus, publicKey.exponent).getAsn1());
      result = _SubjectKeyID(information);
    } else {
      throw ArgumentError.value(publicKey, 'publicKey', 'Invalid Key');
    }
    return result;
  }

  Map<String, String> getContentTable() {
    final Map<String, String> result = <String, String>{};
    // ignore: avoid_function_literals_in_foreach_calls
    _certificates.keys.forEach((String key) {
      result[key] = 'cert';
    });
    // ignore: avoid_function_literals_in_foreach_calls
    _keys.keys.forEach((String key) {
      if (!result.containsKey(key)) {
        result[key] = 'key';
      }
    });
    return result;
  }

  bool isKey(String key) {
    return _keys[key] != null;
  }

  _KeyEntry? getKey(String key) {
    return _keys[key] is _KeyEntry ? _keys[key] as _KeyEntry? : null;
  }

  _X509Certificates? getCertificate(String key) {
    dynamic certificates = _certificates[key];
    if (certificates != null && certificates is _X509Certificates) {
      return certificates;
    } else {
      String? id;
      if (_localIdentifiers.containsKey(key)) {
        id = _localIdentifiers[key];
      }
      if (id != null) {
        if (_keyCertificates.containsKey(id)) {
          certificates = _keyCertificates[id] is _X509Certificates
              ? _keyCertificates[id]
              : null;
        }
      } else {
        if (_keyCertificates.containsKey(key)) {
          certificates = _keyCertificates[key] is _X509Certificates
              ? _keyCertificates[key]
              : null;
        }
      }
      return certificates as _X509Certificates?;
    }
  }

  List<_X509Certificates>? getCertificateChain(String key) {
    if (!isKey(key)) {
      return null;
    }
    _X509Certificates? certificates = getCertificate(key);
    if (certificates != null) {
      final List<_X509Certificates> certificateList = <_X509Certificates>[];
      bool isContinue = true;
      while (certificates != null) {
        final _X509Certificate x509Certificate = certificates.certificate!;
        _X509Certificates? nextCertificate;
        final _Asn1Octet? x509Extension = x509Certificate
            .getExtension(_X509Extensions.authorityKeyIdentifier);
        if (x509Extension != null) {
          final _KeyIdentifier id = _KeyIdentifier.getKeyIdentifier(
              _Asn1Stream(_StreamReader(x509Extension.getOctets())).readAsn1());
          if (id.keyID != null) {
            if (_chainCertificates
                .containsKey(_CertificateIdentifier(id: id.keyID))) {
              nextCertificate =
                  _chainCertificates[_CertificateIdentifier(id: id.keyID)];
            }
          }
        }
        if (nextCertificate == null) {
          final _X509Name? issuer = x509Certificate._c!.issuer;
          final _X509Name? subject = x509Certificate._c!.subject;
          if (!(issuer == subject)) {
            final List<_CertificateIdentifier> keys =
                _chainCertificates.keys.toList();
            // ignore: avoid_function_literals_in_foreach_calls
            keys.forEach((_CertificateIdentifier certId) {
              _X509Certificates? x509CertEntry;
              if (_chainCertificates.containsKey(certId)) {
                x509CertEntry = _chainCertificates[certId];
              }
              final _X509Certificate certificate = x509CertEntry!.certificate!;
              if (certificate._c!.subject == issuer) {
                try {
                  // x509Certificate.verify(certificate.getPublicKey());
                  // nextCertificate = x509CertEntry;
                  isContinue = false;
                } catch (e) {
                  //
                }
              }
            });
          }
        }
        if (isContinue) {
          certificateList.add(certificates);
          certificates =
              nextCertificate != null && nextCertificate != certificates
                  ? nextCertificate
                  : null;
        }
      }
      return List<_X509Certificates>.generate(
          certificateList.length, (int i) => certificateList[i]);
    }
    return null;
  }
}

class _CertificateTable {
  _CertificateTable() {
    _orig = <String, dynamic>{};
    _keys = <String, dynamic>{};
  }
  late Map<String, dynamic> _orig;
  late Map<String, dynamic> _keys;

  //Implementation
  void clear() {
    _orig = <String, dynamic>{};
    _keys = <String, dynamic>{};
  }

  List<String> get keys {
    return _orig.keys.toList();
  }

  dynamic remove(String key) {
    final String lower = key.toLowerCase();
    String? k;
    _keys.forEach((String tempKey, dynamic tempValue) {
      if (lower == tempKey.toLowerCase()) {
        k = _keys[tempKey] as String?;
      }
    });
    if (k == null) {
      return null;
    }
    _keys.remove(lower);
    final dynamic obj = _orig[k!];
    _orig.remove(k);
    return obj;
  }

  dynamic operator [](String key) {
    final String lower = key.toLowerCase();
    String? k;
    _keys.forEach((String tempKey, dynamic tempValue) {
      if (lower == tempKey.toLowerCase()) {
        k = tempKey;
      }
    });
    if (k != null) {
      return _orig[_keys[k!]];
    } else {
      return null;
    }
  }

  void setValue(String key, dynamic value) {
    final String lower = key.toLowerCase();
    String? k;
    _keys.forEach((String tempKey, dynamic tempValue) {
      if (lower == tempKey.toLowerCase()) {
        k = tempKey;
      }
    });
    if (k != null) {
      _orig.remove(_keys[k!]);
    }
    _keys[lower] = key;
    _orig[key] = value;
  }
}

class _CertificateIdentifier {
  _CertificateIdentifier({_CipherParameter? pubKey, List<int>? id}) {
    if (pubKey != null) {
      _id = _PdfPKCSCertificate.createSubjectKeyID(pubKey)._bytes;
    } else {
      _id = id;
    }
  }
  //Fields
  List<int>? _id;
  //Implements
  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  bool operator ==(Object other) {
    if (other is _CertificateIdentifier) {
      return _Asn1.areEqual(_id, other._id);
    } else {
      return false;
    }
  }

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  int get hashCode => _Asn1.getHashCode(_id);
}
