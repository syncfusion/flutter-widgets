part of pdf;

class _IAsn1 {
  _Asn1? getAsn1() => null;
}

class _IAsn1Octet implements _IAsn1 {
  _StreamReader? getOctetStream() => null;
  @override
  _Asn1? getAsn1() => null;
}

class _IAsn1Tag implements _IAsn1 {
  int? get tagNumber => null;
  _IAsn1? getParser(int tagNumber, bool isExplicit) => null;
  @override
  _Asn1? getAsn1() => null;
}

class _IAsn1Collection implements _IAsn1 {
  _IAsn1? readObject() => null;

  @override
  _Asn1? getAsn1() => null;
}

abstract class _Asn1 extends _Asn1Encode {
  _Asn1([List<_Asn1UniversalTags>? tag]) {
    if (tag != null) {
      _tag = tag;
    }
  }

  //Fields
  late List<_Asn1UniversalTags> _tag;
  List<int>? _bytes;

  //Abstract methods
  void encode(_DerStream derOut);
  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  int get hashCode;
  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  bool operator ==(Object other);

  //Implementation
  @override
  _Asn1 getAsn1() {
    return this;
  }

  List<int>? asn1Encode(List<int> bytes) {
    _bytes = <int>[];
    _bytes!.add(getTagValue(_tag));
    write(bytes.length);
    _bytes!.addAll(bytes);
    return _bytes;
  }

  void write(int length) {
    if (length > 127) {
      int size = 1;
      int value = length;
      while ((value >>= 8) != 0) {
        size++;
      }
      _bytes!.add((size | 0x80).toUnsigned(8));
      for (int i = (size - 1) * 8; i >= 0; i -= 8) {
        _bytes!.add((length >> i).toUnsigned(8));
      }
    } else {
      _bytes!.add(length);
    }
  }

  @override
  List<int>? getDerEncoded() {
    final _DerStream stream = _DerStream(<int>[])..writeObject(this);
    return stream._stream;
  }

  int getAsn1Hash() {
    return hashCode;
  }

  int getTagValue(List<_Asn1UniversalTags> tags) {
    int value = 0;
    for (final _Asn1UniversalTags tag in tags) {
      switch (tag) {
        case _Asn1UniversalTags.reservedBER:
          value |= 0;
          break;
        case _Asn1UniversalTags.boolean:
          value |= 1;
          break;
        case _Asn1UniversalTags.integer:
          value |= 2;
          break;
        case _Asn1UniversalTags.bitString:
          value |= 3;
          break;
        case _Asn1UniversalTags.octetString:
          value |= 4;
          break;
        case _Asn1UniversalTags.nullValue:
          value |= 5;
          break;
        case _Asn1UniversalTags.objectIdentifier:
          value |= 6;
          break;
        case _Asn1UniversalTags.objectDescriptor:
          value |= 7;
          break;
        case _Asn1UniversalTags.externalValue:
          value |= 8;
          break;
        case _Asn1UniversalTags.real:
          value |= 9;
          break;
        case _Asn1UniversalTags.enumerated:
          value |= 10;
          break;
        case _Asn1UniversalTags.embeddedPDV:
          value |= 11;
          break;
        case _Asn1UniversalTags.utf8String:
          value |= 12;
          break;
        case _Asn1UniversalTags.relativeOid:
          value |= 13;
          break;
        case _Asn1UniversalTags.sequence:
          value |= 16;
          break;
        case _Asn1UniversalTags.setValue:
          value |= 17;
          break;
        case _Asn1UniversalTags.numericString:
          value |= 18;
          break;
        case _Asn1UniversalTags.printableString:
          value |= 19;
          break;
        case _Asn1UniversalTags.teletexString:
          value |= 20;
          break;
        case _Asn1UniversalTags.videotexString:
          value |= 21;
          break;
        case _Asn1UniversalTags.ia5String:
          value |= 22;
          break;
        case _Asn1UniversalTags.utfTime:
          value |= 23;
          break;
        case _Asn1UniversalTags.generalizedTime:
          value |= 24;
          break;
        case _Asn1UniversalTags.graphicsString:
          value |= 25;
          break;
        case _Asn1UniversalTags.visibleString:
          value |= 26;
          break;
        case _Asn1UniversalTags.generalString:
          value |= 27;
          break;
        case _Asn1UniversalTags.universalString:
          value |= 28;
          break;
        case _Asn1UniversalTags.characterString:
          value |= 29;
          break;
        case _Asn1UniversalTags.bmpString:
          value |= 30;
          break;
        case _Asn1UniversalTags.constructed:
          value |= 32;
          break;
        case _Asn1UniversalTags.application:
          value |= 64;
          break;
        case _Asn1UniversalTags.tagged:
          value |= 128;
          break;
      }
    }
    return value;
  }

