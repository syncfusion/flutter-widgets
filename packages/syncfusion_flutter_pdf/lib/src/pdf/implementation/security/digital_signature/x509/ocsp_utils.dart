import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;

import '../../../annotations/json_parser.dart';
import '../../../io/stream_reader.dart';
import '../asn1/asn1.dart';
import '../asn1/asn1_stream.dart';
import '../asn1/der.dart';
import '../pdf_pkcs_certificate.dart';
import '../pkcs/pfx_data.dart';
import 'x509_certificates.dart';
import 'x509_name.dart';

/// internal class
class Ocsp {
  /// internal method
  Future<List<int>?> getEncodedOcspResponse(X509Certificate? checkCertificate,
      X509Certificate? rootCertificate) async {
    final OcspResponseHelper? helper =
        await getOcspResponse(checkCertificate, rootCertificate);
    if (helper != null) {
      return helper.getResponseBytes();
    }
    return null;
  }

  /// internal method
  Future<OcspResponseHelper?> getOcspResponse(X509Certificate? checkCertificate,
      X509Certificate? rootCertificate) async {
    if (checkCertificate == null || rootCertificate == null) {
      return null;
    }
    final CertificateUtililty utility = CertificateUtililty();
    final String? url = utility.getOcspUrl(checkCertificate);
    if (url == null) {
      return null;
    }
    final OcspRequestHelper request =
        generateOcspRequest(rootCertificate, checkCertificate.c!.serialNumber!);
    final List<int>? requestBody = request.getEncoded();
    if (requestBody != null) {
      final List<int>? data = await fetchData(url, 'POST',
          data: requestBody,
          contentType: 'application/ocsp-request',
          timeOutDuration: const Duration(milliseconds: 5000));
      if (data != null) {
        return OcspResponseHelper(data);
      }
    }
    return null;
  }

  /// internal method
  OcspRequestHelper generateOcspRequest(
      X509Certificate issuerCertificate, DerInteger serialNumber) {
    final CertificateIdentity id = CertificateIdentity(
        CertificateIdentity.sha1, issuerCertificate, serialNumber);
    final OcspRequestCreator requestCreator = OcspRequestCreator();
    requestCreator.addRequest(id);
    final Map<DerObjectID, X509Extension> extensions =
        <DerObjectID, X509Extension>{};
    extensions[OcspConstants.ocspNonce] = X509Extension(
        false, DerOctet(DerOctet(createDocumentId()).getEncoded()!));
    requestCreator.requestExtensions = X509Extensions(extensions);
    return requestCreator.createRequest();
  }

  /// internal method
  List<int> createDocumentId() {
    int time =
        DateTime.now().microsecondsSinceEpoch + DateTime.now().millisecond;
    final int random = 1000000 + Random().nextInt(9999999 - 1000000);
    final List<int> b = utf8.encode('$time+$random+${time++}');
    final dynamic output = AccumulatorSink<Digest>();
    final dynamic input = md5.startChunkedConversion(output);
    input.add(b);
    input.close();
    final List<int> hash = output.events.single.bytes as List<int>;
    return hash;
  }
}

/// Internal class
class RevocationList {
  /// Internal method
  Future<List<List<int>>> getEncoded(X509Certificate certificate) async {
    List<String>? urls;
    try {
      final CertificateUtililty utility = CertificateUtililty();
      urls = utility.getCrlUrls(certificate);
    } catch (ex) {
      //
    }
    final List<List<int>> byteList = <List<int>>[];
    if (urls != null) {
      List<int>? data;
      for (final String entry in urls) {
        try {
          data = await fetchData(entry, 'GET',
              timeOutDuration: const Duration(milliseconds: 5000));
        } catch (e) {
          //
        }
        if (data != null) {
          byteList.add(data);
        }
      }
    }
    return byteList;
  }
}

/// Internal class
class RevocationPointList extends Asn1Encode {
  /// Internal constructor.
  RevocationPointList([Asn1Sequence? sequence]) {
    if (sequence != null) {
      _sequence = sequence;
    }
  }

