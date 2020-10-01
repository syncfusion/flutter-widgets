part of pdf;

class _PdfDictionary implements _IPdfPrimitive, _IPdfChangable {
  /// Constructor to create a [_PdfDictionary] object.
  _PdfDictionary([_PdfDictionary dictionary]) {
    _items = <_PdfName, _IPdfPrimitive>{};
    _copyDictionary(dictionary);
  }

  //Constants
  static const String prefix = '<<';
  static const String suffix = '>>';

  //Fields
  Map<_PdfName, _IPdfPrimitive> _items;
  bool _isChanged;
  bool _isSaving;
  int _objectCollectionIndex;
  int _position;
  _ObjectStatus _status;

  //Properties
  /// Get the PdfDictionary items.
  _IPdfPrimitive operator [](dynamic key) => returnValue(checkName(key));

  ///  Set the PdfDictionary items.
  operator []=(dynamic key, dynamic value) => _addItems(key, value);

  dynamic _addItems(dynamic key, dynamic value) {
    if (key == null) {
      throw ArgumentError.value(key, 'key', 'value cannot be null');
    }
    if (value == null) {
      throw ArgumentError.value(value, 'value', 'value cannot be null');
    }
    _items[checkName(key)] = value;
    modify();
    return value;
  }

  /// Get the length of the item.
  int get count => _items.length;

  /// Get the values of the item.
  List<_IPdfPrimitive> get value => _items.values;

  //Implementation
  void _copyDictionary(_PdfDictionary dictionary) {
    if (dictionary != null) {
      dictionary._items
          .forEach((_PdfName k, _IPdfPrimitive v) => _addItems(k, v));
      freezeChanges(this);
    }
  }

  /// Check and return the valid name.
  _PdfName checkName(dynamic key) {
    if (key is _PdfName) {
      return key;
    } else if (key is String) {
      return _PdfName(key);
    } else {
      return null;
    }
  }

  /// Check key and return the value.
  _IPdfPrimitive returnValue(dynamic key) {
    if (_items.containsKey(key)) {
      return _items[key];
    } else {
      return null;
    }
  }

  bool containsKey(dynamic key) {
    if (key is String) {
      return _items.containsKey(_PdfName(key));
    } else if (key is _PdfName) {
      return _items.containsKey(key);
    }
    return false;
  }

  void remove(dynamic key) {
    if (key == null) {
      throw ArgumentError.value(key, 'key', 'value cannot be null');
    }
    final _PdfName name = key is _PdfName ? key : _PdfName(key);
    _items.remove(name);
    modify();
  }

  void clear() {
    _items.clear();
    modify();
  }

  void modify() {
    changed = true;
  }

  void setProperty(dynamic key, dynamic value) {
    if (value == null) {
      if (key is String) {
        _items.remove(_PdfName(key));
      } else if (key is _PdfName) {
        _items.remove(key);
      }
    } else {
      if (value is _IPdfWrapper) {
        value = value._element;
      }
      this[key] = value;
    }
    modify();
  }

  void _setName(_PdfName key, String name) {
    if (_items.containsKey(key)) {
      this[key] = _PdfName(name);
      modify();
    } else {
      this[key] = _PdfName(name);
    }
  }

  void _setArray(String key, List<_IPdfPrimitive> list) {
    _PdfArray pdfArray = this[key] as _PdfArray;
    if (pdfArray != null) {
      pdfArray._clear();
      modify();
    } else {
      pdfArray = _PdfArray();
      this[key] = pdfArray;
    }
    for (int i = 0; i < list.length; i++) {
      pdfArray._add(list.elementAt(i));
    }
  }

  void _setString(String key, String str) {
    final _PdfString pdfString = this[key] as _PdfString;
    if (pdfString != null) {
      pdfString.value = str;
      modify();
    } else {
      this[key] = _PdfString(str);
    }
  }

  void _saveDictionary(_IPdfWriter writer, bool enableEvents) {
    writer._write(prefix);
    if (enableEvents) {
      final _SavePdfPrimitiveArgs args = _SavePdfPrimitiveArgs(writer);
      _onBeginSave(args);
    }
    if (count > 0) {
      _saveItems(writer);
    }
    writer._write(suffix);
    writer._write(_Operators.newLine);
    if (enableEvents) {
      final _SavePdfPrimitiveArgs args = _SavePdfPrimitiveArgs(writer);
      _onEndSave(args);
    }
  }

  void _saveItems(_IPdfWriter writer) {
    writer._write(_Operators.newLine);
    _items.forEach((_PdfName key, _IPdfPrimitive value) {
      key.save(writer);
      writer._write(_Operators.whiteSpace);
      value.save(writer);
      writer._write(_Operators.newLine);
    });
  }

  _IPdfPrimitive _getValue(String key, String parentKey) {
    _PdfDictionary dictionary = this;
    _IPdfPrimitive element = _PdfCrossTable._dereference(dictionary[key]);
    while (element == null) {
      dictionary =
          _PdfCrossTable._dereference(dictionary[parentKey]) as _PdfDictionary;
      if (dictionary == null) {
        break;
      }
      element = _PdfCrossTable._dereference(dictionary[key]);
    }
    return element;
  }

  int _getInt(String propertyName) {
    final _IPdfPrimitive primitive =
        _PdfCrossTable._dereference(this[propertyName]);
    return (primitive != null && primitive is _PdfNumber)
        ? primitive.value.toInt()
        : 0;
  }

  bool _checkChanges() {
    bool result = false;
    final List<_PdfName> keys = _items.keys.toList();
    for (int i = 0; i < keys.length; i++) {
      final _IPdfPrimitive primitive = _items[keys[i]];
      if (primitive is _IPdfChangable &&
          (primitive as _IPdfChangable).changed) {
        result = true;
        break;
      }
    }
    return result;
  }