  static const String nullValue = 'NULL';
  static const String der = 'DER';
  static const String desEde = 'DESede';
  static const String des = 'DES';
  static const String rsa = 'RSA';
  static const String pkcs7 = 'PKCS7';
  static int getHashCode(List<int>? data) {
    if (data == null) {
      return 0;
    }
    int i = data.length;
    int hc = i + 1;
    while (--i >= 0) {
      hc = (hc * 257).toSigned(32);
      hc = (hc ^ data[i].toUnsigned(8)).toSigned(32);
    }
    return hc;
  }

  static bool areEqual(List<int>? a, List<int>? b) {
    if (a == b) {
      return true;
    }
    if (a == null || b == null) {
      return false;
    }
    return haveSameContents(a, b);
  }

  static bool haveSameContents(List<int> a, List<int> b) {
    int i = a.length;
    if (i != b.length) {
      return false;
    }
    while (i != 0) {
      --i;
      if (a[i] != b[i]) {
        return false;
      }
    }
    return true;
  }

  static List<int> clone(List<int> data) {
    return List<int>.generate(data.length, (int i) => data[i]);
  }

  static void uInt32ToBe(int n, List<int> bs, int off) {
    bs[off] = (n >> 24).toUnsigned(8);
    bs[off + 1] = (n >> 16).toUnsigned(8);
    bs[off + 2] = (n >> 8).toUnsigned(8);
    bs[off + 3] = n.toUnsigned(8);
  }

  static int beToUInt32(List<int> bs, int off) {
    return bs[off].toUnsigned(8) << 24 |
        bs[off + 1].toUnsigned(8) << 16 |
        bs[off + 2].toUnsigned(8) << 8 |
        bs[off + 3].toUnsigned(8);
  }
}

abstract class _Asn1Encode implements _IAsn1 {
  @override
  _Asn1? getAsn1();

  //Implementation
  List<int>? getEncoded([String? encoding]) {
    if (encoding == null) {
      return (_Asn1DerStream(<int>[])..writeObject(this))._stream;
    } else {
      if (encoding == _Asn1.der) {
        final _DerStream stream = _DerStream(<int>[])..writeObject(this);
        return stream._stream;
      }
      return getEncoded();
    }
  }

  List<int>? getDerEncoded() {
    return getEncoded(_Asn1.der);
  }

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  int get hashCode {
    return getAsn1()!.getAsn1Hash();
  }

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  bool operator ==(Object other);
}

class _Asn1EncodeCollection {
  _Asn1EncodeCollection([List<_Asn1Encode?>? vector]) {
    _encodableObjects = <dynamic>[];
    if (vector != null) {
      add(vector);
    }
  }
  late List<dynamic> _encodableObjects;

  //Properties
  _Asn1Encode? operator [](int index) =>
      _encodableObjects[index] as _Asn1Encode?;
  int get count => _encodableObjects.length;

  //Implementation
  void add(List<dynamic> objs) {
    for (final dynamic obj in objs) {
      if (obj is _Asn1Encode) {
        _encodableObjects.add(obj);
      }
    }
  }
}

