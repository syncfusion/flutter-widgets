import '../../../io/stream_reader.dart';
import '../asn1/asn1.dart';
import '../asn1/asn1_stream.dart';
import '../asn1/der.dart';
import '../cryptography/cipher_block_chaining_mode.dart';
import '../cryptography/ipadding.dart';
import '../cryptography/signature_utilities.dart';
import '../pdf_signature_dictionary.dart';
import '../pkcs/pfx_data.dart';
import 'x509_name.dart';
import 'x509_time.dart';

/// internal class
class IX509Extension {
  /// internal method
  Asn1Octet? getExtension(DerObjectID id) => null;
}

/// internal class
class X509Certificates {
  /// internal constructor
  X509Certificates(X509Certificate certificate) {
    _certificate = certificate;
  }
  //Fields
  X509Certificate? _certificate;
  //Properties
  /// internal property
  X509Certificate? get certificate => _certificate;
  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  int get hashCode => _certificate.hashCode;
  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  bool operator ==(Object other) {
    if (other is X509Certificates) {
      return _certificate == other._certificate;
    } else {
      return false;
    }
  }
}

/// internal class
abstract class X509ExtensionBase implements IX509Extension {
  /// internal method
  X509Extensions? getX509Extensions();
  @override
  Asn1Octet? getExtension(DerObjectID oid) {
    final X509Extensions? exts = getX509Extensions();
    if (exts != null) {
      final X509Extension? ext = exts.getExtension(oid);
      if (ext != null) {
        return ext._value;
      }
    }
    return null;
  }
}

/// internal class
class X509Extension {
  /// internal constructor
  X509Extension(bool critical, Asn1Octet? value) {
    _critical = critical;
    _value = value;
  }
  //Fields
  bool? _critical;
  Asn1Octet? _value;
  //Implementation
  /// internal method
  static Asn1? convertValueToObject(X509Extension ext) {
    return Asn1Stream(PdfStreamReader(ext._value!.getOctets())).readAsn1();
  }

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  bool operator ==(Object other) {
    if (other is X509Extension) {
      return _value == other._value && _critical == other._critical;
    } else {
      return false;
    }
  }

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  int get hashCode => _critical! ? _value.hashCode : ~_value.hashCode;
}

/// internal class
class X509Extensions extends Asn1Encode {
  /// internal constructor
  X509Extensions(Map<DerObjectID, X509Extension> extensions,
      [List<DerObjectID?>? ordering]) {
    _extensions = <DerObjectID?, X509Extension?>{};
    if (ordering == null) {
      final List<DerObjectID?> der = <DerObjectID?>[];
      // ignore: avoid_function_literals_in_foreach_calls
      extensions.keys.forEach((DerObjectID? col) {
        der.add(col);
      });
      _ordering = der;
    } else {
      _ordering = ordering;
    }
    // ignore: avoid_function_literals_in_foreach_calls
    _ordering.forEach((DerObjectID? oid) {
      _extensions[oid] = extensions[oid!];
    });
  }

  /// internal method
  X509Extensions.fromSequence(Asn1Sequence seq) {
    _ordering = <DerObjectID?>[];
    _extensions = <DerObjectID?, X509Extension?>{};
    for (int i = 0; i < seq.objects!.length; i++) {
      final Asn1Encode ae = seq.objects![i] as Asn1Encode;
      final Asn1Sequence s = Asn1Sequence.getSequence(ae.getAsn1())!;
      if (s.count < 2 || s.count > 3) {
        throw ArgumentError.value(
            seq, 'count', 'Bad sequence size: ${s.count}');
      }
      final DerObjectID? oid = DerObjectID.getID(s[0]!.getAsn1());
      final bool isCritical =
          s.count == 3 && (s[1]!.getAsn1()! as DerBoolean).isTrue;
      final Asn1Octet? octets =
          Asn1Octet.getOctetStringFromObject(s[s.count - 1]!.getAsn1());
      _extensions[oid] = X509Extension(isCritical, octets);
      _ordering.add(oid);
    }
  }

  /// internal method
  static X509Extensions? getInstance(dynamic obj, [bool? explicitly]) {
    X509Extensions? result;
    if (explicitly == null) {
      if (obj == null || obj is X509Extensions) {
        result = obj as X509Extensions?;
      } else if (obj is Asn1Sequence) {
        result = X509Extensions.fromSequence(obj);
      } else if (obj is Asn1Tag) {
        result = getInstance(obj.getObject());
      } else {
        throw ArgumentError.value(obj, 'obj', 'unknown object in factory');
      }
    } else {
      result = getInstance(Asn1Sequence.getSequence(obj, explicitly));
    }
    return result;
  }