  void _setNumber(String key, int value) {
    final _PdfNumber pdfNumber = this[key] as _PdfNumber;
    if (pdfNumber != null) {
      pdfNumber.value = value;
      modify();
    } else {
      this[key] = _PdfNumber(value);
    }
  }

  void _setBoolean(String key, bool value) {
    final _PdfBoolean pdfBoolean = this[key] as _PdfBoolean;
    if (pdfBoolean != null) {
      pdfBoolean.value = value;
      modify();
    } else {
      this[key] = _PdfBoolean(value);
    }
  }

  void _setDateTime(String key, DateTime dateTime) {
    final _PdfString pdfString = this[key] as _PdfString;
    final DateFormat dateFormat = DateFormat('yyyyMMddHHmmss');
    if (pdfString != null) {
      pdfString.value = dateFormat.format(dateTime);
      modify();
    } else {
      final int regionMinutes = dateTime.minute;
      String offsetMinutes = regionMinutes.toString();
      if (regionMinutes >= 0 && regionMinutes <= 9) {
        offsetMinutes = '0' + offsetMinutes;
      }
      final int regionHours = dateTime.hour;
      String offsetHours = regionHours.toString();
      if (regionHours >= 0 && regionHours <= 9) {
        offsetHours = '0' + offsetHours;
      }
      this[key] = _PdfString('D:' +
          dateFormat.format(dateTime) +
          '+' +
          offsetHours +
          "'" +
          offsetMinutes +
          "'");
    }
  }

  // Gets the date time from Pdf standard date format.
  DateTime _getDateTime(_PdfString dateTimeStringValue) {
    ArgumentError.checkNotNull(dateTimeStringValue, 'dateTimeStringValue');
    const String prefixD = 'D:';
    final _PdfString dateTimeString = _PdfString(dateTimeStringValue.value);
    String value = dateTimeString.value;
    while (value.startsWith(RegExp('[:-D-(-)]'))) {
      dateTimeString.value = value.replaceFirst(value[0], '');
      value = dateTimeString.value;
    }
    while (value[value.length - 1].contains(RegExp('[:-D-(-)]'))) {
      dateTimeString.value =
          value.replaceRange(value.length - 1, value.length, '');
    }
    if (dateTimeString.value.startsWith('191')) {
      dateTimeString.value = dateTimeString.value.replaceFirst('191', '20');
    }
    final bool containPrefixD = dateTimeString.value.contains(prefixD);
    String dateTimeFormat = 'yyyyMMddHHmmss';
    if (dateTimeString.value.length <= 8) {
      dateTimeFormat = 'yyyyMMdd';
    } else if (dateTimeString.value.length <= 10) {
      dateTimeFormat = 'yyyyMMddHH';
    } else if (dateTimeString.value.length <= 12) {
      dateTimeFormat = 'yyyyMMddHHmm';
    }
    String localTime = ''.padRight(dateTimeFormat.length);
    if (dateTimeString.value.isEmpty) {
      return DateTime.now();
    }
    if (dateTimeString.value.length >= localTime.length) {
      localTime = containPrefixD
          ? dateTimeString.value.substring(prefixD.length, localTime.length)
          : dateTimeString.value.substring(0, localTime.length);
    }
    final String dateWithT =
        localTime.substring(0, 8) + 'T' + localTime.substring(8);
    final DateTime dateTime = DateTime.parse(dateWithT);
    return dateTime;
  }

  //_IPdfChangable members
  @override
  bool get changed {
    _isChanged ??= false;
    if (!_isChanged) {
      _isChanged = _checkChanges();
    }
    return _isChanged;
  }

  @override
  set changed(bool value) {
    _isChanged = value;
  }

  @override
  void freezeChanges(dynamic freezer) {
    if (freezer is _PdfParser || freezer is _PdfDictionary) {
      _isChanged = false;
    }
  }

  //_IPdfPrimitive members
  @override
  _IPdfPrimitive clonedObject;

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
  void save(_IPdfWriter writer) {
    _saveDictionary(writer, true);
  }

  @override
  void dispose() {
    if (_items != null && _items.isNotEmpty) {
      final List<_IPdfPrimitive> primitives = _items.keys.toList();
      for (int i = 0; i < primitives.length; i++) {
        _items[primitives[i]].dispose();
      }
      _items.clear();
      _items = null;
    }
    if (_status != null) {
      _status = null;
    }
  }

  //Events
  _SavePdfPrimitiveCallback _beginSave;
  List<_SavePdfPrimitiveCallback> _beginSaveList;
  _SavePdfPrimitiveCallback _endSave;

  void _onBeginSave(_SavePdfPrimitiveArgs args) {
    if (_beginSave != null) {
      _beginSave(this, args);
    }
    if (_beginSaveList != null) {
      for (int i = 0; i < _beginSaveList.length; i++) {
        if (_beginSaveList[i] != null) {
          _beginSaveList[i](this, args);
        }
      }
    }
  }

  void _onEndSave(_SavePdfPrimitiveArgs args) {
    if (_endSave != null) {
      _endSave(this, args);
    }
  }
}

class _SavePdfPrimitiveArgs {
  _SavePdfPrimitiveArgs(_IPdfWriter writer) {
    if (writer == null) {
      throw ArgumentError.notNull('writer');
    } else {
      _writer = writer;
    }
  }

  _IPdfWriter _writer;

  _IPdfWriter get writer => _writer;
}

typedef _SavePdfPrimitiveCallback = void Function(
    Object sender, _SavePdfPrimitiveArgs args);