class _Asn1Octet extends _Asn1 implements _IAsn1Octet {
  _Asn1Octet(List<int> value)
      : super(<_Asn1UniversalTags>[_Asn1UniversalTags.octetString]) {
    _value = value;
  }
  _Asn1Octet.fromObject(_Asn1Encode obj) {
    _value = obj.getEncoded(_Asn1.der);
  }
  //Fields
  List<int>? _value;
  _IAsn1Octet get parser => this;
  //Implementation
  @override
  _StreamReader getOctetStream() {
    return _StreamReader(_value);
  }

  List<int>? getOctets() {
    return _value;
  }

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  int get hashCode {
    return _Asn1.getHashCode(getOctets());
  }

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  bool operator ==(Object asn1) {
    if (asn1 is _DerOctet) {
      return _Asn1.areEqual(getOctets(), asn1.getOctets());
    } else {
      return false;
    }
  }

  @override
  String toString() {
    return _value.toString();
  }

  List<int>? asnEncode() {
    return super.asn1Encode(_value!);
  }

  @override
  void encode(_DerStream stream) {
    throw ArgumentError.value(stream, 'stream', 'Not Implemented');
  }

  //Static methods
  static _Asn1Octet? getOctetString(_Asn1Tag tag, bool isExplicit) {
    final _Asn1? asn1 = tag.getObject();
    if (isExplicit || asn1 is _Asn1Octet) {
      return getOctetStringFromObject(asn1);
    }
    return _BerOctet.getBerOctet(_Asn1Sequence.getSequence(asn1)!);
  }

  static _Asn1Octet? getOctetStringFromObject(dynamic obj) {
    if (obj == null || obj is _Asn1Octet) {
      return obj as _Asn1Octet?;
    }
    if (obj is _Asn1Tag) {
      return getOctetStringFromObject(obj.getObject());
    }
    throw ArgumentError.value(obj, 'obj', 'Invalid object entry');
  }
}

abstract class _Asn1Null extends _Asn1 {
  _Asn1Null() : super(<_Asn1UniversalTags>[_Asn1UniversalTags.nullValue]);
  //Implementation
  List<int> toArray() {
    return <int>[];
  }

  List<int>? asnEncode() {
    return super.asn1Encode(toArray());
  }

  @override
  String toString() {
    return _Asn1.nullValue;
  }

  @override
  void encode(_DerStream derOut) {
    derOut.writeEncoded(5, toArray());
  }
}

class _Asn1Sequence extends _Asn1 {
  //Constructor
  _Asn1Sequence()
      : super(<_Asn1UniversalTags>[
          _Asn1UniversalTags.sequence,
          _Asn1UniversalTags.constructed
        ]) {
    _objects = <dynamic>[];
  }
  //Fields
  List<dynamic>? _objects;
  int get count {
    return _objects!.length;
  }

  _IAsn1Collection get parser {
    return _Asn1SequenceHelper(this);
  }

  _IAsn1? operator [](int index) {
    dynamic result;
    if (index < _objects!.length) {
      result = _objects![index];
    } else {
      result = null;
    }
    return result as _IAsn1?;
  }

