part of pdf;

class _CrossTable {
  //Constructor
  _CrossTable(List<int>? data, _PdfCrossTable crossTable) {
    if (data == null || data.isEmpty) {
      ArgumentError.value(data, 'PDF data', 'PDF data cannot be null or empty');
    }
    _data = data!;
    _crossTable = crossTable;
    _initialize();
  }

  //Fields
  late List<int> _data;
  late _PdfCrossTable _crossTable;
  _PdfReader? _reader;
  _PdfParser? _parser;
  late Map<int, _ObjectInformation> _objects;
  late Map<_PdfStream, _PdfParser> _readersTable;
  late Map<int, _PdfStream> _archives;
  int _startCrossReference = 0;
  bool validateSyntax = false;
  _PdfDictionary? _trailer;
  bool _isStructureAltered = false;
  int _whiteSpace = 0;
  int _initialNumberOfSubsection = 0;
  int _initialSubsectionCount = 0;
  int _totalNumberOfSubsection = 0;
  int? _generationNumber;
  late Map<int, List<_ObjectInformation>> _allTables;
  _PdfReferenceHolder? _documentCatalog;
  _PdfEncryptor? _encryptor;

  //Properties
  _ObjectInformation? operator [](int? key) => _returnValue(key);

  _PdfReader get reader {
    _reader ??= _PdfReader(_data);
    return _reader!;
  }

  _PdfParser get parser {
    _parser ??= _PdfParser(this, reader, _crossTable);
    return _parser!;
  }

  _PdfReferenceHolder? get documentCatalog {
    if (_documentCatalog == null) {
      final _PdfDictionary trailer = _trailer!;
      final _IPdfPrimitive? obj = trailer[_DictionaryProperties.root];
      if (obj is _PdfReferenceHolder) {
        _documentCatalog = obj;
      } else {
        throw ArgumentError.value(obj, 'Invalid format');
      }
    }
    return _documentCatalog;
  }

  _PdfEncryptor? get encryptor {
    return _encryptor;
  }

  set encryptor(_PdfEncryptor? value) {
    if (value != null) {
      _encryptor = value;
    }
  }

