part of xlsio;

/// Represents implementations of names collection in a workbook.
class _WorksheetNamesCollection implements Names {
  /// Create a instances of worksheet names collection.
  _WorksheetNamesCollection(Worksheet sheet) {
    _sheet = sheet;
    _book = sheet.workbook;
    _list = sheet.workbook.innerNamesCollection;
    _parentWorksheet = _sheet;
    _worksheetNames = <Name>[];
    addWorksheetNames(_list);
  }

  /// worksheet
  late Worksheet _sheet;

  /// workbook
  late Workbook _book;

  /// List of names collection
  late List<Name> _list;

  /// List of worksheet names collection
  late List<Name> _worksheetNames;

  /// Returns the count of named ranges.
  late int _count;

  /// Returns parent worksheet of the collection.
  late Worksheet _parentWorksheet;

  /// Get the count of named ranges.
  @override
  int get count {
    _count = _worksheetNames.length;
    return _count;
  }

  @override
  set count(int value) {}

  /// Get the parent worksheet
  @override
  Worksheet get parentWorksheet {
    _parentWorksheet = _sheet;
    return _parentWorksheet;
  }

  @override
  set parentWorksheet(Worksheet value) {}

  /// Checkes whether the named range collection contains a named range with the specified name.
  @override
  bool contains(String name) {
    for (int i = 0; i < _worksheetNames.length; i++) {
      if (_worksheetNames[i].name == name) {
        return true;
      }
    }
    return false;
  }

  /// Removes a named range from the named range collection.
  @override
  void remove(String name) {
    for (int i = 0; i < _list.length; i++) {
      if (_list[i].name == name && _list[i].scope == _sheet._name) {
        _list.remove(_list[i]);
      }
    }
    for (int i = 0; i < _worksheetNames.length; i++) {
      if (_worksheetNames[i].name == name) {
        _worksheetNames.remove(_worksheetNames[i]);
      }
    }
  }

  /// Remove the named range at the specified index from the named range collection.
  @override
  void removeAt(int index) {
    for (int i = 0; i < _list.length; i++) {
      if (_list[i].name == _worksheetNames[index].name) {
        _list.removeAt(i);
      }
    }
    _worksheetNames.removeAt(index);
  }

  /// Adds a new named range to the named range collection.
  @override
  Name add(String name, [Range? range]) {
    final _NameImpl nameImpl = _NameImpl(_book);
    nameImpl.name = name;
    nameImpl._isLocal = true;
    if (range != null) {
      nameImpl.refersToRange = range;
      nameImpl._worksheet = range._worksheet;
      nameImpl._scope = range._worksheet._name;
      nameImpl._value = range.addressGlobal;
    }
    _list.add(nameImpl);
    _worksheetNames.add(nameImpl);
    addWorksheetNames(_list);
    return nameImpl;
  }

  /// Returns a single object from a Names collection.
  @override
  Name operator [](dynamic name) {
    addWorksheetNames(_list);
    if (name is String) {
      for (int i = 0; i < _worksheetNames.length; i++) {
        if (_worksheetNames[i].name == name) {
          return _worksheetNames[i];
        }
      }
    } else if (name is int) {
      if (name < _worksheetNames.length) {
        return _worksheetNames[name];
      }
    }
    throw Exception('Invalid index or name');
  }

  /// Add worksheet names collection
  void addWorksheetNames(List<Name> listColl) {
    for (int i = 0; i < listColl.length; i++) {
      if (listColl[i].scope == _sheet._name &&
          !_worksheetNames.contains(listColl[i])) {
        _worksheetNames.add(listColl[i]);
      }
    }
  }
}