  //Implementation
  static _Asn1Sequence? getSequence(dynamic obj, [bool? explicitly]) {
    _Asn1Sequence? result;
    if (explicitly == null) {
      if (obj == null || obj is _Asn1Sequence) {
        result = obj as _Asn1Sequence?;
      } else if (obj is _IAsn1Collection) {
        result = _Asn1Sequence.getSequence(obj.getAsn1());
      } else if (obj is List<int>) {
        result = _Asn1Sequence.getSequence(
            _Asn1Stream(_StreamReader(obj)).readAsn1());
      } else if (obj is _Asn1Encode) {
        final _Asn1? primitive = obj.getAsn1();
        if (primitive != null && primitive is _Asn1Sequence) {
          return primitive;
        }
      } else {
        throw ArgumentError.value(obj, 'obj', 'Invalid entry in sequence');
      }
    } else if (obj is _Asn1Tag) {
      final _Asn1? inner = obj.getObject();
      if (explicitly) {
        if (!obj._isExplicit!) {
          throw ArgumentError.value(
              explicitly, 'explicitly', 'Invalid entry in sequence');
        }
        result = inner as _Asn1Sequence?;
      } else if (obj._isExplicit!) {
        if (obj is _DerTag) {
          result = _BerSequence.fromObject(inner);
        }
        result = _DerSequence.fromObject(inner);
      } else {
        if (inner is _Asn1Sequence) {
          result = inner;
        } else {
          throw ArgumentError.value(obj, 'obj', 'Invalid entry in sequence');
        }
      }
    }
    return result;
  }

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  int get hashCode {
    int hashCode = count;
    for (final dynamic o in _objects!) {
      hashCode *= 17;
      if (o == null) {
        hashCode ^= _DerNull().getAsn1Hash();
      } else {
        hashCode ^= o.hashCode;
      }
    }
    return hashCode;
  }

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  bool operator ==(Object asn1) {
    if (asn1 is _Asn1Sequence) {
      if (count != asn1.count) {
        return false;
      }
      for (int i = 0; i < count; i++) {
        final _Asn1? o1 = getCurrentObject(_objects![i]).getAsn1();
        final _Asn1? o2 = getCurrentObject(asn1._objects![i]).getAsn1();
        if (o1 != o2) {
          return false;
        }
      }
    } else {
      return false;
    }
    return true;
  }

  _Asn1Encode getCurrentObject(dynamic e) {
    if (e != null && e is _Asn1Encode) {
      return e;
    } else {
      return _DerNull();
    }
  }

  @override
  String toString([List<dynamic>? e]) {
    if (e == null) {
      return toString(_objects);
    } else {
      String result = '[';
      for (int i = 0; i < _objects!.length; i++) {
        result += _objects![i].toString();
        if (i != _objects!.length - 1) {
          result += ', ';
        }
      }
      result += ']';
      return result;
    }
  }

  List<int> toArray() {
    final List<int> stream = <int>[];
    for (final dynamic obj in _objects!) {
      List<int>? buffer;
      if (obj is _Asn1Null) {
        buffer = obj.asnEncode();
      } else if (obj is _Asn1Octet) {
        buffer = obj.asnEncode();
      } else if (obj is _Asn1Sequence) {
        buffer = obj.asnEncode();
      } else if (obj is _Algorithms) {
        buffer = obj.asnEncode();
      }
      if (buffer != null && buffer.isNotEmpty) {
        stream.addAll(buffer);
      }
    }
    return stream;
  }

  @override
  void encode(_DerStream derOut) {
    throw ArgumentError.value('Not Implemented');
  }

  List<int>? asnEncode() {
    return super.asn1Encode(toArray());
  }
}

class _Asn1SequenceCollection extends _Asn1Encode {
  _Asn1SequenceCollection(_Asn1Sequence sequence) {
    _id = _DerObjectID.getID(sequence[0]);
    _value = (sequence[1]! as _Asn1Tag).getObject();
    if (sequence.count == 3) {
      _attributes = sequence[2] as _DerSet?;
    }
  }
  _DerObjectID? _id;
  _Asn1? _value;
  _Asn1Set? _attributes;
  @override
  _Asn1 getAsn1() {
    final _Asn1EncodeCollection collection =
        _Asn1EncodeCollection(<_Asn1Encode?>[_id, _DerTag(0, _value)]);
    if (_attributes != null) {
      collection._encodableObjects.add(_attributes);
    }
    return _DerSequence(collection: collection);
  }
}

