import '../../../io/stream_reader.dart';
import 'asn1.dart';
import 'asn1_stream.dart';
import 'ber.dart';
import 'der.dart';

/// internal class
class Asn1Parser {
  /// internal constructor
  Asn1Parser(PdfStreamReader stream, [int? limit]) {
    _stream = stream;
    _limit = limit ?? Asn1Stream.getLimit(stream);
    _buffers = List<List<int>>.generate(16, (int i) => <int>[]);
  }

  //Fields
  PdfStreamReader? _stream;
  int? _limit;
  List<List<int>>? _buffers;

  //Implementation
  /// internal method
  IAsn1 readImplicit(bool? constructed, int tagNumber) {
    if (_stream is Asn1LengthStream) {
      if (!constructed!) {
        throw ArgumentError.value('Invalid length specified');
      }
      return readIndefinite(tagNumber);
    }
    if (constructed!) {
      switch (tagNumber) {
        case Asn1Tags.setTag:
          return DerSetHelper(this);
        case Asn1Tags.sequence:
          return DerSequenceHelper(this);
        case Asn1Tags.octetString:
          return BerOctetHelper(this);
      }
    } else {
      switch (tagNumber) {
        case Asn1Tags.setTag:
          throw ArgumentError.value(tagNumber, 'tagNumber',
              'Constructed encoding is not used in the set');
        case Asn1Tags.sequence:
          throw ArgumentError.value(tagNumber, 'tagNumber',
              'Constructed encoding is not used in the sequence');
        case Asn1Tags.octetString:
          return DerOctetHelper(_stream as Asn1StreamHelper?);
      }
    }
    throw ArgumentError.value(
        tagNumber, 'tagNumber', 'Implicit tagging is not supported');
  }

  /// internal method
  Asn1 readTaggedObject(bool constructed, int? tagNumber) {
    if (!constructed) {
      final Asn1StreamHelper stream = _stream! as Asn1StreamHelper;
      return DerTag(tagNumber, DerOctet(stream.toArray()), false);
    }
    final Asn1EncodeCollection collection = readCollection();
    if (_stream is Asn1LengthStream) {
      return collection.count == 1
          ? DerTag(tagNumber, collection[0], true)
          : DerTag(tagNumber, BerSequence.fromCollection(collection), false);
    }
    return collection.count == 1
        ? DerTag(tagNumber, collection[0], true)
        : DerTag(tagNumber, DerSequence.fromCollection(collection), false);
  }

  /// internal method
  IAsn1 readIndefinite(int tagValue) {
    switch (tagValue) {
      case Asn1Tags.octetString:
        return BerOctetHelper(this);
      case Asn1Tags.sequence:
        return BerSequenceHelper(this);
      default:
        throw ArgumentError.value(
            tagValue, 'tagValue', 'Invalid entry in sequence');
    }
  }

  /// internal method
  void setEndOfFile(bool enabled) {
    if (_stream is Asn1LengthStream) {
      (_stream! as Asn1LengthStream).setEndOfFileOnStart(enabled);
    }
  }

  /// internal method
  Asn1EncodeCollection readCollection() {
    final Asn1EncodeCollection collection = Asn1EncodeCollection();
    IAsn1? obj;
    while ((obj = readObject()) != null) {
      collection.encodableObjects.add(obj!.getAsn1());
    }
    return collection;
  }

  /// internal method
  IAsn1? readObject() {
    final int? tag = _stream!.readByte();
    if (tag == -1) {
      return null;
    }
    setEndOfFile(false);
    final int tagNumber = Asn1Stream.readTagNumber(_stream, tag!);
    final bool isConstructed = (tag & Asn1Tags.constructed) != 0;
    final int length = Asn1Stream.getLength(_stream!, _limit);
    if (length < 0) {
      if (!isConstructed) {
        throw ArgumentError.value(length, 'length', 'Invalid length specified');
      }
      final Asn1LengthStream stream = Asn1LengthStream(_stream, _limit);
      final Asn1Parser helper = Asn1Parser(stream, _limit);
      if ((tag & Asn1Tags.tagged) != 0) {
        return BerTagHelper(true, tagNumber, helper);
      }
      return helper.readIndefinite(tagNumber);
    } else {
      final Asn1StreamHelper stream = Asn1StreamHelper(_stream, length);
      if ((tag & Asn1Tags.tagged) != 0) {
        return BerTagHelper(isConstructed, tagNumber,
            Asn1Parser(stream, Asn1Stream.getLimit(stream)));
      }
      if (isConstructed) {
        switch (tagNumber) {
          case Asn1Tags.octetString:
            return BerOctetHelper(
                Asn1Parser(stream, Asn1Stream.getLimit(stream)));
          case Asn1Tags.sequence:
            return DerSequenceHelper(
                Asn1Parser(stream, Asn1Stream.getLimit(stream)));
          case Asn1Tags.setTag:
            return DerSetHelper(
                Asn1Parser(stream, Asn1Stream.getLimit(stream)));
          default:
            return null;
        }
      }
      if (tagNumber == Asn1Tags.octetString) {
        return DerOctetHelper(stream);
      }
      return Asn1Stream.getPrimitiveObject(tagNumber, stream, _buffers);
    }
  }
}
