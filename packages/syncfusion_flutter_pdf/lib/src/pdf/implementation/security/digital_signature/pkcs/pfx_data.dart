import '../asn1/asn1.dart';
import '../asn1/der.dart';

/// internal class
class Algorithms extends Asn1Encode {
  /// internal constructor
  Algorithms(this.id, [Asn1Encode? parameters]) {
    if (parameters != null) {
      this.parameters = parameters;
      _parametersDefined = true;
    }
  }

  /// internal constructor
  Algorithms.fromAsn1Sequence(Asn1Identifier id, Asn1 asn1) {
    _sequence = Asn1Sequence();
    _sequence.objects!.add(id);
    _sequence.objects!.add(asn1);
  }

  /// internal constructor
  Algorithms.fromSequence(Asn1Sequence sequence) {
    if (sequence.count < 1 || sequence.count > 2) {
      throw ArgumentError.value('Invalid length in sequence');
    }
    id = DerObjectID.getID(sequence[0]);
    _parametersDefined = sequence.count == 2;
    if (_parametersDefined) {
      parameters = sequence[1] as Asn1Encode?;
    }
  }

  /// internal method
  static Algorithms? getAlgorithms(dynamic obj) {
    if (obj == null || obj is Algorithms) {
      return obj as Algorithms?;
    }
    if (obj is DerObjectID) {
      return Algorithms(obj);
    }
    if (obj is String) {
      return Algorithms(DerObjectID(obj));
    }
    return Algorithms.fromSequence(Asn1Sequence.getSequence(obj)!);
  }

  late Asn1Sequence _sequence;
  bool _parametersDefined = false;

  /// internal field
  DerObjectID? id;

  /// internal field
  Asn1Encode? parameters;

  //Implementation
  /// internal method
  List<int>? asnEncode() {
    return _sequence.asnEncode();
  }

  @override
  Asn1 getAsn1() {
    final Asn1EncodeCollection collection =
        Asn1EncodeCollection(<Asn1Encode?>[id]);
    if (_parametersDefined) {
      collection.encodableObjects.add(parameters ?? DerNull.value);
    }
    return DerSequence(collection: collection);
  }
}

/// internal class
class DigestInformation extends Asn1Encode {
  /// internal constructor
  DigestInformation(Algorithms? algorithms, List<int>? bytes) {
    _bytes = bytes;
    _algorithms = algorithms;
  }

  /// internal constructor
  DigestInformation.fromSequence(Asn1Sequence sequence) {
    if (sequence.count != 2) {
      throw ArgumentError.value('Invalid length in sequence');
    }
    _algorithms = Algorithms.getAlgorithms(sequence[0]);
    _bytes = Asn1Octet.getOctetStringFromObject(sequence[1])!.getOctets();
  }

  //Fields
  Algorithms? _algorithms;
  List<int>? _bytes;

  /// internal method
  static DigestInformation getDigestInformation(dynamic obj) {
    DigestInformation result;
    if (obj is DigestInformation) {
      result = obj;
    } else if (obj is Asn1Sequence) {
      result = DigestInformation.fromSequence(obj);
    } else {
      throw ArgumentError.value(obj, 'obj', 'Invalid entry');
    }
    return result;
  }

  @override
  Asn1 getAsn1() {
    return DerSequence(array: <Asn1Encode?>[_algorithms, DerOctet(_bytes!)]);
  }
}

// ignore: avoid_classes_with_only_static_members
/// internal class
class PkcsObjectId {
  /// internal field
  static const String pkcs1 = '1.2.840.113549.1.1';

  /// internal field
  static const String encryptionAlgorithm = '1.2.840.113549.3';

  /// internal field
  static const String pkcs7 = '1.2.840.113549.1.7';

  /// internal field
  static const String pkcs9 = '1.2.840.113549.1.9';

  /// internal field
  static const String pkcs12 = '1.2.840.113549.1.12';

  /// internal field
  static const String bagTypes = '$pkcs12.10.1';

