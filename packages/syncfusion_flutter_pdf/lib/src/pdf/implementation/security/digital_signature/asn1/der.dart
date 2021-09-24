part of pdf;

class _IAsn1String {
  String? getString([List<int>? bytes]) => null;
}

class _IAsn1SetHelper implements _IAsn1 {
  _IAsn1? readObject() => null;
  @override
  _Asn1? getAsn1() => null;
}

class _ObjectIdentityToken {
  _ObjectIdentityToken(String? id) {
    _id = id;
  }
  String? _id;
  int _index = 0;
  bool get hasMoreTokens => _index != -1;
  String? nextToken() {
    if (_index == -1) {
      return null;
    }
    final int endIndex = _id!.indexOf('.', _index);
    if (endIndex == -1) {
      final String lastToken = _id!.substring(_index);
      _index = -1;
      return lastToken;
    }
    final String nextToken = _id!.substring(_index, endIndex);
    _index = endIndex + 1;
    return nextToken;
  }
}

abstract class _DerString extends _Asn1 implements _IAsn1String {
  @override
  String? getString([List<int>? bytes]);

  @override
  String toString() {
    return getString()!;
  }

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  int get hashCode {
    return getString().hashCode;
  }

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  bool operator ==(Object other) {
    if (other is _DerString) {
      return getString() == other.getString();
    } else {
      return false;
    }
  }
}

class _DerAsciiString extends _DerString {
  //Constructor
  _DerAsciiString(String value, bool isValid) {
    if (isValid && !isAsciiString(value)) {
      throw ArgumentError.value(value, 'value', 'Invalid characters found');
    }
    _value = value;
  }

  _DerAsciiString.fromBytes(List<int> bytes) {
    _value = utf8.decode(bytes);
  }
  //Fields
  String? _value;

  //Implementation
  @override
  String? getString([List<int>? bytes]) {
    return _value;
  }

  @override
  void encode(_DerStream stream) {
    stream.writeEncoded(_Asn1Tags.asciiString, getOctets());
  }

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  int get hashCode {
    return _value.hashCode;
  }

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  bool operator ==(Object asn1) {
    if (asn1 is _DerAsciiString) {
      return _value == asn1._value;
    } else {
      return false;
    }
  }

  List<int>? asnEncode() {
    return super.asn1Encode(getOctets());
  }

  List<int> getOctets() {
    return utf8.encode(_value!);
  }

  //Static methods
  static bool isAsciiString(String value) {
    for (int i = 0; i < value.length; i++) {
      if (value.codeUnitAt(i) > 0x007f) {
        return false;
      }
    }
    return true;
  }
}

class _DerBitString extends _DerString {
  _DerBitString(List<int> data, int? pad) {
    _data = data;
    _extra = pad ?? 0;
    _table = <String>[
      '0',
      '1',
      '2',
      '3',
      '4',
      '5',
      '6',
      '7',
      '8',
      '9',
      'A',
      'B',
      'C',
      'D',
      'E',
      'F'
    ];
  }
  _DerBitString.fromAsn1(_Asn1Encode asn1) {
    _data = asn1.getDerEncoded();
  }

  //Fields
  List<int>? _data;
  int? _extra;
  late List<String> _table;

  //Implementation
  List<int>? getBytes() {
    return _data;
  }

  @override
  void encode(_DerStream stream) {
    final List<int> bytes =
        List<int>.generate(getBytes()!.length + 1, (int i) => 0);
    bytes[0] = _extra!;
    List.copyRange(bytes, 1, getBytes()!, 0, bytes.length - 1);
    stream.writeEncoded(_Asn1Tags.bitString, bytes);
  }

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  int get hashCode {
    return _extra.hashCode ^ _Asn1.getHashCode(_data);
  }

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  bool operator ==(Object asn1) {
    if (asn1 is _DerBitString) {
      return _extra == asn1._extra && _Asn1.areEqual(_data, asn1._data);
    } else {
      return false;
    }
  }

  @override
  String getString([List<int>? bytes]) {
    String result = '#';
    final List<int> str = getDerEncoded()!;
    for (int i = 0; i != str.length; i++) {
      final int ubyte = str[i].toUnsigned(16);
      result += _table[(ubyte >> 4) & 0xf];
      result += _table[str[i] & 0xf];
    }
    return result;
  }

