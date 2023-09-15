import '../asn1/asn1.dart';
import '../asn1/der.dart';
import '../pkcs/pfx_data.dart';

/// internal class
class X509Name extends Asn1Encode {
  /// internal constructor
  X509Name(Asn1Sequence sequence) {
    _initialize();
    _sequence = sequence;
    // ignore: avoid_function_literals_in_foreach_calls
    sequence.objects!.forEach((dynamic encode) {
      final Asn1Set asn1Set = Asn1Set.getAsn1Set(encode.getAsn1())!;
      for (int i = 0; i < asn1Set.objects.length; i++) {
        final Asn1Sequence asn1Sequence =
            Asn1Sequence.getSequence(asn1Set[i]!.getAsn1())!;
        if (asn1Sequence.count != 2) {
          throw ArgumentError.value(
              sequence, 'sequence', 'Invalid length in sequence');
        }
        _ordering.add(DerObjectID.getID(asn1Sequence[0]!.getAsn1()));
        final Asn1? asn1 = asn1Sequence[1]!.getAsn1();
        if (asn1 is IAsn1String) {
          String value = (asn1! as IAsn1String).getString()!;
          if (value.startsWith('#')) {
            value = r'\' + value;
          }
          _values.add(value);
        }
        _added.add(i != 0);
      }
    });
  }

  /// internal field
  static DerObjectID c = DerObjectID('2.5.4.6');

  /// internal field
  static DerObjectID o = DerObjectID('2.5.4.10');

  /// internal field
  static DerObjectID ou = DerObjectID('2.5.4.11');

  /// internal field
  static DerObjectID t = DerObjectID('2.5.4.12');

  /// internal field
  static DerObjectID cn = DerObjectID('2.5.4.3');

  /// internal field
  static DerObjectID street = DerObjectID('2.5.4.9');

  /// internal field
  static DerObjectID serialNumber = DerObjectID('2.5.4.5');

  /// internal field
  static DerObjectID l = DerObjectID('2.5.4.7');

  /// internal field
  static DerObjectID st = DerObjectID('2.5.4.8');

  /// internal field
  static DerObjectID surname = DerObjectID('2.5.4.4');

  /// internal field
  static DerObjectID givenName = DerObjectID('2.5.4.42');

  /// internal field
  static DerObjectID initials = DerObjectID('2.5.4.43');

  /// internal field
  static DerObjectID generation = DerObjectID('2.5.4.44');

  /// internal field
  static DerObjectID uniqueIdentifier = DerObjectID('2.5.4.45');

  /// internal field
  static DerObjectID businessCategory = DerObjectID('2.5.4.15');

  /// internal field
  static DerObjectID postalCode = DerObjectID('2.5.4.17');

  /// internal field
  static DerObjectID dnQualifier = DerObjectID('2.5.4.46');

  /// internal field
  static DerObjectID pseudonym = DerObjectID('2.5.4.65');

  /// internal field
  static DerObjectID dateOfBirth = DerObjectID('1.3.6.1.5.5.7.9.1');

  /// internal field
  static DerObjectID placeOfBirth = DerObjectID('1.3.6.1.5.5.7.9.2');

  /// internal field
  static DerObjectID gender = DerObjectID('1.3.6.1.5.5.7.9.3');

  /// internal field
  static DerObjectID countryOfCitizenship = DerObjectID('1.3.6.1.5.5.7.9.4');

  /// internal field
  static DerObjectID countryOfResidence = DerObjectID('1.3.6.1.5.5.7.9.5');

  /// internal field
  static DerObjectID nameAtBirth = DerObjectID('1.3.36.8.3.14');

  /// internal field
  static DerObjectID postalAddress = DerObjectID('2.5.4.16');

  /// internal field
  static DerObjectID telephoneNumber = X509Objects.telephoneNumberID;

  /// internal field
  static DerObjectID emailAddress = PkcsObjectId.pkcs9AtEmailAddress;

  /// internal field
  static DerObjectID unstructuredName = PkcsObjectId.pkcs9AtUnstructuredName;

  /// internal field
  static DerObjectID unstructuredAddress =
      PkcsObjectId.pkcs9AtUnstructuredAddress;

  /// internal field
  static DerObjectID dc = DerObjectID('0.9.2342.19200300.100.1.25');

  /// internal field
  static DerObjectID uid = DerObjectID('0.9.2342.19200300.100.1.1');
  final List<dynamic> _ordering = <dynamic>[];
  final List<dynamic> _values = <dynamic>[];
  final List<dynamic> _added = <dynamic>[];
  final Map<DerObjectID, String> _defaultSymbols = <DerObjectID, String>{};
  Asn1Sequence? _sequence;

  /// internal property
  static X509Name? getName(dynamic obj, [bool? isExplicit]) {
    X509Name? result;
    if (obj is Asn1Tag && isExplicit != null) {
      result = getName(Asn1Sequence.getSequence(obj, isExplicit));
    } else {
      if (obj == null || obj is X509Name) {
        result = obj as X509Name?;
      } else if (obj != null) {
        result = X509Name(Asn1Sequence.getSequence(obj)!);
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
  Asn1? getAsn1() {
    if (_sequence == null) {
      final Asn1EncodeCollection collection1 = Asn1EncodeCollection();
      Asn1EncodeCollection collection2 = Asn1EncodeCollection();
      DerObjectID? lstOid;
      for (int i = 0; i != _ordering.length; i++) {
        final DerObjectID? oid = _ordering[i] as DerObjectID?;
        if (lstOid != null && !(_added[i] as bool)) {
          collection1.encodableObjects.add(DerSet(collection: collection2));
          collection2 = Asn1EncodeCollection();
        }
        lstOid = oid;
      }
      collection1.encodableObjects.add(DerSet(collection: collection2));
      _sequence = DerSequence(collection: collection1);
    }
    return _sequence;
  }

  /// internal method
  String getString(bool isReverse, Map<DerObjectID, String> symbols) {
    List<dynamic> components = <dynamic>[];
    String result = '';
    for (int i = 0; i < _ordering.length; i++) {
      if (_added[i] as bool) {
        result = '+';
        result = appendValue(
            result, symbols, _ordering[i] as DerObjectID?, _values[i]);
      } else {
        result = '';
        result = appendValue(
            result, symbols, _ordering[i] as DerObjectID?, _values[i]);
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

  /// internal method
  String appendValue(String builder, Map<DerObjectID, String> symbols,
      DerObjectID? id, String value) {
    final String? symbol = symbols[id!];
    if (symbol != null) {
      builder += symbol;
    } else {
      builder += id.id!;
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