  //Implementation
  void _initialize() {
    _generationNumber = 65535;
    _archives = <int, _PdfStream>{};
    _readersTable = <_PdfStream, _PdfParser>{};
    _allTables = <int, List<_ObjectInformation>>{};
    final int startingOffset = _checkJunk();
    if (startingOffset < 0) {
      ArgumentError.value(
          startingOffset, 'Could not find valid signature (%PDF-)');
    }
    _objects = <int, _ObjectInformation>{};
    _PdfReader reader = this.reader;
    _PdfParser parser = this.parser;
    reader.position = startingOffset;
    reader._skipWhiteSpace();
    _whiteSpace = reader.position;
    int position = reader._seekEnd()!;
    checkStartXRef();
    reader.position = position;
    final int endPosition = reader._searchBack(_Operators.endOfFileMarker);
    if (endPosition != -1) {
      if (position != endPosition + 5) {
        reader.position = endPosition + 5;
        final String token = reader._getNextToken()!;
        if (token.isNotEmpty && token.codeUnitAt(0) != 0 && token[0] != '0') {
          reader.position = 0;
          final List<int> buffer = reader._readBytes(endPosition + 5);
          reader = _PdfReader(buffer);
          reader.position = buffer.length;
          parser = _PdfParser(this, reader, _crossTable);
          _reader = reader;
          _parser = parser;
        }
      }
    } else {
      reader.position = position;
    }
    position = reader._searchBack(_Operators.startCrossReference);
    bool isForwardSearch = false;
    if (position >= 0) {
      parser._setOffset(position);
      position = parser.startCrossReference();
      _startCrossReference = position;
      _parser!._setOffset(position);
      if (_whiteSpace != 0) {
        final int crossReferencePosition =
            reader._searchForward(_Operators.crossReference);
        if (crossReferencePosition == -1) {
          isForwardSearch = false;
          position += _whiteSpace;
          reader.position = position;
        } else {
          position = crossReferencePosition;
          parser._setOffset(position);
          isForwardSearch = true;
        }
      }
    }
    String tempString = reader._readLine();
    if (!tempString.contains(_Operators.crossReference) &&
        !tempString.contains(_Operators.obj) &&
        !isForwardSearch) {
      final int rposition = reader.position;
      final String tempS = reader._readLine();
      if (tempS.contains(_Operators.crossReference)) {
        tempString = tempS;
        position = rposition;
      } else {
        reader.position = rposition;
      }
    }
    if (!tempString.contains(_Operators.crossReference) &&
        !tempString.contains(_Operators.obj) &&
        !isForwardSearch) {
      if (position > reader.length!) {
        position = reader.length!;
        reader.position = position;
        position = reader._searchBack(_Operators.startCrossReference);
      }
      final int tempOffset = reader._searchBack(_Operators.crossReference);
      if (tempOffset != -1) {
        position = tempOffset;
      }
      parser._setOffset(position);
    }
    reader.position = position;
    try {
      final Map<String, dynamic> tempResult =
          parser._parseCrossReferenceTable(_objects, this);
      _trailer = tempResult['object'] as _PdfDictionary?;
      _objects = tempResult['objects'];
    } catch (e) {
      throw ArgumentError.value(_trailer, 'Invalid cross reference table.');
    }
    _PdfDictionary trailer = _trailer!;
    while (trailer.containsKey(_DictionaryProperties.prev)) {
      if (_whiteSpace != 0) {
        final _PdfNumber number =
            trailer[_DictionaryProperties.prev] as _PdfNumber;
        number.value = number.value! + _whiteSpace;
        _isStructureAltered = true;
      }
      position =
          (trailer[_DictionaryProperties.prev] as _PdfNumber).value!.toInt();
      final _PdfReader tokenReader = _PdfReader(_reader!._streamReader._data);
      tokenReader.position = position;
      String? token = tokenReader._getNextToken();
      if (token != _DictionaryProperties.crossReference) {
        token = tokenReader._getNextToken();
        //check the coditon for valid object number
        final int? number = int.tryParse(token!);
        if (number != null && number >= 0 && number <= 9) {
          token = tokenReader._getNextToken();
          if (token == _DictionaryProperties.obj) {
            parser._setOffset(position);
            final Map<String, dynamic> tempResults =
                parser._parseCrossReferenceTable(_objects, this);
            trailer = tempResults['object'] as _PdfDictionary;
            _objects = tempResults['objects'];
            parser._setOffset(position);
            continue;
          }
        }
        parser._rebuildXrefTable(_objects, this);
        break;
      } else {
        parser._setOffset(position);
        final Map<String, dynamic> tempResults =
            parser._parseCrossReferenceTable(_objects, this);
        trailer = tempResults['object'] as _PdfDictionary;
        _objects = tempResults['objects'];
        if (trailer.containsKey(_DictionaryProperties.size) &&
            _trailer!.containsKey(_DictionaryProperties.size)) {
          if ((trailer[_DictionaryProperties.size] as _PdfNumber).value! >
              (_trailer![_DictionaryProperties.size] as _PdfNumber).value!) {
            (_trailer![_DictionaryProperties.size] as _PdfNumber).value =
                (trailer[_DictionaryProperties.size] as _PdfNumber).value;
          }
        }
      }
    }
    if (_whiteSpace != 0 && isForwardSearch) {
      List<int> objKey = List<int>.filled(_objects.length, 0);
      objKey = _objects.keys.toList();
      for (int i = 0; i < objKey.length; i++) {
        final int key = objKey[i];
        final _ObjectInformation info = _objects[key]!;
        _objects[key] =
            _ObjectInformation(info._offset! + _whiteSpace, null, this);
      }
      _isStructureAltered = true;
    } else if (_whiteSpace != 0 && _whiteSpace > 0 && !_isStructureAltered) {
      if (!trailer.containsKey(_DictionaryProperties.prev)) {
        _isStructureAltered = true;
      }
    }
  }