  /// Internal field
  Asn1Sequence? _sequence;

  /// Internal method
  List<RevocationDistribution> getDistributionPoints() {
    final List<RevocationDistribution> distributions =
        <RevocationDistribution>[];
    if (_sequence != null) {
      final RevocationDistribution distribution = RevocationDistribution();
      for (int i = 0; i != _sequence!.count; ++i) {
        distributions.add(distribution.getCrlDistribution(_sequence![i])!);
      }
    }
    return distributions;
  }

  /// Internal method
  RevocationPointList getCrlPointList(dynamic obj) {
    if (obj is RevocationPointList || obj == null) {
      return obj;
    }
    if (obj is Asn1Sequence) {
      return RevocationPointList(obj);
    }
    throw Exception('Invalid entry in sequence');
  }

  @override
  Asn1 getAsn1() {
    return _sequence!;
  }
}

/// Internal class
class RevocationDistribution extends Asn1Encode {
  /// Internal constructor.
  RevocationDistribution([Asn1Sequence? sequence]) {
    if (sequence != null) {
      for (int i = 0; i != sequence.count; i++) {
        final Asn1Tag? tag = Asn1Tag.getTag(sequence[i]);
        if (tag != null) {
          switch (tag.tagNumber) {
            case 0:
              final RevocationDistributionType type =
                  RevocationDistributionType();
              distributionPoint = type.getDistributionType(tag, true);
              break;
            case 2:
              final RevocationName name = RevocationName();
              _issuer = name.getCrlName(tag, false);
              break;
          }
        }
      }
    }
  }

  /// Internal field
  RevocationDistributionType? distributionPoint;
  RevocationName? _issuer;

  /// Internal method
  RevocationDistribution? getCrlDistribution(dynamic obj) {
    if (obj == null || obj is RevocationDistribution) {
      return obj;
    }
    if (obj is Asn1Sequence) {
      return RevocationDistribution(obj);
    }
    throw Exception('Invalid entry in CRL distribution point');
  }

  @override
  Asn1 getAsn1() {
    final Asn1EncodeCollection collection = Asn1EncodeCollection();
    if (distributionPoint != null) {
      collection.add(<dynamic>[DerTag(0, distributionPoint)]);
    }
    if (_issuer != null) {
      collection.add(<dynamic>[DerTag(2, _issuer, false)]);
    }
    return DerSequence(collection: collection);
  }
}

/// Internal class
class RevocationDistributionType extends Asn1Encode {
  /// Internal constructor.
  RevocationDistributionType([Asn1Tag? tag]) {
    if (tag != null) {
      type = tag.tagNumber;
      if (type == fullName) {
        final RevocationName crl = RevocationName();
        name = crl.getCrlName(tag, false);
      } else {
        name = Asn1Set.getAsn1Set(tag, false);
      }
    }
  }

  /// Internal field
  Asn1Encode? name;

  /// Internal fields
  int? type;

  /// Internal constants
  static const int fullName = 0;

  /// Internal method
  RevocationDistributionType? getDistributionType(
      Asn1Tag tag, bool isExplicit) {
    return getDistributionTypeFromObj(Asn1Tag.getTag(tag, true));
  }

  /// Internal method
  RevocationDistributionType? getDistributionTypeFromObj(dynamic obj) {
    if (obj == null || obj is RevocationDistributionType) {
      return obj;
    }
    if (obj is Asn1Tag) {
      return RevocationDistributionType(obj);
    }
    throw Exception('Invalid entry in sequence');
  }

  @override
  Asn1 getAsn1() {
    return DerTag(type, name, false);
  }
}

/// Internal class
class RevocationName extends Asn1Encode {
  /// Internal constructor.
  RevocationName([Asn1Sequence? sequence]) {
    if (sequence != null) {
      names = <OcspTag>[];
      for (int i = 0; i != sequence.count; i++) {
        final OcspTag name = OcspTag();
        names!.add(name.getOcspName(sequence[i])!);
      }
    }
  }

  /// Internal field
  List<OcspTag>? names;

