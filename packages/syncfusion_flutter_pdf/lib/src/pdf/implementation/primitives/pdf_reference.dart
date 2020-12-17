part of pdf;

class _PdfReference implements _IPdfPrimitive {
  _PdfReference(int objNum, int genNum) {
    ArgumentError.checkNotNull(objNum, 'objNum');
    ArgumentError.checkNotNull(genNum, 'genNum');
    if (objNum.isNaN) {
      throw ArgumentError.value(objNum, 'not a number');
    }
    if (genNum.isNaN) {
      throw ArgumentError.value(genNum, 'not a number');
    }
    _objNum = objNum;
    _genNum = genNum;
  }

  //Fields
  int _objNum;
  int _genNum;
  bool _isSaving;
  int _objectCollectionIndex;
  int _position;
  _ObjectStatus _status;

  //Implementation
  @override
  String toString() {
    return '$_objNum $_genNum R';
  }

  //_IPdfPrimitive members
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
    writer._write(toString());
  }

  @override
  void dispose() {
    if (_status != null) {
      _status = null;
    }
  }

  @override
  _IPdfPrimitive _clone(_PdfCrossTable crossTable) => null;
}
