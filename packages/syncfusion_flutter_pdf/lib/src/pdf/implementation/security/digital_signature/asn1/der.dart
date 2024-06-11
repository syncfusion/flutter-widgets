import 'dart:convert';

import '../../../io/stream_reader.dart';
import '../cryptography/signature_utilities.dart';
import 'asn1.dart';
import 'asn1_parser.dart';
import 'asn1_stream.dart';

/// internal class
class IAsn1String {
  /// internal method
  String? getString([List<int>? bytes]) => null;
}

/// internal class
class IAsn1SetHelper implements IAsn1 {
  /// internal method
  IAsn1? readObject() => null;
  @override
  Asn1? getAsn1() => null;
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

/// internal class
abstract class DerString extends Asn1 implements IAsn1String {
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
    if (other is DerString) {
      return getString() == other.getString();
    } else {
      return false;
    }
  }
}

/// internal class
class DerAsciiString extends DerString {
  //Constructor
  /// internal constructor
  DerAsciiString(String value, bool isValid) {
    if (isValid && !isAsciiString(value)) {
      throw ArgumentError.value(value, 'value', 'Invalid characters found');
    }
    _value = value;
  }

  /// internal constructor
  DerAsciiString.fromBytes(List<int> bytes) {
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
  // ignore: avoid_renaming_method_parameters
  void encode(DerStream stream) {
    stream.writeEncoded(Asn1Tags.asciiString, getOctets());
  }

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  int get hashCode {
    return _value.hashCode;
  }

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes, avoid_renaming_method_parameters
  bool operator ==(Object asn1) {
    if (asn1 is DerAsciiString) {
      return _value == asn1._value;
    } else {
      return false;
    }
  }

  /// internal method
  List<int>? asnEncode() {
    return super.asn1Encode(getOctets());
  }

  /// internal method
  List<int> getOctets() {
    return utf8.encode(_value!);
  }

  //Static methods
  /// internal method
  static bool isAsciiString(String value) {
    for (int i = 0; i < value.length; i++) {
      if (value.codeUnitAt(i) > 0x007f) {
        return false;
      }
    }
    return true;
  }

  /// internal method
  static DerAsciiString? getAsciiStringFromObj(dynamic obj) {
    if (obj == null || obj is DerAsciiString) {
      return obj;
    }
    throw Exception('Invalid entry');
  }

  /// internal method
  static DerAsciiString? getAsciiString(Asn1Tag tag, bool isExplicit) {
    final Asn1? asn1 = tag.getObject();
    if (asn1 != null) {
      if (isExplicit || asn1 is DerAsciiString) {
        return getAsciiStringFromObj(asn1);
      }
    }
    if (asn1 is Asn1Octet) {
      return DerAsciiString.fromBytes(asn1.getOctets()!);
    }
    return null;
  }
}

/// internal class
class DerBitString extends DerString {
  /// internal constructor
  DerBitString(this.data, int? pad) {
    extra = pad ?? 0;
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

  /// internal constructor
  DerBitString.fromAsn1(Asn1Encode asn1) {
    data = asn1.getDerEncoded();
  }

  //Fields
  /// internal field
  List<int>? data;

  /// internal field
  int? extra;
  late List<String> _table;

  //Implementation
  /// internal method
  List<int>? getBytes() {
    return data;
  }

  @override
  // ignore: avoid_renaming_method_parameters
  void encode(DerStream stream) {
    final List<int> bytes =
        List<int>.generate(getBytes()!.length + 1, (int i) => 0);
    bytes[0] = extra!;
    List.copyRange(bytes, 1, getBytes()!, 0, bytes.length - 1);
    stream.writeEncoded(Asn1Tags.bitString, bytes);
  }

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  int get hashCode {
    return extra.hashCode ^ Asn1.getHashCode(data);
  }

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes, avoid_renaming_method_parameters
  bool operator ==(Object asn1) {
    if (asn1 is DerBitString) {
      return extra == asn1.extra && Asn1.areEqual(data, asn1.data);
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
  /// internal method
  static DerBitString fromAsn1Octets(List<int> bytes) {
    final int pad = bytes[0];
    final List<int> data = List<int>.generate(bytes.length - 1, (int i) => 0);
    List.copyRange(data, 0, bytes, 1, data.length + 1);
    return DerBitString(data, pad);
  }

  /// internal method
  static DerBitString? getDetBitString(dynamic obj) {
    if (obj == null) {
      return null;
    } else if (obj is DerBitString) {
      return obj;
    }
    throw ArgumentError.value(obj, 'object', 'Invalid Entry');
  }

  /// internal method
  static DerBitString? getDerBitStringFromTag(Asn1Tag tag, bool isExplicit) {
    final Asn1? asn1 = tag.getObject();
    if (isExplicit || asn1 is DerBitString) {
      return getDetBitString(asn1);
    }
    return fromAsn1Octets((asn1! as Asn1Octet).getOctets()!);
  }
}

/// internal class
class DerBmpString extends DerString {
  /// internal constructor
  DerBmpString(List<int> bytes) {
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
  // ignore: avoid_equals_and_hash_code_on_mutable_classes, avoid_renaming_method_parameters
  bool operator ==(Object asn1) {
    if (asn1 is DerBmpString) {
      return _value == asn1._value;
    } else {
      return false;
    }
  }

  @override
  // ignore: avoid_renaming_method_parameters
  void encode(DerStream stream) {
    final List<int> bytes =
        List<int>.generate(_value!.length * 2, (int i) => 0);
    for (int i = 0; i != _value!.length; i++) {
      bytes[2 * i] = (_value!.codeUnitAt(i) >> 8).toUnsigned(8);
      bytes[2 * i + 1] = _value!.codeUnitAt(i).toUnsigned(8);
    }
    stream.writeEncoded(Asn1Tags.bmpString, bytes);
  }
}

/// internal class
class DerPrintableString extends DerString {
  /// internal constructor
  DerPrintableString(String value) {
    _value = value;
  }
  //Fields
  String? _value;
  //Implementation
  @override
  String? getString([List<int>? bytes]) {
    return _value;
  }

  /// internal method
  List<int> getBytes() {
    return utf8.encode(_value!);
  }

  /// internal method
  @override
  void encode(DerStream stream) {
    stream.writeEncoded(Asn1Tags.printableString, getBytes());
  }

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes, avoid_renaming_method_parameters
  bool operator ==(Object asn1) {
    if (asn1 is DerPrintableString) {
      return _value == asn1._value;
    } else {
      return false;
    }
  }

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  int get hashCode => _value.hashCode;
}

/// internal class
class DerBoolean extends Asn1 {
  /// internal constructor
  DerBoolean(bool value) {
    _value = value ? 0xff : 0;
  }

  /// internal constructor
  DerBoolean.fromBytes(List<int> bytes) {
    if (bytes.length != 1) {
      throw ArgumentError.value(bytes, 'bytes', 'Invalid length in bytes');
    }
    _value = bytes[0];
  }
  //Fields
  late int _value;

  //Properties
  /// internal property
  bool get isTrue => _value != 0;

  //Implementation
  @override
  // ignore: avoid_renaming_method_parameters
  void encode(DerStream stream) {
    stream.writeEncoded(Asn1Tags.boolean, <int>[_value]);
  }

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes, avoid_renaming_method_parameters
  bool operator ==(Object asn1) {
    if (asn1 is DerBoolean) {
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

/// internal class
class DerInteger extends Asn1 {
  /// internal constructor
  DerInteger(this.intValue);

  /// internal constructor
  DerInteger.fromNumber(BigInt? value) {
    if (value == null) {
      throw ArgumentError.value(value, 'value', 'Invalid value');
    }
    intValue = bigIntToBytes(value);
  }
  //Fields
  /// internal field
  List<int>? intValue;

  //Properties
  /// internal property
  BigInt get value => bigIntFromBytes(intValue);

  /// internal property
  BigInt get positiveValue => bigIntFromBytes(intValue, 1);

  //Implementation
  @override
  // ignore: avoid_renaming_method_parameters
  void encode(DerStream stream) {
    stream.writeEncoded(Asn1Tags.integer, intValue);
  }

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  int get hashCode {
    return Asn1.getHashCode(intValue);
  }

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes, avoid_renaming_method_parameters
  bool operator ==(Object asn1) {
    if (asn1 is DerInteger) {
      return Asn1.areEqual(intValue, asn1.intValue);
    } else {
      return false;
    }
  }

  @override
  String toString() {
    return value.toString();
  }

  //Static methods
  /// internal method
  static DerInteger? getNumber(dynamic obj) {
    if (obj == null || obj is DerInteger) {
      return obj as DerInteger?;
    }
    throw ArgumentError.value(obj, 'obj', 'Invalid entry');
  }

  /// internal method
  static DerInteger? getNumberFromTag(Asn1Tag tag, bool isExplicit) {
    final Asn1? asn1 = tag.getObject();
    if (isExplicit || asn1 is DerInteger) {
      return getNumber(asn1);
    }
    return DerInteger(Asn1Octet.getOctetStringFromObject(asn1)!.getOctets());
  }
}

/// internal class
class DerNull extends Asn1Null {
  /// internal constructor
  DerNull() : super() {
    bytes = <int>[];
  }
  //Fields
  /// internal field
  static DerNull value = DerNull();
  //Implementation
  @override
  // ignore: avoid_renaming_method_parameters
  void encode(DerStream stream) {
    stream.writeEncoded(Asn1Tags.nullValue, bytes);
  }

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes, avoid_renaming_method_parameters
  bool operator ==(Object asn1) {
    return asn1 is DerNull;
  }

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  int get hashCode {
    return -1;
  }
}

/// internal class
class DerObjectID extends Asn1 {
  //Contructors
  /// internal constructor
  DerObjectID(this.id) {
    if (!isValidIdentifier(id!)) {
      throw ArgumentError.value(id, 'id', 'Invalid ID');
    }
  }

  /// internal constructor
  DerObjectID.fromBytes(List<int> bytes) {
    id = getObjectID(bytes);
    bytes = Asn1.clone(bytes);
  }

  /// internal constructor
  DerObjectID.fromBranch(DerObjectID id, String branchId) {
    if (!isValidBranchID(branchId, 0)) {
      throw ArgumentError.value(id, 'id', 'Invalid ID');
    }
    this.id = '${id.id!}.$branchId';
  }

  /// internal field
  String? id;

  // ignore: prefer_final_fields
  static List<DerObjectID?> _objects =
      List<DerObjectID?>.generate(1024, (int i) => null);
  //Implemnetation
  /// internal method
  List<int>? getBytes() {
    bytes ??= getOutput();
    return bytes;
  }

  /// internal method
  List<int> getOutput() {
    List<int> stream = <int>[];
    final _ObjectIdentityToken oidToken = _ObjectIdentityToken(id);
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

  /// internal method
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
  // ignore: avoid_renaming_method_parameters
  void encode(DerStream stream) {
    stream.writeEncoded(Asn1Tags.objectIdentifier, getBytes());
  }

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  int get hashCode {
    return id.hashCode;
  }

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes, avoid_renaming_method_parameters
  bool operator ==(Object asn1) {
    if (asn1 is DerObjectID) {
      return id == asn1.id;
    } else {
      return false;
    }
  }

  @override
  String toString() {
    return id!;
  }

  //Static methods
  /// internal method
  static DerObjectID? getID(dynamic obj) {
    if (obj == null || obj is DerObjectID) {
      return obj as DerObjectID?;
    } else if (obj is List<int>) {
      return fromOctetString(obj);
    }
    throw ArgumentError.value(obj, 'obj', 'Illegal object');
  }

  /// internal method
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

  /// internal method
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

  /// internal method
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

  /// internal method
  static DerObjectID? fromOctetString(List<int> bytes) {
    final int hashCode = Asn1.getHashCode(bytes);
    final int first = hashCode & 1023;
    final DerObjectID? entry = _objects[first];
    if (entry != null && Asn1.areEqual(bytes, entry.getBytes())) {
      return entry;
    }
    _objects[first] = DerObjectID.fromBytes(bytes);
    return _objects[first];
  }

  /// internal method
  DerObjectID branch(String id) {
    return DerObjectID.fromBranch(this, id);
  }
}

/// internal class
class DerOctet extends Asn1Octet {
  /// internal constructor
  DerOctet(List<int> super.bytes);

  /// internal constructor
  DerOctet.fromObject(super.asn1) : super.fromObject();
  @override
  void encode(DerStream stream) {
    stream.writeEncoded(Asn1Tags.octetString, value);
  }
}

/// internal class
class DerSequence extends Asn1Sequence {
  /// internal constructor
  DerSequence({List<Asn1Encode?>? array, Asn1EncodeCollection? collection})
      : super() {
    if (array != null) {
      // ignore: prefer_foreach
      for (final Asn1Encode? entry in array) {
        objects!.add(entry);
      }
    } else if (collection != null) {
      for (int i = 0; i < collection.count; i++) {
        objects!.add(collection[i]);
      }
    }
  }

  /// internal constructor
  DerSequence.fromObject(Asn1Encode? encode) : super() {
    objects!.add(encode);
  }

  /// internal constructor
  static DerSequence fromCollection(Asn1EncodeCollection collection) {
    return collection.count < 1 ? empty : DerSequence(collection: collection);
  }

  /// internal constructor
  static DerSequence empty = DerSequence();
  @override
  // ignore: avoid_renaming_method_parameters
  void encode(DerStream outputStream) {
    final DerStream stream = DerStream(<int>[]);
    // ignore: avoid_function_literals_in_foreach_calls
    objects!.forEach((dynamic asn1) => stream.writeObject(asn1));
    outputStream.writeEncoded(
        Asn1Tags.sequence | Asn1Tags.constructed, stream.stream);
  }
}

/// internal class
class DerSequenceHelper implements IAsn1Collection {
  /// internal constructor
  DerSequenceHelper(Asn1Parser helper) {
    _helper = helper;
  }
  //Fields
  late Asn1Parser _helper;
  //Implementation
  @override
  IAsn1? readObject() {
    return _helper.readObject();
  }

  @override
  Asn1 getAsn1() {
    return DerSequence(collection: _helper.readCollection());
  }
}

/// internal class
class DerSet extends Asn1Set {
  //Constructor
  /// internal constructor
  DerSet(
      {List<Asn1Encode?>? array,
      Asn1EncodeCollection? collection,
      bool? isSort})
      : super() {
    if (array != null) {
      // ignore: avoid_function_literals_in_foreach_calls
      array.forEach((Asn1Encode? asn1) => addObject(asn1));
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
  // ignore: avoid_renaming_method_parameters
  void encode(DerStream outputStream) {
    final DerStream stream = DerStream(<int>[]);
    // ignore: avoid_function_literals_in_foreach_calls
    objects.forEach((dynamic entry) => stream.writeObject(entry));
    outputStream.writeEncoded(
        Asn1Tags.setTag | Asn1Tags.constructed, stream.stream);
  }
}

/// internal class
class DerSetHelper implements IAsn1SetHelper {
  /// internal constructor
  DerSetHelper(Asn1Parser helper) {
    _helper = helper;
  }
  //Fields
  late Asn1Parser _helper;
  //Implementation
  @override
  IAsn1? readObject() {
    return _helper.readObject();
  }

  @override
  Asn1 getAsn1() {
    return DerSet(collection: _helper.readCollection(), isSort: false);
  }
}

/// internal class
class DerStream {
  /// internal constructor
  DerStream([List<int>? stream]) {
    if (stream != null) {
      this.stream = stream;
    }
  }

  /// internal field
  List<int>? stream;
  //Implementation
  /// internal method
  void writeLength(int length) {
    if (length > 127) {
      int size = 1;
      int value = length.toUnsigned(32);
      while ((value >>= 8) != 0) {
        size++;
      }
      stream!.add((size | 0x80).toUnsigned(8));
      for (int i = (size - 1) * 8; i >= 0; i -= 8) {
        stream!.add((length >> i).toUnsigned(8));
      }
    } else {
      stream!.add(length.toUnsigned(8));
    }
  }

  /// internal method
  void writeEncoded(int? tagNumber, List<int>? bytes, [int? flag]) {
    if (flag != null) {
      writeTag(flag, tagNumber!);
      writeLength(bytes!.length);
      stream!.addAll(bytes);
    } else {
      stream!.add(tagNumber!.toUnsigned(8));
      writeLength(bytes!.length);
      stream!.addAll(bytes);
    }
  }

  /// internal method
  void writeTag(int flag, int tagNumber) {
    if (tagNumber < 31) {
      stream!.add((flag | tagNumber).toUnsigned(8));
    } else {
      stream!.add((flag | 0x1f).toUnsigned(8));
      if (tagNumber < 128) {
        stream!.add(tagNumber.toUnsigned(8));
      } else {
        final List<int> bytes = <int>[];
        bytes.add((tagNumber & 0x7F).toUnsigned(8));
        do {
          tagNumber >>= 7;
          bytes.add((tagNumber & 0x7F | 0x80).toUnsigned(8));
        } while (tagNumber > 127 && bytes.length <= 5);
        stream!.addAll(bytes.reversed.toList());
      }
    }
  }

  /// internal method
  void writeObject(dynamic obj) {
    if (obj == null) {
      stream!.add(Asn1Tags.nullValue);
      stream!.add(0x00);
    } else if (obj is Asn1) {
      obj.encode(this);
    } else if (obj is Asn1Encode) {
      obj.getAsn1()!.encode(this);
    } else {
      throw ArgumentError.value(obj, 'obj', 'Invalid object specified');
    }
  }
}

/// internal class
class DerTag extends Asn1Tag {
  /// internal constructor
  DerTag(super.tagNumber, super.asn1, [bool? isExplicit]) {
    if (isExplicit != null) {
      explicit = isExplicit;
    }
  }
  //Implementation
  @override
  void encode(DerStream stream) {
    final List<int>? bytes = object!.getDerEncoded();
    if (explicit!) {
      stream.writeEncoded(
          tagNumber, bytes, Asn1Tags.constructed | Asn1Tags.tagged);
    } else {
      final int flag = (bytes![0] & Asn1Tags.constructed) | Asn1Tags.tagged;
      stream.writeTag(flag, tagNumber!);
      stream.stream!.addAll(bytes.sublist(1));
    }
  }
}

/// internal class
class DerUtcTime extends Asn1 {
  /// internal constructor
  DerUtcTime(List<int> bytes) {
    _time = utf8.decode(bytes);
  }
  //Fields
  String? _time;
  //Properties
  /// internal property
  DateTime? get toAdjustedDateTime {
    return DateTime.tryParse(adjustedTimeString);
  }

  /// internal property
  String get adjustedTimeString {
    String timeString = _time!;
    final String c = timeString.codeUnitAt(0) < '5'.codeUnitAt(0) ? '20' : '19';
    timeString = c + timeString;
    return '${timeString.substring(0, 8)}T${timeString.substring(8)}';
  }

  //Implementation
  @override
  // ignore: avoid_renaming_method_parameters
  void encode(DerStream stream) {
    stream.writeEncoded(Asn1Tags.utcTime, utf8.encode(_time!));
  }

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes, avoid_renaming_method_parameters
  bool operator ==(Object asn1) {
    if (asn1 is DerUtcTime) {
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

/// internal class
class DerCatalogue extends Asn1 {
  /// internal constructor
  DerCatalogue([List<int>? bytes]) {
    this.bytes = bytes;
  }

  //Implemnetation
  @override
  // ignore: avoid_renaming_method_parameters
  void encode(DerStream stream) {
    stream.writeEncoded(Asn1Tags.enumerated, bytes);
  }

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes, avoid_renaming_method_parameters
  bool operator ==(Object asn1) {
    if (asn1 is DerCatalogue) {
      return Asn1.areEqual(bytes, asn1.bytes);
    } else {
      return false;
    }
  }

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  int get hashCode {
    return Asn1.getHashCode(bytes);
  }
}

/// internal class
class DerOctetHelper implements IAsn1Octet {
  /// internal constructor
  DerOctetHelper(Asn1StreamHelper? stream) {
    _stream = stream;
  }
  //Fields
  Asn1StreamHelper? _stream;
  //Implementation
  @override
  PdfStreamReader? getOctetStream() {
    return _stream;
  }

  @override
  Asn1 getAsn1() {
    return DerOctet(_stream!.toArray());
  }
}

/// internal class
class DerUtf8String extends DerString {
  /// internal constructor
  DerUtf8String(String value) {
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
  // ignore: avoid_renaming_method_parameters
  void encode(DerStream stream) {
    stream.writeEncoded(Asn1Tags.utf8String, utf8.encode(_value!));
  }

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes, avoid_renaming_method_parameters
  bool operator ==(Object asn1) {
    if (asn1 is DerUtf8String) {
      return _value == asn1._value;
    } else {
      return false;
    }
  }

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  int get hashCode => _value.hashCode;
}

/// internal class
class DerTeleText extends DerString {
  /// internal constructor
  DerTeleText(String value) {
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
  // ignore: avoid_renaming_method_parameters
  void encode(DerStream stream) {
    stream.writeEncoded(Asn1Tags.teleText, toByteArray(_value!));
  }

  /// internal method
  List<int> toByteArray(String value) {
    final List<int> result = <int>[];
    // ignore: avoid_function_literals_in_foreach_calls
    value.codeUnits.forEach((int entry) => result.add(entry.toUnsigned(8)));
    return result;
  }

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes, avoid_renaming_method_parameters
  bool operator ==(Object asn1) {
    if (asn1 is DerTeleText) {
      return _value == asn1._value;
    } else {
      return false;
    }
  }

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  int get hashCode => _value.hashCode;
}
