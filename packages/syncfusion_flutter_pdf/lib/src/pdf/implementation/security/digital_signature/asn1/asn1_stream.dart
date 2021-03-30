part of pdf;

class _Asn1Stream {
  _Asn1Stream(_StreamReader stream, [int? limit]) {
    _stream = stream;
    _limit = limit ?? getLimit(stream);
    _buffers = List.generate(16, (i) => <int>[]);
  }
  int? _limit;
  List<List<int>>? _buffers;
  _StreamReader? _stream;

  static int? getLimit(_StreamReader input) {
    if (input is _Asn1BaseStream) {
      return input.remaining;
    } else {
      return input.length! - input.position;
    }
  }

  static _Asn1? getPrimitiveObject(
      int tagNumber, _Asn1StreamHelper stream, List<List<int>>? buffers) {
    switch (tagNumber) {
      case _Asn1Tags.boolean:
        return _DerBoolean.fromBytes(getBytes(stream, buffers!));
      case _Asn1Tags.enumerated:
        return _DerCatalogue(getBytes(stream, buffers!));
      case _Asn1Tags.objectIdentifier:
        return _DerObjectID.fromOctetString(getBytes(stream, buffers!));
    }
    final List<int> bytes = stream.toArray();
    switch (tagNumber) {
      case _Asn1Tags.bitString:
        return _DerBitString.fromAsn1Octets(bytes);
      case _Asn1Tags.bmpString:
        return _DerBmpString(bytes);
      case _Asn1Tags.generalizedTime:
        return _GeneralizedTime(bytes);
      case _Asn1Tags.asciiString:
        return _DerAsciiString.fromBytes(bytes);
      case _Asn1Tags.integer:
        return _DerInteger(bytes);
      case _Asn1Tags.nullValue:
        return _DerNull.value;
      case _Asn1Tags.octetString:
        return _DerOctet(bytes);
      case _Asn1Tags.printableString:
        return _DerPrintableString(utf8.decode(bytes));
      case _Asn1Tags.teleText:
        return _DerTeleText(String.fromCharCodes(bytes));
      case _Asn1Tags.utcTime:
        return _DerUtcTime(bytes);
      case _Asn1Tags.utf8String:
        return _DerUtf8String(utf8.decode(bytes));
    }
    return null;
  }

  static List<int> getBytes(_Asn1StreamHelper stream, List<List<int>> buffers) {
    final int length = stream.remaining;
    if (length >= buffers.length) {
      stream.toArray();
    }
    List<int> bytes = buffers[length];
    if (bytes.isEmpty) {
      bytes = buffers[length] = List<int>.generate(length, (i) => 0);
    }
    stream.readAll(bytes);
    return bytes;
  }

  static int readTagNumber(_StreamReader? stream, int tagNumber) {
    int result = tagNumber & 0x1f;
    if (result == 0x1f) {
      result = 0;
      int b = stream!.readByte()!;
      if ((b & 0x7f) == 0) throw Exception('Invalid tag number specified');
      while ((b >= 0) && ((b & 0x80) != 0)) {
        result |= (b & 0x7f);
        result <<= 7;
        b = stream.readByte()!;
      }
      if (b < 0) throw new Exception('End of file detected');
      result |= (b & 0x7f);
    }
    return result;
  }

