part of pdf;

class _PdfNull implements _IPdfPrimitive {
  _PdfNull();

  //Fields
  bool? _isSaving;
  int? _objectCollectionIndex;
  int? _position;
  _ObjectStatus? _status;

  //_IPdfPrimitive members
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
    writer!._write('null');
  }

  @override
  void dispose() {
    if (_status != null) {
      _status = null;
    }
  }

  @override
  _IPdfPrimitive _clone(_PdfCrossTable crossTable) => _PdfNull();
}
