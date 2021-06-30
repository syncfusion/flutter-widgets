part of pdf;

class _BerOctet extends _DerOctet {
  _BerOctet(List<int> bytes) : super(bytes);
  _BerOctet.fromCollection(List<_Asn1Encode> octets)
      : super(_BerOctet.getBytes(octets)) {
    _octets = octets;
  }

  //Fields
  late dynamic _octets;

  //Implementation
  @override
  List<int>? getOctets() {
    return _value;
  }

  List<_DerOctet> generateOctets() {
    final List<_DerOctet> collection = <_DerOctet>[];
    for (int i = 0; i < _value!.length; i += 1000) {
      final int endIndex = min(_value!.length, i + 1000);
      collection.add(_DerOctet(List<int>.generate(
          endIndex - i,
          (int index) =>
              ((i + index) < _value!.length) ? _value![i + index] : 0)));
    }
    return collection;
  }

  @override
  void encode(_DerStream stream) {
    if (stream is _Asn1DerStream) {
      stream._stream!.add(_Asn1Tags.constructed | _Asn1Tags.octetString);
      stream._stream!.add(0x80);
      _octets.forEach((dynamic octet) {
        stream.writeObject(octet);
      });
      stream._stream!.add(0x00);
      stream._stream!.add(0x00);
    } else {
      super.encode(stream);
    }
  }

  static _BerOctet getBerOctet(_Asn1Sequence sequence) {
    final List<_Asn1Encode> collection = <_Asn1Encode>[];
    for (int i = 0; i < sequence._objects!.length; i++) {
      final dynamic entry = sequence._objects![i];
      if (entry != null && entry is _Asn1Encode) {
        collection.add(entry);
      }
    }
    return _BerOctet.fromCollection(collection);
  }

  static List<int> getBytes(List<_Asn1Encode> octets) {
    final List<int> result = <int>[];
    if (octets.isNotEmpty) {
      for (final dynamic o in octets) {
        if (o is _DerOctet) {
          result.addAll(o.getOctets()!);
        }
      }
    }
    return result;
  }
}

class _BerOctetHelper implements _IAsn1Octet {
  _BerOctetHelper(_Asn1Parser helper) {
    _helper = helper;
  }
  //Fields
  _Asn1Parser? _helper;
  @override
  _StreamReader getOctetStream() {
    return _OctetStream(_helper);
  }

  @override
  _Asn1 getAsn1() {
    return _BerOctet(readAll(getOctetStream()));
  }

  List<int> readAll(_StreamReader stream) {
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
    if (other is _BerOctetHelper) {
      return other._helper == _helper;
    } else {
      return false;
    }
  }
}

class _BerTagHelper implements _IAsn1Tag {
  _BerTagHelper(bool isConstructed, int tagNumber, _Asn1Parser helper) {
    _isConstructed = isConstructed;
    _tagNumber = tagNumber;
    _helper = helper;
  }
  //Fields
  bool? _isConstructed;
  int? _tagNumber;
  late _Asn1Parser _helper;
  //Properties
  @override
  int? get tagNumber => _tagNumber;
  //Implements
  @override
  _IAsn1? getParser(int tagNumber, bool isExplicit) {
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
  _Asn1 getAsn1() {
    return _helper.readTaggedObject(_isConstructed!, _tagNumber);
  }
}

class _BerSequence extends _DerSequence {
  _BerSequence({List<_Asn1Encode>? array, _Asn1EncodeCollection? collection})
      : super(array: array, collection: collection);
  _BerSequence.fromObject(_Asn1Encode? object) : super.fromObject(object);
  static _BerSequence empty = _BerSequence();
  static _BerSequence fromCollection(_Asn1EncodeCollection collection) {
    return collection.count < 1 ? empty : _BerSequence(collection: collection);
  }

  @override
  void encode(_DerStream stream) {
    if (stream is _Asn1DerStream) {
      stream._stream!.add(_Asn1Tags.sequence | _Asn1Tags.constructed);
      stream._stream!.add(0x80);
      // ignore: avoid_function_literals_in_foreach_calls
      _objects!.forEach((dynamic entry) {
        if (entry is _Asn1Encode) {
          stream.writeObject(entry);
        }
      });
      stream._stream!.add(0x00);
      stream._stream!.add(0x00);
    } else {
      super.encode(stream);
    }
  }
}

class _BerSequenceHelper implements _IAsn1Collection {
  _BerSequenceHelper(_Asn1Parser helper) {
    _helper = helper;
  }
  late _Asn1Parser _helper;

  @override
  _IAsn1? readObject() {
    return _helper.readObject();
  }

  @override
  _Asn1 getAsn1() {
    return _BerSequence.fromCollection(_helper.readCollection());
  }
}
