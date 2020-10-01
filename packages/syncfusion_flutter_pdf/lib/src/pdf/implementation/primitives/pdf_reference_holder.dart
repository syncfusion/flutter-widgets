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
      _PdfReference reference, _PdfCrossTable crossTable) {
    if (crossTable != null) {
      this.crossTable = crossTable;
    } else {
      throw ArgumentError.value(crossTable, 'crossTable value cannot be null');
    }
    if (reference != null) {
      this.reference = reference;
    } else {
      throw ArgumentError.value(reference, 'reference value cannot be null');
    }
  }

  //Fields
  _IPdfPrimitive _object;
  _PdfReference reference;
  bool _isSaving;
  int _objectCollectionIndex;
  int _position;
  _ObjectStatus _status;
  _PdfCrossTable crossTable;
  int _objectIndex = -1;

  //_IPdfPrimitive members
  _IPdfPrimitive get object {
    if (reference != null || _object == null) {
      _object = _obtainObject();
    }
    return _object;
  }

  set object(_IPdfPrimitive value) {
    _object = value;
  }

  int get index {
    final _PdfMainObjectCollection items = crossTable._items;
    _objectIndex = items._getObjectIndex(reference);
    if (_objectIndex < 0) {
      crossTable._getObject(reference);
      _objectIndex = items._count - 1;
    }
    return _objectIndex;
  }

  @override
  bool get isSaving {
    _isSaving ??= false;
    return _isSaving;
  }

  @override
  set isSaving(bool value) {
    _isSaving = value;
  }

  @override
  int get objectCollectionIndex {
    _objectCollectionIndex ??= 0;
    return _objectCollectionIndex;
  }

  @override
  set objectCollectionIndex(int value) {
    _objectCollectionIndex = value;
  }

  @override
  int get position {
    _position ??= -1;
    return _position;
  }

  @override
  set position(int value) {
    _position = value;
  }

  @override
  _ObjectStatus get status {
    _status ??= _ObjectStatus.none;
    return _status;
  }

  @override
  set status(_ObjectStatus value) {
    _status = value;
  }

  @override
  _IPdfPrimitive clonedObject;

  @override
  void save(_IPdfWriter writer) {
    ArgumentError.checkNotNull(writer, 'writer');
    object.isSaving = !writer._document._isLoadedDocument;
    final _PdfCrossTable crossTable = writer._document._crossTable;
    _PdfReference pdfReference;
    if (writer._document.fileStructure.incrementalUpdate &&
        writer._document._isStreamCopied) {
      if (reference == null) {
        pdfReference = crossTable._getReference(object);
      } else {
        pdfReference = reference;
      }
    } else {
      pdfReference = crossTable._getReference(object);
    }
    pdfReference.save(writer);
  }

  _IPdfPrimitive _obtainObject() {
    _IPdfPrimitive obj;
    if (reference != null) {
      if (index >= 0) {
        obj = crossTable._items._getObject(reference);
      }
    } else if (_object != null) {
      obj = _object;
    }
    return obj;
  }

  @override
  void dispose() {
    if (reference != null) {
      reference.dispose();
      reference = null;
    }
    if (_status != null) {
      _status = null;
    }
  }
}
