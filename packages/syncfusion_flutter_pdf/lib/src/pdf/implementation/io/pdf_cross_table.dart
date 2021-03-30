part of pdf;

/// PDFCrossTable is responsible for intermediate level parsing and
/// savingof a PDF document.
class _PdfCrossTable {
  //Constructor
  _PdfCrossTable([PdfDocument? document, List<int>? data]) {
    if (document != null) {
      _document = document;
      _objNumbers = Queue<_PdfReference>();
      if (data != null) {
        _data = data;
        _initializeCrossTable();
        _document = document;
      }
    }
    _isColorSpace = false;
  }
  _PdfCrossTable._fromCatalog(int tableCount,
      _PdfDictionary? encryptionDictionary, _PdfDictionary? documentCatalog) {
    _storedCount = tableCount;
    _encryptorDictionary = encryptionDictionary;
    _documentCatalog = documentCatalog;
    _bForceNew = true;
    _isColorSpace = false;
  }
  //Fields
  PdfDocument? _pdfDocument;
  int _count = 0;
  _PdfMainObjectCollection? _items;
  _PdfDictionary? _trailer;
  Map<int?, _RegisteredObject>? _objects = <int?, _RegisteredObject>{};
  List<int>? _data;
  _CrossTable? _crossTable;
  late Queue<_PdfReference> _objNumbers;
  _PdfDictionary? _documentCatalog;
  bool _isIndexOutOfRange = false;
  _PdfDictionary? _encryptorDictionary;
  List<_ArchiveInfo>? _archives;
  _PdfArchiveStream? _archive;
  double _maxGenNumIndex = 0;
  late int _storedCount;
  bool _bForceNew = false;
  Map<_PdfReference, _PdfReference>? _mappedReferences;
  List<_PdfReference?>? _prevRef;
  late bool _isColorSpace;

  //Properties
  int get nextObjectNumber {
    if (count == 0) {
      count++;
    }
    return count++;
  }

  _PdfEncryptor? get encryptor {
    return _crossTable == null ? null : _crossTable!.encryptor;
  }

  set encryptor(_PdfEncryptor? value) {
    if (value != null) {
      _crossTable!.encryptor = value._clone();
    }
  }

  _PdfDictionary? get documentCatalog {
    if (_documentCatalog == null && _crossTable != null) {
      _documentCatalog =
          _dereference(_crossTable!.documentCatalog) as _PdfDictionary?;
    }
    return _documentCatalog;
  }

  _PdfDictionary? get trailer {
    _trailer ??= _crossTable == null ? _PdfStream() : _crossTable!._trailer;
    return _trailer;
  }

  _PdfDictionary? get encryptorDictionary {
    if (_encryptorDictionary == null &&
        trailer!.containsKey(_DictionaryProperties.encrypt)) {
      final _IPdfPrimitive? primitive =
          _dereference(trailer![_DictionaryProperties.encrypt]);
      if (primitive is _PdfDictionary) {
        _encryptorDictionary = primitive;
      }
    }
    return _encryptorDictionary;
  }

  int get count {
    if (_count == 0) {
      _IPdfPrimitive? obj;
      _PdfNumber? tempCount;
      if (_crossTable != null) {
        obj = _crossTable!._trailer![_DictionaryProperties.size];
      }
      if (obj != null) {
        tempCount = _dereference(obj) as _PdfNumber?;
      } else {
        tempCount = _PdfNumber(0);
      }
      _count = tempCount!.value!.toInt();
    }
    return _count;
  }

  set count(int value) {
    _count = value;
  }

  _PdfMainObjectCollection? get _objectCollection => _pdfDocument!._objects;
  PdfDocument? get _document => _pdfDocument;
  set _document(PdfDocument? document) {
    if (document == null) {
      throw ArgumentError('Document');
    }
    _pdfDocument = document;
    _items = _pdfDocument!._objects;
  }

  List<_PdfReference?>? get _prevReference =>
      (_prevRef != null) ? _prevRef : _prevRef = <_PdfReference>[];