  //Static methods
  static _DerBitString fromAsn1Octets(List<int> bytes) {
    final int pad = bytes[0];
    final List<int> data = List<int>.generate(bytes.length - 1, (int i) => 0);
    List.copyRange(data, 0, bytes, 1, data.length + 1);
    return _DerBitString(data, pad);
  }

  static _DerBitString? getDetBitString(dynamic obj) {
    if (obj == null) {
      return null;
    } else if (obj is _DerBitString) {
      return obj;
    }
    throw ArgumentError.value(obj, 'object', 'Invalid Entry');
  }

  static _DerBitString? getDerBitStringFromTag(_Asn1Tag tag, bool isExplicit) {
    final _Asn1? asn1 = tag.getObject();
    if (isExplicit || asn1 is _DerBitString) {
      return getDetBitString(asn1);
    }
    return fromAsn1Octets((asn1! as _Asn1Octet).getOctets()!);
  }
}

class _DerBmpString extends _DerString {
  _DerBmpString(List<int> bytes) {
    String result = '';
    for (int i = 0; i != (bytes.length ~/ 2); i++) {
      result +=
          String.fromCharCode((bytes[2 * i] << 8) | (bytes[2 * i + 1] & 0xff));
    }
    _value = result;
  }

  //Fields
  String? _value;

  //Implementation
  @override
  String? getString([List<int>? bytes]) {
    return _value;
  }

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  int get hashCode => _value.hashCode;

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  bool operator ==(Object asn1) {
    if (asn1 is _DerBmpString) {
      return _value == asn1._value;
    } else {
      return false;
    }
  }

  @override
  void encode(_DerStream stream) {
    final List<int> bytes =
        List<int>.generate(_value!.length * 2, (int i) => 0);
    for (int i = 0; i != _value!.length; i++) {
      bytes[2 * i] = (_value!.codeUnitAt(i) >> 8).toUnsigned(8);
      bytes[2 * i + 1] = _value!.codeUnitAt(i).toUnsigned(8);
    }
    stream.writeEncoded(_Asn1Tags.bmpString, bytes);
  }
}

class _DerPrintableString extends _DerString {
  _DerPrintableString(String value) {
    _value = value;
  }
  //Fields
  String? _value;
  //Implementation
  @override
  String? getString([List<int>? bytes]) {
    return _value;
  }

  List<int> getBytes() {
    return utf8.encode(_value!);
  }

  @override
  void encode(_DerStream stream) {
    stream.writeEncoded(_Asn1Tags.printableString, getBytes());
  }

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  bool operator ==(Object asn1) {
    if (asn1 is _DerPrintableString) {
      return _value == asn1._value;
    } else {
      return false;
    }
  }

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  int get hashCode => _value.hashCode;
}

class _DerBoolean extends _Asn1 {
  _DerBoolean(bool value) {
    _value = value ? 0xff : 0;
  }
  _DerBoolean.fromBytes(List<int> bytes) {
    if (bytes.length != 1) {
      throw ArgumentError.value(bytes, 'bytes', 'Invalid length in bytes');
    }
    _value = bytes[0];
  }
  //Fields
  late int _value;

  //Properties
  bool get isTrue => _value != 0;

  //Implementation
  @override
  void encode(_DerStream stream) {
    stream.writeEncoded(_Asn1Tags.boolean, <int>[_value]);
  }

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  bool operator ==(Object asn1) {
    if (asn1 is _DerBoolean) {
      return isTrue == asn1.isTrue;
    } else {
      return false;
    }
  }

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  int get hashCode {
    return isTrue.hashCode;
  }

  @override
  String toString() {
    return isTrue ? 'TRUE' : 'FALSE';
  }
}

class _DerInteger extends _Asn1 {
  _DerInteger(List<int>? bytes) {
    _value = bytes;
  }
  _DerInteger.fromNumber(BigInt? value) {
    if (value == null) {
      throw ArgumentError.value(value, 'value', 'Invalid value');
    }
    _value = _bigIntToBytes(value);
  }
  //Fields
  List<int>? _value;

  //Properties
  BigInt get value => _bigIntFromBytes(_value);
  BigInt get positiveValue => _bigIntFromBytes(_value, 1);