  _ObjectInformation? _returnValue(int? key) {
    return _objects.containsKey(key) ? _objects[key!] : null;
  }

  _IPdfPrimitive? _getObject(_IPdfPrimitive? pointer) {
    if (pointer == null) {
      throw ArgumentError.value(pointer, 'pointer');
    }
    if (pointer is _PdfReference) {
      _IPdfPrimitive? obj;
      final _PdfReference reference = pointer;
      final _ObjectInformation? oi = this[reference._objNum];
      if (oi == null) {
        return _PdfNull();
      }
      final _PdfParser? parser = oi.parser;
      final int? position = oi.offset;
      if (oi._obj != null) {
        obj = oi._obj;
      } else if (oi._archive == null) {
        obj = parser!._parseOffset(position!);
      } else {
        obj = _getObjectFromPosition(parser!, position!);
      }
      oi._obj = obj;
      return obj;
    } else {
      return pointer;
    }
  }

  _IPdfPrimitive? _getObjectFromPosition(_PdfParser parser, int position) {
    parser._startFrom(position);
    return parser._simple();
  }

  Map<int, _ObjectInformation>? _parseNewTable(
      _PdfStream? stream, Map<int, _ObjectInformation>? objects) {
    if (stream == null) {
      throw ArgumentError.value(stream, 'Invalid format');
    }
    stream._decompress();
    final List<_SubSection> subSections = _getSections(stream);
    int? ssIndex = 0;
    for (int i = 0; i < subSections.length; i++) {
      final _SubSection ss = subSections[i];
      final Map<String, dynamic> result =
          _parseWithHashTable(stream, ss, objects, ssIndex);
      ssIndex = result['index'];
      objects = result['objects'];
    }
    return objects;
  }

  Map<String, dynamic> _parseWithHashTable(
      _PdfStream stream,
      _SubSection subsection,
      Map<int, _ObjectInformation>? table,
      int? startIndex) {
    int? index = startIndex;
    final _IPdfPrimitive? entry = _getObject(stream[_DictionaryProperties.w]);
    if (entry is _PdfArray) {
      final int fields = entry.count;
      final List<int> format = List<int>.filled(fields, 0, growable: true);
      for (int i = 0; i < fields; ++i) {
        final _PdfNumber formatNumber = entry[i] as _PdfNumber;
        format[i] = formatNumber.value!.toInt();
      }
      final List<int> reference = List<int>.filled(fields, 0, growable: true);
      final List<int>? buf = stream._dataStream;
      for (int i = 0; i < subsection.count; ++i) {
        for (int j = 0; j < fields; ++j) {
          int field = 0;
          if (j == 0) {
            if (format[j] > 0) {
              field = 0;
            } else {
              field = 1;
            }
          }
          for (int k = 0; k < format[j]; ++k) {
            field <<= 8;
            field = field + buf![index!];
            index += 1;
          }
          reference[j] = field;
        }
        int offset = 0;
        _ArchiveInformation? ai;
        if (reference[0] == _ObjectType.normal.index) {
          if (_whiteSpace != 0) {
            offset = reference[1] + _whiteSpace;
          } else {
            offset = reference[1];
          }
        } else if (reference[0] == _ObjectType.packed.index) {
          ai =
              _ArchiveInformation(reference[1], reference[2], _retrieveArchive);
        }
        _ObjectInformation? oi;
        // NOTE: do not store removed objects.
        if (reference[0] != _ObjectType.free.index) {
          oi = _ObjectInformation(offset, ai, this);
        }
        if (oi != null) {
          final int objectOffset = subsection.startNumber + i;
          if (!table!.containsKey(objectOffset)) {
            table[objectOffset] = oi;
          }
          _addTables(objectOffset, oi);
        }
      }
    }
    return <String, dynamic>{'index': index, 'objects': table};
  }

