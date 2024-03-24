import 'dart:convert';
import 'dart:math';

import '../../../io/stream_reader.dart';
import 'asn1.dart';
import 'asn1_parser.dart';
import 'ber.dart';
import 'der.dart';

/// internal class
class Asn1Stream {
  /// internal constructor
  Asn1Stream(PdfStreamReader stream, [int? limit]) {
    _stream = stream;
    _limit = limit ?? getLimit(stream);
    _buffers = List<List<int>>.generate(16, (int i) => <int>[]);
  }
  int? _limit;
  List<List<int>>? _buffers;
  PdfStreamReader? _stream;

  /// internal method
  static int? getLimit(PdfStreamReader input) {
    if (input is Asn1BaseStream) {
      return input.remaining;
    } else {
      return input.length! - input.position;
    }
  }

  /// internal method
  static Asn1? getPrimitiveObject(
      int tagNumber, Asn1StreamHelper stream, List<List<int>>? buffers) {
    switch (tagNumber) {
      case Asn1Tags.boolean:
        return DerBoolean.fromBytes(getBytes(stream, buffers!));
      case Asn1Tags.enumerated:
        return DerCatalogue(getBytes(stream, buffers!));
      case Asn1Tags.objectIdentifier:
        return DerObjectID.fromOctetString(getBytes(stream, buffers!));
    }
    final List<int> bytes = stream.toArray();
    switch (tagNumber) {
      case Asn1Tags.bitString:
        return DerBitString.fromAsn1Octets(bytes);
      case Asn1Tags.bmpString:
        return DerBmpString(bytes);
      case Asn1Tags.generalizedTime:
        return GeneralizedTime(bytes);
      case Asn1Tags.asciiString:
        return DerAsciiString.fromBytes(bytes);
      case Asn1Tags.integer:
        return DerInteger(bytes);
      case Asn1Tags.nullValue:
        return DerNull.value;
      case Asn1Tags.octetString:
        return DerOctet(bytes);
      case Asn1Tags.printableString:
        return DerPrintableString(utf8.decode(bytes));
      case Asn1Tags.teleText:
        return DerTeleText(String.fromCharCodes(bytes));
      case Asn1Tags.utcTime:
        return DerUtcTime(bytes);
      case Asn1Tags.utf8String:
        return DerUtf8String(utf8.decode(bytes));
    }
    return null;
  }

  /// internal method
  static List<int> getBytes(Asn1StreamHelper stream, List<List<int>> buffers) {
    final int length = stream.remaining;
    if (length >= buffers.length) {
      stream.toArray();
    }
    List<int> bytes = buffers[length];
    if (bytes.isEmpty) {
      bytes = buffers[length] = List<int>.generate(length, (int i) => 0);
    }
    stream.readAll(bytes);
    return bytes;
  }

  /// internal method
  static int readTagNumber(PdfStreamReader? stream, int tagNumber) {
    int result = tagNumber & 0x1f;
    if (result == 0x1f) {
      result = 0;
      int b = stream!.readByte()!;
      if ((b & 0x7f) == 0) {
        throw Exception('Invalid tag number specified');
      }
      while ((b >= 0) && ((b & 0x80) != 0)) {
        result |= b & 0x7f;
        result <<= 7;
        b = stream.readByte()!;
      }
      if (b < 0) {
        throw Exception('End of file detected');
      }
      result |= b & 0x7f;
    }
    return result;
  }

  /// internal method
  static int getLength(PdfStreamReader stream, int? limit) {
    int length = stream.readByte()!;
    if (length < 0) {
      throw Exception('End of file detected');
    }
    if (length == 0x80) {
      return -1;
    }
    if (length > 127) {
      final int size = length & 0x7f;
      if (size > 4) {
        throw Exception('Invalid length detected: $size');
      }
      length = 0;
      for (int i = 0; i < size; i++) {
        final int next = stream.readByte()!;
        if (next < 0) {
          throw Exception('End of file detected');
        }
        length = (length << 8) + next;
      }
      if (length < 0) {
        throw Exception('Invalid length or corrupted input stream detected');
      }
      if (length >= limit!) {
        throw Exception('Out of bound or corrupted stream detected');
      }
    }
    return length;
  }