  //Implementation
  @override
  void encode(_DerStream stream) {
    stream.writeEncoded(_Asn1Tags.integer, _value);
  }

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  int get hashCode {
    return _Asn1.getHashCode(_value);
  }

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  bool operator ==(Object asn1) {
    if (asn1 is _DerInteger) {
      return _Asn1.areEqual(_value, asn1._value);
    } else {
      return false;
    }
  }

  @override
  String toString() {
    return value.toString();
  }

  //Static methods
  static _DerInteger? getNumber(dynamic obj) {
    if (obj == null || obj is _DerInteger) {
      return obj as _DerInteger?;
    }
    throw ArgumentError.value(obj, 'obj', 'Invalid entry');
  }

  static _DerInteger? getNumberFromTag(_Asn1Tag tag, bool isExplicit) {
    final _Asn1? asn1 = tag.getObject();
    if (isExplicit || asn1 is _DerInteger) {
      return getNumber(asn1);
    }
    return _DerInteger(_Asn1Octet.getOctetStringFromObject(asn1)!.getOctets());
  }
}

class _DerNull extends _Asn1Null {
  _DerNull() : super() {
    _bytes = <int>[];
  }
  //Fields
  @override
  List<int>? _bytes;
  static _DerNull value = _DerNull();
  //Implementation
  @override
  void encode(_DerStream stream) {
    stream.writeEncoded(_Asn1Tags.nullValue, _bytes);
  }

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  bool operator ==(Object asn1) {
    return asn1 is _DerNull;
  }

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  int get hashCode {
    return -1;
  }
}

class _DerObjectID extends _Asn1 {
  //Contructors
  _DerObjectID(String id) {
    if (!isValidIdentifier(id)) {
      throw ArgumentError.value(id, 'id', 'Invalid ID');
    }
    _id = id;
  }
  _DerObjectID.fromBytes(List<int> bytes) {
    _id = getObjectID(bytes);
    _bytes = _Asn1.clone(bytes);
  }
  String? _id;
  @override
  List<int>? _bytes;
  // ignore: prefer_final_fields
  static List<_DerObjectID?> _objects =
      List<_DerObjectID?>.generate(1024, (int i) => null);
  //Implemnetation
  List<int>? getBytes() {
    _bytes ??= getOutput();
    return _bytes;
  }

  List<int> getOutput() {
    List<int> stream = <int>[];
    final _ObjectIdentityToken oidToken = _ObjectIdentityToken(_id);
    String token = oidToken.nextToken()!;
    final int first = int.parse(token) * 40;
    token = oidToken.nextToken()!;
    if (token.length <= 18) {
      stream = writeField(stream, fieldValue: first + int.parse(token));
    } else {
      stream = writeField(stream,
          numberValue: BigInt.parse(token) + BigInt.from(first));
    }
    while (oidToken.hasMoreTokens) {
      token = oidToken.nextToken()!;
      if (token.length <= 18) {
        stream = writeField(stream, fieldValue: int.parse(token));
      } else {
        stream = writeField(stream, numberValue: BigInt.parse(token));
      }
    }
    return stream;
  }

  List<int> writeField(List<int> stream,
      {int? fieldValue, BigInt? numberValue}) {
    if (fieldValue != null) {
      final List<int> result = <int>[];
      result.add((fieldValue & 0x7f).toUnsigned(8));
      while (fieldValue! >= 128) {
        fieldValue >>= 7;
        result.add(((fieldValue & 0x7f) | 0x80).toUnsigned(8));
      }
      stream.addAll(result.reversed.toList());
    } else if (numberValue != null) {
      final int byteCount = (numberValue.bitLength + 6) ~/ 7;
      if (byteCount == 0) {
        stream.add(0);
      } else {
        BigInt value = numberValue;
        final List<int> bytes = List<int>.generate(byteCount, (int i) => 0);
        for (int i = byteCount - 1; i >= 0; i--) {
          bytes[i] = ((value.toSigned(32).toInt() & 0x7f) | 0x80).toUnsigned(8);
          value = value >> 7;
        }
        bytes[byteCount - 1] &= 0x7f;
        stream.addAll(bytes);
      }
    }
    return stream;
  }