  _PdfStream _retrieveArchive(int archiveNumber) {
    _PdfStream? archive;
    if (_archives.containsKey(archiveNumber)) {
      archive = _archives[archiveNumber];
    }
    if (archive == null) {
      final _ObjectInformation oi = this[archiveNumber]!;
      final _PdfParser parser = oi.parser!;
      archive = parser._parseOffset(oi._offset!) as _PdfStream?;
      if (encryptor != null && !encryptor!._encryptOnlyAttachment!) {
        archive!.decrypt(encryptor!, archiveNumber);
      }
      archive!._decompress();
      _archives[archiveNumber] = archive;
    }
    return archive;
  }

  List<_SubSection> _getSections(_PdfStream stream) {
    final List<_SubSection> subSections = <_SubSection>[];
    int count = 0;
    if (stream.containsKey(_DictionaryProperties.size)) {
      final _IPdfPrimitive? primitive = stream[_DictionaryProperties.size];
      if (primitive is _PdfNumber) {
        count = primitive.value!.toInt();
      }
    }
    if (count == 0) {
      throw ArgumentError.value(count, 'Invalid Format');
    }
    final _IPdfPrimitive? obj = stream[_DictionaryProperties.index];
    if (obj == null) {
      subSections.add(_SubSection(count));
    } else {
      final _IPdfPrimitive? primitive = _getObject(obj);
      if (primitive != null && primitive is _PdfArray) {
        final _PdfArray indices = primitive;
        if ((indices.count & 1) != 0) {
          throw ArgumentError.value(count, 'Invalid Format');
        }
        for (int i = 0; i < indices.count; ++i) {
          int n = 0, c = 0;
          n = (indices[i] as _PdfNumber).value!.toInt();
          ++i;
          c = (indices[i] as _PdfNumber).value!.toInt();
          subSections.add(_SubSection(c, n));
        }
      }
    }
    return subSections;
  }

  void _parseSubsection(
      _PdfParser parser, Map<int, _ObjectInformation>? table) {
    // Read the initial number of the subsection.
    _PdfNumber integer = parser._simple() as _PdfNumber;

    _initialNumberOfSubsection = integer.value!.toInt();
    // Read the total number of subsection.
    integer = parser._simple() as _PdfNumber;

    _totalNumberOfSubsection = integer.value!.toInt();
    _initialSubsectionCount = _initialNumberOfSubsection;
    for (int i = 0; i < _totalNumberOfSubsection; ++i) {
      integer = parser._simple() as _PdfNumber;
      final int offset = integer.value!.toInt();
      integer = parser._simple() as _PdfNumber;
      final int genNum = integer.value!.toInt();
      final String flag = parser._getObjectFlag();
      if (flag == 'n') {
        final _ObjectInformation oi = _ObjectInformation(offset, null, this);
        int objectOffset = 0;
        if (_initialSubsectionCount == _initialNumberOfSubsection) {
          objectOffset = _initialNumberOfSubsection + i;
        } else {
          objectOffset = _initialSubsectionCount + i;
        }
        if (!table!.containsKey(objectOffset)) {
          table[objectOffset] = oi;
        }
        _addTables(objectOffset, oi);
      } else {
        if (_initialNumberOfSubsection != 0 &&
            offset == 0 &&
            genNum == _generationNumber) {
          _initialNumberOfSubsection = _initialNumberOfSubsection - 1;
          if (i == 0) {
            _initialSubsectionCount = _initialNumberOfSubsection;
          }
        }
      }
    }
  }

  void _addTables(int objectOffset, _ObjectInformation oi) {
    if (_allTables.containsKey(objectOffset)) {
      _allTables[objectOffset]!.add(oi);
    } else {
      _allTables[objectOffset] = <_ObjectInformation>[oi];
    }
  }

  int _checkJunk() {
    int position = 0;
    int index = 0;
    do {
      final int length =
          _data.length - position < 1024 ? (_data.length - position) : 1024;
      final String header =
          String.fromCharCodes(_data.sublist(position, length));
      index = header.indexOf('%PDF-');
      position += length;
    } while (index < 0 && position != _data.length);
    return index;
  }

