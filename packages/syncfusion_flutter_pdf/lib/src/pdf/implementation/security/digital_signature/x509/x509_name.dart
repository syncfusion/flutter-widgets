part of pdf;

class _X509Name extends _Asn1Encode {
  _X509Name(_Asn1Sequence sequence) {
    _initialize();
    _sequence = sequence;
    // ignore: avoid_function_literals_in_foreach_calls
    sequence._objects!.forEach((dynamic encode) {
      final _Asn1Set asn1Set = _Asn1Set.getAsn1Set(encode.getAsn1())!;
      for (int i = 0; i < asn1Set._objects.length; i++) {
        final _Asn1Sequence asn1Sequence =
            _Asn1Sequence.getSequence(asn1Set[i]!.getAsn1())!;
        if (asn1Sequence.count != 2) {
          throw ArgumentError.value(
              sequence, 'sequence', 'Invalid length in sequence');
        }
        _ordering.add(_DerObjectID.getID(asn1Sequence[0]!.getAsn1()));
        final _Asn1? asn1 = asn1Sequence[1]!.getAsn1();
        if (asn1 is _IAsn1String) {
          String value = (asn1! as _IAsn1String).getString()!;
          if (value.startsWith('#')) {
            value = r'\' + value;
          }
          _values.add(value);
        }
        _added.add(i != 0);
      }
    });
  }
  static _DerObjectID c = _DerObjectID('2.5.4.6');
  static _DerObjectID o = _DerObjectID('2.5.4.10');
  static _DerObjectID ou = _DerObjectID('2.5.4.11');
  static _DerObjectID t = _DerObjectID('2.5.4.12');
  static _DerObjectID cn = _DerObjectID('2.5.4.3');
  static _DerObjectID street = _DerObjectID('2.5.4.9');
  static _DerObjectID serialNumber = _DerObjectID('2.5.4.5');
  static _DerObjectID l = _DerObjectID('2.5.4.7');
  static _DerObjectID st = _DerObjectID('2.5.4.8');
  static _DerObjectID surname = _DerObjectID('2.5.4.4');
  static _DerObjectID givenName = _DerObjectID('2.5.4.42');
  static _DerObjectID initials = _DerObjectID('2.5.4.43');
  static _DerObjectID generation = _DerObjectID('2.5.4.44');
  static _DerObjectID uniqueIdentifier = _DerObjectID('2.5.4.45');
  static _DerObjectID businessCategory = _DerObjectID('2.5.4.15');
  static _DerObjectID postalCode = _DerObjectID('2.5.4.17');
  static _DerObjectID dnQualifier = _DerObjectID('2.5.4.46');
  static _DerObjectID pseudonym = _DerObjectID('2.5.4.65');
  static _DerObjectID dateOfBirth = _DerObjectID('1.3.6.1.5.5.7.9.1');
  static _DerObjectID placeOfBirth = _DerObjectID('1.3.6.1.5.5.7.9.2');
  static _DerObjectID gender = _DerObjectID('1.3.6.1.5.5.7.9.3');
  static _DerObjectID countryOfCitizenship = _DerObjectID('1.3.6.1.5.5.7.9.4');
  static _DerObjectID countryOfResidence = _DerObjectID('1.3.6.1.5.5.7.9.5');
  static _DerObjectID nameAtBirth = _DerObjectID('1.3.36.8.3.14');
  static _DerObjectID postalAddress = _DerObjectID('2.5.4.16');
  static _DerObjectID telephoneNumber = _X509Objects.telephoneNumberID;
  static _DerObjectID emailAddress = _PkcsObjectId.pkcs9AtEmailAddress;
  static _DerObjectID unstructuredName = _PkcsObjectId.pkcs9AtUnstructuredName;
  static _DerObjectID unstructuredAddress =
      _PkcsObjectId.pkcs9AtUnstructuredAddress;
  static _DerObjectID dc = _DerObjectID('0.9.2342.19200300.100.1.25');
  static _DerObjectID uid = _DerObjectID('0.9.2342.19200300.100.1.1');
  final List<dynamic> _ordering = <dynamic>[];
  final List<dynamic> _values = <dynamic>[];
  final List<dynamic> _added = <dynamic>[];
  final Map<_DerObjectID, String> _defaultSymbols = <_DerObjectID, String>{};
  _Asn1Sequence? _sequence;
  static _X509Name? getName(dynamic obj, [bool? isExplicit]) {
    _X509Name? result;
    if (obj is _Asn1Tag && isExplicit != null) {
      result = getName(_Asn1Sequence.getSequence(obj, isExplicit));
    } else {
      if (obj == null || obj is _X509Name) {
        result = obj as _X509Name?;
      } else if (obj != null) {
        result = _X509Name(_Asn1Sequence.getSequence(obj)!);
      } else {
        throw ArgumentError.value(obj, 'obj', 'Invalid entry');
      }
    }
    return result;
  }