  set _prevReference(List<_PdfReference?>? value) {
    if (value != null) {
      _prevRef = value;
    }
  }

  //Implementation
  void _initializeCrossTable() {
    _crossTable = _CrossTable(_data, this);
  }

  void _markTrailerReferences() {
    trailer!._items!.forEach((_PdfName? name, _IPdfPrimitive? element) {
      if (element is _PdfReferenceHolder) {
        final _PdfReferenceHolder rh = element;
        if (!_document!._objects.contains(rh.object!)) {
          _document!._objects._add(rh.object);
        }
      }
    });
  }

  void _save(_PdfWriter writer) {
    _saveHead(writer);
    _objects!.clear();
    if (_archives != null) {
      _archives!.clear();
    }
    _archive = null;
    _markTrailerReferences();
    _saveObjects(writer);
    final int saveCount = count;
    if (_document!._isLoadedDocument) {
      writer._position = writer._length;
    }
    if (_isCrossReferenceStream(writer._document)) {
      _saveArchives(writer);
    }
    _registerObject(_PdfReference(0, -1), position: 0, isFreeType: true);
    final int? referencePosition = writer._position;
    final int prevXRef =
        _crossTable == null ? 0 : _crossTable!._startCrossReference;
    if (_isCrossReferenceStream(writer._document)) {
      _PdfReference? xRefReference;
      final Map<String, _IPdfPrimitive> returnedValue = _prepareXRefStream(
          prevXRef.toDouble(), referencePosition!.toDouble(), xRefReference);
      final _PdfStream xRefStream = returnedValue['xRefStream'] as _PdfStream;
      xRefReference = returnedValue['reference'] as _PdfReference?;
      xRefStream._blockEncryption = true;
      _doSaveObject(xRefStream, xRefReference!, writer);
    } else {
      writer._write(_Operators.crossReference);
      writer._write(_Operators.newLine);
      _saveSections(writer);
      _saveTrailer(writer, count, prevXRef);
    }
    _saveEnd(writer, referencePosition);
    count = saveCount;
    for (int i = 0; i < _objectCollection!._count; i++) {
      final _ObjectInfo objectInfo = _objectCollection![i];
      objectInfo._object!.isSaving = false;
    }
  }

  void _saveHead(_PdfWriter writer) {
    writer._write('%PDF-');
    final String version = _generateFileVersion(writer._document!);
    writer._write(version);
    writer._write(_Operators.newLine);
    writer._write(<int>[0x25, 0x83, 0x92, 0xfa, 0xfe]);
    writer._write(_Operators.newLine);
  }

  String _generateFileVersion(PdfDocument document) {
    if (document.fileStructure.version == PdfVersion.version2_0) {
      const String version = '2.0';
      return version;
    } else {
      return '1.' + document.fileStructure.version.index.toString();
    }
  }

  void _saveObjects(_PdfWriter writer) {
    final _PdfMainObjectCollection objectCollection = _objectCollection!;
    if (_bForceNew) {
      count = 1;
      _mappedReferences = null;
    }
    _setSecurity();
    for (int i = 0; i < objectCollection._count; i++) {
      final _ObjectInfo objInfo = objectCollection[i];
      if (objInfo._modified! || _bForceNew) {
        final _IPdfPrimitive obj = objInfo._object!;
        final _IPdfPrimitive? reference = objInfo._reference;
        if (reference == null) {
          final _PdfReference ref = _getReference(obj);
          objInfo._reference = ref;
        }
        _saveIndirectObject(obj, writer);
      }
    }
  }

