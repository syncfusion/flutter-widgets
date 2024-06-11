import 'dart:convert';
import 'dart:math';

import '../../../io/stream_reader.dart';
import '../pkcs/pfx_data.dart';
import 'asn1_stream.dart';
import 'ber.dart';
import 'der.dart';

/// internal class
class IAsn1 {
  /// internal method
  Asn1? getAsn1() => null;
}

/// internal class
class IAsn1Octet implements IAsn1 {
  /// internal method
  PdfStreamReader? getOctetStream() => null;
  @override
  Asn1? getAsn1() => null;
}

/// internal class
class IAsn1Tag implements IAsn1 {
  /// internal property
  int? get tagNumber => null;

  /// internal method
  IAsn1? getParser(int tagNumber, bool isExplicit) => null;
  @override
  Asn1? getAsn1() => null;
}

/// internal class
class IAsn1Collection implements IAsn1 {
  /// internal method
  IAsn1? readObject() => null;

  @override
  Asn1? getAsn1() => null;
}

/// internal class
abstract class Asn1 extends Asn1Encode {
  /// internal constructor
  Asn1([List<_Asn1UniversalTags>? tag]) {
    if (tag != null) {
      _tag = tag;
    }
  }

  //Fields
  late List<_Asn1UniversalTags> _tag;

  /// internal field
  List<int>? bytes;

  /// internal field
  static const String nullValue = 'NULL';

  /// internal field
  static const String der = 'DER';

  /// internal field
  static const String desEde = 'DESede';

  /// internal field
  static const String des = 'DES';

  /// internal field
  static const String rsa = 'RSA';

  /// internal field
  static const String pkcs7 = 'PKCS7';

  //Abstract methods
  /// internal method
  void encode(DerStream derOut);

  //Properties
  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  int get hashCode;
  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  bool operator ==(Object other);

  //Implementation
  @override
  Asn1 getAsn1() {
    return this;
  }

  /// internal method
  List<int>? asn1Encode(List<int> bytes) {
    this.bytes = <int>[];
    this.bytes!.add(getTagValue(_tag));
    write(bytes.length);
    this.bytes!.addAll(bytes);
    final List<int> result = this.bytes!.toList();
    this.bytes!.clear();
    return result;
  }

  /// internal method
  void write(int length) {
    if (length > 127) {
      int size = 1;
      int value = length;
      while ((value >>= 8) != 0) {
        size++;
      }
      bytes!.add((size | 0x80).toUnsigned(8));
      for (int i = (size - 1) * 8; i >= 0; i -= 8) {
        bytes!.add((length >> i).toUnsigned(8));
      }
    } else {
      bytes!.add(length);
    }
  }

  @override
  List<int>? getDerEncoded() {
    final DerStream stream = DerStream(<int>[])..writeObject(this);
    return stream.stream;
  }

  /// internal method
  int getAsn1Hash() {
    return hashCode;
  }

  /// internal method
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

  /// internal method
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

  /// internal method
  static bool areEqual(List<int>? a, List<int>? b) {
    if (a == b) {
      return true;
    }
    if (a == null || b == null) {
      return false;
    }
    return haveSameContents(a, b);
  }

  /// internal method
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

  /// internal method
  static List<int> clone(List<int> data) {
    return List<int>.generate(data.length, (int i) => data[i]);
  }

  /// internal method
  static void uInt32ToBe(int n, List<int> bs, int off) {
    bs[off] = (n >> 24).toUnsigned(8);
    bs[off + 1] = (n >> 16).toUnsigned(8);
    bs[off + 2] = (n >> 8).toUnsigned(8);
    bs[off + 3] = n.toUnsigned(8);
  }

  /// internal method
  static int beToUInt32(List<int> bs, int off) {
    return bs[off].toUnsigned(8) << 24 |
        bs[off + 1].toUnsigned(8) << 16 |
        bs[off + 2].toUnsigned(8) << 8 |
        bs[off + 3].toUnsigned(8);
  }

  /// internal method
  static int beToUInt64(List<int> bs, int off) {
    final int hi = beToUInt32(bs, off);
    final int lo = beToUInt32(bs, off + 4);
    return (hi.toUnsigned(64) << 32) | lo.toUnsigned(64);
  }

  /// internal method
  static void uInt64ToBe(int n, List<int> bs, int off) {
    uInt32ToBe((n >> 32).toUnsigned(32), bs, off);
    uInt32ToBe(n.toUnsigned(32), bs, off + 4);
  }