  void _initialize() {
    _defaultSymbols[c] = 'C';
    _defaultSymbols[o] = 'O';
    _defaultSymbols[t] = 'T';
    _defaultSymbols[ou] = 'OU';
    _defaultSymbols[cn] = 'CN';
    _defaultSymbols[l] = 'L';
    _defaultSymbols[st] = 'ST';
    _defaultSymbols[serialNumber] = 'SERIALNUMBER';
    _defaultSymbols[emailAddress] = 'E';
    _defaultSymbols[dc] = 'DC';
    _defaultSymbols[uid] = 'UID';
    _defaultSymbols[street] = 'STREET';
    _defaultSymbols[surname] = 'SURNAME';
    _defaultSymbols[givenName] = 'GIVENNAME';
    _defaultSymbols[initials] = 'INITIALS';
    _defaultSymbols[generation] = 'GENERATION';
    _defaultSymbols[unstructuredAddress] = 'unstructuredAddress';
    _defaultSymbols[unstructuredName] = 'unstructuredName';
    _defaultSymbols[uniqueIdentifier] = 'UniqueIdentifier';
    _defaultSymbols[dnQualifier] = 'DN';
    _defaultSymbols[pseudonym] = 'Pseudonym';
    _defaultSymbols[postalAddress] = 'PostalAddress';
    _defaultSymbols[nameAtBirth] = 'NameAtBirth';
    _defaultSymbols[countryOfCitizenship] = 'CountryOfCitizenship';
    _defaultSymbols[countryOfResidence] = 'CountryOfResidence';
    _defaultSymbols[gender] = 'Gender';
    _defaultSymbols[placeOfBirth] = 'PlaceOfBirth';
    _defaultSymbols[dateOfBirth] = 'DateOfBirth';
    _defaultSymbols[postalCode] = 'PostalCode';
    _defaultSymbols[businessCategory] = 'BusinessCategory';
    _defaultSymbols[telephoneNumber] = 'TelephoneNumber';
  }

  @override
  _Asn1? getAsn1() {
    if (_sequence == null) {
      final _Asn1EncodeCollection collection1 = _Asn1EncodeCollection();
      _Asn1EncodeCollection collection2 = _Asn1EncodeCollection();
      _DerObjectID? lstOid;
      for (int i = 0; i != _ordering.length; i++) {
        final _DerObjectID? oid = _ordering[i] as _DerObjectID?;
        if (lstOid != null && !(_added[i] as bool)) {
          collection1._encodableObjects.add(_DerSet(collection: collection2));
          collection2 = _Asn1EncodeCollection();
        }
        lstOid = oid;
      }
      collection1._encodableObjects.add(_DerSet(collection: collection2));
      _sequence = _DerSequence(collection: collection1);
    }
    return _sequence;
  }

  String getString(bool isReverse, Map<_DerObjectID, String> symbols) {
    List<dynamic> components = <dynamic>[];
    String result = '';
    for (int i = 0; i < _ordering.length; i++) {
      if (_added[i] as bool) {
        result = '+';
        result = appendValue(
            result, symbols, _ordering[i] as _DerObjectID?, _values[i]);
      } else {
        result = '';
        result = appendValue(
            result, symbols, _ordering[i] as _DerObjectID?, _values[i]);
        components.add(result);
      }
    }
    if (isReverse) {
      components = components.reversed.toList();
    }
    String buf = '';
    if (components.isNotEmpty) {
      buf += components[0].toString();
      for (int i = 1; i < components.length; ++i) {
        buf += ',';
        buf += components[i].toString();
      }
    }
    return buf;
  }

  String appendValue(String builder, Map<_DerObjectID, String> symbols,
      _DerObjectID? id, String value) {
    final String? symbol = symbols[id!];
    if (symbol != null) {
      builder += symbol;
    } else {
      builder += id._id!;
    }
    builder += '=';
    int index = builder.length;
    builder += value;
    int end = builder.length;
    if (value.startsWith(r'\#')) {
      index += 2;
    }
    while (index != end) {
      if ((builder[index] == ',') ||
          (builder[index] == '"') ||
          (builder[index] == r'\') ||
          (builder[index] == '+') ||
          (builder[index] == '=') ||
          (builder[index] == '<') ||
          (builder[index] == '>') ||
          (builder[index] == ';')) {
        builder = builder.substring(0, index) +
            r'\' +
            builder.substring(index, builder.length);
        index++;
        end++;
      }
      index++;
    }
    return builder;
  }

  @override
  String toString() {
    return getString(false, _defaultSymbols);
  }
}
