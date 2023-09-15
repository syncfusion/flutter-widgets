import '../../interfaces/pdf_interface.dart';
import '../io/pdf_constants.dart';
import '../primitives/pdf_array.dart';
import '../primitives/pdf_dictionary.dart';
import '../primitives/pdf_null.dart';
import '../primitives/pdf_number.dart';
import '../primitives/pdf_reference.dart';
import '../primitives/pdf_reference_holder.dart';
import '../primitives/pdf_stream.dart';
import '../primitives/pdf_string.dart';
import '../security/pdf_encryptor.dart';
import 'enums.dart';
import 'pdf_cross_table.dart';
import 'pdf_parser.dart';
import 'pdf_reader.dart';

/// internal class
class CrossTable {
  //Constructor
  /// internal constructor
  CrossTable(List<int>? data, PdfCrossTable crossTable) {
    if (data == null || data.isEmpty) {
      ArgumentError.value(data, 'PDF data', 'PDF data cannot be null or empty');
    }
    _data = data!;
    _crossTable = crossTable;
    _initialize();
  }

  //Fields
  late List<int> _data;
  late PdfCrossTable _crossTable;
  PdfReader? _reader;
  PdfParser? _parser;

  /// internal field
  late Map<int, ObjectInformation> objects;
  late Map<PdfStream, PdfParser> _readersTable;
  late Map<int, PdfStream> _archives;

  /// internal field
  int startCrossReference = 0;

  /// internal field
  bool validateSyntax = false;

  /// internal field
  PdfDictionary? trailer;
  bool _isStructureAltered = false;
  int _whiteSpace = 0;

  /// internal field
  int initialNumberOfSubsection = 0;

  /// internal field
  int initialSubsectionCount = 0;

  /// internal field
  int totalNumberOfSubsection = 0;
  int? _generationNumber;
  late Map<int, List<ObjectInformation>> _allTables;
  PdfReferenceHolder? _documentCatalog;
  PdfEncryptor? _encryptor;

  //Properties
  /// internal property
  ObjectInformation? operator [](int? key) => _returnValue(key);

  /// internal property
  PdfReader get reader {
    _reader ??= PdfReader(_data);
    return _reader!;
  }

  /// internal property
  PdfParser get parser {
    _parser ??= PdfParser(this, reader, _crossTable);
    return _parser!;
  }

  /// internal property
  PdfReferenceHolder? get documentCatalog {
    if (_documentCatalog == null) {
      final PdfDictionary trailerObj = trailer!;
      final IPdfPrimitive? obj = trailerObj[PdfDictionaryProperties.root];
      if (obj is PdfReferenceHolder) {
        _documentCatalog = obj;
      } else {
        throw ArgumentError.value(obj, 'Invalid format');
      }
    }
    return _documentCatalog;
  }

  /// internal property
  PdfEncryptor? get encryptor {
    return _encryptor;
  }

  set encryptor(PdfEncryptor? value) {
    if (value != null) {
      _encryptor = value;
    }
  }