  static int getLength(_StreamReader stream, int? limit) {
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

  _Asn1? buildObject(int tag, int tagNumber, int length) {
    final bool isConstructed = (tag & _Asn1Tags.constructed) != 0;
    final _Asn1StreamHelper stream = new _Asn1StreamHelper(_stream, length);
    if ((tag & _Asn1Tags.tagged) != 0)
      return new _Asn1Parser(stream).readTaggedObject(isConstructed, tagNumber);
    if (isConstructed) {
      switch (tagNumber) {
        case _Asn1Tags.octetString:
          return _BerOctet(getBytesfromAsn1EncodeCollection(
              getDerEncodableCollection(stream)));
        case _Asn1Tags.sequence:
          return createDerSequence(stream);
        case _Asn1Tags.setTag:
          return createDerSet(stream);
      }
    }
    return getPrimitiveObject(tagNumber, stream, _buffers);
  }

  _Asn1EncodeCollection getEncodableCollection() {
    final _Asn1EncodeCollection objects = _Asn1EncodeCollection();
    _Asn1? asn1Object;
    while ((asn1Object = readAsn1()) != null) {
      objects._encodableObjects.add(asn1Object);
    }
    return objects;
  }

  _Asn1? readAsn1() {
    final int tag = _stream!.readByte()!;
    if (tag > 0) {
      final int tagNumber = readTagNumber(_stream, tag);
      final bool isConstructed = (tag & _Asn1Tags.constructed) != 0;
      final int length = getLength(_stream!, _limit);
      if (length < 0) {
        if (!isConstructed) {
          throw ArgumentError.value(
              length, 'length', 'Encodeing length is invalid');
        }
        final _Asn1Parser sp =
            _Asn1Parser(_Asn1LengthStream(_stream, _limit), _limit);
        if ((tag & _Asn1Tags.tagged) != 0) {
          return _BerTagHelper(true, tagNumber, sp).getAsn1();
        }
        switch (tagNumber) {
          case _Asn1Tags.octetString:
            return _BerOctetHelper(sp).getAsn1();
          case _Asn1Tags.sequence:
            return _BerSequenceHelper(sp).getAsn1();
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

  List<int> getBytesfromAsn1EncodeCollection(_Asn1EncodeCollection octets) {
    final List<int> result = [];
    for (int i = 0; i < octets.count; i++) {
      final _DerOctet o = octets[i] as _DerOctet;
      result.addAll(o.getOctets()!);
    }
    return result;
  }

  _Asn1EncodeCollection getDerEncodableCollection(_Asn1StreamHelper stream) {
    return _Asn1Stream(stream).getEncodableCollection();
  }

  _DerSequence createDerSequence(_Asn1StreamHelper stream) {
    return _DerSequence(collection: getDerEncodableCollection(stream));
  }

  _DerSet createDerSet(_Asn1StreamHelper stream) {
    return _DerSet(
        collection: getDerEncodableCollection(stream), isSort: false);
  }
}

class _Asn1BaseStream extends _StreamReader {
  _Asn1BaseStream(_StreamReader? stream, int? lm) {
    input = stream;
    limit = lm;
  }
  int? limit;
  late bool closed;
  _StreamReader? input;
  int? get remaining => limit;
  bool get canRead => !closed;
  bool get canSeek => false;
  bool get canWrite => false;
  void close() {
    closed = true;
  }

  void setParentEndOfFileDetect(bool isDetect) {
    if (input is _Asn1LengthStream) {
      (input as _Asn1LengthStream).setEndOfFileOnStart(isDetect);
    }
  }

  @override
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

class _Asn1StreamHelper extends _Asn1BaseStream {
  _Asn1StreamHelper(_StreamReader? stream, int length) : super(stream, length) {
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

  List<int> toArray() {
    if (_remaining == 0) {
      return <int>[];
    }
    final List<int> bytes = List<int>.generate(_remaining, (i) => 0);
    if ((_remaining -= readData(bytes, 0, bytes.length)) != 0) {
      throw ArgumentError.value(bytes, 'bytes', 'Object truncated');
    }
    setParentEndOfFileDetect(true);
    return bytes;
  }

  void readAll(List<int> bytes) {
    if (_remaining != bytes.length) {
      throw ArgumentError.value(bytes, 'bytes', 'Invalid length in bytes');
    }
    if ((_remaining -= readData(bytes, 0, bytes.length)) != 0) {
      throw ArgumentError.value(bytes, 'bytes', 'Object truncated');
    }
    setParentEndOfFileDetect(true);
  }

  int readData(List<int> bytes, int offset, int length) {
    int total = 0;
    while (total < length) {
      final int count = this.read(bytes, offset + total, length - total);
      if (count < 1) {
        break;
      }
      total += count;
    }
    return total;
  }
}

class _Asn1LengthStream extends _Asn1BaseStream {
  _Asn1LengthStream(_StreamReader? stream, int? limit) : super(stream, limit) {
    byte = requireByte();
    checkEndOfFile();
  }

  int? byte;
  bool isEndOfFile = true;

  int requireByte() {
    final int value = input!.readByte()!;
    if (value < 0) {
      throw ArgumentError.value(value, 'value', 'Invalid data in stream');
    }
    return value;
  }

  void setEndOfFileOnStart(bool isEOF) {
    isEndOfFile = isEOF;
    if (isEndOfFile) {
      checkEndOfFile();
    }
  }

  bool checkEndOfFile() {
    if (byte == 0x00) {
      final int extra = requireByte();
      if (extra != 0) throw Exception("Invalid content");
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
      throw new Exception();
    }
    buffer[offset] = byte!;
    byte = requireByte();
    return numRead + 1;
  }
}

class _PushStream extends _StreamReader {
  _PushStream(_StreamReader stream) : super(stream._data) {
    _stream = stream;
    _buffer = -1;
  }
  //Fields
  late _StreamReader _stream;
  int? _buffer;
  int get position => _stream.position;
  set position(int value) {
    _stream.position = value;
  }

  //Implementation
  @override
  int? readByte() {
    if (_buffer != -1) {
      final int? temp = _buffer;
      _buffer = -1;
      return temp;
    }
    return _stream.readByte();
  }

  @override
  int? read(List<int> buffer, int offset, int count) {
    if (_buffer != -1) {
      final int? temp = _buffer;
      _buffer = -1;
      return temp;
    }
    return _stream.read(buffer, offset, count);
  }

  void unread(int b) {
    _buffer = b & 0xFF;
  }
}