class _Asn1SequenceHelper implements _IAsn1Collection {
  _Asn1SequenceHelper(_Asn1Sequence sequence) {
    _sequence = sequence;
    _max = sequence.count;
  }
  //Fields
  _Asn1Sequence? _sequence;
  int? _max;
  int? _index;
  //Implementation
  @override
  _IAsn1? readObject() {
    if (_index == _max) {
      return null;
    }
    final _IAsn1? obj = _sequence![_index!];
    _index = _index! + 1;
    if (obj is _Asn1Sequence) {
      return obj.parser;
    }
    if (obj is _Asn1Set) {
      return obj.parser;
    }
    return obj;
  }

  @override
  _Asn1? getAsn1() {
    return _sequence;
  }
}

class _Asn1Set extends _Asn1 {
  _Asn1Set([int? capacity]) {
    _objects = capacity != null
        ? List<dynamic>.generate(capacity, (dynamic i) => null)
        : <dynamic>[];
  }
  //Fields
  late List<dynamic> _objects;

  //Properties
  _IAsn1SetHelper get parser {
    return _Asn1SetHelper(this);
  }

  _Asn1Encode? operator [](int index) => _objects[index] as _Asn1Encode?;

  //Implementation
  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  int get hashCode {
    int hc = _objects.length;
    for (final dynamic o in _objects) {
      hc *= 17;
      if (o == null) {
        hc ^= _DerNull.value.getAsn1Hash();
      } else {
        hc ^= o.hashCode;
      }
    }
    return hc;
  }

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  bool operator ==(Object asn1) {
    if (asn1 is _Asn1Set) {
      if (_objects.length != asn1._objects.length) {
        return false;
      }
      for (int i = 0; i < _objects.length; i++) {
        final _Asn1? o1 = getCurrentSet(_objects[i]).getAsn1();
        final _Asn1? o2 = getCurrentSet(asn1._objects[i]).getAsn1();
        if (o1 != o2) {
          return false;
        }
      }
    } else {
      return false;
    }
    return true;
  }

  _Asn1Encode getCurrentSet(dynamic e) {
    if (e is _Asn1Encode) {
      return e;
    } else {
      return _DerNull.value;
    }
  }

  bool lessThanOrEqual(List<int> a, List<int> b) {
    final int len = min(a.length, b.length);
    for (int i = 0; i != len; ++i) {
      if (a[i] != b[i]) {
        return a[i] < b[i];
      }
    }
    return len == a.length;
  }

  void addObject(_Asn1Encode? obj) {
    _objects.add(obj);
  }

  @override
  String toString() {
    return _objects.toString();
  }

  @override
  void encode(_DerStream derOut) {
    throw ArgumentError.value('Not Implemented');
  }

  void sortObjects() {
    if (_objects.length > 1) {
      bool swapped = true;
      int lastSwap = _objects.length - 1;
      while (swapped) {
        int index = 0;
        int swapIndex = 0;
        List<int>? a = (_objects[0] as _Asn1Encode).getEncoded();
        swapped = false;
        while (index != lastSwap) {
          final List<int> b =
              (_objects[index + 1] as _Asn1Encode).getEncoded()!;
          if (lessThanOrEqual(a!, b)) {
            a = b;
          } else {
            final dynamic o = _objects[index];
            _objects[index] = _objects[index + 1];
            _objects[index + 1] = o;
            swapped = true;
            swapIndex = index;
          }
          index++;
        }
        lastSwap = swapIndex;
      }
    }
  }