  @override
  void encode(_DerStream stream) {
    stream.writeEncoded(_Asn1Tags.objectIdentifier, getBytes());
  }

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  int get hashCode {
    return _id.hashCode;
  }

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  bool operator ==(Object asn1) {
    if (asn1 is _DerObjectID) {
      return _id == asn1._id;
    } else {
      return false;
    }
  }

  @override
  String toString() {
    return _id!;
  }

  //Static methods
  static _DerObjectID? getID(dynamic obj) {
    if (obj == null || obj is _DerObjectID) {
      return obj as _DerObjectID?;
    } else if (obj is List<int>) {
      return fromOctetString(obj);
    }
    throw ArgumentError.value(obj, 'obj', 'Illegal object');
  }

  static bool isValidBranchID(String branchID, int start) {
    bool isAllowed = false;
    int position = branchID.length;
    while (--position >= start) {
      final String entry = branchID[position];
      if ('0'.codeUnitAt(0) <= entry.codeUnitAt(0) &&
          entry.codeUnitAt(0) <= '9'.codeUnitAt(0)) {
        isAllowed = true;
        continue;
      }
      if (entry == '.') {
        if (!isAllowed) {
          return false;
        }
        isAllowed = false;
        continue;
      }
      return false;
    }
    return isAllowed;
  }

  static bool isValidIdentifier(String id) {
    if (id.length < 3 || id[1] != '.') {
      return false;
    }
    if (id.codeUnitAt(0) < '0'.codeUnitAt(0) ||
        id.codeUnitAt(0) > '2'.codeUnitAt(0)) {
      return false;
    }
    return isValidBranchID(id, 2);
  }

  static String getObjectID(List<int> bytes) {
    String result = '';
    int value = 0;
    BigInt? number;
    bool first = true;
    for (int i = 0; i != bytes.length; i++) {
      final int entry = bytes[i];
      if (value <= 72057594037927808) {
        value += entry & 0x7f;
        if ((entry & 0x80) == 0) {
          if (first) {
            if (value < 40) {
              result += '0';
            } else if (value < 80) {
              result += '1';
              value -= 40;
            } else {
              result += '2';
              value -= 80;
            }
            first = false;
          }
          result += '.';
          result += value.toString();
          value = 0;
        } else {
          value <<= 7;
        }
      } else {
        number ??= BigInt.from(value);
        number = number | BigInt.from(entry & 0x7f);
        if ((entry & 0x80) == 0) {
          if (first) {
            result += '2';
            number = number - BigInt.from(80);
            first = false;
          }
          result += '.';
          result += number.toSigned(32).toInt().toString();
          number = null;
          value = 0;
        } else {
          number = number << 7;
        }
      }
    }
    return result;
  }

  static _DerObjectID? fromOctetString(List<int> bytes) {
    final int hashCode = _Asn1.getHashCode(bytes);
    final int first = hashCode & 1023;
    final _DerObjectID? entry = _objects[first];
    if (entry != null && _Asn1.areEqual(bytes, entry.getBytes())) {
      return entry;
    }
    _objects[first] = _DerObjectID.fromBytes(bytes);
    return _objects[first];
  }
}

class _DerOctet extends _Asn1Octet {
  _DerOctet(List<int> bytes) : super(bytes);
  _DerOctet.fromObject(_Asn1Encode asn1) : super.fromObject(asn1);
  @override
  void encode(_DerStream stream) {
    stream.writeEncoded(_Asn1Tags.octetString, _value);
  }
}

class _DerSequence extends _Asn1Sequence {
  _DerSequence({List<_Asn1Encode?>? array, _Asn1EncodeCollection? collection})
      : super() {
    if (array != null) {
      // ignore: prefer_foreach
      for (final _Asn1Encode? entry in array) {
        _objects!.add(entry);
      }
    } else if (collection != null) {
      for (int i = 0; i < collection.count; i++) {
        _objects!.add(collection[i]);
      }
    }
  }
  _DerSequence.fromObject(_Asn1Encode? encode) : super() {
    _objects!.add(encode);
  }
  static _DerSequence fromCollection(_Asn1EncodeCollection collection) {
    return collection.count < 1 ? empty : _DerSequence(collection: collection);
  }

  static _DerSequence empty = _DerSequence();
  @override
  void encode(_DerStream outputStream) {
    final _DerStream stream = _DerStream(<int>[]);
    // ignore: avoid_function_literals_in_foreach_calls
    _objects!.forEach((dynamic asn1) => stream.writeObject(asn1));
    outputStream.writeEncoded(
        _Asn1Tags.sequence | _Asn1Tags.constructed, stream._stream);
  }
}