  /// Internal method
  RevocationName? getCrlNameFromObj(dynamic obj) {
    if (obj == null || obj is RevocationName) {
      return obj;
    }
    if (obj is Asn1Sequence) {
      return RevocationName(obj);
    }
    throw Exception('Invalid entry in sequence');
  }

  /// Internal method
  RevocationName? getCrlName(Asn1Tag tag, bool isExplicit) {
    return getCrlNameFromObj(Asn1Sequence.getSequence(tag, isExplicit));
  }

  @override
  Asn1 getAsn1() {
    return DerSequence(array: names);
  }
}

/// Internal class
class OcspTag extends Asn1Encode {
  /// Internal constructor.
  OcspTag([int? tag, Asn1Encode? encode]) {
    if (encode != null) {
      _encode = encode;
    }
    if (tag != null) {
      tagNumber = tag;
    }
  }

  /// Internal fields
  Asn1Encode? _encode;

  /// Internal fields
  int? tagNumber;

  /// Internal method
  OcspTag? getOcspName(dynamic obj) {
    if (obj == null || obj is OcspTag) {
      return obj;
    }
    if (obj is Asn1Tag) {
      final Asn1Tag tag = obj;
      final int? tagNumber = obj.tagNumber;
      if (tagNumber != null) {
        switch (tagNumber) {
          case 0:
            return OcspTag(tagNumber, Asn1Sequence.getSequence(tag, false));
          case 1:
            return OcspTag(
                tagNumber, DerAsciiString.getAsciiString(tag, false));
          case 2:
            return OcspTag(
                tagNumber, DerAsciiString.getAsciiString(tag, false));
          case 3:
            throw Exception('Invalid tag number specified: $tagNumber');
          case 4:
            return OcspTag(tagNumber, X509Name.getName(tag, true));
          case 5:
            return OcspTag(tagNumber, Asn1Sequence.getSequence(tag, false));
          case 6:
            return OcspTag(
                tagNumber, DerAsciiString.getAsciiString(tag, false));
          case 7:
            return OcspTag(tagNumber, Asn1Octet.getOctetString(tag, false));
          case 8:
            return OcspTag(tagNumber, DerObjectID.getID(tag.getObject()));
        }
      }
    }
    if (obj is List<int>) {
      try {
        return getOcspName(Asn1.fromByteArray(obj));
      } catch (e) {
        throw Exception('Invalid OCSP name to parse');
      }
    }
    throw Exception('Invalid entry in sequence');
  }

  @override
  Asn1 getAsn1() {
    return DerTag(tagNumber, _encode, tagNumber == 4);
  }
}

/// internal class
class CertificateUtililty {
  /// internal method
  List<String>? getCrlUrls(X509Certificate certificate) {
    final List<String> urls = <String>[];
    try {
      final Asn1? obj = getExtensionValue(
          certificate, X509Extensions.crlDistributionPoints.id!);
      if (obj == null) {
        return null;
      }
      final RevocationPointList list = RevocationPointList();
      final RevocationPointList distributionList = list.getCrlPointList(obj);
      final List<RevocationDistribution> distributionLists =
          distributionList.getDistributionPoints();
      for (final RevocationDistribution entry in distributionLists) {
        final RevocationDistributionType? distributionPointName =
            entry.distributionPoint;
        if (distributionPointName != null) {
          if (RevocationDistributionType.fullName !=
              distributionPointName.type) {
            continue;
          }
          if (distributionPointName.name != null &&
              distributionPointName.name is RevocationName) {
            final RevocationName generalNames =
                distributionPointName.name! as RevocationName;
            final List<OcspTag>? names = generalNames.names;
            if (names != null) {
              for (final OcspTag name in names) {
                if (name.tagNumber != 6) {
                  continue;
                }
                final DerAsciiString? asciiString =
                    DerAsciiString.getAsciiString(
                        name.getAsn1() as Asn1Tag, false);
                if (asciiString != null) {
                  final String? url = asciiString.getString();
                  if (url != null && url.toLowerCase().endsWith('.crl') ||
                      !isNullOrEmpty(url)) {
                    urls.add(url!);
                  }
                }
              }
            }
          }
        }
      }
      return urls;
    } catch (ex) {
      return null;
    }
  }

