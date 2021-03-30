part of pdf;

class _PdfMainObjectCollection {
  //Constructor
  _PdfMainObjectCollection() {
    _initialize();
  }

  //Fields
  int? _index;
  Map<int?, _ObjectInfo>? _mainObjectCollection;
  List<_ObjectInfo>? _objectCollection;
  Map<_IPdfPrimitive?, int>? _primitiveObjectCollection;
  int? _maximumReferenceObjectNumber = 0;

  //Properties
  int get _count {
    return _objectCollection!.length;
  }

  /// Get the PdfMainObjectCollection items.
  _ObjectInfo operator [](int key) => _returnValue(key);

  //Implementation
  void _initialize() {
    _index = 0;
    _mainObjectCollection = <int?, _ObjectInfo>{};
    _objectCollection = <_ObjectInfo>[];
    _primitiveObjectCollection = <_IPdfPrimitive?, int>{};
  }

  /// Check key and return the value.
  _ObjectInfo _returnValue(int index) {
    if (index < 0 || index > _objectCollection!.length) {
      throw ArgumentError.value(index, 'index', 'index out of range');
    }
    return _objectCollection![index];
  }

  bool _containsReference(_PdfReference reference) {
    return _mainObjectCollection!.containsKey(reference._objNum);
  }

  /// Adds the specified element.
  void _add(dynamic element, [_PdfReference? reference]) {
    if (element == null) {
      throw ArgumentError.value(element, 'element', 'value cannot be null');
    }
    if (element is _IPdfWrapper) {
      element = element._element;
    }
    if (reference == null) {
      final _ObjectInfo info = _ObjectInfo(element);
      _objectCollection!.add(info);
      if (!_primitiveObjectCollection!.containsKey(element)) {
        _primitiveObjectCollection![element] = _objectCollection!.length - 1;
      }
      element.position = _objectCollection!.length - 1;
      _index = _objectCollection!.length - 1;
      element.status = _ObjectStatus.registered;
    } else {
      final _ObjectInfo info = _ObjectInfo(element, reference);
      if (_maximumReferenceObjectNumber! < reference._objNum!) {
        _maximumReferenceObjectNumber = reference._objNum;
      }
      _objectCollection!.add(info);
      if (!_primitiveObjectCollection!.containsKey(element)) {
        _primitiveObjectCollection![element] = _objectCollection!.length - 1;
      }
      _mainObjectCollection![reference._objNum] = info;
      element.position = _objectCollection!.length - 1;
      reference.position = _objectCollection!.length - 1;
    }
  }

  Map<String, dynamic> _getReference(_IPdfPrimitive object, bool? isNew) {
    _index = _lookFor(object);
    _PdfReference? reference;
    if (_index! < 0 || _index! > _count) {
      isNew = true;
    } else {
      isNew = false;
      final _ObjectInfo objectInfo = _objectCollection![_index!];
      reference = objectInfo._reference;
    }
    return <String, dynamic>{'isNew': isNew, 'reference': reference};
  }

  bool contains(_IPdfPrimitive element) {
    return (_lookFor(element)! >= 0);
  }

  int? _lookFor(_IPdfPrimitive obj) {
    int? index = -1;
    if (obj.position != -1) {
      return obj.position;
    }
    if (_primitiveObjectCollection!.containsKey(obj) &&
        _count == _primitiveObjectCollection!.length) {
      index = _primitiveObjectCollection![obj];
    } else {
      for (int i = _count - 1; i >= 0; i--) {
        final _ObjectInfo objectInfo = _objectCollection![i];
        final _IPdfPrimitive? primitive = objectInfo._object;
        final bool isValidType =
            ((primitive is _PdfName && !(obj is _PdfName)) ||
                    (!(primitive is _PdfName) && obj is _PdfName))
                ? false
                : true;
        if (isValidType && primitive == obj) {
          index = i;
          break;
        }
      }
    }
    return index;
  }

  _IPdfPrimitive? _getObject(_PdfReference reference) {
    try {
      return _mainObjectCollection![reference._objNum]!._object;
    } catch (e) {
      return null;
    }
  }

  int? _getObjectIndex(_PdfReference reference) {
    if (reference.position != -1) {
      return reference.position;
    }
    if (_mainObjectCollection!.isEmpty) {
      if (_objectCollection!.isEmpty) {
        return -1;
      } else {
        for (int i = 0; i < _objectCollection!.length - 1; i++) {
          _mainObjectCollection![_objectCollection![i]._reference!._objNum] =
              _objectCollection![i];
        }
        if (!_mainObjectCollection!.containsKey(reference._objNum)) {
          return -1;
        } else {
          return 0;
        }
      }
    } else {
      if (!_mainObjectCollection!.containsKey(reference._objNum)) {
        return -1;
      } else {
        return 0;
      }
    }
  }

  bool _trySetReference(_IPdfPrimitive object, _PdfReference reference) {
    bool result = true;
    _index = _lookFor(object);
    if (_index! < 0 || _index! >= _objectCollection!.length) {
      result = false;
    } else {
      final _ObjectInfo objectInfo = _objectCollection![_index!];
      if (objectInfo._reference != null) {
        result = false;
      } else {
        objectInfo._setReference(reference);
      }
    }
    return result;
  }

  _IPdfPrimitive? _getObjectFromReference(_PdfReference reference) {
    try {
      return _mainObjectCollection![reference._objNum]!._object;
    } catch (e) {
      return null;
    }
  }

  void _reregisterReference(int oldObjIndex, _IPdfPrimitive newObj) {
    if (oldObjIndex < 0 || oldObjIndex > _count) {
      throw ArgumentError.value(
          oldObjIndex, 'oldObjIndex', 'index out of range');
    }
    final _ObjectInfo oi = _objectCollection![oldObjIndex];
    if (oi._object != newObj) {
      _primitiveObjectCollection!.remove(oi._object);
      _primitiveObjectCollection![newObj] = oldObjIndex;
    }
    oi._object = newObj;
    newObj.position = oldObjIndex;
  }

  void _dispose() {
    if (_mainObjectCollection != null) {
      _mainObjectCollection!.clear();
      _mainObjectCollection = null;
    }
    if (_objectCollection != null) {
      _objectCollection!.clear();
      _objectCollection = null;
    }
    if (_primitiveObjectCollection != null &&
        _primitiveObjectCollection!.isNotEmpty) {
      final List<_IPdfPrimitive?> primitives =
          _primitiveObjectCollection!.keys.toList();
      for (int i = 0; i < primitives.length; i++) {
        primitives[i]!.dispose();
      }
      _primitiveObjectCollection!.clear();
      _primitiveObjectCollection = null;
    }
  }
}