  /// internal method
  static BigInt leToUInt32(List<int> bs, int off) {
    return BigInt.from(bs[off].toUnsigned(32) |
        bs[off + 1].toUnsigned(32) << 8 |
        bs[off + 2].toUnsigned(32) << 16 |
        bs[off + 3].toUnsigned(32) << 24);
  }

  /// internal method
  static void uInt32ToLe(BigInt n, List<int> bs, int off) {
    bs[off] = n.toUnsigned(8).toInt();
    bs[off + 1] = (n >> 8).toUnsigned(8).toInt();
    bs[off + 2] = (n >> 16).toUnsigned(8).toInt();
    bs[off + 3] = (n >> 24).toUnsigned(8).toInt();
  }

  /// internal method
  static Asn1 fromByteArray(List<int> data) {
    try {
      return Asn1Stream(PdfStreamReader(data)).readAsn1()!;
    } catch (e) {
      throw Exception('Invalid entry');
    }
  }
}

/// internal class
abstract class Asn1Encode implements IAsn1 {
  @override
  Asn1? getAsn1();

  //Implementation
  /// internal method
  List<int>? getEncoded([String? encoding]) {
    if (encoding == null) {
      return (Asn1DerStream(<int>[])..writeObject(this)).stream;
    } else {
      if (encoding == Asn1.der) {
        final DerStream stream = DerStream(<int>[])..writeObject(this);
        return stream.stream;
      }
      return getEncoded();
    }
  }

  /// internal method
  Future<List<int>?> getEncodedAsync([String? encoding]) async {
    if (encoding == null) {
      return (Asn1DerStream(<int>[])..writeObject(this)).stream;
    } else {
      if (encoding == Asn1.der) {
        final DerStream stream = DerStream(<int>[])..writeObject(this);
        return stream.stream;
      }
      return getEncoded();
    }
  }