  /// internal method
  String? getOcspUrl(X509Certificate certificate) {
    try {
      final Asn1? asn1 = getExtensionValue(
          certificate, X509Extensions.authorityInfoAccess.id!);
      if (asn1 == null) {
        return null;
      }
      if (asn1 is Asn1Sequence) {
        final Asn1Sequence sequence = asn1;
        for (int i = 0; i < sequence.count; i++) {
          final dynamic asn1Sequence = sequence.objects![i];
          if (asn1Sequence is Asn1Sequence) {
            if (asn1Sequence.count != 2) {
              continue;
            } else {
              if (asn1Sequence.objects![0] is DerObjectID &&
                  (asn1Sequence.objects![0]! as DerObjectID).id ==
                      '1.3.6.1.5.5.7.48.1') {
                final dynamic obj = asn1Sequence.objects![1];
                if (obj is Asn1) {
                  final String? accessLocation = getStringFromGeneralName(obj);
                  if (accessLocation == null) {
                    return '';
                  } else {
                    return accessLocation;
                  }
                }
              }
            }
          }
        }
      }
    } catch (e) {
      return null;
    }
    return null;
  }

  /// internal method
  Asn1? getExtensionValue(X509Certificate certificate, String id) {
    List<int>? bytes;
    final Asn1Octet? extension = certificate.getExtension(DerObjectID(id));
    if (extension != null) {
      bytes = extension.getDerEncoded();
    }
    if (bytes == null) {
      return null;
    }
    Asn1Stream asn1 = Asn1Stream(PdfStreamReader(bytes));
    final Asn1? octet = asn1.readAsn1();
    if (octet is Asn1Octet) {
      asn1 = Asn1Stream(PdfStreamReader(octet.getOctets()));
    }
    return asn1.readAsn1();
  }

  /// internal method
  String? getStringFromGeneralName(Asn1 names) {
    if (names is Asn1Tag) {
      final Asn1Octet? octet = Asn1Octet.getOctetString(names, false);
      if (octet != null) {
        final List<int>? bytes = octet.getOctets();
        if (bytes != null) {
          return utf8.decode(bytes);
        }
      }
    }
    return null;
  }
}

/// internal class
class OcspRequestCreator {
  /// Internal constructor
  OcspRequestCreator() {
    _list = <dynamic>[];
  }

  /// Internal field
  late List<dynamic> _list;

  /// Internal field
  X509Extensions? requestExtensions;
  OcspTag? _requestorName;

  /// Internal method
  void addRequest(CertificateIdentity id) {
    _list.add(RequestCreatorHelper(id, null));
  }

  /// Internal method
  OcspRequestHelper createRequest() {
    final Asn1EncodeCollection requests = Asn1EncodeCollection();
    for (final dynamic reqObj in _list) {
      try {
        requests.add(<dynamic>[(reqObj as RequestCreatorHelper).toRequest()]);
      } catch (e) {
        throw Exception('Invalid request creation');
      }
    }
    final OcspRequestCollection requestList = OcspRequestCollection(
        _requestorName, DerSequence(collection: requests), requestExtensions!);
    return OcspRequestHelper(RevocationListRequest(requestList));
  }
}

/// Internal class
class OcspRequestHelper extends X509ExtensionBase {
  /// Internal constructor
  OcspRequestHelper(this._request);

  /// Internal field
  final RevocationListRequest _request;

  @override
  X509Extensions? getX509Extensions() {
    return null;
  }

  /// Internal method
  List<int>? getEncoded() {
    return _request.getEncoded();
  }
}

/// Internal class
class OcspRequestCollection extends Asn1Encode {
  /// Internal constructor
  OcspRequestCollection(
      this._requestorName, this._requestList, this._requestExtensions) {
    _version = DerInteger(<int>[0]);
    versionSet = false;
  }

