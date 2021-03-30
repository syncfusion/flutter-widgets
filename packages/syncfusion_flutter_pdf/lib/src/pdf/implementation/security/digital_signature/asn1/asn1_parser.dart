part of pdf;

class _Asn1Parser {
  _Asn1Parser(_StreamReader stream, [int? limit]) {
    _stream = stream;
    _limit = limit != null ? limit : _Asn1Stream.getLimit(stream);
    _buffers = List.generate(16, (i) => <int>[]);
  }

  //Fields
  _StreamReader? _stream;
  int? _limit;
  List<List<int>>? _buffers;

  //Implementation
  _IAsn1 readImplicit(bool? constructed, int tagNumber) {
    if (_stream is _Asn1LengthStream) {
      if (!constructed!) {
        throw ArgumentError.value('Invalid length specified');
      }
      return readIndefinite(tagNumber);
    }
    if (constructed!) {
      switch (tagNumber) {
        case _Asn1Tags.setTag:
          return _DerSetHelper(this);
        case _Asn1Tags.sequence:
          return _DerSequenceHelper(this);
        case _Asn1Tags.octetString:
          return _BerOctetHelper(this);
      }
    } else {
      switch (tagNumber) {
        case _Asn1Tags.setTag:
          throw ArgumentError.value(tagNumber, 'tagNumber',
              'Constructed encoding is not used in the set');
        case _Asn1Tags.sequence:
          throw ArgumentError.value(tagNumber, 'tagNumber',
              'Constructed encoding is not used in the sequence');
        case _Asn1Tags.octetString:
          return _DerOctetHelper(_stream as _Asn1StreamHelper?);
      }
    }
    throw ArgumentError.value(
        tagNumber, 'tagNumber', 'Implicit tagging is not supported');
  }

  _Asn1 readTaggedObject(bool constructed, int? tagNumber) {
    if (!constructed) {
      final _Asn1StreamHelper stream = _stream as _Asn1StreamHelper;
      return _DerTag(tagNumber, _DerOctet(stream.toArray()), false);
    }
    final _Asn1EncodeCollection collection = readCollection();
    if (_stream is _Asn1LengthStream) {
      return collection.count == 1
          ? _DerTag(tagNumber, collection[0], true)
          : _DerTag(tagNumber, _BerSequence.fromCollection(collection), false);
    }
    return collection.count == 1
        ? _DerTag(tagNumber, collection[0], true)
        : _DerTag(tagNumber, _DerSequence.fromCollection(collection), false);
  }

  _IAsn1 readIndefinite(int tagValue) {
    switch (tagValue) {
      case _Asn1Tags.octetString:
        return _BerOctetHelper(this);
      case _Asn1Tags.sequence:
        return _BerSequenceHelper(this);
      default:
        throw ArgumentError.value(
            tagValue, 'tagValue', 'Invalid entry in sequence');
    }
  }

  void setEndOfFile(bool enabled) {
    if (_stream is _Asn1LengthStream) {
      (_stream as _Asn1LengthStream).setEndOfFileOnStart(enabled);
    }
  }

  _Asn1EncodeCollection readCollection() {
    final _Asn1EncodeCollection collection = _Asn1EncodeCollection();
    _IAsn1? obj;
    while ((obj = readObject()) != null) {
      collection._encodableObjects.add(obj!.getAsn1());
    }
    return collection;
  }

  _IAsn1? readObject() {
    final int? tag = _stream!.readByte();
    if (tag == -1) {
      return null;
    }
    setEndOfFile(false);
    final int tagNumber = _Asn1Stream.readTagNumber(_stream, tag!);
    final bool isConstructed = (tag & _Asn1Tags.constructed) != 0;
    final int length = _Asn1Stream.getLength(_stream!, _limit);
    if (length < 0) {
      if (!isConstructed) {
        throw ArgumentError.value(length, 'length', 'Invalid length specified');
      }
      final _Asn1LengthStream stream = _Asn1LengthStream(_stream, _limit);
      final _Asn1Parser helper = _Asn1Parser(stream, _limit);
      if ((tag & _Asn1Tags.tagged) != 0)
        return _BerTagHelper(true, tagNumber, helper);
      return helper.readIndefinite(tagNumber);
    } else {
      final _Asn1StreamHelper stream = _Asn1StreamHelper(_stream, length);
      if ((tag & _Asn1Tags.tagged) != 0) {
        return _BerTagHelper(isConstructed, tagNumber,
            _Asn1Parser(stream, _Asn1Stream.getLimit(stream)));
      }
      if (isConstructed) {
        switch (tagNumber) {
          case _Asn1Tags.octetString:
            return _BerOctetHelper(
                _Asn1Parser(stream, _Asn1Stream.getLimit(stream)));
          case _Asn1Tags.sequence:
            return _DerSequenceHelper(
                _Asn1Parser(stream, _Asn1Stream.getLimit(stream)));
          case _Asn1Tags.setTag:
            return _DerSetHelper(
                _Asn1Parser(stream, _Asn1Stream.getLimit(stream)));
          default:
            return null;
        }
      }
      if (tagNumber == _Asn1Tags.octetString) {
        return _DerOctetHelper(stream);
      }
      return _Asn1Stream.getPrimitiveObject(tagNumber, stream, _buffers);
    }
  }
}