  //static methods
  static _Asn1Set? getAsn1Set(dynamic obj, [bool? isExplicit]) {
    _Asn1Set? result;
    if (isExplicit == null) {
      if (obj == null || obj is _Asn1Set) {
        result = obj as _Asn1Set?;
      } else if (obj is _IAsn1SetHelper) {
        result = _Asn1Set.getAsn1Set(obj.getAsn1());
      } else if (obj is List<int>) {
        result =
            _Asn1Set.getAsn1Set(_Asn1Stream(_StreamReader(obj)).readAsn1());
      } else if (obj is _Asn1Encode) {
        final _Asn1? asn1 = obj.getAsn1();
        if (asn1 != null && asn1 is _Asn1Set) {
          result = asn1;
        }
      } else {
        throw ArgumentError.value(obj, 'obj', 'Invalid entry in sequence');
      }
    } else if (obj is _Asn1Tag) {
      final _Asn1? inner = obj.getObject();
      if (isExplicit) {
        if (!obj._isExplicit!) {
          throw ArgumentError.value(obj, 'obj', 'Tagged object is implicit.');
        }
        result = (inner is _Asn1Set) ? inner : null;
      } else if (obj._isExplicit! && inner is _Asn1Encode) {
        result = _DerSet(array: <_Asn1Encode?>[inner]);
      } else if (inner is _Asn1Set) {
        result = inner;
      } else if (inner is _Asn1Sequence) {
        final _Asn1EncodeCollection collection = _Asn1EncodeCollection();
        // ignore: avoid_function_literals_in_foreach_calls
        inner._objects!.toList().forEach(
            (dynamic entry) => collection._encodableObjects.add(entry));
        result = _DerSet(collection: collection, isSort: false);
      } else {
        throw ArgumentError.value(obj, 'obj', 'Invalid entry in sequence');
      }
    }
    return result;
  }
}

class _Asn1SetHelper implements _IAsn1SetHelper {
  _Asn1SetHelper(_Asn1Set outer) {
    _set = outer;
    _max = outer._objects.length;
  }
  _Asn1Set? _set;
  int? _max;
  int? _index;
  @override
  _IAsn1? readObject() {
    if (_index == _max) {
      return null;
    } else {
      final _Asn1Encode? obj = _set![_index!];
      _index = _index! + 1;
      if (obj is _Asn1Sequence) {
        return obj.parser;
      }
      if (obj is _Asn1Set) {
        return obj.parser;
      }
      return obj;
    }
  }

  @override
  _Asn1? getAsn1() {
    return _set;
  }
}

class _Asn1Tag extends _Asn1 implements _IAsn1Tag {
  _Asn1Tag(int? tagNumber, _Asn1Encode? asn1Encode, [bool? isExplicit]) {
    _isExplicit = isExplicit ?? true;
    _tagNumber = tagNumber;
    _object = asn1Encode;
  }
  //Fields
  int? _tagNumber;
  bool? _isExplicit;
  _Asn1Encode? _object;
  //Properties
  @override
  int? get tagNumber {
    return _tagNumber;
  }

  //Static methods
  static _Asn1Tag? getTag(dynamic obj, [bool? isExplicit]) {
    if (isExplicit != null && obj is _Asn1Tag) {
      if (isExplicit) {
        return obj.getObject() as _Asn1Tag?;
      }
      throw ArgumentError.value(obj, 'obj', 'Explicit tag is not used');
    } else {
      if (obj == null || obj is _Asn1Tag) {
        return obj as _Asn1Tag?;
      }
      throw ArgumentError.value(obj, 'obj', 'Invalid entry in sequence');
    }
  }

  //Implementation
  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  bool operator ==(Object asn1) {
    if (asn1 is _Asn1Tag) {
      return _tagNumber == asn1._tagNumber &&
          _isExplicit == asn1._isExplicit &&
          getObject() == asn1.getObject();
    } else {
      return false;
    }
  }

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  int get hashCode {
    int code = _tagNumber.hashCode;
    if (_object != null) {
      code ^= _object.hashCode;
    }
    return code;
  }

  @override
  String toString() {
    return '[' + _tagNumber.toString() + ']' + _object.toString();
  }

  @override
  void encode(_DerStream stream) {
    throw ArgumentError.value(stream, 'stream', 'Not Implemented');
  }

  _Asn1? getObject() {
    if (_object != null) {
      return _object!.getAsn1();
    }
    return null;
  }