  /// Internal fields
  late DerInteger _version;
  late final OcspTag? _requestorName;
  late final Asn1Sequence _requestList;
  late final X509Extensions _requestExtensions;

  /// Internal fields
  late bool versionSet;

  ///Internal method
  @override
  Asn1 getAsn1() {
    final Asn1EncodeCollection collection = Asn1EncodeCollection();
    if (!(_version == DerInteger(<int>[0])) || versionSet) {
      collection.add(<dynamic>[DerTag(0, _version, true)]);
    }
    if (_requestorName != null) {
      collection.add(<dynamic>[DerTag(1, _requestorName, true)]);
    }
    collection.add(<dynamic>[_requestList]);
    collection.add(<dynamic>[DerTag(2, _requestExtensions, true)]);
    return DerSequence(collection: collection);
  }
}

/// Internal class
class RevocationListRequest extends Asn1Encode {
  /// Internal constructor
  RevocationListRequest(this._requests);

  /// Internal field
  late final OcspRequestCollection _requests;

  @override
  Asn1 getAsn1() {
    return DerSequence(
        collection: Asn1EncodeCollection(<Asn1Encode>[_requests]));
  }
}

/// Internal class
class OcspResponseHelper {
  /// Internal constructor
  OcspResponseHelper(List<int> data) {
    _response = OcspResponse(
        Asn1Stream(PdfStreamReader(data)).readAsn1()! as Asn1Sequence);
  }

  /// Internal field
  late OcspResponse _response;

  /// Internal method
  List<int>? getResponseBytes() {
    final RevocationResponseBytes? bytes = _response.responseBytes;
    if (bytes == null) {
      return null;
    }
    if (bytes.responseType.id == OcspConstants.ocspBasic.id) {
      try {
        return bytes.response.getOctets();
      } catch (e) {
        throw Exception('Invalid response detected');
      }
    }
    return null;
  }
}

/// Internal class
class OcspResponse extends Asn1Encode {
  /// Internal constructor
  OcspResponse(Asn1Sequence sequence) {
    if (sequence.count == 2) {
      responseBytes = RevocationResponseBytes()
          .getResponseBytes(sequence[1]! as Asn1Tag, true);
    }
  }

  /// Internal field
  RevocationResponseBytes? responseBytes;

  @override
  Asn1 getAsn1() {
    final Asn1EncodeCollection collection = Asn1EncodeCollection(<Asn1Encode>[
      DerCatalogue(<int>[0])
    ]);
    if (responseBytes != null) {
      collection.add(<dynamic>[DerTag(0, responseBytes, true)]);
    }
    return DerSequence(collection: collection);
  }
}

/// Internal class
class RevocationResponseBytes extends Asn1Encode {
  /// Internal constructor
  RevocationResponseBytes([Asn1Sequence? sequence]) {
    if (sequence != null) {
      if (sequence.count != 2) {
        ArgumentError.value(sequence, 'Invalid length in sequence');
      }
      responseType = DerObjectID.getID(sequence[0])!;
      response = Asn1Octet.getOctetStringFromObject(sequence[1])!;
    }
  }

  /// Internal field
  late DerObjectID responseType;

  /// Internal field
  late Asn1Octet response;

  /// Internal method
  RevocationResponseBytes? getResponseBytes(Asn1Tag tag, bool isExplicit) {
    return getResponseBytesFromObject(
        Asn1Sequence.getSequence(tag, isExplicit));
  }

  /// Internal method
  RevocationResponseBytes? getResponseBytesFromObject(dynamic obj) {
    if (obj == null || obj is RevocationResponseBytes) {
      return obj;
    } else if (obj is Asn1Sequence) {
      return RevocationResponseBytes(obj);
    }
    ArgumentError.checkNotNull(obj, 'Invalid entry in sequence');
    return null;
  }

  @override
  Asn1 getAsn1() {
    return DerSequence(array: <Asn1Encode>[responseType, response]);
  }
}

/// internal class
class RequestCreatorHelper {
  /// internal constructor
  RequestCreatorHelper(this._id, this._extensions);

