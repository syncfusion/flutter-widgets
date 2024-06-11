import 'dart:convert';

import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart';

import '../../io/decode_big_endian.dart';
import '../../io/stream_reader.dart';
import '../../primitives/pdf_string.dart';
import 'asn1/asn1.dart';
import 'asn1/asn1_stream.dart';
import 'asn1/ber.dart';
import 'asn1/der.dart';
import 'cryptography/buffered_block_padding_base.dart';
import 'cryptography/cipher_block_chaining_mode.dart';
import 'cryptography/cipher_utils.dart';
import 'cryptography/ipadding.dart';
import 'cryptography/message_digest_utils.dart';
import 'cryptography/pkcs1_encoding.dart';
import 'cryptography/rsa_algorithm.dart';
import 'cryptography/signature_utilities.dart';
import 'pkcs/password_utility.dart';
import 'pkcs/pfx_data.dart';
import 'x509/x509_certificates.dart';
import 'x509/x509_name.dart';

/// internal class
class PdfPKCSCertificate {
  /// internal constructor
  PdfPKCSCertificate(List<int> certificateBytes, String password) {
    _keys = _CertificateTable();
    _certificates = _CertificateTable();
    _localIdentifiers = <String?, String>{};
    _chainCertificates = <_CertificateIdentifier, X509Certificates>{};
    _keyCertificates = <String, X509Certificates>{};
    _loadCertificate(certificateBytes, password);
  }

  //Fields
  late _CertificateTable _keys;
  late _CertificateTable _certificates;
  late Map<String?, String> _localIdentifiers;
  late Map<_CertificateIdentifier, X509Certificates> _chainCertificates;
  late Map<String, X509Certificates> _keyCertificates;