  void _setSecurity() {
    final PdfSecurity security = _document!.security;
    trailer!.encrypt = false;
    if (security._encryptor.encrypt) {
      _PdfDictionary? securityDictionary = encryptorDictionary;
      if (securityDictionary == null) {
        securityDictionary = _PdfDictionary();
        securityDictionary.encrypt = false;
        _document!._objects._add(securityDictionary);
        securityDictionary.position = -1;
      }
      securityDictionary =
          security._encryptor._saveToDictionary(securityDictionary);
      trailer![_DictionaryProperties.id] = security._encryptor.fileID;
      trailer![_DictionaryProperties.encrypt] =
          _PdfReferenceHolder(securityDictionary);
    } else if (!security._encryptor.encryptOnlyAttachment) {
      if (trailer!.containsKey(_DictionaryProperties.encrypt)) {
        trailer!.remove(_DictionaryProperties.encrypt);
      }
      if (trailer!.containsKey(_DictionaryProperties.id) &&
          !_document!.fileStructure._fileID) {
        trailer!.remove(_DictionaryProperties.id);
      }
    }
  }

  void _saveIndirectObject(_IPdfPrimitive object, _PdfWriter writer) {
    final _PdfReference reference = _getReference(object);
    if (object is _PdfCatalog) {
      trailer![_DictionaryProperties.root] = reference;
      //NOTE: This is needed to get PDF/A Conformance.
      if (_document != null &&
          _document!._conformanceLevel != PdfConformanceLevel.none) {
        trailer![_DictionaryProperties.id] =
            _document!.security._encryptor.fileID;
      }
    }
    _document!._currentSavingObject = reference;
    bool archive = false;
    archive = (object is _PdfDictionary) ? object._archive : true;
    final bool allowedType =
        !((object is _PdfStream) || !(archive) || (object is _PdfCatalog));
    bool sigFlag = false;
    if (object is _PdfDictionary &&
        _document!.fileStructure.crossReferenceType ==
            PdfCrossReferenceType.crossReferenceStream) {
      final _PdfDictionary dictionary = object;
      if (dictionary.containsKey(_DictionaryProperties.type)) {
        final _PdfName? name =
            dictionary[_DictionaryProperties.type] as _PdfName?;
        if (name != null && name._name! == 'Sig') {
          sigFlag = true;
        }
      }
    }
    if (allowedType &&
        _isCrossReferenceStream(writer._document) &&
        reference._genNum == 0 &&
        !sigFlag) {
      _doArchiveObject(object, reference, writer);
    } else {
      _registerObject(reference, position: writer._position);
      _doSaveObject(object, reference, writer);
      if (object == _archive) {
        _archive = null;
      }
    }
  }