  //Implementation
  void _initialize() {
    _generationNumber = 65535;
    _archives = <int, PdfStream>{};
    _readersTable = <PdfStream, PdfParser>{};
    _allTables = <int, List<ObjectInformation>>{};
    final int startingOffset = _checkJunk();
    if (startingOffset < 0) {
      ArgumentError.value(
          startingOffset, 'Could not find valid signature (%PDF-)');
    }
    objects = <int, ObjectInformation>{};
    PdfReader reader = this.reader;
    PdfParser parser = this.parser;
    reader.position = startingOffset;
    reader.skipWhiteSpace();
    _whiteSpace = reader.position;
    int position = reader.seekEnd()!;
    checkStartXRef();
    reader.position = position;
    final int endPosition = reader.searchBack(PdfOperators.endOfFileMarker);
    if (endPosition != -1) {
      if (position != endPosition + 5) {
        reader.position = endPosition + 5;
        final String token = reader.getNextToken()!;
        if (token.isNotEmpty && token.codeUnitAt(0) != 0 && token[0] != '0') {
          reader.position = 0;
          final List<int> buffer = reader.readBytes(endPosition + 5);
          reader = PdfReader(buffer);
          reader.position = buffer.length;
          parser = PdfParser(this, reader, _crossTable);
          _reader = reader;
          _parser = parser;
        }
      }
    } else {
      reader.position = position;
    }
    position = reader.searchBack(PdfOperators.startCrossReference);
    bool isForwardSearch = false;
    if (position >= 0) {
      parser.setOffset(position);
      position = parser.startCrossReference();
      startCrossReference = position;
      _parser!.setOffset(position);
      if (_whiteSpace != 0) {
        final int crossReferencePosition =
            reader.searchForward(PdfOperators.crossReference);
        if (crossReferencePosition == -1) {
          isForwardSearch = false;
          position += _whiteSpace;
          reader.position = position;
        } else {
          position = crossReferencePosition;
          parser.setOffset(position);
          isForwardSearch = true;
        }
      }
    }
    String tempString = reader.readLine();
    if (!tempString.contains(PdfOperators.crossReference) &&
        !tempString.contains(PdfOperators.obj) &&
        !isForwardSearch) {
      final int rposition = reader.position;
      final String tempS = reader.readLine();
      if (tempS.contains(PdfOperators.crossReference)) {
        tempString = tempS;
        position = rposition;
      } else {
        reader.position = rposition;
      }
    }
    if (!tempString.contains(PdfOperators.crossReference) &&
        !tempString.contains(PdfOperators.obj) &&
        !isForwardSearch) {
      if (position > reader.length!) {
        position = reader.length!;
        reader.position = position;
        position = reader.searchBack(PdfOperators.startCrossReference);
      }
      final int tempOffset = reader.searchBack(PdfOperators.crossReference);
      if (tempOffset != -1) {
        position = tempOffset;
      }
      parser.setOffset(position);
    }
    reader.position = position;
    try {
      final Map<String, dynamic> tempResult =
          parser.parseCrossReferenceTable(objects, this);
      trailer = tempResult['object'] as PdfDictionary?;
      objects = tempResult['objects'] as Map<int, ObjectInformation>;
    } catch (e) {
      throw ArgumentError.value(trailer, 'Invalid cross reference table.');
    }
    PdfDictionary trailerObj = trailer!;
    while (trailerObj.containsKey(PdfDictionaryProperties.prev)) {
      if (_whiteSpace != 0) {
        final PdfNumber number =
            trailerObj[PdfDictionaryProperties.prev]! as PdfNumber;
        number.value = number.value! + _whiteSpace;
        _isStructureAltered = true;
      }
      position = (trailerObj[PdfDictionaryProperties.prev]! as PdfNumber)
          .value!
          .toInt();
      final PdfReader tokenReader = PdfReader(_reader!.streamReader.data);
      tokenReader.position = position;
      String? token = tokenReader.getNextToken();
      if (token != PdfDictionaryProperties.crossReference) {
        token = tokenReader.getNextToken();
        //check the coditon for valid object number
        final int? number = int.tryParse(token!);
        if (number != null && number >= 0) {
          token = tokenReader.getNextToken();
          if (token == PdfDictionaryProperties.obj) {
            parser.setOffset(position);
            final Map<String, dynamic> tempResults =
                parser.parseCrossReferenceTable(objects, this);
            trailerObj = tempResults['object'] as PdfDictionary;
            objects = tempResults['objects'] as Map<int, ObjectInformation>;
            parser.setOffset(position);
            continue;
          }
        }
        parser.rebuildXrefTable(objects, this);
        break;
      } else {
        parser.setOffset(position);
        final Map<String, dynamic> tempResults =
            parser.parseCrossReferenceTable(objects, this);
        trailerObj = tempResults['object'] as PdfDictionary;
        objects = tempResults['objects'] as Map<int, ObjectInformation>;
        if (trailerObj.containsKey(PdfDictionaryProperties.size) &&
            trailer!.containsKey(PdfDictionaryProperties.size)) {
          if ((trailerObj[PdfDictionaryProperties.size]! as PdfNumber).value! >
              (trailer![PdfDictionaryProperties.size]! as PdfNumber).value!) {
            (trailer![PdfDictionaryProperties.size]! as PdfNumber).value =
                (trailerObj[PdfDictionaryProperties.size]! as PdfNumber).value;
          }
        }
      }
    }
    if (_whiteSpace != 0 && isForwardSearch) {
      List<int> objKey = List<int>.filled(objects.length, 0);
      objKey = objects.keys.toList();
      for (int i = 0; i < objKey.length; i++) {
        final int key = objKey[i];
        final ObjectInformation info = objects[key]!;
        objects[key] =
            ObjectInformation(info._offset! + _whiteSpace, null, this);
      }
      _isStructureAltered = true;
    } else if (_whiteSpace != 0 && _whiteSpace > 0 && !_isStructureAltered) {
      if (!trailerObj.containsKey(PdfDictionaryProperties.prev)) {
        _isStructureAltered = true;
      }
    }
  }

  ObjectInformation? _returnValue(int? key) {
    return objects.containsKey(key) ? objects[key!] : null;
  }

