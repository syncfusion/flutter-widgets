part of pdf;

class _PdfReferenceHolder implements _IPdfPrimitive {
  _PdfReferenceHolder(dynamic obj) {
    if (obj == null) {
      throw ArgumentError.value(obj, 'object', 'value cannot be null');
    }
    if (obj is _IPdfWrapper) {
      object = obj._element;
    } else if (obj is _IPdfPrimitive) {
      object = obj;
    } else {
      throw ArgumentError.value(
          'argument is not set to an instance of an object');
    }
  }

  _PdfReferenceHolder.fromReference(
      _PdfReference reference, _PdfCrossTable? crossTable) {
    if (crossTable != null) {
      this.crossTable = crossTable;
    } else {
      throw ArgumentError.value(crossTable, 'crossTable value cannot be null');
    }
    this.reference = reference;
  }

  //Fields
  _IPdfPrimitive? _object;
  _PdfReference? reference;
  bool? _isSaving;
  int? _objectCollectionIndex;
  int? _position;
  _ObjectStatus? _status;
  late _PdfCrossTable crossTable;
  int? _objectIndex = -1;

  //_IPdfPrimitive members
  _IPdfPrimitive? get object {
    if (reference != null || _object == null) {
      _object = _obtainObject();
    }
    return _object;
  }

  set object(_IPdfPrimitive? value) {
    _object = value;
  }

  int? get index {
    final _PdfMainObjectCollection items = crossTable._items!;
    _objectIndex = items._getObjectIndex(reference!);
    if (_objectIndex! < 0) {
      crossTable._getObject(reference);
      _objectIndex = items._count - 1;
    }
    return _objectIndex;
  }

  @override
  bool? get isSaving {
    _isSaving ??= false;
    return _isSaving;
  }

  @override
  set isSaving(bool? value) {
    _isSaving = value;
  }

  @override
  int? get objectCollectionIndex {
    _objectCollectionIndex ??= 0;
    return _objectCollectionIndex;
  }

  @override
  set objectCollectionIndex(int? value) {
    _objectCollectionIndex = value;
  }

  @override
  int? get position {
    _position ??= -1;
    return _position;
  }

  @override
  set position(int? value) {
    _position = value;
  }

  @override
  _ObjectStatus? get status {
    _status ??= _ObjectStatus.none;
    return _status;
  }

  @override
  set status(_ObjectStatus? value) {
    _status = value;
  }

  @override
  _IPdfPrimitive? clonedObject;

  @override
  void save(_IPdfWriter? writer) {
    if (writer != null) {
      if (!writer._document!._isLoadedDocument) {
        object!.isSaving = true;
      }
      final _PdfCrossTable? crossTable = writer._document!._crossTable;
      _PdfReference? pdfReference;
      if (writer._document!.fileStructure.incrementalUpdate &&
          writer._document!._isStreamCopied) {
        if (reference == null) {
          pdfReference = crossTable!._getReference(object);
        } else {
          pdfReference = reference;
        }
      } else {
        pdfReference = crossTable!._getReference(object);
      }
      pdfReference!.save(writer);
    }
  }

  _IPdfPrimitive? _obtainObject() {
    _IPdfPrimitive? obj;
    if (reference != null) {
      if (index! >= 0) {
        obj = crossTable._items!._getObject(reference!);
      }
    } else if (_object != null) {
      obj = _object;
    }
    return obj;
  }

  @override
  void dispose() {
    if (reference != null) {
      reference!.dispose();
      reference = null;
    }
    if (_status != null) {
      _status = null;
    }
  }

  @override
  _IPdfPrimitive _clone(_PdfCrossTable crossTable) {
    _PdfReferenceHolder refHolder;
    _IPdfPrimitive? temp;
    _PdfReference reference;
    if (object is _PdfNumber) {
      return _PdfNumber((object as _PdfNumber).value!);
    }

    if (object is _PdfDictionary) {
      // Meaning the referenced page is not available for import.
      final _PdfName type = _PdfName(_DictionaryProperties.type);
      final _PdfDictionary dict = object as _PdfDictionary;
      if (dict.containsKey(type)) {
        final _PdfName? pageName = dict[type] as _PdfName?;
        if (pageName != null) {
          if (pageName._name == 'Page') {
            return _PdfNull();
          }
        }
      }
    }
    if (object is _PdfName) {
      return _PdfName((object as _PdfName)._name);
    }

    // Resolves circular references.
    if (crossTable._prevReference != null &&
        crossTable._prevReference!.contains(this.reference)) {
      _IPdfPrimitive? obj;
      if (crossTable._document != null) {
        obj = this.crossTable._getObject(this.reference);
      } else {
        obj = this.crossTable._getObject(this.reference)!.clonedObject;
      }
      if (obj != null) {
        reference = crossTable._getReference(obj);
        return _PdfReferenceHolder.fromReference(reference, crossTable);
      } else {
        return _PdfNull();
      }
    }
    if (this.reference != null) {
      crossTable._prevReference!.add(this.reference);
    }
    if (!(object is _PdfCatalog)) {
      temp = object!._clone(crossTable);
    } else {
      temp = crossTable._document!._catalog;
    }

    reference = crossTable._getReference(temp);
    refHolder = _PdfReferenceHolder.fromReference(reference, crossTable);
    return refHolder;
  }
}