  _PdfReference _getReference(_IPdfPrimitive? object) {
    if (object is _PdfArchiveStream) {
      final _PdfReference r = _findArchiveReference(object);
      return r;
    }
    if (object is _PdfReferenceHolder) {
      object = object.object;
      if (_document != null && !_document!._isLoadedDocument) {
        object!.isSaving = true;
      }
    }
    if (object is _IPdfWrapper) {
      object = (object as _IPdfWrapper)._element;
    }
    dynamic reference;
    bool? wasNew = false;
    if (object!.isSaving!) {
      if (_items!._count > 0 &&
          object.objectCollectionIndex! > 0 &&
          _items!._count > object.objectCollectionIndex! - 1) {
        final Map<String, dynamic> result =
            _document!._objects._getReference(object, wasNew);
        wasNew = result['isNew'];
        reference = result['reference'];
      }
    } else {
      final Map<String, dynamic> result =
          _document!._objects._getReference(object, wasNew);
      wasNew = result['isNew'];
      reference = result['reference'];
    }
    if (reference == null) {
      if (object.status == _ObjectStatus.registered) {
        wasNew = false;
      } else {
        wasNew = true;
      }
    } else {
      wasNew = false;
    }
    if (_bForceNew) {
      if (reference == null) {
        int maxObj =
            (_storedCount > 0) ? _storedCount++ : _document!._objects._count;
        if (maxObj <= 0) {
          maxObj = -1;
          _storedCount = 2;
        }
        while (_document!._objects._mainObjectCollection!.containsKey(maxObj)) {
          maxObj++;
        }
        reference = _PdfReference(maxObj, 0);
        if (wasNew) {
          _document!._objects._add(object, reference);
        }
      }
      reference = getMappedReference(reference);
    }
    if (reference == null) {
      int objectNumber = nextObjectNumber;
      if (_crossTable != null) {
        while (_crossTable!._objects.containsKey(objectNumber)) {
          objectNumber = nextObjectNumber;
        }
      }
      if (_document!._objects._mainObjectCollection!
          .containsKey(objectNumber)) {
        reference = _PdfReference(nextObjectNumber, 0);
      } else {
        _PdfNumber? trailerCount;
        if (_crossTable != null) {
          trailerCount =
              _crossTable!._trailer![_DictionaryProperties.size] as _PdfNumber?;
        }
        if (trailerCount != null && objectNumber == trailerCount.value) {
          reference = _PdfReference(nextObjectNumber, 0);
        } else {
          reference = _PdfReference(objectNumber, 0);
        }
      }
      if (wasNew) {
        if (object is _IPdfChangable) {
          (object as _IPdfChangable).changed = true;
        }
        _document!._objects._add(object);
        _document!._objects._trySetReference(object, reference);
        final int tempIndex = _document!._objects._count - 1;
        final int? tempkey = _document!
            ._objects._objectCollection![tempIndex]._reference!._objNum;
        final _ObjectInfo tempvalue = _document!
            ._objects._objectCollection![_document!._objects._count - 1];
        _document!._objects._mainObjectCollection![tempkey] = tempvalue;
        object.position = -1;
      } else {
        _document!._objects._trySetReference(object, reference);
      }
      object.objectCollectionIndex = reference._objNum;
      object.status = _ObjectStatus.none;
    }
    return reference;
  }

  _PdfReference getMappedReference(_PdfReference reference) {
    _mappedReferences ??= <_PdfReference, _PdfReference>{};
    _PdfReference? mref = _mappedReferences!.containsKey(reference)
        ? _mappedReferences![reference]
        : null;
    if (mref == null) {
      mref = _PdfReference(nextObjectNumber, 0);
      _mappedReferences![reference] = mref;
    }
    return mref;
  }

  void _registerObject(_PdfReference reference,
      {int? position, _PdfArchiveStream? archive, bool? isFreeType}) {
    if (isFreeType == null) {
      if (position != null) {
        _objects![reference._objNum] = _RegisteredObject(position, reference);
        _maxGenNumIndex = max(_maxGenNumIndex, reference._genNum!.toDouble());
      } else {
        _objects![reference._objNum] =
            _RegisteredObject.fromArchive(this, archive, reference);
        _maxGenNumIndex = max(_maxGenNumIndex, archive!.count.toDouble());
      }
    } else {
      _objects![reference._objNum] =
          _RegisteredObject(position, reference, isFreeType);
      _maxGenNumIndex = max(_maxGenNumIndex, reference._genNum!.toDouble());
    }
  }

  void _doSaveObject(
      _IPdfPrimitive object, _PdfReference reference, _PdfWriter writer) {
    writer._write(reference._objNum);
    writer._write(_Operators.whiteSpace);
    writer._write(reference._genNum);
    writer._write(_Operators.whiteSpace);
    writer._write(_Operators.obj);
    writer._write(_Operators.newLine);
    object.save(writer);
    if (object is _PdfName || object is _PdfNumber || object is _PdfNull) {
      writer._write(_Operators.newLine);
    }
    writer._write(_Operators.endobj);
    writer._write(_Operators.newLine);
  }

  void _saveSections(_IPdfWriter writer) {
    int objectNumber = 0;
    int? count = 0;
    do {
      final Map<String, int> result = _prepareSubsection(objectNumber);
      count = result['count'];
      objectNumber = result['objectNumber']!;
      _saveSubsection(writer, objectNumber, count!);
      objectNumber += count;
    } while (count != 0);
  }