  /// internal method
  List<int>? getDerEncoded() {
    return getEncoded(Asn1.der);
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

/// internal class
class Asn1EncodeCollection {
  /// internal constructor
  Asn1EncodeCollection([List<Asn1Encode?>? vector]) {
    encodableObjects = <dynamic>[];
    if (vector != null) {
      add(vector);
    }
  }

  /// internal field
  late List<dynamic> encodableObjects;

  //Properties
  /// internal property
  Asn1Encode? operator [](int index) => encodableObjects[index] as Asn1Encode?;

  /// internal property
  int get count => encodableObjects.length;

  //Implementation
  /// internal method
  void add(List<dynamic> objs) {
    for (final dynamic obj in objs) {
      if (obj is Asn1Encode) {
        encodableObjects.add(obj);
      }
    }
  }
}

/// internal class
class Asn1Octet extends Asn1 implements IAsn1Octet {
  /// internal constructor
  Asn1Octet(this.value)
      : super(<_Asn1UniversalTags>[_Asn1UniversalTags.octetString]);

  /// internal constructor
  Asn1Octet.fromObject(Asn1Encode obj) {
    value = obj.getEncoded(Asn1.der);
  }
  //Fields
  /// internal field
  List<int>? value;

  /// internal property
  IAsn1Octet get parser => this;
  //Implementation
  @override
  PdfStreamReader getOctetStream() {
    return PdfStreamReader(value);
  }

  /// internal method
  List<int>? getOctets() {
    return value;
  }

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  int get hashCode {
    return Asn1.getHashCode(getOctets());
  }

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes, avoid_renaming_method_parameters
  bool operator ==(Object asn1) {
    if (asn1 is DerOctet) {
      return Asn1.areEqual(getOctets(), asn1.getOctets());
    } else {
      return false;
    }
  }

  @override
  String toString() {
    return value.toString();
  }

  /// internal method
  List<int>? asnEncode() {
    return super.asn1Encode(value!);
  }

  /// internal method
  @override
  void encode(DerStream stream) {
    throw ArgumentError.value(stream, 'stream', 'Not Implemented');
  }

  //Static methods
  /// internal method
  static Asn1Octet? getOctetString(Asn1Tag tag, bool isExplicit) {
    final Asn1? asn1 = tag.getObject();
    if (isExplicit || asn1 is Asn1Octet) {
      return getOctetStringFromObject(asn1);
    }
    return BerOctet.getBerOctet(Asn1Sequence.getSequence(asn1)!);
  }

  /// internal method
  static Asn1Octet? getOctetStringFromObject(dynamic obj) {
    if (obj == null || obj is Asn1Octet) {
      return obj as Asn1Octet?;
    }
    if (obj is Asn1Tag) {
      return getOctetStringFromObject(obj.getObject());
    }
    throw ArgumentError.value(obj, 'obj', 'Invalid object entry');
  }
}

/// internal class
abstract class Asn1Null extends Asn1 {
  /// internal constructor
  Asn1Null() : super(<_Asn1UniversalTags>[_Asn1UniversalTags.nullValue]);
  //Implementation
  /// internal method
  List<int> toArray() {
    return <int>[];
  }

  /// internal method
  List<int>? asnEncode() {
    return super.asn1Encode(toArray());
  }

  @override
  String toString() {
    return Asn1.nullValue;
  }

  @override
  void encode(DerStream derOut) {
    derOut.writeEncoded(5, toArray());
  }
}

/// internal class
class Asn1Sequence extends Asn1 {
  //Constructor
  /// internal constructor
  Asn1Sequence()
      : super(<_Asn1UniversalTags>[
          _Asn1UniversalTags.sequence,
          _Asn1UniversalTags.constructed
        ]) {
    objects = <dynamic>[];
  }
  //Fields
  /// internal field
  List<dynamic>? objects;
  Asn1SequenceHelper? _parser;

  /// internal field
  int get count {
    return objects!.length;
  }

  /// internal property
  IAsn1Collection get parser {
    return _parser ??= Asn1SequenceHelper(this);
  }

  /// internal property
  IAsn1? operator [](int index) {
    dynamic result;
    if (index < objects!.length) {
      result = objects![index];
    } else {
      result = null;
    }
    return result as IAsn1?;
  }

  //Implementation
  /// internal method
  static Asn1Sequence? getSequence(dynamic obj, [bool? explicitly]) {
    Asn1Sequence? result;
    if (explicitly == null) {
      if (obj == null || obj is Asn1Sequence) {
        result = obj as Asn1Sequence?;
      } else if (obj is IAsn1Collection) {
        result = Asn1Sequence.getSequence(obj.getAsn1());
      } else if (obj is List<int>) {
        result = Asn1Sequence.getSequence(
            Asn1Stream(PdfStreamReader(obj)).readAsn1());
      } else if (obj is Asn1Encode) {
        final Asn1? primitive = obj.getAsn1();
        if (primitive != null && primitive is Asn1Sequence) {
          return primitive;
        }
      } else {
        throw ArgumentError.value(obj, 'obj', 'Invalid entry in sequence');
      }
    } else if (obj is Asn1Tag) {
      final Asn1? inner = obj.getObject();
      if (explicitly) {
        if (!obj.explicit!) {
          throw ArgumentError.value(
              explicitly, 'explicitly', 'Invalid entry in sequence');
        }
        result = inner as Asn1Sequence?;
      } else if (obj.explicit!) {
        if (obj is DerTag) {
          result = BerSequence.fromObject(inner);
        }
        result = DerSequence.fromObject(inner);
      } else {
        if (inner is Asn1Sequence) {
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
    for (final dynamic o in objects!) {
      hashCode *= 17;
      if (o == null) {
        hashCode ^= DerNull().getAsn1Hash();
      } else {
        hashCode ^= o.hashCode;
      }
    }
    return hashCode;
  }

  /// internal property
  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  bool operator ==(Object asn1) {
    if (asn1 is Asn1Sequence) {
      if (count != asn1.count) {
        return false;
      }
      for (int i = 0; i < count; i++) {
        final Asn1? o1 = getCurrentObject(objects![i]).getAsn1();
        final Asn1? o2 = getCurrentObject(asn1.objects![i]).getAsn1();
        if (o1 != o2) {
          return false;
        }
      }
    } else {
      return false;
    }
    return true;
  }

  /// internal method
  Asn1Encode getCurrentObject(dynamic e) {
    if (e != null && e is Asn1Encode) {
      return e;
    } else {
      return DerNull();
    }
  }

  @override
  String toString([List<dynamic>? e]) {
    if (e == null) {
      return toString(objects);
    } else {
      String result = '[';
      for (int i = 0; i < objects!.length; i++) {
        result += objects![i].toString();
        if (i != objects!.length - 1) {
          result += ', ';
        }
      }
      result += ']';
      return result;
    }
  }

  /// internal method
  List<int> toArray() {
    final List<int> stream = <int>[];
    for (final dynamic obj in objects!) {
      List<int>? buffer;
      if (obj is Asn1Integer) {
        buffer = obj.asnEncode();
      } else if (obj is Asn1Boolean) {
        buffer = obj.asnEncode();
      } else if (obj is Asn1Identifier) {
        buffer = obj.asnEncode();
      } else if (obj is Asn1Null) {
        buffer = obj.asnEncode();
      } else if (obj is Asn1Octet) {
        buffer = obj.asnEncode();
      } else if (obj is Asn1Sequence) {
        buffer = obj.asnEncode();
      } else if (obj is Algorithms) {
        buffer = obj.asnEncode();
      }
      if (buffer != null && buffer.isNotEmpty) {
        stream.addAll(buffer);
      }
    }
    return stream;
  }

  @override
  void encode(DerStream derOut) {
    throw ArgumentError.value('Not Implemented');
  }

  /// internal method
  List<int>? asnEncode() {
    return super.asn1Encode(toArray());
  }
}

/// internal class
class Asn1SequenceCollection extends Asn1Encode {
  /// internal constructor
  Asn1SequenceCollection(Asn1Sequence sequence) {
    id = DerObjectID.getID(sequence[0]);
    value = (sequence[1]! as Asn1Tag).getObject();
    if (sequence.count == 3) {
      attributes = sequence[2] as DerSet?;
    }
  }

  /// internal field
  DerObjectID? id;

  /// internal field
  Asn1? value;

  /// internal field
  Asn1Set? attributes;
  @override
  Asn1 getAsn1() {
    final Asn1EncodeCollection collection =
        Asn1EncodeCollection(<Asn1Encode?>[id, DerTag(0, value)]);
    if (attributes != null) {
      collection.encodableObjects.add(attributes);
    }
    return DerSequence(collection: collection);
  }
}

/// internal class
class Asn1SequenceHelper implements IAsn1Collection {
  /// internal constructor
  Asn1SequenceHelper(Asn1Sequence sequence) {
    _sequence = sequence;
    _max = sequence.count;
  }
  //Fields
  Asn1Sequence? _sequence;
  int? _max;
  int? _index;
  //Implementation
  @override
  IAsn1? readObject() {
    if (_index == _max) {
      return null;
    }
    final IAsn1? obj = _sequence![_index!];
    _index = _index! + 1;
    if (obj is Asn1Sequence) {
      return obj.parser;
    }
    if (obj is Asn1Set) {
      return obj.parser;
    }
    return obj;
  }

  @override
  Asn1? getAsn1() {
    return _sequence;
  }
}

/// internal class
class Asn1Set extends Asn1 {
  /// internal constructor
  Asn1Set([int? capacity]) {
    objects = capacity != null
        ? List<dynamic>.generate(capacity, (dynamic i) => null)
        : <dynamic>[];
  }
  //Fields
  /// internal field
  late List<dynamic> objects;

  //Properties
  /// internal property
  IAsn1SetHelper get parser {
    return Asn1SetHelper(this);
  }

  /// internal property
  Asn1Encode? operator [](int index) => objects[index] as Asn1Encode?;

  //Implementation
  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  int get hashCode {
    int hc = objects.length;
    for (final dynamic o in objects) {
      hc *= 17;
      if (o == null) {
        hc ^= DerNull.value.getAsn1Hash();
      } else {
        hc ^= o.hashCode;
      }
    }
    return hc;
  }

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes, avoid_renaming_method_parameters
  bool operator ==(Object asn1) {
    if (asn1 is Asn1Set) {
      if (objects.length != asn1.objects.length) {
        return false;
      }
      for (int i = 0; i < objects.length; i++) {
        final Asn1? o1 = getCurrentSet(objects[i]).getAsn1();
        final Asn1? o2 = getCurrentSet(asn1.objects[i]).getAsn1();
        if (o1 != o2) {
          return false;
        }
      }
    } else {
      return false;
    }
    return true;
  }

  /// internal method
  Asn1Encode getCurrentSet(dynamic e) {
    if (e is Asn1Encode) {
      return e;
    } else {
      return DerNull.value;
    }
  }

  /// internal method
  bool lessThanOrEqual(List<int> a, List<int> b) {
    final int len = min(a.length, b.length);
    for (int i = 0; i != len; ++i) {
      if (a[i] != b[i]) {
        return a[i] < b[i];
      }
    }
    return len == a.length;
  }

  /// internal method
  void addObject(Asn1Encode? obj) {
    objects.add(obj);
  }

  @override
  String toString() {
    return objects.toString();
  }

  @override
  void encode(DerStream derOut) {
    throw ArgumentError.value('Not Implemented');
  }

  /// internal method
  void sortObjects() {
    if (objects.length > 1) {
      bool swapped = true;
      int lastSwap = objects.length - 1;
      while (swapped) {
        int index = 0;
        int swapIndex = 0;
        List<int>? a = (objects[0] as Asn1Encode).getEncoded();
        swapped = false;
        while (index != lastSwap) {
          final List<int> b = (objects[index + 1] as Asn1Encode).getEncoded()!;
          if (lessThanOrEqual(a!, b)) {
            a = b;
          } else {
            final dynamic o = objects[index];
            objects[index] = objects[index + 1];
            objects[index + 1] = o;
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
  /// internal method
  static Asn1Set? getAsn1Set(dynamic obj, [bool? isExplicit]) {
    Asn1Set? result;
    if (isExplicit == null) {
      if (obj == null || obj is Asn1Set) {
        result = obj as Asn1Set?;
      } else if (obj is IAsn1SetHelper) {
        result = Asn1Set.getAsn1Set(obj.getAsn1());
      } else if (obj is List<int>) {
        result =
            Asn1Set.getAsn1Set(Asn1Stream(PdfStreamReader(obj)).readAsn1());
      } else if (obj is Asn1Encode) {
        final Asn1? asn1 = obj.getAsn1();
        if (asn1 != null && asn1 is Asn1Set) {
          result = asn1;
        }
      } else {
        throw ArgumentError.value(obj, 'obj', 'Invalid entry in sequence');
      }
    } else if (obj is Asn1Tag) {
      final Asn1? inner = obj.getObject();
      if (isExplicit) {
        if (!obj.explicit!) {
          throw ArgumentError.value(obj, 'obj', 'Tagged object is implicit.');
        }
        result = (inner is Asn1Set) ? inner : null;
      } else if (obj.explicit! && inner is Asn1Encode) {
        result = DerSet(array: <Asn1Encode?>[inner]);
      } else if (inner is Asn1Set) {
        result = inner;
      } else if (inner is Asn1Sequence) {
        final Asn1EncodeCollection collection = Asn1EncodeCollection();
        // ignore: avoid_function_literals_in_foreach_calls
        inner.objects!
            .toList()
            .forEach((dynamic entry) => collection.encodableObjects.add(entry));
        result = DerSet(collection: collection, isSort: false);
      } else {
        throw ArgumentError.value(obj, 'obj', 'Invalid entry in sequence');
      }
    }
    return result;
  }
}

/// internal class
class Asn1SetHelper implements IAsn1SetHelper {
  /// internal constructor
  Asn1SetHelper(Asn1Set outer) {
    _set = outer;
    _max = outer.objects.length;
  }
  Asn1Set? _set;
  int? _max;
  int? _index;
  @override
  IAsn1? readObject() {
    if (_index == _max) {
      return null;
    } else {
      final Asn1Encode? obj = _set![_index!];
      _index = _index! + 1;
      if (obj is Asn1Sequence) {
        return obj.parser;
      }
      if (obj is Asn1Set) {
        return obj.parser;
      }
      return obj;
    }
  }

  @override
  Asn1? getAsn1() {
    return _set;
  }
}

/// internal class
class Asn1Tag extends Asn1 implements IAsn1Tag {
  /// internal constructor
  Asn1Tag(int? tagNumber, this.object, [bool? isExplicit]) {
    explicit = isExplicit ?? true;
    _tagNumber = tagNumber;
  }
  //Fields
  int? _tagNumber;

  /// internal field
  bool? explicit;

  /// internal field
  Asn1Encode? object;
  //Properties
  @override
  int? get tagNumber {
    return _tagNumber;
  }

  //Static methods
  /// internal method
  static Asn1Tag? getTag(dynamic obj, [bool? isExplicit]) {
    if (isExplicit != null && obj is Asn1Tag) {
      if (isExplicit) {
        return obj.getObject() as Asn1Tag?;
      }
      throw ArgumentError.value(obj, 'obj', 'Explicit tag is not used');
    } else {
      if (obj == null || obj is Asn1Tag) {
        return obj as Asn1Tag?;
      }
      throw ArgumentError.value(obj, 'obj', 'Invalid entry in sequence');
    }
  }

  //Implementation
  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes, avoid_renaming_method_parameters
  bool operator ==(Object asn1) {
    if (asn1 is Asn1Tag) {
      return _tagNumber == asn1._tagNumber &&
          explicit == asn1.explicit &&
          getObject() == asn1.getObject();
    } else {
      return false;
    }
  }

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  int get hashCode {
    int code = _tagNumber.hashCode;
    if (object != null) {
      code ^= object.hashCode;
    }
    return code;
  }

  @override
  String toString() {
    return '[$_tagNumber]$object';
  }

  @override
  // ignore: avoid_renaming_method_parameters
  void encode(DerStream stream) {
    throw ArgumentError.value(stream, 'stream', 'Not Implemented');
  }

  /// internal method
  Asn1? getObject() {
    if (object != null) {
      return object!.getAsn1();
    }
    return null;
  }

  @override
  IAsn1? getParser(int tagNumber, bool isExplicit) {
    switch (tagNumber) {
      case Asn1Tags.setTag:
        return Asn1Set.getAsn1Set(this, isExplicit)!.parser;
      case Asn1Tags.sequence:
        return Asn1Sequence.getSequence(this, isExplicit)!.parser;
      case Asn1Tags.octetString:
        return Asn1Octet.getOctetString(this, isExplicit)!.parser;
    }
    if (isExplicit) {
      return getObject();
    }
    throw ArgumentError.value(
        tagNumber, 'tagNumber', 'Implicit tagging is not supported');
  }
}

/// internal class
class Asn1DerStream extends DerStream {
  /// internal constructor
  Asn1DerStream([List<int>? stream]) {
    if (stream != null) {
      this.stream = stream;
    } else {
      this.stream = <int>[];
    }
  }
}

/// internal class
class Asn1Integer extends Asn1 {
  /// internal constructor
  Asn1Integer(this._value)
      : super(<_Asn1UniversalTags>[_Asn1UniversalTags.integer]);

  /// internal field
  late final int _value;

  /// internal property
  List<int> _toArray() {
    return _value < 255 ? <int>[_value] : _getBytesFromLong(_value);
  }

  /// internal method
  List<int>? asnEncode() {
    return super.asn1Encode(_toArray());
  }

  @override
  void encode(DerStream derOut) {
    derOut.writeEncoded(
        getTagValue(<_Asn1UniversalTags>[_Asn1UniversalTags.integer]), null);
  }

  List<int> _getBytesFromLong(int value) {
    final List<int> bytes = <int>[];
    for (int i = 0; i < 8; i++) {
      bytes.add((value >> (i * 8)) & 0xFF);
    }
    return bytes;
  }
}

/// internal class
class Asn1Boolean extends Asn1 {
  /// internal constructor
  Asn1Boolean(this._value)
      : super(<_Asn1UniversalTags>[_Asn1UniversalTags.boolean]);

  /// internal field
  late final bool _value;

  /// internal method
  List<int> _toArray() {
    return _value ? <int>[0xff] : <int>[0];
  }

  /// internal method
  List<int>? asnEncode() {
    return super.asn1Encode(_toArray());
  }

  @override
  void encode(DerStream derOut) {
    derOut.writeEncoded(
        getTagValue(<_Asn1UniversalTags>[_Asn1UniversalTags.boolean]),
        _toArray());
  }
}

/// internal class
class Asn1Identifier extends Asn1 {
  /// internal constructor
  Asn1Identifier(this._id)
      : super(<_Asn1UniversalTags>[_Asn1UniversalTags.objectIdentifier]);

  /// internal field
  late final String _id;

  /// internal method
  List<int> _toArray() {
    final List<String> parts = _id.split('.');
    final int firstPart = int.parse(parts[0]);
    final int secondPart = int.parse(parts[1]);
    final List<int> bytes = <int>[];
    _appendField(firstPart * 40 + secondPart, bytes);
    for (int i = 2; i < parts.length; i++) {
      final String part = parts[i];
      if (part.length < 18) {
        _appendField(int.parse(part), bytes);
      } else {
        _appendFieldFromString(part, bytes);
      }
    }
    return bytes;
  }

  void _appendField(int value, List<int> bytes) {
    if (value >= (1 << 7)) {
      if (value >= (1 << 14)) {
        if (value >= (1 << 21)) {
          if (value >= (1 << 28)) {
            if (value >= (1 << 35)) {
              if (value >= (1 << 42)) {
                if (value >= (1 << 49)) {
                  if (value >= (1 << 56)) {
                    bytes.add(((value >> 56) | 0x80).toUnsigned(8));
                  }
                  bytes.add(((value >> 49) | 0x80).toUnsigned(8));
                }
                bytes.add(((value >> 42) | 0x80).toUnsigned(8));
              }
              bytes.add(((value >> 35) | 0x80).toUnsigned(8));
            }
            bytes.add(((value >> 28) | 0x80).toUnsigned(8));
          }
          bytes.add(((value >> 21) | 0x80).toUnsigned(8));
        }
        bytes.add(((value >> 14) | 0x80).toUnsigned(8));
      }
      bytes.add(((value >> 7) | 0x80).toUnsigned(8));
    }
    bytes.add((value & 0x7f).toUnsigned(8));
  }

  void _appendFieldFromString(String value, List<int> bytes) {
    int byteCount;
    byteCount = ((utf8.encode(value).length) + 6) ~/ 7;
    if (byteCount == 0) {
      bytes.add(0);
    } else {
      int tmpValue = int.parse(value);
      final List<int> tmp = List<int>.filled(byteCount, 0);
      for (int i = byteCount - 1; i >= 0; i--) {
        tmp[i] = (tmpValue & 0x7F) | 0x80;
        tmpValue = tmpValue >> 7;
      }
      tmp[byteCount - 1] &= 0x7F;
      bytes.addAll(tmp);
    }
  }

  /// internal method
  List<int>? asnEncode() {
    return super.asn1Encode(_toArray());
  }

  @override
  void encode(DerStream derOut) {
    derOut.writeEncoded(
        getTagValue(<_Asn1UniversalTags>[_Asn1UniversalTags.objectIdentifier]),
        _toArray());
  }
}

/// internal class
class GeneralizedTime extends Asn1 {
  /// internal constructor
  GeneralizedTime(List<int> bytes) {
    time = utf8.decode(bytes);
  }
  //Fields
  /// internal field
  late String time;
  //Implementation
  /// internal method
  DateTime? toDateTime() {
    return DateTime.tryParse(time);
  }

  @override
  // ignore: avoid_renaming_method_parameters
  void encode(DerStream stream) {
    stream.writeEncoded(Asn1Tags.generalizedTime, utf8.encode(time));
  }

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes, avoid_renaming_method_parameters
  bool operator ==(Object asn1Object) {
    throw ArgumentError.value('Not implemented');
  }

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  int get hashCode {
    return time.hashCode;
  }
}

/// internal class
class Asn1Tags {
  /// internal field
  static const int boolean = 0x01;

  /// internal field
  static const int integer = 0x02;

  /// internal field
  static const int bitString = 0x03;

  /// internal field
  static const int octetString = 0x04;

  /// internal field
  static const int nullValue = 0x05;

  /// internal field
  static const int objectIdentifier = 0x06;

  /// internal field
  static const int enumerated = 0x0a;

  /// internal field
  static const int sequence = 0x10;

  /// internal field
  static const int setTag = 0x11;

  /// internal field
  static const int printableString = 0x13;

  /// internal field
  static const int teleText = 0x14;

  /// internal field
  static const int asciiString = 0x16;

  /// internal field
  static const int utcTime = 0x17;

  /// internal field
  static const int generalizedTime = 0x18;

  /// internal field
  static const int bmpString = 0x1e;

  /// internal field
  static const int utf8String = 0x0c;

  /// internal field
  static const int constructed = 0x20;

  /// internal field
  static const int tagged = 0x80;
}

enum _Asn1UniversalTags {
  reservedBER,
  boolean,
  integer,
  bitString,
  octetString,
  nullValue,
  objectIdentifier,
  objectDescriptor,
  externalValue,
  real,
  enumerated,
  embeddedPDV,
  utf8String,
  relativeOid,
  sequence,
  setValue,
  numericString,
  printableString,
  teletexString,
  videotexString,
  ia5String,
  utfTime,
  generalizedTime,
  graphicsString,
  visibleString,
  generalString,
  universalString,
  characterString,
  bmpString,
  constructed,
  application,
  tagged
}