  /// internal method
  IPdfPrimitive? getObject(IPdfPrimitive? pointer) {
    if (pointer == null) {
      throw ArgumentError.value(pointer, 'pointer');
    }
    if (pointer is PdfReference) {
      IPdfPrimitive? obj;
      final PdfReference reference = pointer;
      final ObjectInformation? oi = this[reference.objNum];
      if (oi == null) {
        return PdfNull();
      }
      final PdfParser? parser = oi.parser;
      final int? position = oi.offset;
      if (oi.obj != null) {
        obj = oi.obj;
      } else if (oi._archive == null) {
        obj = parser!.parseOffset(position!);
      } else {
        obj = _getObjectFromPosition(parser!, position!);
        if (encryptor != null) {
          if (obj is PdfDictionary) {
            obj.decrypted = true;
            for (final dynamic element in obj.items!.values) {
              if (element is PdfString) {
                element.isParentDecrypted = true;
              }
            }
          }
        }
      }
      oi.obj = obj;
      return obj;
    } else {
      return pointer;
    }
  }

  IPdfPrimitive? _getObjectFromPosition(PdfParser parser, int position) {
    parser.startFrom(position);
    return parser.simple();
  }

  /// internal method
  Map<int, ObjectInformation>? parseNewTable(
      PdfStream? stream, Map<int, ObjectInformation>? objects) {
    if (stream == null) {
      throw ArgumentError.value(stream, 'Invalid format');
    }
    stream.decompress();
    final List<_SubSection> subSections = _getSections(stream);
    int? ssIndex = 0;
    for (int i = 0; i < subSections.length; i++) {
      final _SubSection ss = subSections[i];
      final Map<String, dynamic> result =
          _parseWithHashTable(stream, ss, objects, ssIndex);
      ssIndex = result['index'] as int?;
      objects = result['objects'] as Map<int, ObjectInformation>?;
    }
    return objects;
  }