  Map<String, int> _prepareSubsection(int objectNumber) {
    int tempCount = 0;
    int i;
    int total = count;
    if (total <= 0) {
      total = _document!._objects._count + 1;
    }
    if (total < _document!._objects._maximumReferenceObjectNumber!) {
      total = _document!._objects._maximumReferenceObjectNumber!;
      _isIndexOutOfRange = true;
    }
    if (objectNumber >= total) {
      return <String, int>{'count': tempCount, 'objectNumber': objectNumber};
    }
    for (i = objectNumber; i < total; ++i) {
      if (_objects!.containsKey(i)) {
        break;
      }
    }
    objectNumber = i;
    for (; i < total; ++i) {
      if (!_objects!.containsKey(i)) {
        break;
      }
      ++tempCount;
    }
    return <String, int>{'count': tempCount, 'objectNumber': objectNumber};
  }

  void _saveSubsection(_IPdfWriter writer, int? objectNumber, int tempCount) {
    if (tempCount <= 0 || objectNumber! >= count && !_isIndexOutOfRange) {
      return;
    }

    writer._write(objectNumber.toString() +
        ' ' +
        (tempCount).toString() +
        _Operators.newLine);
    for (int i = objectNumber; i < objectNumber + tempCount; ++i) {
      final _RegisteredObject obj = _objects![i]!;
      String value = '';
      if (obj._type == _ObjectType.free) {
        value = _getItem(obj._offset, 65535, true);
      } else {
        value = _getItem(obj._offset, obj._generationNumber!, false);
      }
      writer._write(value);
    }
  }

  String _getItem(int? offset, int generationNumber, bool isFreeType) {
    String result = '';
    final int offsetLength = 10 - offset.toString().length;
    if (generationNumber <= 0) {
      generationNumber = 0;
    }
    final int generationNumberLength =
        (5 - generationNumber.toString().length) <= 0
            ? 0
            : (5 - generationNumber.toString().length);
    for (int index = 0; index < offsetLength; index++) {
      result = result + '0';
    }
    result = result + offset.toString() + ' ';
    for (int index = 0; index < generationNumberLength; index++) {
      result = result + '0';
    }
    result = result + generationNumber.toString() + ' ';
    result = result +
        (isFreeType ? _Operators.f : _Operators.n) +
        _Operators.newLine;
    return result;
  }

  void _saveTrailer(_IPdfWriter writer, int count, int prevCrossReference) {
    writer._write(_Operators.trailer);
    writer._write(_Operators.newLine);
    _PdfDictionary trailerDictionary = trailer!;
    if (prevCrossReference != 0) {
      trailer![_DictionaryProperties.prev] = _PdfNumber(prevCrossReference);
    }
    trailerDictionary[_DictionaryProperties.size] = _PdfNumber(_count);
    trailerDictionary = _PdfDictionary(trailerDictionary);
    trailerDictionary.encrypt = false;
    trailerDictionary.save(writer);
  }

  void _saveEnd(_IPdfWriter writer, int? position) {
    writer._write(_Operators.newLine +
        _Operators.startCrossReference +
        _Operators.newLine);
    writer._write(position.toString() + _Operators.newLine);
    writer._write(_Operators.endOfFileMarker);
    writer._write(_Operators.newLine);
  }

  static _IPdfPrimitive? _dereference(_IPdfPrimitive? element) {
    if (element != null && element is _PdfReferenceHolder) {
      final _PdfReferenceHolder holder = element;
      return holder.object;
    }
    return element;
  }

  void _dispose() {
    if (_items != null) {
      _items!._dispose();
      _items = null;
    }
    if (_objects != null && _objects!.isNotEmpty) {
      _objects!.clear();
      _objects = null;
    }
  }

