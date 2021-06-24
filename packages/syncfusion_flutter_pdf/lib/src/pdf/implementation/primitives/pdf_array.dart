part of pdf;

class _PdfArray implements _IPdfPrimitive, _IPdfChangable {
  _PdfArray([dynamic data]) {
    if (data != null) {
      if (data is _PdfArray) {
        _elements.addAll(data._elements);
      } else if (data is List<num> || data is List<num?>) {
        for (final num entry in data) {
          final _PdfNumber pdfNumber = _PdfNumber(entry);
          _elements.add(pdfNumber);
        }
      } else if (data is List<_PdfArray> || data is List<_PdfArray?>) {
        data.forEach(_elements.add);
      }
    }
  }

  //Constants
  static const String startMark = '[';
  static const String endMark = ']';

  //Fields
  // ignore: prefer_final_fields
  List<_IPdfPrimitive?> _elements = <_IPdfPrimitive?>[];
  bool? _isChanged;
  bool? _isSaving;
  int? _objectCollectionIndex;
  int? _position;
  _ObjectStatus? _status;
  _PdfArray? _clonedObject;
  _PdfCrossTable? _crossTable;

  //Properties
  _IPdfPrimitive? operator [](int index) => _getElement(index);
  _IPdfPrimitive? _getElement(int index) {
    return _elements[index];
  }

  void _add(_IPdfPrimitive element) {
    _elements.add(element);
  }

  bool _contains(_IPdfPrimitive element) {
    return _elements.contains(element);
  }

  void _insert(int index, _IPdfPrimitive element) {
    if (index > _elements.length) {
      throw ArgumentError.value('index out of range $index');
    } else if (index == _elements.length) {
      _elements.add(element);
    } else {
      _elements.insert(index, element);
    }
    _isChanged = true;
  }

  /// Cleares the array.
  void _clear() {
    _elements.clear();
    _isChanged = true;
  }

  int _indexOf(_IPdfPrimitive element) {
    return _elements.indexOf(element);
  }

  int get count => _elements.length;

  //Static methods
  static _PdfArray fromRectangle(_Rectangle rectangle) {
    final List<double?> list = <double?>[
      rectangle.left,
      rectangle.top,
      rectangle.right,
      rectangle.bottom
    ];
    return _PdfArray(list);
  }

  // Converts an instance of the PdfArray to the RectangleF.
  _Rectangle toRectangle() {
    if (count < 4) {
      throw ArgumentError('Can\'t convert to rectangle.');
    }
    double x1, x2, y1, y2;
    _PdfNumber number = _getNumber(0);
    x1 = number.value!.toDouble();
    number = _getNumber(1);
    y1 = number.value!.toDouble();
    number = _getNumber(2);
    x2 = number.value!.toDouble();
    number = _getNumber(3);
    y2 = number.value!.toDouble();
    final double x = <double>[x1, x2].reduce(min);
    final double y = <double>[y1, y2].reduce(min);
    final double width = (x1 - x2).abs();
    final double height = (y1 - y2).abs();
    final _Rectangle rect = _Rectangle(x, y, width, height);
    return rect;
  }

  // Gets the number from the array.
  _PdfNumber _getNumber(int index) {
    final _PdfNumber? number =
        _PdfCrossTable._dereference(this[index]) as _PdfNumber?;
    if (number == null) {
      throw ArgumentError('Can\'t convert to rectangle.');
    }
    return number;
  }

  //_IPdfPrimitive members
  @override
  bool? get changed {
    _isChanged ??= false;
    return _isChanged;
  }

  @override
  set changed(bool? value) {
    _isChanged = value;
  }

  @override
  _IPdfPrimitive? clonedObject;
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
  void save(_IPdfWriter? writer) {
    if (writer != null) {
      writer._write(startMark);
      for (int i = 0; i < count; i++) {
        this[i]!.save(writer);
        if (i + 1 != count) {
          writer._write(_Operators.whiteSpace);
        }
      }
      writer._write(endMark);
    }
  }

  void _removeAt(int index) {
    _elements.removeAt(index);
    _isChanged = true;
  }

  void _remove(_IPdfPrimitive element) {
    final bool hasRemoved = _elements.remove(element);
    if (_elements.isNotEmpty) {
      changed = changed! | hasRemoved;
    }
  }

  @override
  void dispose() {
    if (_elements.isNotEmpty) {
      _elements.clear();
    }
    if (_status != null) {
      _status = null;
    }
  }

  //_IPdfChangable members
  @override
  void freezeChanges(Object? freezer) {
    if (freezer is _PdfParser || freezer is _PdfDictionary) {
      _isChanged = false;
    }
  }

  @override
  _IPdfPrimitive? _clone(_PdfCrossTable crossTable) {
    if (_clonedObject != null && _clonedObject!._crossTable == crossTable) {
      return _clonedObject;
    } else {
      _clonedObject = null;
    }
    final _PdfArray newArray = _PdfArray();
    for (final _IPdfPrimitive? obj in _elements) {
      newArray._add(obj!._clone(crossTable)!);
    }
    newArray._crossTable = crossTable;
    _clonedObject = newArray;
    return newArray;
  }
}
