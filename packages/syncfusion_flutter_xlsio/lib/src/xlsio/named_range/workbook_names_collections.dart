part of xlsio;

/// Represents implementations of names collection in a worksheet.
class _WorkbookNamesCollection implements Names {
  /// Create a instances of Workbook names collection.
  _WorkbookNamesCollection(Workbook book) {
    _book = book;
    _list = book.innerNamesCollection;
    _count = _list.length;
  }

  /// Workbook
  late Workbook _book;

  /// List of names collection.
  late List<Name> _list;

  /// Returns the count of named ranges.
  late int _count;

  /// Returns parent worksheet of the collection.
  late Worksheet _parentWorksheet;

  /// Get the count of named ranges.
  @override
  int get count {
    _count = _list.length;
    return _count;
  }

  @override
  set count(int value) {}

  /// Get the parent worksheet
  @override
  Worksheet get parentWorksheet {
    return _parentWorksheet;
  }

  @override
  set parentWorksheet(Worksheet value) {}

  /// Checkes whether the named range collection contains a named range with the specified name.
  @override
  bool contains(String name) {
    for (int i = 0; i < _list.length; i++) {
      if (_list[i].name == name) {
        return true;
      }
    }
    return false;
  }

  /// Removes a named range from the named range collection.
  @override
  void remove(String name) {
    for (int i = 0; i < _list.length; i++) {
      if (_list[i].name == name) {
        _list.remove(_list[i]);
      }
    }
  }

  /// Remove the named range at the specified index from the named range collection.
  @override
  void removeAt(int index) {
    _list.removeAt(index);
  }

  /// Adds a new named range to the named range collection.
  @override
  Name add(String name, [Range? range]) {
    final _NameImpl nameImpl = _NameImpl(_book);
    nameImpl.name = name;
    nameImpl._scope = 'workbook';
    if (range != null) {
      nameImpl.refersToRange = range;
      _parentWorksheet = range.worksheet;
      nameImpl._worksheet = _parentWorksheet;
      nameImpl._value = range.addressGlobal;
    }
    _list.add(nameImpl);
    return nameImpl;
  }

  /// Returns a single object from a Names collection.
  @override
  Name operator [](dynamic name) {
    if (name is String) {
      for (int i = 0; i < _list.length; i++) {
        if (_list[i].name == name) {
          return _list[i];
        }
      }
    } else if (name is int) {
      if (name < _list.length) {
        return _list[name];
      }
    }
    throw Exception('Invalid index or name');
  }
}