  _IPdfPrimitive? _getObject(_IPdfPrimitive? pointer) {
    bool isEncryptedMetadata = true;
    _IPdfPrimitive? result = pointer;
    if (pointer is _PdfReferenceHolder) {
      result = pointer.object;
    } else if (pointer is _PdfReference) {
      final _PdfReference reference = pointer;
      _objNumbers.addLast(pointer);
      _IPdfPrimitive? obj;
      if (_crossTable != null) {
        obj = _crossTable!._getObject(pointer);
      } else {
        final int? index = _items!._getObjectIndex(reference);
        if (index == 0) {
          obj = _items!._getObjectFromReference(reference);
        }
      }
      obj = _pageProceed(obj);
      final _PdfMainObjectCollection? goc = _items;
      if (obj != null) {
        if (goc!._containsReference(reference)) {
          goc._getObjectIndex(reference);
          obj = goc._getObjectFromReference(reference);
        } else {
          goc._add(obj, reference);
          obj.position = -1;
          reference.position = -1;
        }
      }
      result = obj;
      if (obj != null && obj is _PdfDictionary) {
        final _PdfDictionary dictionary = obj;
        if (dictionary.containsKey(_DictionaryProperties.type)) {
          final _IPdfPrimitive? primitive =
              dictionary[_DictionaryProperties.type];
          if (primitive != null &&
              primitive is _PdfName &&
              primitive._name == _DictionaryProperties.metadata) {
            if (encryptor != null) {
              isEncryptedMetadata = encryptor!.encryptMetadata;
            }
          }
        }
      }
      if (_document!._isEncrypted && isEncryptedMetadata) {
        _decrypt(result);
      }
    }
    if (pointer is _PdfReference) {
      _objNumbers.removeLast();
    }
    return result;
  }

  _IPdfPrimitive? _pageProceed(_IPdfPrimitive? obj) {
    if (obj is PdfPage) {
      return obj;
    }
    if (obj is _PdfDictionary) {
      final _PdfDictionary dic = obj;
      if (!(obj is PdfPage)) {
        if (dic.containsKey(_DictionaryProperties.type)) {
          final _IPdfPrimitive? objType = dic[_DictionaryProperties.type];
          if (objType is _PdfName) {
            final _PdfName type = _getObject(objType) as _PdfName;
            if (type._name == 'Page') {
              if (!dic.containsKey(_DictionaryProperties.kids)) {
                if (_pdfDocument!._isLoadedDocument) {
                  final PdfPage lPage = _pdfDocument!.pages._getPage(dic);
                  obj = lPage._element;
                  final _PdfMainObjectCollection items = _pdfDocument!._objects;
                  final int index = items._lookFor(dic)!;
                  if (index >= 0) {
                    items._reregisterReference(index, obj!);
                    obj.position = -1;
                  }
                }
              }
            }
          }
        }
      }
    }
    return obj;
  }

  bool _isCrossReferenceStream(PdfDocument? document) {
    ArgumentError.notNull('document');
    bool result = false;
    if (_crossTable != null) {
      if (_crossTable!._trailer is _PdfStream) {
        result = true;
      }
    } else {
      result = document!.fileStructure.crossReferenceType ==
          PdfCrossReferenceType.crossReferenceStream;
    }
    return result;
  }

  void _saveArchives(_PdfWriter writer) {
    if (_archives != null) {
      for (final _ArchiveInfo ai in _archives!) {
        _PdfReference? reference = ai._reference;
        if (reference == null) {
          reference = _PdfReference(nextObjectNumber, 0);
          ai._reference = reference;
        }
        _document!._currentSavingObject = reference;
        _registerObject(reference, position: writer._position);
        _doSaveObject(ai._archive!, reference, writer);
      }
    }
  }

  void _doArchiveObject(
      _IPdfPrimitive obj, _PdfReference reference, _PdfWriter writer) {
    if (_archive == null) {
      _archive = _PdfArchiveStream(_document);
      _saveArchive(writer);
    }
    _registerObject(reference, archive: _archive);
    _archive!._saveObject(obj, reference);
    if (_archive!._objCount >= 100) {
      _archive = null;
    }
  }

  void _saveArchive(_PdfWriter writer) {
    final _ArchiveInfo ai = _ArchiveInfo(null, _archive);
    _archives ??= <_ArchiveInfo>[];
    _archives!.add(ai);
  }