class _DerSequenceHelper implements _IAsn1Collection {
  _DerSequenceHelper(_Asn1Parser helper) {
    _helper = helper;
  }
  //Fields
  late _Asn1Parser _helper;
  //Implementation
  @override
  _IAsn1? readObject() {
    return _helper.readObject();
  }

  @override
  _Asn1 getAsn1() {
    return _DerSequence(collection: _helper.readCollection());
  }
}

class _DerSet extends _Asn1Set {
  //Constructor
  _DerSet(
      {List<_Asn1Encode?>? array,
      _Asn1EncodeCollection? collection,
      bool? isSort})
      : super() {
    if (array != null) {
      // ignore: avoid_function_literals_in_foreach_calls
      array.forEach((_Asn1Encode? asn1) => addObject(asn1));
      sortObjects();
    } else if (collection != null) {
      isSort ??= true;
      for (int i = 0; i < collection.count; i++) {
        addObject(collection[i]);
      }
      if (isSort) {
        sortObjects();
      }
    }
  }
  //Implementation
  @override
  void encode(_DerStream outputStream) {
    final _DerStream stream = _DerStream(<int>[]);
    // ignore: avoid_function_literals_in_foreach_calls
    _objects.forEach((dynamic entry) => stream.writeObject(entry));
    outputStream.writeEncoded(
        _Asn1Tags.setTag | _Asn1Tags.constructed, stream._stream);
  }
}

class _DerSetHelper implements _IAsn1SetHelper {
  _DerSetHelper(_Asn1Parser helper) {
    _helper = helper;
  }
  //Fields
  late _Asn1Parser _helper;
  //Implementation
  @override
  _IAsn1? readObject() {
    return _helper.readObject();
  }

  @override
  _Asn1 getAsn1() {
    return _DerSet(collection: _helper.readCollection(), isSort: false);
  }
}

class _DerStream {
  _DerStream([List<int>? stream]) {
    if (stream != null) {
      _stream = stream;
    }
  }
  List<int>? _stream;
  //Implementation
  void writeLength(int length) {
    if (length > 127) {
      int size = 1;
      int value = length.toUnsigned(32);
      while ((value >>= 8) != 0) {
        size++;
      }
      _stream!.add((size | 0x80).toUnsigned(8));
      for (int i = (size - 1) * 8; i >= 0; i -= 8) {
        _stream!.add((length >> i).toUnsigned(8));
      }
    } else {
      _stream!.add(length.toUnsigned(8));
    }
  }

  void writeEncoded(int? tagNumber, List<int>? bytes, [int? flag]) {
    if (flag != null) {
      writeTag(flag, tagNumber!);
      writeLength(bytes!.length);
      _stream!.addAll(bytes);
    } else {
      _stream!.add(tagNumber!.toUnsigned(8));
      writeLength(bytes!.length);
      _stream!.addAll(bytes);
    }
  }

  void writeTag(int flag, int tagNumber) {
    if (tagNumber < 31) {
      _stream!.add((flag | tagNumber).toUnsigned(8));
    } else {
      _stream!.add((flag | 0x1f).toUnsigned(8));
      if (tagNumber < 128) {
        _stream!.add(tagNumber.toUnsigned(8));
      } else {
        final List<int> bytes = <int>[];
        bytes.add((tagNumber & 0x7F).toUnsigned(8));
        do {
          tagNumber >>= 7;
          bytes.add((tagNumber & 0x7F | 0x80).toUnsigned(8));
        } while (tagNumber > 127 && bytes.length <= 5);
        _stream!.addAll(bytes.reversed.toList());
      }
    }
  }

  void writeObject(dynamic obj) {
    if (obj == null) {
      _stream!.add(_Asn1Tags.nullValue);
      _stream!.add(0x00);
    } else if (obj is _Asn1) {
      obj.encode(this);
    } else if (obj is _Asn1Encode) {
      obj.getAsn1()!.encode(this);
    } else {
      throw ArgumentError.value(obj, 'obj', 'Invalid object specified');
    }
  }
}