  /// internal field
  late final CertificateIdentity _id;
  final X509Extensions? _extensions;

  /// internal method
  RevocationRequest toRequest() {
    return RevocationRequest(_id.id!, _extensions);
  }
}

/// internal class
class RevocationRequest extends Asn1Encode {
  /// internal constructor
  RevocationRequest(this._certificateID, this._singleRequestExtensions);

  /// internal field
  late final CertificateIdentityHelper _certificateID;
  final X509Extensions? _singleRequestExtensions;

  @override
  Asn1 getAsn1() {
    final Asn1EncodeCollection collection =
        Asn1EncodeCollection(<Asn1Encode>[_certificateID]);
    if (_singleRequestExtensions != null) {
      collection.add(<dynamic>[DerTag(0, _singleRequestExtensions, true)]);
    }
    return DerSequence(collection: collection);
  }
}

/// Internal class
class TimeStampRequestCreator extends Asn1 {
  /// Internal field
  static const String _idSHA256 = '2.16.840.1.101.3.4.2.1';

  /// Internal method
  List<int> getAsnEncodedTimestampRequest(List<int> hash) {
    final Asn1Identifier digestAlgOid = Asn1Identifier(_idSHA256);
    final Algorithms algID =
        Algorithms.fromAsn1Sequence(digestAlgOid, DerNull.value);
    final Asn1Sequence seq = Asn1Sequence();
    seq.objects!.add(algID);
    seq.objects!.add(Asn1Octet(hash));
    final Asn1Sequence asn1Sequence = Asn1Sequence();
    asn1Sequence.objects!.add(Asn1Integer(1));
    asn1Sequence.objects!.add(seq);
    asn1Sequence.objects!.add(Asn1Integer(100));
    asn1Sequence.objects!.add(Asn1Boolean(true));
    return asn1Sequence.asnEncode()!;
  }

  @override
  void encode(DerStream derOut) {
    throw UnsupportedError('This functionality is not implemented yet.');
  }
}

// ignore: avoid_classes_with_only_static_members
/// internal class
class OcspConstants {
  /// internal field
  static DerObjectID ocsp = DerObjectID('1.3.6.1.5.5.7.48.1');

  /// internal field
  static DerObjectID ocspBasic = DerObjectID('1.3.6.1.5.5.7.48.1.1');

  /// internal field
  static DerObjectID ocspNonce = DerObjectID('$ocsp.2');

  /// internal field
  static DerObjectID ocspCrl = DerObjectID('$ocsp.3');

  /// internal field
  static DerObjectID ocspResponse = DerObjectID('$ocsp.4');

  /// internal field
  static DerObjectID ocspNocheck = DerObjectID('$ocsp.5');

  /// internal field
  static DerObjectID ocspArchiveCutoff = DerObjectID('$ocsp.6');

  /// internal field
  static DerObjectID ocspServiceLocator = DerObjectID('$ocsp.7');
}

/// Send the data to the server and get the response.
Future<List<int>?> fetchData(dynamic uri, String method,
    {String? contentType,
    String? userName,
    String? password,
    List<int>? data,
    Duration? timeOutDuration}) async {
  final http.Client client = http.Client();
  try {
    if (uri is String) {
      uri = Uri.parse(uri);
    }
    final http.Request request = http.Request(method, uri as Uri);
    if (contentType != null) {
      request.headers.addAll(<String, String>{'Content-Type': contentType});
    }
    if (password != null && userName != null) {
      request.headers.addAll(<String, String>{
        'Authorization':
            'Basic ${base64Encode(utf8.encode('$userName:$password'))}'
      });
    }
    if (data != null) {
      request.bodyBytes = data;
    }
    final http.StreamedResponse response = await ((timeOutDuration != null)
        ? client.send(request).timeout(timeOutDuration)
        : client.send(request));
    final List<int> responseBytes = await response.stream.toBytes();
    return (response.statusCode == 200) ? responseBytes : null;
  } catch (e) {
    return null;
  } finally {
    client.close();
  }
}
