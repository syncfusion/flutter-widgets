import 'pdf_pkcs_certificate.dart';
import 'x509/x509_certificates.dart';

/// Represents the Certificate object.
class PdfCertificate {
  /// Initializes a new instance of the [PdfCertificate] class
  PdfCertificate(List<int> certificateBytes, String password) {
    _initializeCertificate(certificateBytes, password);
  }

  //Fields
  late PdfPKCSCertificate _pkcsCertificate;
  int _version = 0;
  late List<int> _serialNumber;
  String _issuerName = '';
  String _subjectName = '';
  DateTime? _validFrom;
  DateTime? _validTo;
  late Map<String, Map<String, String>> _distinguishedNameCollection;

  //Properties
  /// Gets the certificate's version number.
  int get version => _version;

  /// Gets the serial number of a certificate.
  List<int> get serialNumber => _serialNumber;

  /// Gets the certificate issuer's name.
  String get issuerName => _issuerName;

  /// Gets the certificate subject's name.
  String get subjectName => _subjectName;

  /// Gets the date and time before which the certificate is not valid.
  DateTime get validTo => _validTo!;

  /// Gets the date and time after which the certificate is not valid.
  DateTime get validFrom => _validFrom!;

  /// Gets the certificate chain in raw bytes.
  ///
  /// ```dart
  /// //Load the certificate from the file
  /// final PdfCertificate certificate =
  ///     PdfCertificate(File('PDF.pfx').readAsBytesSync(), 'password');
  /// //Get the certificate chain
  /// List<List<int>>? certificateChain = certificate.getCertificateChain();
  /// ```
  List<List<int>>? getCertificateChain() {
    List<List<int>>? certificateChain;
    try {
      certificateChain = <List<int>>[];
      _pkcsCertificate.getChainCertificates().forEach((X509Certificates entry) {
        final List<int> certificateBytes =
            entry.certificate!.c!.getDerEncoded()!;
        certificateChain!.add(certificateBytes);
      });
    } catch (e) {
      return null;
    }
    return certificateChain;
  }

  //Implementation
  void _initializeCertificate(List<int> certificateBytes, String password) {
    _distinguishedNameCollection = <String, Map<String, String>>{};
    _pkcsCertificate = PdfPKCSCertificate(certificateBytes, password);
    String certificateAlias = '';
    final List<String> keys = _pkcsCertificate.getContentTable().keys.toList();
    bool isContinue = true;
    keys.toList().forEach((String key) {
      if (isContinue &&
          _pkcsCertificate.isKey(key) &&
          _pkcsCertificate.getKey(key)!.key!.isPrivate!) {
        certificateAlias = key;
        isContinue = false;
      }
    });
    final X509Certificates entry =
        _pkcsCertificate.getCertificate(certificateAlias)!;
    _loadDetails(entry.certificate!);
  }

  void _loadDetails(X509Certificate certificate) {
    _issuerName =
        _getDistinguishedAttributes(certificate.c!.issuer.toString(), 'CN');
    _subjectName =
        _getDistinguishedAttributes(certificate.c!.subject.toString(), 'CN');
    _validFrom = certificate.c!.startDate!.toDateTime();
    _validTo = certificate.c!.endDate!.toDateTime();
    _version = certificate.c!.version;
    final List<int> serialNumber = <int>[]
      // ignore: prefer_spread_collections
      ..addAll(certificate.c!.serialNumber!.intValue!.reversed.toList());
    _serialNumber = serialNumber;
  }

  String _getDistinguishedAttributes(String name, String key) {
    String x509Name = '';
    Map<String, String> attributesDictionary = <String, String>{};
    if (key.contains('=')) {
      key = key.replaceAll('=', '');
    }
    if (!_distinguishedNameCollection.containsKey(name)) {
      String result = '';
      bool isInitialSeparator = true;
      for (int i = 0; i < name.length; i++) {
        if (isInitialSeparator) {
          if (name[i] == ',' || name[i] == ';' || name[i] == '+') {
            _addStringToDictionary(result, attributesDictionary);
            result = '';
          } else {
            result += name[i];
            if (name[i] == r'\') {
              result += name[++i];
            } else if (name[i] == '"') {
              isInitialSeparator = false;
            }
          }
        } else {
          result += name[i];
          if (name[i] == r'\') {
            result += name[++i];
          } else if (name[i] == '"') {
            isInitialSeparator = true;
          }
        }
      }
      _addStringToDictionary(result, attributesDictionary);
      result = '';
      _distinguishedNameCollection[name] = attributesDictionary;
      if (attributesDictionary.containsKey(key)) {
        x509Name = attributesDictionary[key]!;
      }
    } else {
      attributesDictionary = _distinguishedNameCollection[name]!;
      if (attributesDictionary.containsKey(key)) {
        x509Name = attributesDictionary[key]!;
      }
    }
    return x509Name;
  }

  void _addStringToDictionary(String name, Map<String?, String?>? dictionary) {
    int index = name.indexOf('=');
    if (index > 0) {
      final List<String?> keyNameArray =
          List<String?>.generate(2, (int i) => null);
      keyNameArray[0] = name.substring(0, index).trimLeft().trimRight();
      index++;
      keyNameArray[1] =
          name.substring(index, name.length).trimLeft().trimRight();
      if (keyNameArray[0] != null &&
          keyNameArray[0] != '' &&
          keyNameArray[1] != null &&
          keyNameArray[1] != '') {
        if (!dictionary!.containsKey(keyNameArray[0])) {
          dictionary[keyNameArray[0]] = keyNameArray[1];
        }
      }
    }
  }
}

// ignore: avoid_classes_with_only_static_members
/// [PdfCertificate] helper
class PdfCertificateHelper {
  /// internal method
  static PdfPKCSCertificate getPkcsCertificate(PdfCertificate certificate) {
    return certificate._pkcsCertificate;
  }

  /// internal method
  static void setPkcsCertificate(
      PdfCertificate certificate, PdfPKCSCertificate pkcsCertificate) {
    certificate._pkcsCertificate = pkcsCertificate;
  }
}