  /// internal method
  Asn1? buildObject(int tag, int tagNumber, int length) {
    final bool isConstructed = (tag & Asn1Tags.constructed) != 0;
    final Asn1StreamHelper stream = Asn1StreamHelper(_stream, length);
    if ((tag & Asn1Tags.tagged) != 0) {
      return Asn1Parser(stream).readTaggedObject(isConstructed, tagNumber);
    }
    if (isConstructed) {
      switch (tagNumber) {
        case Asn1Tags.octetString:
          return BerOctet(getBytesfromAsn1EncodeCollection(
              getDerEncodableCollection(stream)));
        case Asn1Tags.sequence:
          return createDerSequence(stream);
        case Asn1Tags.setTag:
          return createDerSet(stream);
      }
    }
    return getPrimitiveObject(tagNumber, stream, _buffers);
  }

  /// internal method
  Asn1EncodeCollection getEncodableCollection() {
    final Asn1EncodeCollection objects = Asn1EncodeCollection();
    Asn1? asn1Object;
    while ((asn1Object = readAsn1()) != null) {
      objects.encodableObjects.add(asn1Object);
    }
    return objects;
  }

  /// internal method
  Asn1? readAsn1() {
    final int tag = _stream!.readByte()!;
    if (tag > 0) {
      final int tagNumber = readTagNumber(_stream, tag);
      final bool isConstructed = (tag & Asn1Tags.constructed) != 0;
      final int length = getLength(_stream!, _limit);
      if (length < 0) {
        if (!isConstructed) {
          throw ArgumentError.value(
              length, 'length', 'Encodeing length is invalid');
        }
        final Asn1Parser sp =
            Asn1Parser(Asn1LengthStream(_stream, _limit), _limit);
        if ((tag & Asn1Tags.tagged) != 0) {
          return BerTagHelper(true, tagNumber, sp).getAsn1();
        }
        switch (tagNumber) {
          case Asn1Tags.octetString:
            return BerOctetHelper(sp).getAsn1();
          case Asn1Tags.sequence:
            return BerSequenceHelper(sp).getAsn1();
          default:
            throw ArgumentError.value(
                tagNumber, 'tag', 'Invalid object in the sequence');
        }
      } else {
        return buildObject(tag, tagNumber, length);
      }
    } else if (tag < 0) {
      return null;
    } else if (tag == 0) {
      throw ArgumentError.value(tag, 'tag', 'End of contents is invalid');
    }
    return null;
  }

  /// internal method
  List<int> getBytesfromAsn1EncodeCollection(Asn1EncodeCollection octets) {
    final List<int> result = <int>[];
    for (int i = 0; i < octets.count; i++) {
      final DerOctet o = octets[i]! as DerOctet;
      result.addAll(o.getOctets()!);
    }
    return result;
  }

  /// internal method
  Asn1EncodeCollection getDerEncodableCollection(Asn1StreamHelper stream) {
    return Asn1Stream(stream).getEncodableCollection();
  }

  /// internal method
  DerSequence createDerSequence(Asn1StreamHelper stream) {
    return DerSequence(collection: getDerEncodableCollection(stream));
  }

  /// internal method
  DerSet createDerSet(Asn1StreamHelper stream) {
    return DerSet(collection: getDerEncodableCollection(stream), isSort: false);
  }
}

/// internal class
class Asn1BaseStream extends PdfStreamReader {
  /// internal constructor
  Asn1BaseStream(this.input, this.limit);

  /// internal field
  int? limit;

  /// internal field
  late bool closed;

  /// internal field
  PdfStreamReader? input;

  /// internal property
  int? get remaining => limit;

  /// internal property
  bool get canRead => !closed;

  /// internal property
  bool get canSeek => false;

  /// internal property
  bool get canWrite => false;

  /// internal method
  void close() {
    closed = true;
  }

  /// internal method
  void setParentEndOfFileDetect(bool isDetect) {
    if (input is Asn1LengthStream) {
      (input! as Asn1LengthStream).setEndOfFileOnStart(isDetect);
    }
  }

