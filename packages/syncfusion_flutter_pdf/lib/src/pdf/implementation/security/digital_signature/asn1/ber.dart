import 'dart:math';

import '../../../io/stream_reader.dart';
import 'asn1.dart';
import 'asn1_parser.dart';
import 'der.dart';

/// internal class
class BerOctet extends DerOctet {
  /// internal constructor
  BerOctet(super.bytes);

  /// internal constructor
  BerOctet.fromCollection(List<Asn1Encode> octets)
      : super(BerOctet.getBytes(octets)) {
    _octets = octets;
  }

  //Fields
  late dynamic _octets;

  //Implementation
  @override
  List<int>? getOctets() {
    return value;
  }

  /// internal method
  List<DerOctet> generateOctets() {
    final List<DerOctet> collection = <DerOctet>[];
    for (int i = 0; i < value!.length; i += 1000) {
      final int endIndex = min(value!.length, i + 1000);
      collection.add(DerOctet(List<int>.generate(
          endIndex - i,
          (int index) =>
              ((i + index) < value!.length) ? value![i + index] : 0)));
    }
    return collection;
  }

  @override
  void encode(DerStream stream) {
    if (stream is Asn1DerStream) {
      stream.stream!.add(Asn1Tags.constructed | Asn1Tags.octetString);
      stream.stream!.add(0x80);
      _octets.forEach((dynamic octet) {
        stream.writeObject(octet);
      });
      stream.stream!.add(0x00);
      stream.stream!.add(0x00);
    } else {
      super.encode(stream);
    }
  }

  /// internal method
  static BerOctet getBerOctet(Asn1Sequence sequence) {
    final List<Asn1Encode> collection = <Asn1Encode>[];
    for (int i = 0; i < sequence.objects!.length; i++) {
      final dynamic entry = sequence.objects![i];
      if (entry != null && entry is Asn1Encode) {
        collection.add(entry);
      }
    }
    return BerOctet.fromCollection(collection);
  }

  /// internal method
  static List<int> getBytes(List<Asn1Encode> octets) {
    final List<int> result = <int>[];
    if (octets.isNotEmpty) {
      for (final dynamic o in octets) {
        if (o is DerOctet) {
          result.addAll(o.getOctets()!);
        }
      }
    }
    return result;
  }
}

/// [BerOctet] helper
class BerOctetHelper implements IAsn1Octet {
  /// internal constructor
  BerOctetHelper(Asn1Parser helper) {
    _helper = helper;
  }
  //Fields
  Asn1Parser? _helper;
  @override
  PdfStreamReader getOctetStream() {
    return _OctetStream(_helper);
  }

  @override
  Asn1 getAsn1() {
    return BerOctet(readAll(getOctetStream()));
  }

  /// internal method
  List<int> readAll(PdfStreamReader stream) {
    final List<int> output = <int>[];
    final List<int> bytes = List<int>.generate(512, (int i) => 0);
    int? index;
    while ((index = stream.read(bytes, 0, bytes.length))! > 0) {
      output.addAll(bytes.sublist(0, index));
    }
    return output;
  }

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  int get hashCode => _helper.hashCode;

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  bool operator ==(Object other) {
    if (other is BerOctetHelper) {
      return other._helper == _helper;
    } else {
      return false;
    }
  }
}

/// [BerTag] helper
class BerTagHelper implements IAsn1Tag {
  /// internal constructor
  BerTagHelper(bool isConstructed, int tagNumber, Asn1Parser helper) {
    _isConstructed = isConstructed;
    _tagNumber = tagNumber;
    _helper = helper;
  }
  //Fields
  bool? _isConstructed;
  int? _tagNumber;
  late Asn1Parser _helper;
  //Properties
  @override
  int? get tagNumber => _tagNumber;
  //Implements
  @override
  IAsn1? getParser(int tagNumber, bool isExplicit) {
    if (isExplicit) {
      if (!_isConstructed!) {
        throw ArgumentError.value(
            isExplicit, 'isExplicit', 'Implicit tags identified');
      }
      return _helper.readObject();
    }
    return _helper.readImplicit(_isConstructed, tagNumber);
  }

  @override
  Asn1 getAsn1() {
    return _helper.readTaggedObject(_isConstructed!, _tagNumber);
  }
}

/// internal class
class BerSequence extends DerSequence {
  /// internal constructor
  BerSequence({List<Asn1Encode>? super.array, super.collection});

  /// internal constructor
  BerSequence.fromObject(super.object) : super.fromObject();

  /// internal constructor
  static BerSequence empty = BerSequence();

  /// internal constructor
  static BerSequence fromCollection(Asn1EncodeCollection collection) {
    return collection.count < 1 ? empty : BerSequence(collection: collection);
  }

  /// internal method
  @override
  void encode(DerStream stream) {
    if (stream is Asn1DerStream) {
      stream.stream!.add(Asn1Tags.sequence | Asn1Tags.constructed);
      stream.stream!.add(0x80);
      // ignore: avoid_function_literals_in_foreach_calls
      objects!.forEach((dynamic entry) {
        if (entry is Asn1Encode) {
          stream.writeObject(entry);
        }
      });
      stream.stream!.add(0x00);
      stream.stream!.add(0x00);
    } else {
      super.encode(stream);
    }
  }
}

/// internal class
class BerSequenceHelper implements IAsn1Collection {
  /// internal constructor
  BerSequenceHelper(Asn1Parser helper) {
    _helper = helper;
  }
  late Asn1Parser _helper;

  @override
  IAsn1? readObject() {
    return _helper.readObject();
  }

  @override
  Asn1 getAsn1() {
    return BerSequence.fromCollection(_helper.readCollection());
  }
}

class _OctetStream extends PdfStreamReader {
  _OctetStream(Asn1Parser? helper) : super(<int>[]) {
    _helper = helper;
    _first = true;
  }
  Asn1Parser? _helper;
  PdfStreamReader? _stream;
  late bool _first;
  //Implementation
  @override
  int? read(List<int> buffer, int offset, int count) {
    if (_stream == null) {
      if (!_first) {
        return 0;
      }
      final IAsn1? octet = _helper!.readObject();
      if (octet != null && octet is IAsn1Octet) {
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
        final IAsn1? octet = _helper!.readObject();
        if (octet != null && octet is IAsn1Octet) {
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
      final IAsn1? octet = _helper!.readObject();
      if (octet != null && octet is IAsn1Octet) {
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
        final IAsn1? octet = _helper!.readObject();
        if (octet != null && octet is IAsn1Octet) {
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