  @override
  _IAsn1? getParser(int tagNumber, bool isExplicit) {
    switch (tagNumber) {
      case _Asn1Tags.setTag:
        return _Asn1Set.getAsn1Set(this, isExplicit)!.parser;
      case _Asn1Tags.sequence:
        return _Asn1Sequence.getSequence(this, isExplicit)!.parser;
      case _Asn1Tags.octetString:
        return _Asn1Octet.getOctetString(this, isExplicit)!.parser;
    }
    if (isExplicit) {
      return getObject();
    }
    throw ArgumentError.value(
        tagNumber, 'tagNumber', 'Implicit tagging is not supported');
  }
}

class _Asn1DerStream extends _DerStream {
  _Asn1DerStream([List<int>? stream]) {
    if (stream != null) {
      _stream = stream;
    } else {
      _stream = <int>[];
    }
  }
}

class _GeneralizedTime extends _Asn1 {
  _GeneralizedTime(List<int> bytes) {
    _time = utf8.decode(bytes);
  }
  //Fields
  late String _time;
  //Implementation
  DateTime? toDateTime() {
    return DateTime.tryParse(_time);
  }

  @override
  void encode(_DerStream stream) {
    stream.writeEncoded(_Asn1Tags.generalizedTime, utf8.encode(_time));
  }

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  bool operator ==(Object asn1Object) {
    throw ArgumentError.value('Not implemented');
  }

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  int get hashCode {
    return _time.hashCode;
  }
}

class _OctetStream extends _StreamReader {
  _OctetStream(_Asn1Parser? helper) : super(<int>[]) {
    _helper = helper;
    _first = true;
  }
  _Asn1Parser? _helper;
  _StreamReader? _stream;
  late bool _first;
  //Implementation
  @override
  int? read(List<int> buffer, int offset, int count) {
    if (_stream == null) {
      if (!_first) {
        return 0;
      }
      final _IAsn1? octet = _helper!.readObject();
      if (octet != null && octet is _IAsn1Octet) {
        _first = false;
        _stream = octet.getOctetStream();
      } else {
        return 0;
      }
    }
    int totalRead = 0;
    bool isContinue = true;
    int? result;
    while (isContinue) {
      final int numRead =
          _stream!.read(buffer, offset + totalRead, count - totalRead)!;
      if (numRead > 0) {
        totalRead += numRead;
        if (totalRead == count) {
          result = totalRead;
          isContinue = false;
        }
      } else {
        final _IAsn1? octet = _helper!.readObject();
        if (octet != null && octet is _IAsn1Octet) {
          _stream = octet.getOctetStream();
        } else {
          _stream = null;
          result = totalRead;
          isContinue = false;
        }
      }
    }
    return result;
  }

  @override
  int? readByte() {
    if (_stream == null) {
      if (!_first) {
        return 0;
      }
      final _IAsn1? octet = _helper!.readObject();
      if (octet != null && octet is _IAsn1Octet) {
        _first = false;
        _stream = octet.getOctetStream();
      } else {
        return 0;
      }
    }
    bool isContinue = true;
    int? result;
    while (isContinue) {
      final int value = _stream!.readByte()!;
      if (value >= 0) {
        result = value;
        isContinue = false;
      } else {
        final _IAsn1? octet = _helper!.readObject();
        if (octet != null && octet is _IAsn1Octet) {
          _stream = octet.getOctetStream();
        } else {
          _stream = null;
          result = -1;
          isContinue = false;
        }
      }
    }
    return result;
  }
}

class _Asn1Tags {
  static const int boolean = 0x01;
  static const int integer = 0x02;
  static const int bitString = 0x03;
  static const int octetString = 0x04;
  static const int nullValue = 0x05;
  static const int objectIdentifier = 0x06;
  static const int enumerated = 0x0a;
  static const int sequence = 0x10;
  static const int setTag = 0x11;
  static const int printableString = 0x13;
  static const int teleText = 0x14;
  static const int asciiString = 0x16;
  static const int utcTime = 0x17;
  static const int generalizedTime = 0x18;
  static const int bmpString = 0x1e;
  static const int utf8String = 0x0c;
  static const int constructed = 0x20;
  static const int tagged = 0x80;
}
