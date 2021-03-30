part of pdf;

/// Represents the Certificate object.
class PdfCertificate {
  /// Initializes a new instance of the [PdfCertificate] class
  PdfCertificate(List<int> certificateBytes, String password) {
    _initializeCertificate(certificateBytes, password);
  }

  //Fields
  late _PdfPKCSCertificate _pkcsCertificate;
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

  //Implementation
  void _initializeCertificate(List<int> certificateBytes, String password) {
    _distinguishedNameCollection = <String, Map<String, String>>{};
    _pkcsCertificate = _PdfPKCSCertificate(certificateBytes, password);
    String certificateAlias = '';
    final List<String> keys = _pkcsCertificate.getContentTable().keys.toList();
    bool isContinue = true;
    keys.forEach((key) {
      if (isContinue &&
          _pkcsCertificate.isKey(key) &&
          _pkcsCertificate.getKey(key)!._key!.isPrivate!) {
        certificateAlias = key;
        isContinue = false;
      }
    });
    final _X509Certificates entry =
        _pkcsCertificate.getCertificate(certificateAlias)!;
    _loadDetails(entry.certificate!);
  }

  void _loadDetails(_X509Certificate certificate) {
    _issuerName =
        _getDistinguishedAttributes(certificate._c!.issuer.toString(), 'CN');
    _subjectName =
        _getDistinguishedAttributes(certificate._c!.subject.toString(), 'CN');
    _validFrom = certificate._c!.startDate!.toDateTime();
    _validTo = certificate._c!.endDate!.toDateTime();
    _version = certificate._c!.version;
    final List<int> serialNumber = <int>[]
      ..addAll(certificate._c!.serialNumber!._value!.reversed.toList());
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
            if (name[i] == '\\') {
              result += name[++i];
            } else if (name[i] == '"') {
              isInitialSeparator = false;
            }
          }
        } else {
          result += name[i];
          if (name[i] == '\\') {
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
      final List<String?> keyNameArray = List<String?>.generate(2, (i) => null);
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