  /// internal field
  static const String pkcs12PbeIds = '$pkcs12.1';

  /// internal field
  static const String messageDigestAlgorithm = '1.2.840.113549.2';

  /// internal field
  static DerObjectID rsaEncryption = DerObjectID('$pkcs1.1');

  /// internal field
  static DerObjectID md2WithRsaEncryption = DerObjectID('$pkcs1.2');

  /// internal field
  static DerObjectID sha1WithRsaEncryption = DerObjectID('$pkcs1.5');

  /// internal field
  static DerObjectID sha256WithRsaEncryption = DerObjectID('$pkcs1.11');

  /// internal field
  static DerObjectID sha384WithRsaEncryption = DerObjectID('$pkcs1.12');

  /// internal field
  static DerObjectID sha512WithRsaEncryption = DerObjectID('$pkcs1.13');

  /// internal field
  static DerObjectID desEde3Cbc = DerObjectID('$encryptionAlgorithm.7');

  /// internal field
  static DerObjectID rc2Cbc = DerObjectID('$encryptionAlgorithm.2');

  /// internal field
  static DerObjectID data = DerObjectID('$pkcs7.1');

  /// internal field
  static DerObjectID signedData = DerObjectID('$pkcs7.2');

  /// internal field
  static DerObjectID encryptedData = DerObjectID('$pkcs7.6');

  /// internal field
  static DerObjectID pkcs9AtEmailAddress = DerObjectID('$pkcs9.1');

  /// internal field
  static DerObjectID pkcs9AtUnstructuredName = DerObjectID('$pkcs9.2');

  /// internal field
  static DerObjectID pkcs9AtUnstructuredAddress = DerObjectID('$pkcs9.8');

  /// internal field
  static DerObjectID pkcs9AtFriendlyName = DerObjectID('$pkcs9.20');

  /// internal field
  static DerObjectID pkcs9AtLocalKeyID = DerObjectID('$pkcs9.21');

  /// internal field
  static DerObjectID keyBag = DerObjectID('$bagTypes.1');

  /// internal field
  static DerObjectID pkcs8ShroudedKeyBag = DerObjectID('$bagTypes.2');

  /// internal field
  static DerObjectID certBag = DerObjectID('$bagTypes.3');

  /// internal field
  static DerObjectID pbeWithShaAnd128BitRC4 = DerObjectID('$pkcs12PbeIds.1');

  /// internal field
  static DerObjectID pbeWithShaAnd40BitRC4 = DerObjectID('$pkcs12PbeIds.2');

  /// internal field
  static DerObjectID pbeWithShaAnd3KeyTripleDesCbc =
      DerObjectID('$pkcs12PbeIds.3');

  /// internal field
  static DerObjectID pbeWithShaAnd2KeyTripleDesCbc =
      DerObjectID('$pkcs12PbeIds.4');

  /// internal field
  static DerObjectID pbeWithShaAnd128BitRC2Cbc = DerObjectID('$pkcs12PbeIds.5');

  /// internal field
  static DerObjectID pbewithShaAnd40BitRC2Cbc = DerObjectID('$pkcs12PbeIds.6');

  /// internal field
  static DerObjectID idAlgCms3DesWrap =
      DerObjectID('1.2.840.113549.1.9.16.3.6');

  /// internal field
  static DerObjectID idAlgCmsRC2Wrap = DerObjectID('1.2.840.113549.1.9.16.3.7');

  /// internal field
  static DerObjectID md5 = DerObjectID('${messageDigestAlgorithm}5');
}

// ignore: avoid_classes_with_only_static_members
/// internal class
class X509Objects {
  /// internal field
  static const String id = '2.5.4';

  /// internal field
  static DerObjectID telephoneNumberID = DerObjectID('$id.20');

  /// internal field
  static DerObjectID idSha1 = DerObjectID('1.3.14.3.2.26');

  /// internal field
  static DerObjectID idEARsa = DerObjectID('2.5.8.1.1');
}