  Map<String, _IPdfPrimitive> _prepareXRefStream(
      double prevXRef, double position, _PdfReference? reference) {
    _PdfStream? xRefStream;
    xRefStream = _trailer as _PdfStream?;
    if (xRefStream == null) {
      xRefStream = _PdfStream();
    } else {
      xRefStream.remove(_DictionaryProperties.filter);
      xRefStream.remove(_DictionaryProperties.decodeParms);
    }
    final _PdfArray sectionIndeces = _PdfArray();
    reference = _PdfReference(nextObjectNumber, 0);
    _registerObject(reference, position: position.toInt());

    double objectNum = 0;
    double count = 0;
    final List<int> paramsFormat = <int>[1, 8, 1];
    paramsFormat[1] = max(_getSize(position), _getSize(this.count.toDouble()));
    paramsFormat[2] = _getSize(_maxGenNumIndex);
    final List<int> ms = <int>[];
    while (true) {
      final Map<String, int> result = _prepareSubsection(objectNum.toInt());
      count = result['count']!.toDouble();
      objectNum = result['objectNumber']!.toDouble();
      if (count <= 0) {
        break;
      } else {
        sectionIndeces._add(_PdfNumber(objectNum));
        sectionIndeces._add(_PdfNumber(count));
        _saveSubSection(ms, objectNum, count, paramsFormat);
        objectNum += count;
      }
    }
    //iw.Flush();
    xRefStream._dataStream = ms;
    xRefStream[_DictionaryProperties.index] = sectionIndeces;
    xRefStream[_DictionaryProperties.size] = _PdfNumber(this.count);
    xRefStream[_DictionaryProperties.prev] = _PdfNumber(prevXRef);
    xRefStream[_DictionaryProperties.type] = _PdfName('XRef');
    xRefStream[_DictionaryProperties.w] = _PdfArray(paramsFormat);
    if (_crossTable != null) {
      final _PdfDictionary trailer = _crossTable!._trailer!;
      trailer._items!.keys.forEach((_PdfName? key) {
        final bool contains = xRefStream!.containsKey(key);
        if (!contains &&
            key!._name != _DictionaryProperties.decodeParms &&
            key._name != _DictionaryProperties.filter) {
          xRefStream[key] = trailer[key];
        }
      });
    }
    if (prevXRef == 0 && xRefStream.containsKey(_DictionaryProperties.prev)) {
      xRefStream.remove(_DictionaryProperties.prev);
    }
    xRefStream.encrypt = false;
    return <String, _IPdfPrimitive>{
      'xRefStream': xRefStream,
      'reference': reference
    };
  }

  int _getSize(double number) {
    int size = 0;

    if (number < 4294967295) {
      if (number < 65535) {
        if (number < 255) {
          size = 1;
        } else {
          size = 2;
        }
      } else {
        if (number < (65535 | 65535 << 8)) {
          size = 3;
        } else {
          size = 4;
        }
      }
    } else {
      size = 8;
    }
    return size;
  }

  void _saveSubSection(
      List<int> xRefStream, double objectNum, double count, List<int> format) {
    for (int i = objectNum.toInt(); i < objectNum + count; ++i) {
      final _RegisteredObject obj = _objects![i]!;
      xRefStream.add(obj._type!.index.toUnsigned(8));
      switch (obj._type) {
        case _ObjectType.free:
          _saveLong(xRefStream, obj._objectNumber!.toInt(), format[1]);
          _saveLong(xRefStream, obj._generationNumber, format[2]);
          break;

        case _ObjectType.normal:
          _saveLong(xRefStream, obj.offset, format[1]);
          _saveLong(xRefStream, obj._generationNumber, format[2]);
          break;

        case _ObjectType.packed:
          _saveLong(xRefStream, obj._objectNumber!.toInt(), format[1]);
          _saveLong(xRefStream, obj.offset, format[2]);
          break;

        default:
          throw ArgumentError('Internal error: Undefined object type.');
      }
    }
  }