  //Fields
  late Map<DerObjectID?, X509Extension?> _extensions;
  late List<DerObjectID?> _ordering;

  /// internal field
  static DerObjectID authorityKeyIdentifier = DerObjectID('2.5.29.35');

  /// internal field
  static DerObjectID crlDistributionPoints = DerObjectID('2.5.29.31');

  /// internal field
  static DerObjectID authorityInfoAccess = DerObjectID('1.3.6.1.5.5.7.1.1');

  //Implementation
  @override
  Asn1 getAsn1() {
    final Asn1EncodeCollection vec = Asn1EncodeCollection();
    // ignore: avoid_function_literals_in_foreach_calls
    _ordering.forEach((DerObjectID? oid) {
      final X509Extension ext = _extensions[oid]!;
      final Asn1EncodeCollection v = Asn1EncodeCollection(<Asn1Encode?>[oid]);
      if (ext._critical!) {
        v.encodableObjects.add(DerBoolean(true));
      }
      v.encodableObjects.add(ext._value);
      vec.encodableObjects.add(DerSequence(collection: v));
    });
    return DerSequence(collection: vec);
  }

  /// internal method
  X509Extension? getExtension(DerObjectID oid) {
    return (_extensions.containsKey(oid)) ? _extensions[oid] : null;
  }
}