  //Implementation
  void _loadCertificate(List<int> certificateBytes, String password) {
    final Asn1Sequence sequence = Asn1Stream(PdfStreamReader(certificateBytes))
        .readAsn1()! as Asn1Sequence;
    final _PfxData pfxData = _PfxData(sequence);
    final _ContentInformation information = pfxData._contentInformation!;
    bool isUnmarkedKey = false;
    final bool isInvalidPassword = password.isEmpty;
    final List<Asn1SequenceCollection> certificateChain =
        <Asn1SequenceCollection>[];
    if (information._contentType!.id == PkcsObjectId.data.id) {
      final List<int>? octs = (information._content! as Asn1Octet).getOctets();
      final Asn1Sequence asn1Sequence =
          Asn1Stream(PdfStreamReader(octs)).readAsn1()! as Asn1Sequence;
      final List<_ContentInformation?> contentInformation =
          <_ContentInformation?>[];
      for (int i = 0; i < asn1Sequence.count; i++) {
        contentInformation
            .add(_ContentInformation.getInformation(asn1Sequence[i]));
      }
      // ignore: avoid_function_literals_in_foreach_calls
      contentInformation.forEach((_ContentInformation? entry) {
        final DerObjectID type = entry!._contentType!;
        if (type.id == PkcsObjectId.data.id) {
          final List<int>? octets = (entry._content! as Asn1Octet).getOctets();
          final Asn1Sequence asn1SubSequence =
              Asn1Stream(PdfStreamReader(octets)).readAsn1()! as Asn1Sequence;
          for (int index = 0; index < asn1SubSequence.count; index++) {
            final dynamic subSequence = asn1SubSequence[index];
            if (subSequence != null && subSequence is Asn1Sequence) {
              final Asn1SequenceCollection subSequenceCollection =
                  Asn1SequenceCollection(subSequence);
              if (subSequenceCollection.id!.id ==
                  PkcsObjectId.pkcs8ShroudedKeyBag.id) {
                final _EncryptedPrivateKey encryptedInformation =
                    _EncryptedPrivateKey.getEncryptedPrivateKeyInformation(
                        subSequenceCollection.value);
                final _KeyInformation privateKeyInformation =
                    createPrivateKeyInfo(
                        password, isInvalidPassword, encryptedInformation)!;
                RsaPrivateKeyParam? rsaparam;
                if (privateKeyInformation._algorithms!.id!.id ==
                        PkcsObjectId.rsaEncryption.id ||
                    privateKeyInformation._algorithms!.id!.id ==
                        X509Objects.idEARsa.id) {
                  final _RsaKey keyStructure = _RsaKey.fromSequence(
                      Asn1Sequence.getSequence(
                          privateKeyInformation._privateKey)!);
                  rsaparam = RsaPrivateKeyParam(
                      keyStructure._modulus,
                      keyStructure._publicExponent,
                      keyStructure._privateExponent,
                      keyStructure._prime1,
                      keyStructure._prime2,
                      keyStructure._exponent1,
                      keyStructure._exponent2,
                      keyStructure._coefficient);
                }
                final CipherParameter? privateKey = rsaparam;
                final Map<String?, dynamic> attributes = <String?, dynamic>{};
                final KeyEntry key = KeyEntry(privateKey);
                String? localIdentifier;
                Asn1Octet? localId;
                if (subSequenceCollection.attributes != null) {
                  final Asn1Set sq = subSequenceCollection.attributes!;
                  for (int i = 0; i < sq.objects.length; i++) {
                    final Asn1Encode? entry = sq.objects[i] as Asn1Encode?;
                    if (entry is Asn1Sequence) {
                      final DerObjectID? algorithmId =
                          DerObjectID.getID(entry[0]);
                      final Asn1Set attributeSet = entry[1]! as Asn1Set;
                      Asn1Encode? attribute;
                      if (attributeSet.objects.isNotEmpty) {
                        attribute = attributeSet[0];
                        if (attributes.containsKey(algorithmId!.id)) {
                          if (attributes[algorithmId.id] != attribute) {
                            throw ArgumentError.value(attributes, 'attributes',
                                'attempt to add existing attribute with different value');
                          }
                        } else {
                          attributes[algorithmId.id] = attribute;
                        }
                        if (algorithmId.id ==
                            PkcsObjectId.pkcs9AtFriendlyName.id) {
                          localIdentifier =
                              (attribute! as DerBmpString).getString();
                          _keys.setValue(localIdentifier!, key);
                        } else if (algorithmId.id ==
                            PkcsObjectId.pkcs9AtLocalKeyID.id) {
                          localId = attribute as Asn1Octet?;
                        }
                      }
                    }
                  }
                }
                if (localId != null) {
                  final String name =
                      PdfString.bytesToHex(localId.getOctets()!);
                  if (localIdentifier == null) {
                    _keys.setValue(name, key);
                  } else {
                    _localIdentifiers[localIdentifier] = name;
                  }
                } else {
                  isUnmarkedKey = true;
                  _keys.setValue('unmarked', key);
                }
              } else if (subSequenceCollection.id!.id ==
                  PkcsObjectId.certBag.id) {
                certificateChain.add(subSequenceCollection);
              }
            }
          }
        } else if (type.id == PkcsObjectId.encryptedData.id) {
          final Asn1Sequence sequence1 = entry._content! as Asn1Sequence;
          if (sequence1.count != 2) {
            throw ArgumentError.value(
                entry, 'sequence', 'Invalid length of the sequence');
          }
          final int version =
              (sequence1[0]! as DerInteger).value.toSigned(32).toInt();
          if (version != 0) {
            throw ArgumentError.value(
                version, 'version', 'Invalid sequence version');
          }
          final Asn1Sequence data = sequence1[1]! as Asn1Sequence;
          Asn1Octet? content;
          if (data.count == 3) {
            final DerTag taggedObject = data[2]! as DerTag;
            content = Asn1Octet.getOctetString(taggedObject, false);
          }
          final List<int>? octets = getCryptographicData(
              false,
              Algorithms.getAlgorithms(data[1])!,
              password,
              isInvalidPassword,
              content!.getOctets());
          final Asn1Sequence seq =
              Asn1Stream(PdfStreamReader(octets)).readAsn1()! as Asn1Sequence;
          // ignore: avoid_function_literals_in_foreach_calls
          seq.objects!.forEach((dynamic subSequence) {
            final Asn1SequenceCollection subSequenceCollection =
                Asn1SequenceCollection(subSequence);
            if (subSequenceCollection.id!.id == PkcsObjectId.certBag.id) {
              certificateChain.add(subSequenceCollection);
            } else if (subSequenceCollection.id!.id ==
                PkcsObjectId.pkcs8ShroudedKeyBag.id) {
              final _EncryptedPrivateKey encryptedPrivateKeyInformation =
                  _EncryptedPrivateKey.getEncryptedPrivateKeyInformation(
                      subSequenceCollection.value);
              final _KeyInformation privateInformation = createPrivateKeyInfo(
                  password, isInvalidPassword, encryptedPrivateKeyInformation)!;
              RsaPrivateKeyParam? rsaParameter;
              if (privateInformation._algorithms!.id!.id ==
                      PkcsObjectId.rsaEncryption.id ||
                  privateInformation._algorithms!.id!.id ==
                      X509Objects.idEARsa.id) {
                final _RsaKey keyStructure = _RsaKey.fromSequence(
                    Asn1Sequence.getSequence(privateInformation._privateKey)!);
                rsaParameter = RsaPrivateKeyParam(
                    keyStructure._modulus,
                    keyStructure._publicExponent,
                    keyStructure._privateExponent,
                    keyStructure._prime1,
                    keyStructure._prime2,
                    keyStructure._exponent1,
                    keyStructure._exponent2,
                    keyStructure._coefficient);
              }
              final CipherParameter? privateKey = rsaParameter;
              final Map<dynamic, dynamic> attributes = <dynamic, dynamic>{};
              final KeyEntry keyEntry = KeyEntry(privateKey);
              String? key;
              Asn1Octet? localIdentity;
              // ignore: avoid_function_literals_in_foreach_calls
              subSequenceCollection.attributes!.objects.forEach((dynamic sq) {
                final DerObjectID? asn1Id = sq[0] as DerObjectID?;
                final Asn1Set attributeSet = sq[1] as Asn1Set;
                Asn1Encode? attribute;
                if (attributeSet.objects.isNotEmpty) {
                  attribute = attributeSet.objects[0] as Asn1Encode?;
                  if (attributes.containsKey(asn1Id!.id)) {
                    if (!(attributes[asn1Id.id] == attribute)) {
                      throw ArgumentError.value(attributes, 'attributes',
                          'attempt to add existing attribute with different value');
                    }
                  } else {
                    attributes[asn1Id.id] = attribute;
                  }
                  if (asn1Id.id == PkcsObjectId.pkcs9AtFriendlyName.id) {
                    key = (attribute! as DerBmpString).getString();
                    _keys.setValue(key!, keyEntry);
                  } else if (asn1Id.id == PkcsObjectId.pkcs9AtLocalKeyID.id) {
                    localIdentity = attribute as Asn1Octet?;
                  }
                }
              });
              final String name =
                  PdfString.bytesToHex(localIdentity!.getOctets()!);
              if (key == null) {
                _keys.setValue(name, keyEntry);
              } else {
                _localIdentifiers[key] = name;
              }
            } else if (subSequenceCollection.id!.id == PkcsObjectId.keyBag.id) {
              final _KeyInformation privateKeyInformation =
                  _KeyInformation.getInformation(subSequenceCollection.value)!;
              RsaPrivateKeyParam? rsaParameter;
              if (privateKeyInformation._algorithms!.id!.id ==
                      PkcsObjectId.rsaEncryption.id ||
                  privateKeyInformation._algorithms!.id!.id ==
                      X509Objects.idEARsa.id) {
                final _RsaKey keyStructure = _RsaKey.fromSequence(
                    Asn1Sequence.getSequence(
                        privateKeyInformation._privateKey)!);
                rsaParameter = RsaPrivateKeyParam(
                    keyStructure._modulus,
                    keyStructure._publicExponent,
                    keyStructure._privateExponent,
                    keyStructure._prime1,
                    keyStructure._prime2,
                    keyStructure._exponent1,
                    keyStructure._exponent2,
                    keyStructure._coefficient);
              }
              final CipherParameter? privateKey = rsaParameter;
              String? key;
              Asn1Octet? localId;
              final Map<dynamic, dynamic> attributes = <dynamic, dynamic>{};
              final KeyEntry keyEntry = KeyEntry(privateKey);
              // ignore: avoid_function_literals_in_foreach_calls
              subSequenceCollection.attributes!.objects.forEach((dynamic sq) {
                final DerObjectID? id = sq[0] as DerObjectID?;
                final Asn1Set attributeSet = sq[1] as Asn1Set;
                Asn1Encode? attribute;
                if (attributeSet.objects.isNotEmpty) {
                  attribute = attributeSet[0];
                  if (attributes.containsKey(id!.id)) {
                    final Asn1Encode? attr = attributes[id.id] as Asn1Encode?;
                    if (attr != null && attr != attribute) {
                      throw ArgumentError.value(sq, 'sequence',
                          'attempt to add existing attribute with different value');
                    }
                  } else {
                    attributes[id.id] = attribute;
                  }
                  if (id.id == PkcsObjectId.pkcs9AtFriendlyName.id) {
                    key = (attribute! as DerBmpString).getString();
                    _keys.setValue(key!, keyEntry);
                  } else if (id.id == PkcsObjectId.pkcs9AtLocalKeyID.id) {
                    localId = attribute as Asn1Octet?;
                  }
                }
              });
              final String name = PdfString.bytesToHex(localId!.getOctets()!);
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
    _chainCertificates = <_CertificateIdentifier, X509Certificates>{};
    _keyCertificates = <String, X509Certificates>{};
    // ignore: avoid_function_literals_in_foreach_calls
    certificateChain.forEach((Asn1SequenceCollection asn1Collection) {
      final Asn1Sequence asn1Sequence = asn1Collection.value! as Asn1Sequence;
      final Asn1 certValue = Asn1Tag.getTag(asn1Sequence[1])!.getObject()!;
      final List<int>? octets = (certValue as Asn1Octet).getOctets();
      final X509Certificate certificate =
          X509CertificateParser().readCertificate(PdfStreamReader(octets))!;
      final Map<dynamic, dynamic> attributes = <dynamic, dynamic>{};
      Asn1Octet? localId;
      String? key;
      final Asn1Set? tempAttributes = asn1Collection.attributes;
      if (tempAttributes != null) {
        for (int i = 0; i < tempAttributes.objects.length; i++) {
          final Asn1Sequence sq = tempAttributes.objects[i] as Asn1Sequence;
          final DerObjectID? aOid = DerObjectID.getID(sq[0]);
          final Asn1Set attrSet = sq[1]! as Asn1Set;
          if (attrSet.objects.isNotEmpty) {
            final Asn1Encode? attr = attrSet[0];
            if (attributes.containsKey(aOid!.id)) {
              if (attributes[aOid.id] != attr) {
                throw ArgumentError.value(attributes, 'attributes',
                    'attempt to add existing attribute with different value');
              }
            } else {
              attributes[aOid.id] = attr;
            }
            if (aOid.id == PkcsObjectId.pkcs9AtFriendlyName.id) {
              key = (attr! as DerBmpString).getString();
            } else if (aOid.id == PkcsObjectId.pkcs9AtLocalKeyID.id) {
              localId = attr as Asn1Octet?;
            }
          }
        }
      }
      final _CertificateIdentifier certId =
          _CertificateIdentifier(pubKey: certificate.getPublicKey());
      final X509Certificates certificateCollection =
          X509Certificates(certificate);
      _chainCertificates[certId] = certificateCollection;
      if (isUnmarkedKey) {
        if (_keyCertificates.isEmpty) {
          final String name = PdfString.bytesToHex(certId.id!);
          _keyCertificates[name] = certificateCollection;
          final dynamic temp = _keys['unmarked'];
          _keys.remove('unmarked');
          _keys.setValue('name', temp);
        }
      } else {
        if (localId != null) {
          final String name = PdfString.bytesToHex(localId.getOctets()!);
          _keyCertificates[name] = certificateCollection;
        }
        if (key != null) {
          _certificates.setValue(key, certificateCollection);
        }
      }
    });
  }

  /// internal method
  static List<int>? getCryptographicData(bool forEncryption, Algorithms id,
      String password, bool isZero, List<int>? data) {
    final _PasswordUtility utility = _PasswordUtility();
    final IBufferedCipher? cipher =
        utility.createEncoder(id.id) as IBufferedCipher?;
    if (cipher == null) {
      throw ArgumentError.value(id, 'id', 'Invalid encryption algorithm');
    }
    final _Pkcs12PasswordParameter parameter =
        _Pkcs12PasswordParameter.getPbeParameter(id.parameters);
    final ICipherParameter? parameters = utility.generateCipherParameters(
        id.id!.id!, password, isZero, parameter);
    cipher.initialize(forEncryption, parameters);
    return cipher.doFinalFromInput(data);
  }

  /// internal method
  _KeyInformation? createPrivateKeyInfo(
      String passPhrase, bool isPkcs12empty, _EncryptedPrivateKey encInfo) {
    final Algorithms algID = encInfo._algorithms!;
    final _PasswordUtility pbeU = _PasswordUtility();
    final IBufferedCipher? cipher =
        pbeU.createEncoder(algID) as IBufferedCipher?;
    if (cipher == null) {
      throw ArgumentError.value(
          cipher, 'cipher', 'Unknown encryption algorithm');
    }
    final ICipherParameter? cipherParameters = pbeU.generateCipherParameters(
        algID.id!.id!, passPhrase, isPkcs12empty, algID.parameters);
    cipher.initialize(false, cipherParameters);
    final List<int>? keyBytes =
        cipher.doFinalFromInput(encInfo._octet!.getOctets());
    return _KeyInformation.getInformation(keyBytes);
  }

  /// internal method
  static _SubjectKeyID createSubjectKeyID(CipherParameter publicKey) {
    _SubjectKeyID result;
    if (publicKey is RsaKeyParam) {
      final PublicKeyInformation information = PublicKeyInformation(
          Algorithms(PkcsObjectId.rsaEncryption, DerNull.value),
          RsaPublicKey(publicKey.modulus, publicKey.exponent).getAsn1());
      result = _SubjectKeyID(information);
    } else {
      throw ArgumentError.value(publicKey, 'publicKey', 'Invalid Key');
    }
    return result;
  }

  /// internal method
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

  /// internal method
  Future<Map<String, String>> getContentTableAsync() async {
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

  /// internal method
  bool isKey(String key) {
    return _keys[key] != null;
  }

  /// internal method
  KeyEntry? getKey(String key) {
    return _keys[key] is KeyEntry ? _keys[key] as KeyEntry? : null;
  }

  /// internal method
  X509Certificates? getCertificate(String key) {
    dynamic certificates = _certificates[key];
    if (certificates != null && certificates is X509Certificates) {
      return certificates;
    } else {
      String? id;
      if (_localIdentifiers.containsKey(key)) {
        id = _localIdentifiers[key];
      }
      if (id != null) {
        if (_keyCertificates.containsKey(id)) {
          certificates = _keyCertificates[id] is X509Certificates
              ? _keyCertificates[id]
              : null;
        }
      } else {
        if (_keyCertificates.containsKey(key)) {
          certificates = _keyCertificates[key] is X509Certificates
              ? _keyCertificates[key]
              : null;
        }
      }
      return certificates as X509Certificates?;
    }
  }

  /// internal method
  Future<X509Certificates?> getCertificateAsync(String key) async {
    dynamic certificates = _certificates[key];
    if (certificates != null && certificates is X509Certificates) {
      return certificates;
    } else {
      String? id;
      if (_localIdentifiers.containsKey(key)) {
        id = _localIdentifiers[key];
      }
      if (id != null) {
        if (_keyCertificates.containsKey(id)) {
          certificates = _keyCertificates[id] is X509Certificates
              ? _keyCertificates[id]
              : null;
        }
      } else {
        if (_keyCertificates.containsKey(key)) {
          certificates = _keyCertificates[key] is X509Certificates
              ? _keyCertificates[key]
              : null;
        }
      }
      return certificates as X509Certificates?;
    }
  }

  /// internal method
  List<X509Certificates>? getCertificateChain(String key) {
    if (!isKey(key)) {
      return null;
    }
    X509Certificates? certificates = getCertificate(key);
    if (certificates != null) {
      final List<X509Certificates> certificateList = <X509Certificates>[];
      bool isContinue = true;
      while (certificates != null) {
        final X509Certificate x509Certificate = certificates.certificate!;
        X509Certificates? nextCertificate;
        final Asn1Octet? x509Extension =
            x509Certificate.getExtension(X509Extensions.authorityKeyIdentifier);
        if (x509Extension != null) {
          final _KeyIdentifier id = _KeyIdentifier.getKeyIdentifier(
              Asn1Stream(PdfStreamReader(x509Extension.getOctets()))
                  .readAsn1());
          if (id.keyID != null) {
            if (_chainCertificates
                .containsKey(_CertificateIdentifier(id: id.keyID))) {
              nextCertificate =
                  _chainCertificates[_CertificateIdentifier(id: id.keyID)];
            }
          }
        }
        if (nextCertificate == null) {
          final X509Name? issuer = x509Certificate.c!.issuer;
          final X509Name? subject = x509Certificate.c!.subject;
          if (!(issuer == subject)) {
            final List<_CertificateIdentifier> keys =
                _chainCertificates.keys.toList();
            // ignore: avoid_function_literals_in_foreach_calls
            keys.forEach((_CertificateIdentifier certId) {
              X509Certificates? x509CertEntry;
              if (_chainCertificates.containsKey(certId)) {
                x509CertEntry = _chainCertificates[certId];
              }
              final X509Certificate certificate = x509CertEntry!.certificate!;
              if (certificate.c!.subject == issuer) {
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
      return List<X509Certificates>.generate(
          certificateList.length, (int i) => certificateList[i]);
    }
    return null;
  }

  /// internal method
  Future<List<X509Certificates>?> getCertificateChainAsync(String key) async {
    if (!isKey(key)) {
      return null;
    }
    List<X509Certificates>? x509Certificates;
    await getCertificateAsync(key).then((X509Certificates? certificates) {
      if (certificates != null) {
        final List<X509Certificates> certificateList = <X509Certificates>[];
        bool isContinue = true;
        while (certificates != null) {
          final X509Certificate x509Certificate = certificates.certificate!;
          X509Certificates? nextCertificate;
          final Asn1Octet? x509Extension = x509Certificate
              .getExtension(X509Extensions.authorityKeyIdentifier);
          if (x509Extension != null) {
            final _KeyIdentifier id = _KeyIdentifier.getKeyIdentifier(
                Asn1Stream(PdfStreamReader(x509Extension.getOctets()))
                    .readAsn1());
            if (id.keyID != null) {
              if (_chainCertificates
                  .containsKey(_CertificateIdentifier(id: id.keyID))) {
                nextCertificate =
                    _chainCertificates[_CertificateIdentifier(id: id.keyID)];
              }
            }
          }
          if (nextCertificate == null) {
            final X509Name? issuer = x509Certificate.c!.issuer;
            final X509Name? subject = x509Certificate.c!.subject;
            if (!(issuer == subject)) {
              final List<_CertificateIdentifier> keys =
                  _chainCertificates.keys.toList();
              // ignore: avoid_function_literals_in_foreach_calls
              keys.forEach((_CertificateIdentifier certId) {
                X509Certificates? x509CertEntry;
                if (_chainCertificates.containsKey(certId)) {
                  x509CertEntry = _chainCertificates[certId];
                }
                final X509Certificate certificate = x509CertEntry!.certificate!;
                if (certificate.c!.subject == issuer) {
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
        x509Certificates = List<X509Certificates>.generate(
            certificateList.length, (int i) => certificateList[i]);
      }
    });
    return x509Certificates;
  }

  /// internal method
  List<X509Certificates> getChainCertificates() {
    return _chainCertificates.values.toList();
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
  _CertificateIdentifier({CipherParameter? pubKey, List<int>? id}) {
    this.id = pubKey != null
        ? PdfPKCSCertificate.createSubjectKeyID(pubKey)._bytes
        : id;
  }
  //Fields
  List<int>? id;
  //Implements
  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  bool operator ==(Object other) {
    if (other is _CertificateIdentifier) {
      return Asn1.areEqual(id, other.id);
    } else {
      return false;
    }
  }

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  int get hashCode => Asn1.getHashCode(id);
}

class _PasswordUtility {
  _PasswordUtility() {
    _cipherUtils = _CipherUtils();
    _pkcs12 = 'Pkcs12';
    _algorithms = <String?, String>{};
    _type = <String, String?>{};
    _ids = <String, DerObjectID>{};
    _algorithms['PBEWITHSHAAND40BITRC4'] = 'PBEwithSHA-1and40bitRC4';
    _algorithms['PBEWITHSHA1AND40BITRC4'] = 'PBEwithSHA-1and40bitRC4';
    _algorithms['PBEWITHSHA-1AND40BITRC4'] = 'PBEwithSHA-1and40bitRC4';
    _algorithms[PkcsObjectId.pbeWithShaAnd40BitRC4.id] =
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
    _algorithms[PkcsObjectId.pbeWithShaAnd3KeyTripleDesCbc.id] =
        'PBEwithSHA-1and3-keyDESEDE-CBC';
    _algorithms['PBEWITHSHAAND40BITRC2-CBC'] = 'PBEwithSHA-1and40bitRC2-CBC';
    _algorithms['PBEWITHSHA1AND40BITRC2-CBC'] = 'PBEwithSHA-1and40bitRC2-CBC';
    _algorithms['PBEWITHSHA-1AND40BITRC2-CBC'] = 'PBEwithSHA-1and40bitRC2-CBC';
    _algorithms[PkcsObjectId.pbewithShaAnd40BitRC2Cbc.id] =
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
    _ids['PBEwithSHA-1and128bitRC4'] = PkcsObjectId.pbeWithShaAnd128BitRC4;
    _ids['PBEwithSHA-1and40bitRC4'] = PkcsObjectId.pbeWithShaAnd40BitRC4;
    _ids['PBEwithSHA-1and3-keyDESEDE-CBC'] =
        PkcsObjectId.pbeWithShaAnd3KeyTripleDesCbc;
    _ids['PBEwithSHA-1and2-keyDESEDE-CBC'] =
        PkcsObjectId.pbeWithShaAnd2KeyTripleDesCbc;
    _ids['PBEwithSHA-1and128bitRC2-CBC'] =
        PkcsObjectId.pbeWithShaAnd128BitRC2Cbc;
    _ids['PBEwithSHA-1and40bitRC2-CBC'] = PkcsObjectId.pbewithShaAnd40BitRC2Cbc;
  }

  //Fields
  String? _pkcs12;
  late Map<String?, String> _algorithms;
  late Map<String, String?> _type;
  late Map<String, DerObjectID> _ids;
  late _CipherUtils _cipherUtils;

  //Implementation
  dynamic createEncoder(dynamic obj) {
    dynamic result;
    if (obj is Algorithms) {
      result = createEncoder(obj.id!.id);
    } else if (obj is DerObjectID) {
      result = createEncoder(obj.id);
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

      if (mechanism != null &&
          (mechanism!.startsWith('PBEwithMD2') ||
              mechanism!.startsWith('PBEwithMD5') ||
              mechanism!.startsWith('PBEwithSHA-1') ||
              mechanism!.startsWith('PBEwithSHA-256'))) {
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

  ICipherParameter? generateCipherParameters(String algorithm, String password,
      bool isWrong, Asn1Encode? pbeParameters) {
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
    ICipherParameter? parameters;
    _PasswordGenerator generator;
    if (mechanism.startsWith('PBEwithSHA-1')) {
      generator = getEncoder(_type[mechanism], DigestAlgorithms.sha1, keyBytes,
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
      generator = getEncoder(_type[mechanism], DigestAlgorithms.sha256,
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
    keyBytes = List<int>.generate(keyBytes.length, (int i) => 0);
    return fixDataEncryptionParity(mechanism, parameters);
  }

  static int getByteLength(String digest) {
    return (digest == DigestAlgorithms.md5 ||
            digest == DigestAlgorithms.sha1 ||
            digest == DigestAlgorithms.sha256 ||
            digest.contains('Hmac'))
        ? 64
        : 128;
  }

  static int? getBlockSize(String digest) {
    int? result;
    if (digest == DigestAlgorithms.md5) {
      result = 16;
    } else if (digest == DigestAlgorithms.sha1) {
      result = 20;
    } else if (digest == DigestAlgorithms.sha256) {
      result = 32;
    } else if (digest == DigestAlgorithms.sha512) {
      result = 64;
    } else if (digest == DigestAlgorithms.sha384) {
      result = 48;
    } else if (digest.contains('Hmac')) {
      result = 20;
    }
    return result;
  }

  ICipherParameter? fixDataEncryptionParity(
      String mechanism, ICipherParameter? parameters) {
    if (!mechanism.endsWith('DES-CBC') & !mechanism.endsWith('DESEDE-CBC')) {
      return parameters;
    }
    if (parameters is InvalidParameter) {
      return InvalidParameter(
          fixDataEncryptionParity(mechanism, parameters.parameters),
          parameters.bytes!);
    }
    final KeyParameter kParam = parameters! as KeyParameter;
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
    return KeyParameter(keyBytes);
  }

  bool isPkcs12(String algorithm) {
    final String? mechanism = getAlgorithmFromUpeerInvariant(algorithm);
    return mechanism != null &&
        _type.containsKey(mechanism) &&
        _pkcs12 == _type[mechanism];
  }

  String getDigest(String algorithm) {
    String? digest = getAlgorithmFromUpeerInvariant(algorithm);
    digest ??= algorithm;
    if (digest.contains('sha_1') ||
        digest.contains('sha-1') ||
        digest.contains('sha1')) {
      digest = DigestAlgorithms.hmacWithSha1;
    } else if (digest.contains('sha_256') ||
        digest.contains('sha-256') ||
        digest.contains('sha256')) {
      digest = DigestAlgorithms.hmacWithSha256;
    } else if (digest.contains('md5') ||
        digest.contains('md_5') ||
        digest.contains('md-5')) {
      digest = DigestAlgorithms.hmacWithMd5;
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
  ICipherParameter generateParam(int? keySize, [String? algorithm, int? size]);
  void init(List<int> password, List<int> value, int count) {
    _password = Asn1.clone(password);
    _value = Asn1.clone(value);
    _count = count;
  }

  static List<int> toBytes(String password, bool isWrong) {
    if (password.isEmpty) {
      return isWrong ? List<int>.generate(2, (int i) => 0) : <int>[];
    }
    final List<int> bytes =
        List<int>.generate((password.length + 1) * 2, (int i) => 0);
    final List<int> tempBytes = encodeBigEndian(password);
    int i = 0;
    // ignore: avoid_function_literals_in_foreach_calls
    tempBytes.forEach((int tempByte) {
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
    if (digest == DigestAlgorithms.md5) {
      result = md5;
    } else if (digest == DigestAlgorithms.sha1) {
      result = sha1;
    } else if (digest == DigestAlgorithms.sha256) {
      result = sha256;
    } else if (digest == DigestAlgorithms.sha384) {
      result = sha384;
    } else if (digest == DigestAlgorithms.sha512) {
      result = sha512;
    } else if (digest == DigestAlgorithms.hmacWithSha1) {
      result = Hmac(sha1, utf8.encode(password));
    } else if (digest == DigestAlgorithms.hmacWithSha256) {
      result = Hmac(sha256, utf8.encode(password));
    } else if (digest == DigestAlgorithms.hmacWithMd5) {
      result = Hmac(md5, utf8.encode(password));
    } else {
      throw ArgumentError.value(digest, 'digest', 'Invalid message digest');
    }
    return result;
  }

  @override
  ICipherParameter generateParam(int? keySize, [String? algorithm, int? size]) {
    if (size != null) {
      size = size ~/ 8;
      keySize = keySize! ~/ 8;
      final List<int> bytes = generateDerivedKey(_keyMaterial, keySize);
      final _ParamUtility util = _ParamUtility();
      final KeyParameter key =
          util.createKeyParameter(algorithm!, bytes, 0, keySize);
      final List<int> iv = generateDerivedKey(_invaidMaterial, size);
      return InvalidParameter(key, iv, 0, size);
    } else if (algorithm != null) {
      keySize = keySize! ~/ 8;
      final List<int> bytes = generateDerivedKey(_keyMaterial, keySize);
      final _ParamUtility util = _ParamUtility();
      return util.createKeyParameter(algorithm, bytes, 0, keySize);
    } else {
      keySize = keySize! ~/ 8;
      final List<int> bytes = generateDerivedKey(_keyMaterial, keySize);
      return KeyParameter.fromLengthValue(bytes, 0, keySize);
    }
  }

  List<int> generateDerivedKey(int? id, int length) {
    final List<int> d = List<int>.generate(_length, (int index) => 0);
    final List<int> derivedKey = List<int>.generate(length, (int index) => 0);
    for (int index = 0; index != d.length; index++) {
      d[index] = id!.toUnsigned(8);
    }
    List<int> s;
    if (_value != null && _value!.isNotEmpty) {
      s = List<int>.generate(
          _length * ((_value!.length + _length - 1) ~/ _length),
          (int index) => 0);
      for (int index = 0; index != s.length; index++) {
        s[index] = _value![index % _value!.length];
      }
    } else {
      s = <int>[];
    }
    List<int> password;
    if (_password != null && _password!.isNotEmpty) {
      password = List<int>.generate(
          _length * ((_password!.length + _length - 1) ~/ _length),
          (int index) => 0);
      for (int index = 0; index != password.length; index++) {
        password[index] = _password![index % _password!.length];
      }
    } else {
      password = <int>[];
    }
    List<int> tempBytes =
        List<int>.generate(s.length + password.length, (int index) => 0);
    List.copyRange(tempBytes, 0, s, 0, s.length);
    List.copyRange(tempBytes, s.length, password, 0, password.length);
    final List<int> b = List<int>.generate(_length, (int index) => 0);
    final int c = (length + _size! - 1) ~/ _size!;
    List<int>? a = List<int>.generate(_size!, (int index) => 0);
    for (int i = 1; i <= c; i++) {
      final dynamic output = AccumulatorSink<Digest>();
      final dynamic input = sha1.startChunkedConversion(output);
      input.add(d);
      input.add(tempBytes);
      input.close();
      a = output.events.single.bytes as List<int>?;
      for (int j = 1; j != _count; j++) {
        a = _digest.convert(a).bytes as List<int>?;
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

class _Pkcs12PasswordParameter extends Asn1Encode {
  _Pkcs12PasswordParameter(Asn1Sequence sequence) {
    if (sequence.count != 2) {
      throw ArgumentError.value(
          sequence, 'sequence', 'Invalid length in sequence');
    }
    _octet = Asn1Octet.getOctetStringFromObject(sequence[0]);
    _iterations = DerInteger.getNumber(sequence[1]);
  }
  //Fields
  DerInteger? _iterations;
  Asn1Octet? _octet;
  //Implementation
  static _Pkcs12PasswordParameter getPbeParameter(dynamic obj) {
    _Pkcs12PasswordParameter result;
    if (obj is _Pkcs12PasswordParameter) {
      result = obj;
    } else if (obj is Asn1Sequence) {
      result = _Pkcs12PasswordParameter(obj);
    } else {
      throw ArgumentError.value(obj, 'obj', 'Invalid entry');
    }
    return result;
  }

  @override
  Asn1 getAsn1() {
    return DerSequence(array: <Asn1Encode?>[_octet, _iterations]);
  }
}

class _ParamUtility {
  _ParamUtility() {
    _algorithms = <String, String>{};
    addAlgorithm('DESEDE', <dynamic>[
      'DESEDEWRAP',
      'TDEA',
      DerObjectID('1.3.14.3.2.17'),
      PkcsObjectId.idAlgCms3DesWrap
    ]);
    addAlgorithm('DESEDE3', <dynamic>[PkcsObjectId.desEde3Cbc]);
    addAlgorithm(
        'RC2', <dynamic>[PkcsObjectId.rc2Cbc, PkcsObjectId.idAlgCmsRC2Wrap]);
  }

  //Fields
  late Map<String, String> _algorithms;

  //Implementation
  void addAlgorithm(String name, List<dynamic> objects) {
    _algorithms[name] = name;
    // ignore: avoid_function_literals_in_foreach_calls
    objects.forEach((dynamic entry) {
      if (entry is String) {
        _algorithms[entry] = name;
      } else {
        _algorithms[entry.toString()] = name;
      }
    });
  }

  KeyParameter createKeyParameter(
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
    return KeyParameter.fromLengthValue(bytes, offset, length!);
  }
}

class _DataEncryptionParameter extends KeyParameter {
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
  List<int> get keys => List<int>.from(bytes!);
  @override
  set keys(List<int>? value) {
    bytes = value;
  }
}

class _DesedeAlgorithmParameter extends _DataEncryptionParameter {
  _DesedeAlgorithmParameter(List<int> key, int keyOffset, int? keyLength)
      : super(fixKey(key, keyOffset, keyLength));
  //Implementation
  static List<int> fixKey(List<int> key, int keyOffset, int? keyLength) {
    final List<int> tmp = List<int>.generate(24, (int i) => 0);
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
  List<int> get keys => List<int>.from(bytes!);
  @override
  set keys(List<int>? value) {
    bytes = value;
  }
}

class _CipherUtils {
  _CipherUtils() {
    _algorithms = <String, String>{};
  }
  //Fields
  late Map<String, String> _algorithms;
  //Implementation
  IBufferedCipher getCipher(String algorithm) {
    String? value;
    if (_algorithms.isNotEmpty) {
      value = _algorithms[algorithm];
    }
    if (value != null) {
      algorithm = value;
    }
    final List<String> parts = algorithm.split('/');
    ICipher? blockCipher;
    ICipherBlock? asymBlockCipher;
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
        asymBlockCipher = RsaAlgorithm();
        break;
      // ignore: no_default_cases
      default:
        throw ArgumentError.value(
            cipherAlgorithm, 'algorithm', 'Invalid cipher algorithm');
    }
    bool isPadded = true;
    IPadding? padding;
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
          asymBlockCipher = Pkcs1Encoding(asymBlockCipher);
          break;
        case _CipherPaddingType.pkcs5:
        case _CipherPaddingType.pkcs5Padding:
        case _CipherPaddingType.pkcs7:
        case _CipherPaddingType.pkcs7Padding:
          padding = Pkcs7Padding();
          break;
        // ignore: no_default_cases
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
          blockCipher = CipherBlockChainingMode(blockCipher);
          break;
        case _CipherMode.cts:
          blockCipher = CipherBlockChainingMode(blockCipher);
          break;
        // ignore: no_default_cases
        default:
          throw ArgumentError.value(
              cipherMode, 'CipherMode', 'Invalid cipher algorithm');
      }
    }
    if (blockCipher != null) {
      if (padding != null) {
        return BufferedBlockPadding(blockCipher, padding);
      }
      if (!isPadded || blockCipher.isBlock!) {
        return BufferedCipher(blockCipher);
      }
      return BufferedBlockPadding(blockCipher);
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

class _KeyIdentifier extends Asn1Encode {
  _KeyIdentifier(Asn1Sequence sequence) {
    // ignore: avoid_function_literals_in_foreach_calls
    sequence.objects!.forEach((dynamic entry) {
      if (entry is Asn1Tag) {
        switch (entry.tagNumber) {
          case 0:
            _keyIdentifier = Asn1Octet.getOctetStringFromObject(entry);
            break;
          case 1:
            break;
          case 2:
            _serialNumber = DerInteger.getNumberFromTag(entry, false);
            break;
          default:
            throw ArgumentError.value(
                sequence, 'sequence', 'Invalid entry in sequence');
        }
      }
    });
  }
  //Fields
  Asn1Octet? _keyIdentifier;
  DerInteger? _serialNumber;
  //Properties
  List<int>? get keyID => _keyIdentifier?.getOctets();
  //Implementation
  static _KeyIdentifier getKeyIdentifier(dynamic obj) {
    _KeyIdentifier result;
    if (obj is _KeyIdentifier) {
      result = obj;
    } else if (obj is Asn1Sequence) {
      result = _KeyIdentifier(obj);
    } else if (obj is X509Extension) {
      result = getKeyIdentifier(X509Extension.convertValueToObject(obj));
    } else {
      throw ArgumentError.value(obj, 'obj', 'Invalid entry');
    }
    return result;
  }

  @override
  Asn1 getAsn1() {
    final Asn1EncodeCollection collection = Asn1EncodeCollection();
    if (_keyIdentifier != null) {
      collection.encodableObjects.add(DerTag(0, _keyIdentifier, false));
    }
    if (_serialNumber != null) {
      collection.encodableObjects.add(DerTag(2, _serialNumber, false));
    }
    return DerSequence(collection: collection);
  }

  @override
  String toString() {
    return 'AuthorityKeyIdentifier: KeyID(${String.fromCharCodes(_keyIdentifier!.getOctets()!)})';
  }
}

class _DesEdeAlogorithm extends _DataEncryption {
  _DesEdeAlogorithm() : super();
  List<int>? _key1;
  List<int>? _key2;
  List<int>? _key3;
  bool? _isEncryption;

  //Properties
  @override
  int? get blockSize => _blockSize;
  @override
  String get algorithmName => Asn1.desEde;
  //Implementation
  @override
  void initialize(bool? forEncryption, ICipherParameter? parameters) {
    if (parameters is! KeyParameter) {
      throw ArgumentError.value(parameters, 'parameters', 'Invalid parameter');
    }
    final List<int> keyMaster = parameters.keys;
    if (keyMaster.length != 24 && keyMaster.length != 16) {
      throw ArgumentError.value(parameters, 'parameters',
          'Invalid key size. Size must be 16 or 24 bytes.');
    }
    _isEncryption = forEncryption;
    final List<int> key1 = List<int>.generate(8, (int i) => 0);
    List.copyRange(key1, 0, keyMaster, 0, key1.length);
    _key1 = generateWorkingKey(forEncryption, key1);
    final List<int> key2 = List<int>.generate(8, (int i) => 0);
    List.copyRange(key2, 0, keyMaster, 8, 8 + key2.length);
    _key2 = generateWorkingKey(!forEncryption!, key2);
    if (keyMaster.length == 24) {
      final List<int> key3 = List<int>.generate(8, (int i) => 0);
      List.copyRange(key3, 0, keyMaster, 16, 16 + key3.length);
      _key3 = generateWorkingKey(forEncryption, key3);
    } else {
      _key3 = _key1;
    }
  }

  @override
  Map<String, dynamic> processBlock(
      [List<int>? inputBytes,
      int? inOffset,
      List<int>? outputBytes,
      int? outOffset]) {
    ArgumentError.checkNotNull(_key1);
    if ((inOffset! + _blockSize!) > inputBytes!.length) {
      throw ArgumentError.value(
          inOffset, 'inOffset', 'Invalid length in input bytes');
    }
    if ((outOffset! + _blockSize!) > outputBytes!.length) {
      throw ArgumentError.value(
          inOffset, 'inOffset', 'Invalid length in output bytes');
    }
    final List<int> tempBytes = List<int>.generate(_blockSize!, (int i) => 0);
    if (_isEncryption!) {
      encryptData(_key1, inputBytes, inOffset, tempBytes, 0);
      encryptData(_key2, tempBytes, 0, tempBytes, 0);
      encryptData(_key3, tempBytes, 0, outputBytes, outOffset);
    } else {
      encryptData(_key3, inputBytes, inOffset, tempBytes, 0);
      encryptData(_key2, tempBytes, 0, tempBytes, 0);
      encryptData(_key1, tempBytes, 0, outputBytes, outOffset);
    }
    return <String, dynamic>{'length': _blockSize, 'output': outputBytes};
  }

  @override
  void reset() {}
}

class _DataEncryption implements ICipher {
  _DataEncryption() {
    _blockSize = 8;
    byteBit = <int>[128, 64, 32, 16, 8, 4, 2, 1];
    bigByte = <int>[
      0x800000,
      0x400000,
      0x200000,
      0x100000,
      0x80000,
      0x40000,
      0x20000,
      0x10000,
      0x8000,
      0x4000,
      0x2000,
      0x1000,
      0x800,
      0x400,
      0x200,
      0x100,
      0x80,
      0x40,
      0x20,
      0x10,
      0x8,
      0x4,
      0x2,
      0x1
    ];
    pc1 = <int>[
      56,
      48,
      40,
      32,
      24,
      16,
      8,
      0,
      57,
      49,
      41,
      33,
      25,
      17,
      9,
      1,
      58,
      50,
      42,
      34,
      26,
      18,
      10,
      2,
      59,
      51,
      43,
      35,
      62,
      54,
      46,
      38,
      30,
      22,
      14,
      6,
      61,
      53,
      45,
      37,
      29,
      21,
      13,
      5,
      60,
      52,
      44,
      36,
      28,
      20,
      12,
      4,
      27,
      19,
      11,
      3
    ];
    toTrot = <int>[1, 2, 4, 6, 8, 10, 12, 14, 15, 17, 19, 21, 23, 25, 27, 28];
    pc2 = <int>[
      13,
      16,
      10,
      23,
      0,
      4,
      2,
      27,
      14,
      5,
      20,
      9,
      22,
      18,
      11,
      3,
      25,
      7,
      15,
      6,
      26,
      19,
      12,
      1,
      40,
      51,
      30,
      36,
      46,
      54,
      29,
      39,
      50,
      44,
      32,
      47,
      43,
      48,
      38,
      55,
      33,
      52,
      45,
      41,
      49,
      35,
      28,
      31
    ];
    sp1 = <int>[
      0x01010400,
      0x00000000,
      0x00010000,
      0x01010404,
      0x01010004,
      0x00010404,
      0x00000004,
      0x00010000,
      0x00000400,
      0x01010400,
      0x01010404,
      0x00000400,
      0x01000404,
      0x01010004,
      0x01000000,
      0x00000004,
      0x00000404,
      0x01000400,
      0x01000400,
      0x00010400,
      0x00010400,
      0x01010000,
      0x01010000,
      0x01000404,
      0x00010004,
      0x01000004,
      0x01000004,
      0x00010004,
      0x00000000,
      0x00000404,
      0x00010404,
      0x01000000,
      0x00010000,
      0x01010404,
      0x00000004,
      0x01010000,
      0x01010400,
      0x01000000,
      0x01000000,
      0x00000400,
      0x01010004,
      0x00010000,
      0x00010400,
      0x01000004,
      0x00000400,
      0x00000004,
      0x01000404,
      0x00010404,
      0x01010404,
      0x00010004,
      0x01010000,
      0x01000404,
      0x01000004,
      0x00000404,
      0x00010404,
      0x01010400,
      0x00000404,
      0x01000400,
      0x01000400,
      0x00000000,
      0x00010004,
      0x00010400,
      0x00000000,
      0x01010004
    ];
    sp2 = <int>[
      0x80108020,
      0x80008000,
      0x00008000,
      0x00108020,
      0x00100000,
      0x00000020,
      0x80100020,
      0x80008020,
      0x80000020,
      0x80108020,
      0x80108000,
      0x80000000,
      0x80008000,
      0x00100000,
      0x00000020,
      0x80100020,
      0x00108000,
      0x00100020,
      0x80008020,
      0x00000000,
      0x80000000,
      0x00008000,
      0x00108020,
      0x80100000,
      0x00100020,
      0x80000020,
      0x00000000,
      0x00108000,
      0x00008020,
      0x80108000,
      0x80100000,
      0x00008020,
      0x00000000,
      0x00108020,
      0x80100020,
      0x00100000,
      0x80008020,
      0x80100000,
      0x80108000,
      0x00008000,
      0x80100000,
      0x80008000,
      0x00000020,
      0x80108020,
      0x00108020,
      0x00000020,
      0x00008000,
      0x80000000,
      0x00008020,
      0x80108000,
      0x00100000,
      0x80000020,
      0x00100020,
      0x80008020,
      0x80000020,
      0x00100020,
      0x00108000,
      0x00000000,
      0x80008000,
      0x00008020,
      0x80000000,
      0x80100020,
      0x80108020,
      0x00108000
    ];
    sp3 = <int>[
      0x00000208,
      0x08020200,
      0x00000000,
      0x08020008,
      0x08000200,
      0x00000000,
      0x00020208,
      0x08000200,
      0x00020008,
      0x08000008,
      0x08000008,
      0x00020000,
      0x08020208,
      0x00020008,
      0x08020000,
      0x00000208,
      0x08000000,
      0x00000008,
      0x08020200,
      0x00000200,
      0x00020200,
      0x08020000,
      0x08020008,
      0x00020208,
      0x08000208,
      0x00020200,
      0x00020000,
      0x08000208,
      0x00000008,
      0x08020208,
      0x00000200,
      0x08000000,
      0x08020200,
      0x08000000,
      0x00020008,
      0x00000208,
      0x00020000,
      0x08020200,
      0x08000200,
      0x00000000,
      0x00000200,
      0x00020008,
      0x08020208,
      0x08000200,
      0x08000008,
      0x00000200,
      0x00000000,
      0x08020008,
      0x08000208,
      0x00020000,
      0x08000000,
      0x08020208,
      0x00000008,
      0x00020208,
      0x00020200,
      0x08000008,
      0x08020000,
      0x08000208,
      0x00000208,
      0x08020000,
      0x00020208,
      0x00000008,
      0x08020008,
      0x00020200
    ];
    sp4 = <int>[
      0x00802001,
      0x00002081,
      0x00002081,
      0x00000080,
      0x00802080,
      0x00800081,
      0x00800001,
      0x00002001,
      0x00000000,
      0x00802000,
      0x00802000,
      0x00802081,
      0x00000081,
      0x00000000,
      0x00800080,
      0x00800001,
      0x00000001,
      0x00002000,
      0x00800000,
      0x00802001,
      0x00000080,
      0x00800000,
      0x00002001,
      0x00002080,
      0x00800081,
      0x00000001,
      0x00002080,
      0x00800080,
      0x00002000,
      0x00802080,
      0x00802081,
      0x00000081,
      0x00800080,
      0x00800001,
      0x00802000,
      0x00802081,
      0x00000081,
      0x00000000,
      0x00000000,
      0x00802000,
      0x00002080,
      0x00800080,
      0x00800081,
      0x00000001,
      0x00802001,
      0x00002081,
      0x00002081,
      0x00000080,
      0x00802081,
      0x00000081,
      0x00000001,
      0x00002000,
      0x00800001,
      0x00002001,
      0x00802080,
      0x00800081,
      0x00002001,
      0x00002080,
      0x00800000,
      0x00802001,
      0x00000080,
      0x00800000,
      0x00002000,
      0x00802080
    ];
    sp5 = <int>[
      0x00000100,
      0x02080100,
      0x02080000,
      0x42000100,
      0x00080000,
      0x00000100,
      0x40000000,
      0x02080000,
      0x40080100,
      0x00080000,
      0x02000100,
      0x40080100,
      0x42000100,
      0x42080000,
      0x00080100,
      0x40000000,
      0x02000000,
      0x40080000,
      0x40080000,
      0x00000000,
      0x40000100,
      0x42080100,
      0x42080100,
      0x02000100,
      0x42080000,
      0x40000100,
      0x00000000,
      0x42000000,
      0x02080100,
      0x02000000,
      0x42000000,
      0x00080100,
      0x00080000,
      0x42000100,
      0x00000100,
      0x02000000,
      0x40000000,
      0x02080000,
      0x42000100,
      0x40080100,
      0x02000100,
      0x40000000,
      0x42080000,
      0x02080100,
      0x40080100,
      0x00000100,
      0x02000000,
      0x42080000,
      0x42080100,
      0x00080100,
      0x42000000,
      0x42080100,
      0x02080000,
      0x00000000,
      0x40080000,
      0x42000000,
      0x00080100,
      0x02000100,
      0x40000100,
      0x00080000,
      0x00000000,
      0x40080000,
      0x02080100,
      0x40000100
    ];
    sp6 = <int>[
      0x20000010,
      0x20400000,
      0x00004000,
      0x20404010,
      0x20400000,
      0x00000010,
      0x20404010,
      0x00400000,
      0x20004000,
      0x00404010,
      0x00400000,
      0x20000010,
      0x00400010,
      0x20004000,
      0x20000000,
      0x00004010,
      0x00000000,
      0x00400010,
      0x20004010,
      0x00004000,
      0x00404000,
      0x20004010,
      0x00000010,
      0x20400010,
      0x20400010,
      0x00000000,
      0x00404010,
      0x20404000,
      0x00004010,
      0x00404000,
      0x20404000,
      0x20000000,
      0x20004000,
      0x00000010,
      0x20400010,
      0x00404000,
      0x20404010,
      0x00400000,
      0x00004010,
      0x20000010,
      0x00400000,
      0x20004000,
      0x20000000,
      0x00004010,
      0x20000010,
      0x20404010,
      0x00404000,
      0x20400000,
      0x00404010,
      0x20404000,
      0x00000000,
      0x20400010,
      0x00000010,
      0x00004000,
      0x20400000,
      0x00404010,
      0x00004000,
      0x00400010,
      0x20004010,
      0x00000000,
      0x20404000,
      0x20000000,
      0x00400010,
      0x20004010
    ];
    sp7 = <int>[
      0x00200000,
      0x04200002,
      0x04000802,
      0x00000000,
      0x00000800,
      0x04000802,
      0x00200802,
      0x04200800,
      0x04200802,
      0x00200000,
      0x00000000,
      0x04000002,
      0x00000002,
      0x04000000,
      0x04200002,
      0x00000802,
      0x04000800,
      0x00200802,
      0x00200002,
      0x04000800,
      0x04000002,
      0x04200000,
      0x04200800,
      0x00200002,
      0x04200000,
      0x00000800,
      0x00000802,
      0x04200802,
      0x00200800,
      0x00000002,
      0x04000000,
      0x00200800,
      0x04000000,
      0x00200800,
      0x00200000,
      0x04000802,
      0x04000802,
      0x04200002,
      0x04200002,
      0x00000002,
      0x00200002,
      0x04000000,
      0x04000800,
      0x00200000,
      0x04200800,
      0x00000802,
      0x00200802,
      0x04200800,
      0x00000802,
      0x04000002,
      0x04200802,
      0x04200000,
      0x00200800,
      0x00000000,
      0x00000002,
      0x04200802,
      0x00000000,
      0x00200802,
      0x04200000,
      0x00000800,
      0x04000002,
      0x04000800,
      0x00000800,
      0x00200002
    ];
    sp8 = <int>[
      0x10001040,
      0x00001000,
      0x00040000,
      0x10041040,
      0x10000000,
      0x10001040,
      0x00000040,
      0x10000000,
      0x00040040,
      0x10040000,
      0x10041040,
      0x00041000,
      0x10041000,
      0x00041040,
      0x00001000,
      0x00000040,
      0x10040000,
      0x10000040,
      0x10001000,
      0x00001040,
      0x00041000,
      0x00040040,
      0x10040040,
      0x10041000,
      0x00001040,
      0x00000000,
      0x00000000,
      0x10040040,
      0x10000040,
      0x10001000,
      0x00041040,
      0x00040000,
      0x00041040,
      0x00040000,
      0x10041000,
      0x00001000,
      0x00000040,
      0x10040040,
      0x00001000,
      0x00041040,
      0x10001000,
      0x00000040,
      0x10000040,
      0x10040000,
      0x10040040,
      0x10000000,
      0x00040000,
      0x10001040,
      0x00000000,
      0x10041040,
      0x00040040,
      0x10000040,
      0x10040000,
      0x10001000,
      0x10001040,
      0x00000000,
      0x10041040,
      0x00041000,
      0x00041000,
      0x00001040,
      0x00001040,
      0x00040040,
      0x10000000,
      0x10041000
    ];
  }

  //Fields
  int? _blockSize;
  late List<int> byteBit;
  late List<int> bigByte;
  late List<int> pc1;
  late List<int> toTrot;
  late List<int> pc2;
  late List<int> sp1;
  late List<int> sp2;
  late List<int> sp3;
  late List<int> sp4;
  late List<int> sp5;
  late List<int> sp6;
  late List<int> sp7;
  late List<int> sp8;
  List<int>? _keys;

  //Properties
  List<int>? get keys => _keys;
  @override
  String get algorithmName => Asn1.des;
  @override
  bool get isBlock => false;
  @override
  int? get blockSize => _blockSize;

  //Implementation
  @override
  void initialize(bool? isEncryption, ICipherParameter? parameters) {
    if (parameters is! KeyParameter) {
      throw ArgumentError.value(parameters, 'parameters', 'Invalid parameter');
    }
    _keys = generateWorkingKey(isEncryption, parameters.keys);
  }

  @override
  Map<String, dynamic> processBlock(
      List<int>? inBytes, int inOffset, List<int>? outBytes, int? outOffset) {
    ArgumentError.checkNotNull(_keys);
    if ((inOffset + _blockSize!) > inBytes!.length) {
      throw ArgumentError.value(
          inOffset, 'inOffset', 'Invalid length in input bytes');
    }
    if ((outOffset! + _blockSize!) > outBytes!.length) {
      throw ArgumentError.value(
          outOffset, 'outOffset', 'Invalid length in output bytes');
    }
    encryptData(_keys, inBytes, inOffset, outBytes, outOffset);
    return <String, dynamic>{'length': _blockSize, 'output': outBytes};
  }

  @override
  void reset() {}
  List<int> generateWorkingKey(bool? isEncrypt, List<int> bytes) {
    final List<int> newKeys = List<int>.generate(32, (int i) => 0);
    final List<bool> bytes1 = List<bool>.generate(56, (int i) => false);
    final List<bool> bytes2 = List<bool>.generate(56, (int i) => false);
    for (int j = 0; j < 56; j++) {
      final int length = pc1[j];
      bytes1[j] =
          (bytes[length.toUnsigned(32) >> 3] & byteBit[length & 07]) != 0;
    }
    for (int i = 0; i < 16; i++) {
      int a;
      int b;
      int c;
      if (isEncrypt!) {
        b = i << 1;
      } else {
        b = (15 - i) << 1;
      }
      c = b + 1;
      newKeys[b] = newKeys[c] = 0;
      for (int j = 0; j < 28; j++) {
        a = j + toTrot[i];
        if (a < 28) {
          bytes2[j] = bytes1[a];
        } else {
          bytes2[j] = bytes1[a - 28];
        }
      }
      for (int j = 28; j < 56; j++) {
        a = j + toTrot[i];
        if (a < 56) {
          bytes2[j] = bytes1[a];
        } else {
          bytes2[j] = bytes1[a - 28];
        }
      }
      for (int j = 0; j < 24; j++) {
        if (bytes2[pc2[j]]) {
          newKeys[b] |= bigByte[j];
        }
        if (bytes2[pc2[j + 24]]) {
          newKeys[c] |= bigByte[j];
        }
      }
    }
    for (int i = 0; i != 32; i += 2) {
      int value1, value2;
      value1 = newKeys[i];
      value2 = newKeys[i + 1];
      newKeys[i] = (((value1 & 0x00fc0000) << 6).toUnsigned(32) |
              ((value1 & 0x00000fc0) << 10).toUnsigned(32) |
              ((value2 & 0x00fc0000).toUnsigned(32) >> 10) |
              ((value2 & 0x00000fc0).toUnsigned(32) >> 6))
          .toSigned(32);
      newKeys[i + 1] = (((value1 & 0x0003f000) << 12).toUnsigned(32) |
              ((value1 & 0x0000003f) << 16).toUnsigned(32) |
              ((value2 & 0x0003f000).toUnsigned(32) >> 4) |
              (value2 & 0x0000003f).toUnsigned(32))
          .toSigned(32);
    }
    return newKeys;
  }

  void encryptData(List<int>? keys, List<int> inputBytes, int inOffset,
      List<int> outBytes, int outOffset) {
    int left = Asn1.beToUInt32(inputBytes, inOffset);
    int right = Asn1.beToUInt32(inputBytes, inOffset + 4);
    int data = (((left >> 4) ^ right) & 0x0f0f0f0f).toUnsigned(32);
    right ^= data;
    left ^= data << 4;
    data = ((left >> 16) ^ right) & 0x0000ffff;
    right ^= data;
    left ^= data << 16;
    data = ((right >> 2) ^ left) & 0x33333333;
    left ^= data;
    right ^= data << 2;
    data = ((right >> 8) ^ left) & 0x00ff00ff;
    left ^= data;
    right ^= data << 8;
    right = ((right << 1) | (right >> 31)).toUnsigned(32);
    data = (left ^ right) & 0xaaaaaaaa;
    left ^= data;
    right ^= data;
    left = ((left << 1) | (left >> 31)).toUnsigned(32);
    for (int round = 0; round < 8; round++) {
      data = ((right << 28) | (right >> 4)).toUnsigned(32);
      data ^= keys![round * 4 + 0].toUnsigned(32);
      int value = sp7[data & 0x3f];
      value |= sp5[(data >> 8) & 0x3f];
      value |= sp3[(data >> 16) & 0x3f];
      value |= sp1[(data >> 24) & 0x3f];
      data = right ^ keys[round * 4 + 1].toUnsigned(32);
      value |= sp8[data & 0x3f];
      value |= sp6[(data >> 8) & 0x3f];
      value |= sp4[(data >> 16) & 0x3f];
      value |= sp2[(data >> 24) & 0x3f];
      left ^= value;
      data = ((left << 28) | (left >> 4)).toUnsigned(32);
      data ^= keys[round * 4 + 2].toUnsigned(32);
      value = sp7[data & 0x3f];
      value |= sp5[(data >> 8) & 0x3f];
      value |= sp3[(data >> 16) & 0x3f];
      value |= sp1[(data >> 24) & 0x3f];
      data = left ^ keys[round * 4 + 3].toUnsigned(32);
      value |= sp8[data & 0x3f];
      value |= sp6[(data >> 8) & 0x3f];
      value |= sp4[(data >> 16) & 0x3f];
      value |= sp2[(data >> 24) & 0x3f];
      right ^= value;
    }
    right = ((right << 31) | (right >> 1)).toUnsigned(32);
    data = (left ^ right) & 0xaaaaaaaa;
    left ^= data;
    right ^= data;
    left = ((left << 31) | (left >> 1)).toUnsigned(32);
    data = ((left >> 8) ^ right) & 0x00ff00ff;
    right ^= data;
    left ^= data << 8;
    data = ((left >> 2) ^ right) & 0x33333333;
    right ^= data;
    left ^= data << 2;
    data = ((right >> 16) ^ left) & 0x0000ffff;
    left ^= data;
    right ^= data << 16;
    data = ((right >> 4) ^ left) & 0x0f0f0f0f;
    left ^= data;
    right ^= data << 4;
    Asn1.uInt32ToBe(right, outBytes, outOffset);
    Asn1.uInt32ToBe(left, outBytes, outOffset + 4);
  }
}

class _Rc2Algorithm implements ICipher {
  _Rc2Algorithm() {
    _piTable = <int>[
      217,
      120,
      249,
      196,
      25,
      221,
      181,
      237,
      40,
      233,
      253,
      121,
      74,
      160,
      216,
      157,
      198,
      126,
      55,
      131,
      43,
      118,
      83,
      142,
      98,
      76,
      100,
      136,
      68,
      139,
      251,
      162,
      23,
      154,
      89,
      245,
      135,
      179,
      79,
      19,
      97,
      69,
      109,
      141,
      9,
      129,
      125,
      50,
      189,
      143,
      64,
      235,
      134,
      183,
      123,
      11,
      240,
      149,
      33,
      34,
      92,
      107,
      78,
      130,
      84,
      214,
      101,
      147,
      206,
      96,
      178,
      28,
      115,
      86,
      192,
      20,
      167,
      140,
      241,
      220,
      18,
      117,
      202,
      31,
      59,
      190,
      228,
      209,
      66,
      61,
      212,
      48,
      163,
      60,
      182,
      38,
      111,
      191,
      14,
      218,
      70,
      105,
      7,
      87,
      39,
      242,
      29,
      155,
      188,
      148,
      67,
      3,
      248,
      17,
      199,
      246,
      144,
      239,
      62,
      231,
      6,
      195,
      213,
      47,
      200,
      102,
      30,
      215,
      8,
      232,
      234,
      222,
      128,
      82,
      238,
      247,
      132,
      170,
      114,
      172,
      53,
      77,
      106,
      42,
      150,
      26,
      210,
      113,
      90,
      21,
      73,
      116,
      75,
      159,
      208,
      94,
      4,
      24,
      164,
      236,
      194,
      224,
      65,
      110,
      15,
      81,
      203,
      204,
      36,
      145,
      175,
      80,
      161,
      244,
      112,
      57,
      153,
      124,
      58,
      133,
      35,
      184,
      180,
      122,
      252,
      2,
      54,
      91,
      37,
      85,
      151,
      49,
      45,
      93,
      250,
      152,
      227,
      138,
      146,
      174,
      5,
      223,
      41,
      16,
      103,
      108,
      186,
      201,
      211,
      0,
      230,
      207,
      225,
      158,
      168,
      44,
      99,
      22,
      1,
      63,
      88,
      226,
      137,
      169,
      13,
      56,
      52,
      27,
      171,
      51,
      255,
      176,
      187,
      72,
      12,
      95,
      185,
      177,
      205,
      46,
      197,
      243,
      219,
      71,
      229,
      165,
      156,
      119,
      10,
      166,
      32,
      104,
      254,
      127,
      193,
      173
    ];
    _blockSize = 8;
  }
  //Fields
  int? _blockSize;
  late List<int> _key;
  bool? _isEncrypt;
  late List<int> _piTable;

  //Properties
  @override
  String get algorithmName => 'RC2';
  @override
  bool get isBlock => false;
  @override
  int? get blockSize => _blockSize;

  //Implementation
  List<int> generateKey(List<int> key, int bits) {
    int x;
    final List<int> xKey = List<int>.generate(128, (int i) => 0);
    for (int i = 0; i != key.length; i++) {
      xKey[i] = key[i] & 0xff;
    }
    int len = key.length;
    if (len < 128) {
      int index = 0;
      x = xKey[len - 1];
      do {
        x = _piTable[(x + xKey[index++]) & 255] & 0xff;
        xKey[len++] = x;
      } while (len < 128);
    }
    len = (bits + 7) >> 3;
    x = _piTable[xKey[128 - len] & (255 >> (7 & -bits))] & 0xff;
    xKey[128 - len] = x;
    for (int i = 128 - len - 1; i >= 0; i--) {
      x = _piTable[x ^ xKey[i + len]] & 0xff;
      xKey[i] = x;
    }
    final List<int> newKey = <int>[];
    for (int i = 0; i < 64; i++) {
      newKey.add(xKey[2 * i] + (xKey[2 * i + 1] << 8));
    }
    return newKey;
  }

  @override
  void initialize(bool? forEncryption, ICipherParameter? parameters) {
    _isEncrypt = forEncryption;
    if (parameters is KeyParameter) {
      final List<int> key = parameters.keys;
      _key = generateKey(key, key.length * 8);
    }
  }

  @override
  void reset() {}

  @override
  Map<String, dynamic> processBlock(
      List<int>? input, int inOff, List<int>? output, int? outOff) {
    if (_isEncrypt!) {
      encryptBlock(input!, inOff, output!, outOff!);
    } else {
      decryptBlock(input!, inOff, output!, outOff!);
    }
    return <String, dynamic>{'length': _blockSize, 'output': output};
  }

  int rotateWordLeft(int x, int y) {
    x &= 0xffff;
    return (x << y) | (x >> (16 - y));
  }

  void encryptBlock(
      List<int> input, int inOff, List<int> outBytes, int outOff) {
    int x76 = ((input[inOff + 7] & 0xff) << 8) + (input[inOff + 6] & 0xff);
    int x54 = ((input[inOff + 5] & 0xff) << 8) + (input[inOff + 4] & 0xff);
    int x32 = ((input[inOff + 3] & 0xff) << 8) + (input[inOff + 2] & 0xff);
    int x10 = ((input[inOff + 1] & 0xff) << 8) + (input[inOff + 0] & 0xff);
    for (int i = 0; i <= 16; i += 4) {
      x10 = rotateWordLeft(x10 + (x32 & ~x76) + (x54 & x76) + _key[i], 1);
      x32 = rotateWordLeft(x32 + (x54 & ~x10) + (x76 & x10) + _key[i + 1], 2);
      x54 = rotateWordLeft(x54 + (x76 & ~x32) + (x10 & x32) + _key[i + 2], 3);
      x76 = rotateWordLeft(x76 + (x10 & ~x54) + (x32 & x54) + _key[i + 3], 5);
    }
    x10 += _key[x76 & 63];
    x32 += _key[x10 & 63];
    x54 += _key[x32 & 63];
    x76 += _key[x54 & 63];
    for (int i = 20; i <= 40; i += 4) {
      x10 = rotateWordLeft(x10 + (x32 & ~x76) + (x54 & x76) + _key[i], 1);
      x32 = rotateWordLeft(x32 + (x54 & ~x10) + (x76 & x10) + _key[i + 1], 2);
      x54 = rotateWordLeft(x54 + (x76 & ~x32) + (x10 & x32) + _key[i + 2], 3);
      x76 = rotateWordLeft(x76 + (x10 & ~x54) + (x32 & x54) + _key[i + 3], 5);
    }
    x10 += _key[x76 & 63];
    x32 += _key[x10 & 63];
    x54 += _key[x32 & 63];
    x76 += _key[x54 & 63];
    for (int i = 44; i < 64; i += 4) {
      x10 = rotateWordLeft(x10 + (x32 & ~x76) + (x54 & x76) + _key[i], 1);
      x32 = rotateWordLeft(x32 + (x54 & ~x10) + (x76 & x10) + _key[i + 1], 2);
      x54 = rotateWordLeft(x54 + (x76 & ~x32) + (x10 & x32) + _key[i + 2], 3);
      x76 = rotateWordLeft(x76 + (x10 & ~x54) + (x32 & x54) + _key[i + 3], 5);
    }
    outBytes[outOff + 0] = x10.toUnsigned(8);
    outBytes[outOff + 1] = (x10 >> 8).toUnsigned(8);
    outBytes[outOff + 2] = x32.toUnsigned(8);
    outBytes[outOff + 3] = (x32 >> 8).toUnsigned(8);
    outBytes[outOff + 4] = x54.toUnsigned(8);
    outBytes[outOff + 5] = (x54 >> 8).toUnsigned(8);
    outBytes[outOff + 6] = x76.toUnsigned(8);
    outBytes[outOff + 7] = (x76 >> 8).toUnsigned(8);
  }

  void decryptBlock(
      List<int> input, int inOff, List<int> outBytes, int outOff) {
    int x76 = ((input[inOff + 7] & 0xff) << 8) + (input[inOff + 6] & 0xff);
    int x54 = ((input[inOff + 5] & 0xff) << 8) + (input[inOff + 4] & 0xff);
    int x32 = ((input[inOff + 3] & 0xff) << 8) + (input[inOff + 2] & 0xff);
    int x10 = ((input[inOff + 1] & 0xff) << 8) + (input[inOff + 0] & 0xff);
    for (int i = 60; i >= 44; i -= 4) {
      x76 =
          rotateWordLeft(x76, 11) - ((x10 & ~x54) + (x32 & x54) + _key[i + 3]);
      x54 =
          rotateWordLeft(x54, 13) - ((x76 & ~x32) + (x10 & x32) + _key[i + 2]);
      x32 =
          rotateWordLeft(x32, 14) - ((x54 & ~x10) + (x76 & x10) + _key[i + 1]);
      x10 = rotateWordLeft(x10, 15) - ((x32 & ~x76) + (x54 & x76) + _key[i]);
    }
    x76 -= _key[x54 & 63];
    x54 -= _key[x32 & 63];
    x32 -= _key[x10 & 63];
    x10 -= _key[x76 & 63];
    for (int i = 40; i >= 20; i -= 4) {
      x76 =
          rotateWordLeft(x76, 11) - ((x10 & ~x54) + (x32 & x54) + _key[i + 3]);
      x54 =
          rotateWordLeft(x54, 13) - ((x76 & ~x32) + (x10 & x32) + _key[i + 2]);
      x32 =
          rotateWordLeft(x32, 14) - ((x54 & ~x10) + (x76 & x10) + _key[i + 1]);
      x10 = rotateWordLeft(x10, 15) - ((x32 & ~x76) + (x54 & x76) + _key[i]);
    }
    x76 -= _key[x54 & 63];
    x54 -= _key[x32 & 63];
    x32 -= _key[x10 & 63];
    x10 -= _key[x76 & 63];
    for (int i = 16; i >= 0; i -= 4) {
      x76 =
          rotateWordLeft(x76, 11) - ((x10 & ~x54) + (x32 & x54) + _key[i + 3]);
      x54 =
          rotateWordLeft(x54, 13) - ((x76 & ~x32) + (x10 & x32) + _key[i + 2]);
      x32 =
          rotateWordLeft(x32, 14) - ((x54 & ~x10) + (x76 & x10) + _key[i + 1]);
      x10 = rotateWordLeft(x10, 15) - ((x32 & ~x76) + (x54 & x76) + _key[i]);
    }
    outBytes[outOff + 0] = x10.toUnsigned(8);
    outBytes[outOff + 1] = (x10 >> 8).toUnsigned(8);
    outBytes[outOff + 2] = x32.toUnsigned(8);
    outBytes[outOff + 3] = (x32 >> 8).toUnsigned(8);
    outBytes[outOff + 4] = x54.toUnsigned(8);
    outBytes[outOff + 5] = (x54 >> 8).toUnsigned(8);
    outBytes[outOff + 6] = x76.toUnsigned(8);
    outBytes[outOff + 7] = (x76 >> 8).toUnsigned(8);
  }
}

class _PfxData extends Asn1Encode {
  _PfxData(Asn1Sequence sequence) {
    _contentInformation = _ContentInformation.getInformation(sequence[1]);
    if (sequence.count == 3) {
      _macInformation = _MacInformation.getInformation(sequence[2]);
    }
  }
  _ContentInformation? _contentInformation;
  _MacInformation? _macInformation;
  @override
  Asn1 getAsn1() {
    final Asn1EncodeCollection collection = Asn1EncodeCollection(<Asn1Encode?>[
      DerInteger(bigIntToBytes(BigInt.from(3))),
      _contentInformation
    ]);
    if (_macInformation != null) {
      collection.encodableObjects.add(_macInformation);
    }
    return BerSequence(collection: collection);
  }
}

class _ContentInformation extends Asn1Encode {
  _ContentInformation(Asn1Sequence sequence) {
    if (sequence.count < 1 || sequence.count > 2) {
      throw ArgumentError.value(
          sequence, 'sequence', 'Invalid length in sequence');
    }
    _contentType = sequence[0] as DerObjectID?;
    if (sequence.count > 1) {
      final Asn1Tag tagged = sequence[1]! as Asn1Tag;
      if (!tagged.explicit! || tagged.tagNumber != 0) {
        throw ArgumentError.value(tagged, 'tagged', 'Invalid tag');
      }
      _content = tagged.getObject();
    }
  }
  //Fields
  DerObjectID? _contentType;
  Asn1Encode? _content;
  //Implementation
  static _ContentInformation? getInformation(dynamic obj) {
    _ContentInformation? result;
    if (obj == null || obj is _ContentInformation) {
      result = obj as _ContentInformation?;
    } else if (obj is Asn1Sequence) {
      result = _ContentInformation(obj);
    } else {
      throw ArgumentError.value(obj, 'obj', 'Invalid entry');
    }
    return result;
  }

  @override
  Asn1 getAsn1() {
    final Asn1EncodeCollection collection =
        Asn1EncodeCollection(<Asn1Encode?>[_contentType]);
    if (_content != null) {
      collection.encodableObjects.add(DerTag(0, _content));
    }
    return BerSequence(collection: collection);
  }
}

class _MacInformation extends Asn1Encode {
  _MacInformation(Asn1Sequence sequence) {
    _digest = DigestInformation.getDigestInformation(sequence[0]);
    _value = (sequence[1]! as Asn1Octet).getOctets();
    if (sequence.count == 3) {
      _count = (sequence[2]! as DerInteger).value;
    } else {
      _count = BigInt.one;
    }
  }
  //Fields
  DigestInformation? _digest;
  List<int>? _value;
  BigInt? _count;
  //Implementation
  static _MacInformation getInformation(dynamic obj) {
    _MacInformation result;
    if (obj is _MacInformation) {
      result = obj;
    } else if (obj is Asn1Sequence) {
      result = _MacInformation(obj);
    } else {
      throw ArgumentError.value(obj, 'obj', 'Invalid entry');
    }
    return result;
  }

  @override
  Asn1 getAsn1() {
    final Asn1EncodeCollection collection =
        Asn1EncodeCollection(<Asn1Encode?>[_digest, DerOctet(_value!)]);
    if (_count != BigInt.one) {
      collection.encodableObjects.add(DerInteger.fromNumber(_count));
    }
    return DerSequence(collection: collection);
  }
}

class _EncryptedPrivateKey extends Asn1Encode {
  _EncryptedPrivateKey(Asn1Sequence sequence) {
    if (sequence.count != 2) {
      throw ArgumentError.value(
          sequence, 'sequence', 'Invalid length in sequence');
    }
    _algorithms = Algorithms.getAlgorithms(sequence[0]);
    _octet = Asn1Octet.getOctetStringFromObject(sequence[1]);
  }

  //Fields
  Algorithms? _algorithms;
  Asn1Octet? _octet;

  //Implementation
  @override
  Asn1 getAsn1() {
    return DerSequence(array: <Asn1Encode?>[_algorithms, _octet]);
  }

  static _EncryptedPrivateKey getEncryptedPrivateKeyInformation(dynamic obj) {
    if (obj is _EncryptedPrivateKey) {
      return obj;
    }
    if (obj is Asn1Sequence) {
      return _EncryptedPrivateKey(obj);
    }
    throw ArgumentError.value(obj, 'obj', 'Invalid entry in sequence');
  }
}

class _KeyInformation extends Asn1Encode {
  _KeyInformation(Algorithms algorithms, Asn1 privateKey,
      [Asn1Set? attributes]) {
    _privateKey = privateKey;
    _algorithms = algorithms;
    if (attributes != null) {
      _attributes = attributes;
    }
  }
  _KeyInformation.fromSequence(Asn1Sequence? sequence) {
    if (sequence != null) {
      final List<dynamic> objects = sequence.objects!;
      if (objects.length >= 3) {
        _algorithms = Algorithms.getAlgorithms(objects[1]);
        final dynamic privateKeyValue = objects[2];
        try {
          _privateKey = Asn1Stream(PdfStreamReader(privateKeyValue.getOctets()))
              .readAsn1();
        } catch (e) {
          throw ArgumentError.value(sequence, 'sequence', 'Invalid sequence');
        }
        if (objects.length > 3) {
          _attributes = Asn1Set.getAsn1Set(objects[3]! as Asn1Tag?, false);
        }
      } else {
        throw ArgumentError.value(sequence, 'sequence', 'Invalid sequence');
      }
    }
  }

  //Fields
  Asn1? _privateKey;
  Algorithms? _algorithms;
  Asn1Set? _attributes;

  //Implementation
  static _KeyInformation? getInformation(dynamic obj) {
    if (obj is _KeyInformation) {
      return obj;
    }
    if (obj != null) {
      return _KeyInformation.fromSequence(Asn1Sequence.getSequence(obj));
    }
    return null;
  }

  @override
  Asn1 getAsn1() {
    final Asn1EncodeCollection v = Asn1EncodeCollection(<Asn1Encode?>[
      DerInteger.fromNumber(BigInt.from(0)),
      _algorithms,
      DerOctet.fromObject(_privateKey!)
    ]);
    if (_attributes != null) {
      v.encodableObjects.add(DerTag(0, _attributes, false));
    }
    return DerSequence(collection: v);
  }
}

class _RsaKey extends Asn1Encode {
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
  _RsaKey.fromSequence(Asn1Sequence sequence) {
    final BigInt version = (sequence[0]! as DerInteger).value;
    if (version.toSigned(32).toInt() != 0) {
      throw ArgumentError.value(sequence, 'sequence', 'Invalid RSA key');
    }
    _modulus = (sequence[1]! as DerInteger).value;
    _publicExponent = (sequence[2]! as DerInteger).value;
    _privateExponent = (sequence[3]! as DerInteger).value;
    _prime1 = (sequence[4]! as DerInteger).value;
    _prime2 = (sequence[5]! as DerInteger).value;
    _exponent1 = (sequence[6]! as DerInteger).value;
    _exponent2 = (sequence[7]! as DerInteger).value;
    _coefficient = (sequence[8]! as DerInteger).value;
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
  Asn1 getAsn1() {
    return DerSequence(array: <Asn1Encode>[
      DerInteger.fromNumber(BigInt.from(0)),
      DerInteger.fromNumber(_modulus),
      DerInteger.fromNumber(_publicExponent),
      DerInteger.fromNumber(_privateExponent),
      DerInteger.fromNumber(_prime1),
      DerInteger.fromNumber(_prime2),
      DerInteger.fromNumber(_exponent1),
      DerInteger.fromNumber(_exponent2),
      DerInteger.fromNumber(_coefficient)
    ]);
  }
}

class _SubjectKeyID extends Asn1Encode {
  _SubjectKeyID(dynamic obj) {
    if (obj is Asn1Octet) {
      _bytes = obj.getOctets();
    } else if (obj is PublicKeyInformation) {
      _bytes = getDigest(obj);
    }
  }

  List<int>? _bytes;
  //Implementation
  static List<int> getDigest(PublicKeyInformation publicKey) {
    return sha1.convert(publicKey.publicKey!.data!).bytes;
  }

  /// internal method
  static PublicKeyInformation createSubjectKeyID(CipherParameter publicKey) {
    if (publicKey is RsaKeyParam) {
      final PublicKeyInformation information = PublicKeyInformation(
          Algorithms(PkcsObjectId.rsaEncryption, DerNull.value),
          RsaPublicKey(publicKey.modulus, publicKey.exponent).getAsn1());
      return information;
    } else {
      throw ArgumentError.value(publicKey, 'publicKey', 'Invalid Key');
    }
  }

  @override
  Asn1 getAsn1() {
    return DerOctet(_bytes!);
  }
}

/// Internal class
class CertificateIdentity {
  /// Internal constructor
  CertificateIdentity(String hashAlgorithm, X509Certificate issuerCert,
      DerInteger serialNumber) {
    final Algorithms algorithms =
        Algorithms(DerObjectID(hashAlgorithm), DerNull.value);
    try {
      final String algorithm = algorithms.id!.id!;
      final X509Name? issuerName = SingnedCertificate.getCertificate(
              Asn1.fromByteArray(issuerCert.getTbsCertificate()!))!
          .subject;
      MessageDigestFinder utilities = MessageDigestFinder();
      final List<int> issuerNameHash =
          utilities.getDigest(algorithm, issuerName!.getEncoded()!);
      final CipherParameter issuerKey = issuerCert.getPublicKey();
      final PublicKeyInformation info =
          _SubjectKeyID.createSubjectKeyID(issuerKey);
      utilities = MessageDigestFinder();
      final List<int> issuerKeyHash =
          utilities.getDigest(algorithm, info.publicKey!.getBytes()!);
      id = CertificateIdentityHelper(
          hash: algorithms,
          issuerName: DerOctet(issuerNameHash),
          issuerKey: DerOctet(issuerKeyHash),
          serialNumber: serialNumber);
    } catch (e) {
      throw Exception('Invalid certificate ID');
    }
  }

  /// Internal field
  CertificateIdentityHelper? id;

  /// Internal constant
  static const String sha1 = '1.3.14.3.2.26';
}

/// Internal class
class CertificateIdentityHelper extends Asn1Encode {
  /// Internal constructor
  CertificateIdentityHelper(
      {Algorithms? hash,
      Asn1Octet? issuerName,
      Asn1Octet? issuerKey,
      DerInteger? serialNumber}) {
    _hash = hash;
    _issuerName = issuerName;
    _issuerKey = issuerKey;
    _serialNumber = serialNumber;
  }

  /// Internal field
  Algorithms? _hash;
  Asn1Octet? _issuerName;
  Asn1Octet? _issuerKey;
  DerInteger? _serialNumber;

  @override
  Asn1 getAsn1() {
    return DerSequence(
        array: <Asn1Encode>[_hash!, _issuerName!, _issuerKey!, _serialNumber!]);
  }
}