  void _saveLong(List<int> xRefStream, int? number, int count) {
    for (int i = count - 1; i >= 0; --i) {
      final int b = (number! >> (i << 3) & 255).toUnsigned(8);
      xRefStream.add(b);
    }
  }

  _PdfReference _findArchiveReference(_PdfArchiveStream archive) {
    int i = 0;
    late _ArchiveInfo ai;
    for (final int count = _archives!.length; i < count; ++i) {
      ai = _archives![i];
      if (ai._archive == archive) {
        break;
      }
    }
    _PdfReference? reference = ai._reference;
    reference ??= _PdfReference(nextObjectNumber, 0);
    ai._reference = reference;
    return reference;
  }

  void _decrypt(_IPdfPrimitive? obj) {
    if (obj != null) {
      if (obj is _PdfDictionary || obj is _PdfStream) {
        final _PdfDictionary dic = obj as _PdfDictionary;
        if (!dic.decrypted!) {
          dic._items!.forEach((_PdfName? key, _IPdfPrimitive? element) {
            _decrypt(element);
          });
          if (obj is _PdfStream) {
            final _PdfStream stream = obj;
            if (_document!._isEncrypted &&
                !stream.decrypted! &&
                _objNumbers.isNotEmpty &&
                encryptor != null &&
                !encryptor!._encryptOnlyAttachment!) {
              stream.decrypt(encryptor!, _objNumbers.last._objNum);
            }
          }
        }
      } else if (obj is _PdfArray) {
        final _PdfArray array = obj;
        array._elements.forEach((_IPdfPrimitive? element) {
          if (element != null && element is _PdfName) {
            final _PdfName name = element;
            if (name._name == 'Indexed') {
              _isColorSpace = true;
            }
          }
          _decrypt(element!);
        });
        _isColorSpace = false;
      } else if (obj is _PdfString) {
        final _PdfString str = obj;
        if (!str.decrypted && (!str._isHex! || _isColorSpace)) {
          if (_document!._isEncrypted && _objNumbers.isNotEmpty) {
            obj.decrypt(encryptor!, _objNumbers.last._objNum);
          }
        }
      }
    }
  }
}

/// Represents a registered object.
class _RegisteredObject {
  _RegisteredObject(int? offset, _PdfReference reference, [bool? isFreeType]) {
    _offset = offset;
    _generationNumber = reference._genNum;
    _objNumber = reference._objNum!.toDouble();
    if (isFreeType != null) {
      _type = isFreeType ? _ObjectType.free : _ObjectType.normal;
    } else {
      _type = _ObjectType.normal;
      _objNumber = reference._objNum!.toDouble();
    }
  }

  _RegisteredObject.fromArchive(_PdfCrossTable xrefTable,
      _PdfArchiveStream? archive, _PdfReference reference) {
    _xrefTable = xrefTable;
    _archive = archive;
    _offset = reference._objNum;
    _type = _ObjectType.packed;
  }
  int? _offset;
  int? _generationNumber;
  _ObjectType? _type;
  double? _objNumber;
  late _PdfCrossTable _xrefTable;
  _PdfArchiveStream? _archive;

  int? get offset {
    int? result;
    if (_archive != null) {
      result = _archive!._getIndex(_offset);
    } else {
      result = _offset;
    }
    return result;
  }

  double? get _objectNumber {
    _objNumber ??= 0;
    if (_objNumber == 0) {
      if (_archive != null) {
        _objNumber = _xrefTable._getReference(_archive)._objNum!.toDouble();
      }
    }
    return _objNumber;
  }
}

class _ArchiveInfo {
  // Constructor
  _ArchiveInfo(_PdfReference? reference, _PdfArchiveStream? archive) {
    _reference = reference;
    _archive = archive;
  }
  // Fields
  _PdfReference? _reference;
  _PdfArchiveStream? _archive;
}