  @override
  // ignore: avoid_renaming_method_parameters
  int read(List<int> buffer, int offset, int count) {
    int pos = offset;
    try {
      final int end = offset + count;
      while (pos < end) {
        final int b = input!.readByte()!;
        if (b == -1) {
          break;
        }
        buffer[pos++] = b;
      }
    } catch (e) {
      if (pos == offset) {
        throw Exception('End of stream');
      }
    }
    return pos - offset;
  }
}

/// internal class
class Asn1StreamHelper extends Asn1BaseStream {
  /// internal constructor
  Asn1StreamHelper(PdfStreamReader? stream, int length)
      : super(stream, length) {
    if (length < 0) {
      throw Exception('Invalid length specified.');
    }
    _remaining = length;
    if (length == 0) {
      setParentEndOfFileDetect(true);
    }
  }

  late int _remaining;
  @override
  int get remaining => _remaining;

  @override
  int readByte() {
    if (_remaining == 0) {
      return -1;
    }
    final int result = input!.readByte()!;
    if (result < 0) {
      throw ArgumentError.value(result, 'result', 'Invalid length in bytes');
    }
    _remaining -= 1;
    if (_remaining == 0) {
      setParentEndOfFileDetect(true);
    }
    return result;
  }

  /// internal method
  @override
  int read(List<int> bytes, int offset, int length) {
    if (remaining == 0) {
      return 0;
    }
    final int count = super.read(bytes, offset, min(length, _remaining));
    if (count < 1) {
      throw ArgumentError.value(count, 'count', 'Object truncated');
    }
    if ((_remaining -= count) == 0) {
      setParentEndOfFileDetect(true);
    }
    return count;
  }

  /// internal method
  List<int> toArray() {
    if (_remaining == 0) {
      return <int>[];
    }
    final List<int> bytes = List<int>.generate(_remaining, (int i) => 0);
    if ((_remaining -= readData(bytes, 0, bytes.length)) != 0) {
      throw ArgumentError.value(bytes, 'bytes', 'Object truncated');
    }
    setParentEndOfFileDetect(true);
    return bytes;
  }

  /// internal method
  void readAll(List<int> bytes) {
    if (_remaining != bytes.length) {
      throw ArgumentError.value(bytes, 'bytes', 'Invalid length in bytes');
    }
    if ((_remaining -= readData(bytes, 0, bytes.length)) != 0) {
      throw ArgumentError.value(bytes, 'bytes', 'Object truncated');
    }
    setParentEndOfFileDetect(true);
  }

  /// internal method
  int readData(List<int> bytes, int offset, int length) {
    int total = 0;
    while (total < length) {
      final int count = read(bytes, offset + total, length - total);
      if (count < 1) {
        break;
      }
      total += count;
    }
    return total;
  }
}

/// internal class
class Asn1LengthStream extends Asn1BaseStream {
  /// internal constructor
  Asn1LengthStream(super.stream, super.limit) {
    byte = requireByte();
    checkEndOfFile();
  }

  /// internal field
  int? byte;

  /// internal field
  bool isEndOfFile = true;

  /// internal method
  int requireByte() {
    final int value = input!.readByte()!;
    if (value < 0) {
      throw ArgumentError.value(value, 'value', 'Invalid data in stream');
    }
    return value;
  }

  /// internal method
  void setEndOfFileOnStart(bool isEOF) {
    isEndOfFile = isEOF;
    if (isEndOfFile) {
      checkEndOfFile();
    }
  }

  /// internal method
  bool checkEndOfFile() {
    if (byte == 0x00) {
      final int extra = requireByte();
      if (extra != 0) {
        throw Exception('Invalid content');
      }
      byte = -1;
      setParentEndOfFileDetect(true);
      return true;
    }
    return byte! < 0;
  }

  @override
  int? readByte() {
    if (isEndOfFile && checkEndOfFile()) {
      return -1;
    }
    final int? result = byte;
    byte = requireByte();
    return result;
  }

  @override
  int read(List<int> buffer, int offset, int count) {
    if (isEndOfFile || count <= 1) {
      return super.read(buffer, offset, count);
    }
    if (byte! < 0) {
      return 0;
    }
    final int numRead = input!.read(buffer, offset + 1, count - 1)!;
    if (numRead <= 0) {
      throw Exception();
    }
    buffer[offset] = byte!;
    byte = requireByte();
    return numRead + 1;
  }
}