class _DerTag extends _Asn1Tag {
  _DerTag(int? tagNumber, _Asn1Encode? asn1, [bool? isExplicit])
      : super(tagNumber, asn1) {
    if (isExplicit != null) {
      _isExplicit = isExplicit;
    }
  }
  //Implementation
  @override
  void encode(_DerStream stream) {
    final List<int>? bytes = _object!.getDerEncoded();
    if (_isExplicit!) {
      stream.writeEncoded(
          _tagNumber, bytes, _Asn1Tags.constructed | _Asn1Tags.tagged);
    } else {
      final int flag = (bytes![0] & _Asn1Tags.constructed) | _Asn1Tags.tagged;
      stream.writeTag(flag, _tagNumber!);
      stream._stream!.addAll(bytes.sublist(1));
    }
  }
}

class _DerUtcTime extends _Asn1 {
  _DerUtcTime(List<int> bytes) {
    _time = utf8.decode(bytes);
  }
  //Fields
  String? _time;
  //Properties
  DateTime? get toAdjustedDateTime {
    return DateTime.tryParse(adjustedTimeString);
  }

  String get adjustedTimeString {
    String timeString = _time!;
    final String c = timeString.codeUnitAt(0) < '5'.codeUnitAt(0) ? '20' : '19';
    timeString = c + timeString;
    return timeString.substring(0, 8) + 'T' + timeString.substring(8);
  }

  //Implementation
  @override
  void encode(_DerStream stream) {
    stream.writeEncoded(_Asn1Tags.utcTime, utf8.encode(_time!));
  }

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  bool operator ==(Object asn1) {
    if (asn1 is _DerUtcTime) {
      return _time == asn1._time;
    } else {
      return false;
    }
  }

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  int get hashCode {
    return _time.hashCode;
  }

  @override
  String toString() {
    return _time!;
  }
}

class _DerCatalogue extends _Asn1 {
  _DerCatalogue(List<int> bytes) {
    _bytes = bytes;
  }
  //Fields
  @override
  List<int>? _bytes;
  //Implemnetation
  @override
  void encode(_DerStream stream) {
    stream.writeEncoded(_Asn1Tags.enumerated, _bytes);
  }

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  bool operator ==(Object asn1) {
    if (asn1 is _DerCatalogue) {
      return _Asn1.areEqual(_bytes, asn1._bytes);
    } else {
      return false;
    }
  }

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  int get hashCode {
    return _Asn1.getHashCode(_bytes);
  }
}

class _DerOctetHelper implements _IAsn1Octet {
  _DerOctetHelper(_Asn1StreamHelper? stream) {
    _stream = stream;
  }
  //Fields
  _Asn1StreamHelper? _stream;
  //Implementation
  @override
  _StreamReader? getOctetStream() {
    return _stream;
  }

  @override
  _Asn1 getAsn1() {
    return _DerOctet(_stream!.toArray());
  }
}

class _DerUtf8String extends _DerString {
  _DerUtf8String(String value) {
    _value = value;
  }
  //Fields
  String? _value;
  //Implementation
  @override
  String? getString([List<int>? bytes]) {
    return _value;
  }

  @override
  void encode(_DerStream stream) {
    stream.writeEncoded(_Asn1Tags.utf8String, utf8.encode(_value!));
  }

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  bool operator ==(Object asn1) {
    if (asn1 is _DerUtf8String) {
      return _value == asn1._value;
    } else {
      return false;
    }
  }

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  int get hashCode => _value.hashCode;
}

class _DerTeleText extends _DerString {
  _DerTeleText(String value) {
    _value = value;
  }
  //Fields
  String? _value;
  //Implementation
  @override
  String? getString([List<int>? bytes]) {
    return _value;
  }

  @override
  void encode(_DerStream stream) {
    stream.writeEncoded(_Asn1Tags.teleText, toByteArray(_value!));
  }

  List<int> toByteArray(String value) {
    final List<int> result = <int>[];
    // ignore: avoid_function_literals_in_foreach_calls
    value.codeUnits.forEach((int entry) => result.add(entry.toUnsigned(8)));
    return result;
  }

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  bool operator ==(Object asn1) {
    if (asn1 is _DerTeleText) {
      return _value == asn1._value;
    } else {
      return false;
    }
  }

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  int get hashCode => _value.hashCode;
}
