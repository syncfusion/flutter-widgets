part of pdf;

class _RandomArray implements _IRandom {
  _RandomArray(List<int> array) {
    _array = array;
  }
  //Fields
  late List<int> _array;
  //Properties
  @override
  int get length => _array.length;
  //Implementation
  @override
  int? getValue(int offset, [List<int>? bytes, int? off, int? length]) {
    if (bytes == null) {
      if (offset >= _array.length) {
        return -1;
      }
      return (0xff & _array[offset]);
    } else {
      if (offset >= _array.length) {
        return -1;
      }
      if (offset + length! > _array.length) {
        length = (_array.length - offset).toSigned(32);
      }
      List.copyRange(bytes, off!, _array, offset, offset + length);
      return length;
    }
  }
}

class _WindowRandom implements _IRandom {
  _WindowRandom(_IRandom source, int offset, int length) {
    _source = source;
    _offset = offset;
    _length = length;
  }
  //Fields
  late _IRandom _source;
  late int _offset;
  int? _length;
  //Properties
  @override
  int? get length => _length;
  //Implementation
  @override
  int? getValue(int position, [List<int>? bytes, int? off, int? len]) {
    if (position >= _length!) {
      return -1;
    }
    if (bytes == null) {
      return _source.getValue(_offset + position);
    } else {
      final int toRead = min(len!, _length! - position);
      return _source.getValue(_offset + position, bytes, off, toRead);
    }
  }
}

class _RandomGroup implements _IRandom {
  _RandomGroup(List<_IRandom?> sources) {
    _sources = <_SourceEntry>[];
    int totalSize = 0;
    int i = 0;
    sources.forEach((ras) {
      _sources.add(_SourceEntry(i, ras!, totalSize));
      ++i;
      totalSize += ras.length!;
    });
    _size = totalSize;
    _cse = _sources[sources.length - 1];
  }
  //Fields
  late List<_SourceEntry> _sources;
  _SourceEntry? _cse;
  int? _size;
  //Properties
  @override
  int? get length => _size;
  //Implementation
  @override
  int getValue(int position, [List<int>? bytes, int? off, int? len]) {
    _SourceEntry? entry = getEntry(position);
    if (entry == null) {
      return -1;
    }
    int offN = entry.offsetN(position);
    int? remaining = len;
    bool isContinue = true;
    while (isContinue && remaining! > 0) {
      if (entry == null || offN > entry._source.length!) {
        isContinue = false;
      } else {
        final int? count = entry._source.getValue(offN, bytes, off, remaining);
        if (count == -1) {
          isContinue = false;
        } else {
          off = off! + count!;
          position += count;
          remaining -= count;
          offN = 0;
          entry = getEntry(position);
        }
      }
    }
    return remaining == len ? -1 : len! - remaining!;
  }

  int? getStartIndex(int offset) {
    if (offset >= _cse!._startByte) {
      return _cse!._index;
    }
    return 0;
  }

  _SourceEntry? getEntry(int offset) {
    if (offset >= _size!) {
      return null;
    }
    if (offset >= _cse!._startByte && offset <= _cse!._endByte) {
      return _cse;
    }
    final int startAt = getStartIndex(offset)!;
    for (int i = startAt; i < _sources.length; i++) {
      if (offset >= _sources[i]._startByte && offset <= _sources[i]._endByte) {
        _cse = _sources[i];
        return _cse;
      }
    }
    return null;
  }
}

class _SourceEntry {
  _SourceEntry(int index, _IRandom source, int offset) {
    _index = index;
    _source = source;
    _startByte = offset;
    _endByte = offset + source.length! - 1;
  }
  //Fields
  late _IRandom _source;
  late int _startByte;
  late int _endByte;
  int? _index;
  //Implementation
  int offsetN(int absoluteOffset) {
    return absoluteOffset - _startByte;
  }
}

class _RandomStream extends _StreamReader {
  _RandomStream(_IRandom source)
      : super(List<int>.generate(source.length!, (i) => 0)) {
    _random = source;
  }
  //Fields
  late _IRandom _random;
  int position = 0;
  //Properties
  @override
  int? get length => _random.length;

  //Implementation
  @override
  int? read(List<int> buffer, int offset, int length) {
    final int? count = _random.getValue(position, buffer, offset, length);
    if (count == -1) {
      return 0;
    }
    position += count!;
    return count;
  }

  @override
  int readByte() {
    final int c = _random.getValue(position)!;
    if (c >= 0) {
      ++position;
    }
    return c;
  }
}