/// internal class
class X509Certificate extends X509ExtensionBase {
  /// internal constructor
  X509Certificate(this.c) {
    try {
      final Asn1Octet? str = getExtension(DerObjectID('2.5.29.15'));
      if (str != null) {
        final DerBitString bits = DerBitString.getDetBitString(
            Asn1Stream(PdfStreamReader(str.getOctets())).readAsn1())!;
        final List<int> bytes = bits.getBytes()!;
        final int length = (bytes.length * 8) - bits.extra!;
        _keyUsage =
            List<bool>.generate((length < 9) ? 9 : length, (int i) => false);
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
  /// internal field
  X509CertificateStructure? c;
  List<bool>? _keyUsage;
  //Implementation
  @override
  X509Extensions? getX509Extensions() {
    return c!.version == 3 ? c!.tbsCertificate!.extensions : null;
  }

  /// internal method
  CipherParameter getPublicKey() {
    return createKey(c!.subjectPublicKeyInfo!);
  }

  /// internal method
  List<int>? getTbsCertificate() {
    return c!.tbsCertificate!.getDerEncoded();
  }

  /// internal method
  List<int>? getSignature() {
    return c!.signature!.getBytes();
  }

  /// internal method
  CipherParameter createKey(PublicKeyInformation keyInfo) {
    CipherParameter result;
    final Algorithms algID = keyInfo.algorithm!;
    final DerObjectID algOid = algID.id!;
    if (algOid.id == PkcsObjectId.rsaEncryption.id ||
        algOid.id == X509Objects.idEARsa.id) {
      final RsaPublicKey pubKey =
          RsaPublicKey.getPublicKey(keyInfo.getPublicKey())!;
      result = RsaKeyParam(false, pubKey.modulus, pubKey.publicExponent);
    } else {
      throw ArgumentError.value(
          keyInfo, 'keyInfo', 'algorithm identifier in key not recognised');
    }
    return result;
  }

  /// internal method
  void verify(CipherParameter key) {
    if (c != null) {
      final String sigName = c!.signatureAlgorithm!.id!.id!;
      final SignerUtilities util = SignerUtilities();
      final ISigner signature = util.getSigner(sigName);
      checkSignature(key, signature);
    }
  }

  /// internal method
  void checkSignature(CipherParameter publicKey, ISigner signature) {
    if (!isAlgIDEqual(c!.signatureAlgorithm!, c!.tbsCertificate!.signature!)) {
      throw Exception('signature algorithm in TBS cert not same as outer cert');
    }
    signature.initialize(false, publicKey);
    final List<int>? b = getTbsCertificate();
    if (b != null) {
      signature.blockUpdate(b, 0, b.length);
      final List<int>? sig = getSignature();
      if (!signature.validateSignature(sig!)) {
        throw Exception('Public key presented not for certificate signature');
      }
    }
  }

  /// internal method
  bool isAlgIDEqual(Algorithms id1, Algorithms id2) {
    if (!(id1.id == id2.id)) {
      return false;
    }
    final Asn1Encode? p1 = id1.parameters;
    final Asn1Encode? p2 = id2.parameters;
    if ((p1 == null) == (p2 == null)) {
      return p1 == p2;
    }
    return p1 == null ? p2!.getAsn1() is Asn1Null : p1.getAsn1() is Asn1Null;
  }
}

/// internal class
class X509CertificateStructure extends Asn1Encode {
  /// internal constructor
  X509CertificateStructure(Asn1Sequence seq) {
    _tbsCert = SingnedCertificate.getCertificate(seq[0]);
    _sigAlgID = Algorithms.getAlgorithms(seq[1]);
    _sig = DerBitString.getDetBitString(seq[2]);
  }
  //Fields
  SingnedCertificate? _tbsCert;
  Algorithms? _sigAlgID;
  DerBitString? _sig;
  //Properties
  /// internal property
  SingnedCertificate? get tbsCertificate => _tbsCert;

  /// internal property
  int get version => _tbsCert!.version;

  /// internal property
  DerInteger? get serialNumber => _tbsCert!.serialNumber;

  /// internal property
  X509Name? get issuer => _tbsCert!.issuer;

  /// internal property
  X509Time? get startDate => _tbsCert!.startDate;

  /// internal property
  X509Time? get endDate => _tbsCert!.endDate;

  /// internal property
  X509Name? get subject => _tbsCert!.subject;

  /// internal property
  PublicKeyInformation? get subjectPublicKeyInfo =>
      _tbsCert!.subjectPublicKeyInfo;

  /// internal property
  Algorithms? get signatureAlgorithm => _sigAlgID;

  /// internal property
  DerBitString? get signature => _sig;
  //Implementation
  /// internal method
  static X509CertificateStructure? getInstance(dynamic obj) {
    if (obj is X509CertificateStructure) {
      return obj;
    }
    if (obj != null) {
      return X509CertificateStructure(Asn1Sequence.getSequence(obj)!);
    }
    return null;
  }

  @override
  Asn1 getAsn1() {
    return DerSequence(array: <Asn1Encode?>[_tbsCert, _sigAlgID, _sig]);
  }
}

/// Internal class
class SingnedCertificate extends Asn1Encode {
  /// internal constructor
  SingnedCertificate(Asn1Sequence sequence) {
    int seqStart = 0;
    _sequence = sequence;
    if (sequence[0] is DerTag || sequence[0] is Asn1Tag) {
      _version = DerInteger.getNumberFromTag(sequence[0]! as Asn1Tag, true);
    } else {
      seqStart = -1;
      _version = DerInteger(bigIntToBytes(BigInt.from(0)));
    }
    _serialNumber = DerInteger.getNumber(sequence[seqStart + 1]);
    _signature = Algorithms.getAlgorithms(sequence[seqStart + 2]);
    _issuer = X509Name.getName(sequence[seqStart + 3]);
    final Asn1Sequence dates = sequence[seqStart + 4]! as Asn1Sequence;
    _startDate = X509Time.getTime(dates[0]);
    _endDate = X509Time.getTime(dates[1]);
    _subject = X509Name.getName(sequence[seqStart + 5]);
    _publicKeyInformation =
        PublicKeyInformation.getPublicKeyInformation(sequence[seqStart + 6]);
    for (int extras = sequence.count - (seqStart + 6) - 1;
        extras > 0;
        extras--) {
      final Asn1Tag extra = sequence[seqStart + 6 + extras]! as Asn1Tag;
      switch (extra.tagNumber) {
        case 1:
          _issuerID = DerBitString.getDerBitStringFromTag(extra, false);
          break;
        case 2:
          _subjectID = DerBitString.getDerBitStringFromTag(extra, false);
          break;
        case 3:
          _extensions = X509Extensions.getInstance(extra);
          break;
      }
    }
  }

  /// internal method
  static SingnedCertificate? getCertificate(dynamic obj) {
    if (obj is SingnedCertificate) {
      return obj;
    }
    if (obj != null) {
      return SingnedCertificate(Asn1Sequence.getSequence(obj)!);
    }
    return null;
  }

  //Fields
  Asn1Sequence? _sequence;
  DerInteger? _version;
  DerInteger? _serialNumber;
  Algorithms? _signature;
  X509Name? _issuer;
  X509Time? _startDate;
  X509Time? _endDate;
  X509Name? _subject;
  PublicKeyInformation? _publicKeyInformation;
  DerBitString? _issuerID;
  DerBitString? _subjectID;
  X509Extensions? _extensions;
  //Properties
  /// internal field
  int get version => _version!.value.toSigned(32).toInt() + 1;

  /// internal field
  DerInteger? get serialNumber => _serialNumber;

  /// internal field
  Algorithms? get signature => _signature;

  /// internal field
  X509Name? get issuer => _issuer;

  /// internal field
  X509Time? get startDate => _startDate;

  /// internal field
  X509Time? get endDate => _endDate;

  /// internal field
  X509Name? get subject => _subject;

  /// internal field
  PublicKeyInformation? get subjectPublicKeyInfo => _publicKeyInformation;

  /// internal field
  DerBitString? get issuerUniqueID => _issuerID;

  /// internal field
  DerBitString? get subjectUniqueID => _subjectID;

  /// internal field
  X509Extensions? get extensions => _extensions;
  //Implementation
  @override
  Asn1? getAsn1() {
    return _sequence;
  }
}

/// internal class
class PublicKeyInformation extends Asn1Encode {
  /// internal constructor
  PublicKeyInformation(Algorithms algorithms, Asn1Encode publicKey) {
    _publicKey = DerBitString.fromAsn1(publicKey);
    _algorithms = algorithms;
  }

  /// internal constructor
  PublicKeyInformation.fromSequence(Asn1Sequence sequence) {
    if (sequence.count != 2) {
      throw ArgumentError.value(
          sequence, 'sequence', 'Invalid length in sequence');
    }
    _algorithms = Algorithms.getAlgorithms(sequence[0]);
    _publicKey = DerBitString.getDetBitString(sequence[1]);
  }

  /// internal method
  static PublicKeyInformation? getPublicKeyInformation(dynamic obj) {
    if (obj is PublicKeyInformation) {
      return obj;
    }
    if (obj != null) {
      return PublicKeyInformation.fromSequence(Asn1Sequence.getSequence(obj)!);
    }
    return null;
  }

  Algorithms? _algorithms;
  DerBitString? _publicKey;

  /// internal property
  Algorithms? get algorithm => _algorithms;

  /// internal property
  DerBitString? get publicKey => _publicKey;
  //Implementation
  /// internal method
  Asn1? getPublicKey() {
    return Asn1Stream(PdfStreamReader(_publicKey!.getBytes())).readAsn1();
  }

  @override
  Asn1 getAsn1() {
    return DerSequence(array: <Asn1Encode?>[_algorithms, _publicKey]);
  }
}

/// internal class
class RsaPublicKey extends Asn1Encode {
  /// internal constructor
  RsaPublicKey(BigInt? modulus, BigInt? publicExponent) {
    _modulus = modulus;
    _publicExponent = publicExponent;
  }

  /// internal constructor
  RsaPublicKey.fromSequence(Asn1Sequence sequence) {
    _modulus = DerInteger.getNumber(sequence[0])!.positiveValue;
    _publicExponent = DerInteger.getNumber(sequence[1])!.positiveValue;
  }
  BigInt? _modulus;
  BigInt? _publicExponent;

  /// internal property
  BigInt? get modulus => _modulus;

  /// internal property
  BigInt? get publicExponent => _publicExponent;

  /// internal method
  static RsaPublicKey? getPublicKey(dynamic obj) {
    RsaPublicKey? result;
    if (obj == null || obj is RsaPublicKey) {
      result = obj as RsaPublicKey?;
    } else if (obj is Asn1Sequence) {
      result = RsaPublicKey.fromSequence(obj);
    } else {
      throw ArgumentError.value(obj, 'obj', 'Invalid entry');
    }
    return result;
  }

  @override
  Asn1 getAsn1() {
    return DerSequence(array: <Asn1Encode>[
      DerInteger.fromNumber(modulus),
      DerInteger.fromNumber(publicExponent)
    ]);
  }
}

/// internal class
class X509CertificateParser {
  /// internal constructor
  X509CertificateParser();
  //Fields
  Asn1Set? _sData;
  int? _sDataObjectCount;
  PdfStreamReader? _currentStream;
  //Implementation
  /// internal method
  X509Certificate? readCertificate(PdfStreamReader inStream) {
    if (_currentStream == null || _currentStream != inStream) {
      _currentStream = inStream;
      _sData = null;
      _sDataObjectCount = 0;
    }
    if (_sData != null) {
      if (_sDataObjectCount != _sData!.objects.length) {
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
    return readDerCertificate(Asn1Stream(pis));
  }

  /// Internal method
  List<X509Certificate?>? getCertificateChain(PdfStreamReader inStream) {
    if (_currentStream == null || _currentStream != inStream) {
      _currentStream = inStream;
      _sData = null;
      _sDataObjectCount = 0;
    }
    if (_sData != null) {
      if (_sDataObjectCount != _sData!.objects.length) {
        return _getCertificateChain();
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
    return _readDerCertificates(Asn1Stream(pis));
  }

  /// internal method
  X509Certificate? getCertificate() {
    if (_sData != null) {
      while (_sDataObjectCount! < _sData!.objects.length) {
        final dynamic obj = _sData![_sDataObjectCount!];
        _sDataObjectCount = _sDataObjectCount! + 1;
        if (obj is Asn1Sequence) {
          return createX509Certificate(
              X509CertificateStructure.getInstance(obj));
        }
      }
    }
    return null;
  }

  /// internal method
  X509Certificate? readDerCertificate(Asn1Stream dIn) {
    final dynamic seq = dIn.readAsn1();
    if (seq != null && seq is Asn1Sequence) {
      if (seq.count > 1 && seq[0] is DerObjectID) {
        if ((seq[0]! as DerObjectID).id == PkcsObjectId.signedData.id) {
          if (seq.count >= 2) {
            final Asn1Sequence signedSequence =
                Asn1Sequence.getSequence(seq[1] as Asn1Tag?, true)!;
            bool isContinue = true;
            // ignore: avoid_function_literals_in_foreach_calls
            signedSequence.objects!.forEach((dynamic o) {
              if (isContinue && o is Asn1Tag) {
                if (o.tagNumber == 0) {
                  _sData = Asn1Set.getAsn1Set(o, false);
                  isContinue = false;
                }
              }
            });
          }
          return getCertificate();
        }
      }
    }
    return createX509Certificate(X509CertificateStructure.getInstance(seq));
  }

  List<X509Certificate?>? _getCertificateChain() {
    final List<X509Certificate?> certList = <X509Certificate?>[];
    if (_sData != null) {
      while (_sDataObjectCount! < _sData!.objects.length) {
        final dynamic obj = _sData![_sDataObjectCount!];
        _sDataObjectCount = _sDataObjectCount! + 1;
        if (obj is Asn1Sequence) {
          certList.add(
              createX509Certificate(X509CertificateStructure.getInstance(obj)));
        }
      }
    }
    return certList.isNotEmpty ? certList : null;
  }

  /// internal method
  List<X509Certificate?>? _readDerCertificates(Asn1Stream dIn) {
    final dynamic seq = dIn.readAsn1();
    if (seq != null && seq is Asn1Sequence) {
      if (seq.count > 1 && seq[0] is DerObjectID) {
        if ((seq[0]! as DerObjectID).id == PkcsObjectId.signedData.id) {
          if (seq.count >= 2) {
            final Asn1Sequence signedSequence =
                Asn1Sequence.getSequence(seq[1] as Asn1Tag?, true)!;
            bool isContinue = true;
            // ignore: avoid_function_literals_in_foreach_calls
            signedSequence.objects!.forEach((dynamic o) {
              if (isContinue && o is Asn1Tag) {
                if (o.tagNumber == 0) {
                  _sData = Asn1Set.getAsn1Set(o, false);
                  isContinue = false;
                }
              }
            });
          }
          return _getCertificateChain();
        }
      }
    }
    return <X509Certificate?>[
      createX509Certificate(X509CertificateStructure.getInstance(seq))
    ];
  }

  /// internal method
  X509Certificate createX509Certificate(X509CertificateStructure? c) {
    return X509Certificate(c);
  }
}

class _PushStream extends PdfStreamReader {
  _PushStream(PdfStreamReader stream) : super(stream.data) {
    _stream = stream;
    _buffer = -1;
  }
  //Fields
  late PdfStreamReader _stream;
  int? _buffer;
  @override
  int get position => _stream.position;
  @override
  set position(int value) {
    _stream.position = value;
  }

  //Implementation
  @override
  int? readByte() {
    if (_buffer != -1) {
      final int? temp = _buffer;
      _buffer = -1;
      return temp;
    }
    return _stream.readByte();
  }

  @override
  int? read(List<int> buffer, int offset, int count) {
    if (_buffer != -1) {
      final int? temp = _buffer;
      _buffer = -1;
      return temp;
    }
    return _stream.read(buffer, offset, count);
  }

  void unread(int b) {
    _buffer = b & 0xFF;
  }
}