  Map<String, dynamic> _parseWithHashTable(
      PdfStream stream,
      _SubSection subsection,
      Map<int, ObjectInformation>? table,
      int? startIndex) {
    int? index = startIndex;
    final IPdfPrimitive? entry = getObject(stream[PdfDictionaryProperties.w]);
    if (entry is PdfArray) {
      final int fields = entry.count;
      final List<int> format = List<int>.filled(fields, 0, growable: true);
      for (int i = 0; i < fields; ++i) {
        final PdfNumber formatNumber = entry[i]! as PdfNumber;
        format[i] = formatNumber.value!.toInt();
      }
      final List<int> reference = List<int>.filled(fields, 0, growable: true);
      final List<int>? buf = stream.dataStream;
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
        if (reference[0] == PdfObjectType.normal.index) {
          if (_whiteSpace != 0) {
            offset = reference[1] + _whiteSpace;
          } else {
            offset = reference[1];
          }
        } else if (reference[0] == PdfObjectType.packed.index) {
          ai =
              _ArchiveInformation(reference[1], reference[2], _retrieveArchive);
        }
        ObjectInformation? oi;
        // NOTE: do not store removed objects.
        if (reference[0] != PdfObjectType.free.index) {
          oi = ObjectInformation(offset, ai, this);
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

  PdfStream _retrieveArchive(int archiveNumber) {
    PdfStream? archive;
    if (_archives.containsKey(archiveNumber)) {
      archive = _archives[archiveNumber];
    }
    if (archive == null) {
      final ObjectInformation oi = this[archiveNumber]!;
      final PdfParser parser = oi.parser!;
      archive = parser.parseOffset(oi._offset!) as PdfStream?;
      if (encryptor != null && !encryptor!.encryptAttachmentOnly!) {
        archive!.decrypt(encryptor!, archiveNumber);
      }
      archive!.decompress();
      _archives[archiveNumber] = archive;
    }
    return archive;
  }

  List<_SubSection> _getSections(PdfStream stream) {
    final List<_SubSection> subSections = <_SubSection>[];
    int count = 0;
    if (stream.containsKey(PdfDictionaryProperties.size)) {
      final IPdfPrimitive? primitive = stream[PdfDictionaryProperties.size];
      if (primitive is PdfNumber) {
        count = primitive.value!.toInt();
      }
    }
    if (count == 0) {
      throw ArgumentError.value(count, 'Invalid Format');
    }
    final IPdfPrimitive? obj = stream[PdfDictionaryProperties.index];
    if (obj == null) {
      subSections.add(_SubSection(count));
    } else {
      final IPdfPrimitive? primitive = getObject(obj);
      if (primitive != null && primitive is PdfArray) {
        final PdfArray indices = primitive;
        if ((indices.count & 1) != 0) {
          throw ArgumentError.value(count, 'Invalid Format');
        }
        for (int i = 0; i < indices.count; ++i) {
          int n = 0, c = 0;
          n = (indices[i]! as PdfNumber).value!.toInt();
          ++i;
          c = (indices[i]! as PdfNumber).value!.toInt();
          subSections.add(_SubSection(c, n));
        }
      }
    }
    return subSections;
  }

  /// internal method
  void parseSubsection(PdfParser parser, Map<int, ObjectInformation>? table) {
    // Read the initial number of the subsection.
    PdfNumber integer = parser.simple()! as PdfNumber;

    initialNumberOfSubsection = integer.value!.toInt();
    // Read the total number of subsection.
    integer = parser.simple()! as PdfNumber;

    totalNumberOfSubsection = integer.value!.toInt();
    initialSubsectionCount = initialNumberOfSubsection;
    for (int i = 0; i < totalNumberOfSubsection; ++i) {
      integer = parser.simple()! as PdfNumber;
      final int offset = integer.value!.toInt();
      integer = parser.simple()! as PdfNumber;
      final int genNum = integer.value!.toInt();
      final String flag = parser.getObjectFlag();
      if (flag == 'n') {
        final ObjectInformation oi = ObjectInformation(offset, null, this);
        int objectOffset = 0;
        if (initialSubsectionCount == initialNumberOfSubsection) {
          objectOffset = initialNumberOfSubsection + i;
        } else {
          objectOffset = initialSubsectionCount + i;
        }
        if (!table!.containsKey(objectOffset)) {
          table[objectOffset] = oi;
        }
        _addTables(objectOffset, oi);
      } else {
        if (initialNumberOfSubsection != 0 &&
            offset == 0 &&
            genNum == _generationNumber) {
          initialNumberOfSubsection = initialNumberOfSubsection - 1;
          if (i == 0) {
            initialSubsectionCount = initialNumberOfSubsection;
          }
        }
      }
    }
  }

  void _addTables(int objectOffset, ObjectInformation oi) {
    if (_allTables.containsKey(objectOffset)) {
      _allTables[objectOffset]!.add(oi);
    } else {
      _allTables[objectOffset] = <ObjectInformation>[oi];
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

  /// internal method
  void checkStartXRef() {
    const int maxSize = 1024;
    int pos = reader.length! - maxSize;
    if (pos < 1) {
      pos = 1;
    }
    List<int>? data = List<int>.filled(maxSize, 0);
    while (pos > 0) {
      reader.position = pos;
      final Map<String, dynamic> result = reader.copyBytes(data, 0, maxSize);
      data = result['buffer'] as List<int>?;
      final String start = String.fromCharCodes(data!);
      final int index = start.lastIndexOf('startxref');
      if (index >= 0) {
        reader.position = index;
        break;
      }
      pos = pos - maxSize + 9;
    }
  }

  /// internal method
  PdfParser? retrieveParser(_ArchiveInformation? archive) {
    if (archive == null) {
      return _parser;
    } else {
      final PdfStream stream = archive.archive;
      PdfParser? parser;
      if (_readersTable.containsKey(stream)) {
        parser = _readersTable[stream];
      }
      if (parser == null) {
        final PdfReader reader = PdfReader(stream.dataStream);
        parser = PdfParser(this, reader, _crossTable);
        _readersTable[stream] = parser;
      }
      return parser;
    }
  }
}

/// internal class
class ObjectInformation {
  //Constructor
  /// internal constructor
  ObjectInformation(
      int offset, _ArchiveInformation? arciveInfo, CrossTable? crossTable) {
    _offset = offset;
    _archive = arciveInfo;
    _crossTable = crossTable;
  }
  //Fields
  _ArchiveInformation? _archive;
  PdfParser? _parser;
  int? _offset;
  CrossTable? _crossTable;

  /// internal Fields
  IPdfPrimitive? obj;

  //Properties
  /// internal property
  PdfParser? get parser {
    _parser ??= _crossTable!.retrieveParser(_archive);
    return _parser;
  }

  /// internal property
  int? get offset {
    if (_offset == 0) {
      final PdfParser parser = this.parser!;
      parser.startFrom(0);
      int pairs = 0;
      // Read indices.
      if (_archive != null) {
        final PdfNumber? archieveNumber =
            _archive!.archive[PdfDictionaryProperties.n] as PdfNumber?;
        if (archieveNumber != null) {
          pairs = archieveNumber.value!.toInt();
        }
        final List<int> indices =
            List<int>.filled(pairs * 2, 0, growable: true);
        for (int i = 0; i < pairs; ++i) {
          PdfNumber? obj = parser.simple() as PdfNumber?;
          if (obj != null) {
            indices[i * 2] = obj.value!.toInt();
          }
          obj = parser.simple() as PdfNumber?;
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
            (_archive!.archive[PdfDictionaryProperties.first]! as PdfNumber)
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
  PdfStream? _archive;
  late _GetArchive _getArchive;

  //Properties
  PdfStream get archive {
    _archive ??= _getArchive(_archiveNumber);
    return _archive!;
  }
}

typedef _GetArchive = PdfStream Function(int archiveNumber);

class _SubSection {
  //constructor
  _SubSection(this.count, [int? start]) {
    startNumber = start ?? 0;
  }

  late int startNumber;
  late int count;
}