  void checkStartXRef() {
    const int maxSize = 1024;
    int pos = reader.length! - maxSize;
    if (pos < 1) {
      pos = 1;
    }
    List<int>? data = List<int>.filled(maxSize, 0);
    while (pos > 0) {
      reader.position = pos;
      final Map<String, dynamic> result = reader._copyBytes(data, 0, maxSize);
      data = result['buffer'];
      final String start = String.fromCharCodes(data!);
      final int index = start.lastIndexOf('startxref');
      if (index >= 0) {
        reader.position = index;
        break;
      }
      pos = pos - maxSize + 9;
    }
  }

  _PdfParser? retrieveParser(_ArchiveInformation? archive) {
    if (archive == null) {
      return _parser;
    } else {
      final _PdfStream? stream = archive.archive;
      _PdfParser? parser;
      if (_readersTable.containsKey(stream)) {
        parser = _readersTable[stream];
      }
      if (parser == null) {
        final _PdfReader reader = _PdfReader(stream!._dataStream);
        parser = _PdfParser(this, reader, _crossTable);
        _readersTable[stream] = parser;
      }
      return parser;
    }
  }
}

class _ObjectInformation {
  //Constructor
  _ObjectInformation(
      int offset, _ArchiveInformation? arciveInfo, _CrossTable? crossTable) {
    _offset = offset;
    _archive = arciveInfo;
    _crossTable = crossTable;
  }
  //Fields
  _ArchiveInformation? _archive;
  _PdfParser? _parser;
  int? _offset;
  _CrossTable? _crossTable;
  _IPdfPrimitive? _obj;

  //Properties
  _PdfParser? get parser {
    _parser ??= _crossTable!.retrieveParser(_archive);
    return _parser;
  }

  int? get offset {
    if (_offset == 0) {
      final _PdfParser parser = this.parser!;
      parser._startFrom(0);
      int pairs = 0;
      // Read indices.
      if (_archive != null) {
        final _PdfNumber? archieveNumber =
            _archive!.archive[_DictionaryProperties.n] as _PdfNumber?;
        if (archieveNumber != null) {
          pairs = archieveNumber.value!.toInt();
        }
        final List<int> indices =
            List<int>.filled(pairs * 2, 0, growable: true);
        for (int i = 0; i < pairs; ++i) {
          _PdfNumber? obj = parser._simple() as _PdfNumber?;
          if (obj != null) {
            indices[i * 2] = obj.value!.toInt();
          }
          obj = parser._simple() as _PdfNumber?;
          if (obj != null) {
            indices[i * 2 + 1] = obj.value!.toInt();
          }
        }
        final int index = _archive!._index;
        if (index * 2 >= indices.length) {
          throw ArgumentError.value(
              _archive!._archiveNumber, 'Missing indexes in archive');
        }
        _offset = indices[index * 2 + 1];
        final int first =
            (_archive!.archive[_DictionaryProperties.first] as _PdfNumber)
                .value!
                .toInt();
        _offset = _offset! + first;
      }
    }
    return _offset;
  }
}

class _ArchiveInformation {
  //Constructor
  _ArchiveInformation(int archiveNumber, int index, _GetArchive getArchive) {
    _archiveNumber = archiveNumber;
    _index = index;
    _getArchive = getArchive;
  }

  //Fields
  late int _archiveNumber;
  late int _index;
  _PdfStream? _archive;
  late _GetArchive _getArchive;

  //Properties
  _PdfStream get archive {
    _archive ??= _getArchive(_archiveNumber);
    return _archive!;
  }
}

typedef _GetArchive = _PdfStream Function(int archiveNumber);

class _SubSection {
  //constructor
  _SubSection(int count, [int? start]) {
    this.count = count;
    startNumber = start ?? 0;
  }

  late int startNumber;
  late int count;
}
