part of xlsio;

/// Represents implementations of pagesetup in a worksheet.
class _NameImpl implements Name {
  /// Create a instances of tables collection.
  _NameImpl(Workbook book) {
    _book = book;
    _index = -1;
    _name = '';
    _value = '';
    _description = '';
    _isVisible = true;
    _isLocal = false;
    _scope = '';
  }

  /// Workbook
  late Workbook _book;

  /// Returns the named range index from the named range collection.
  late int _index;

  /// Returns or sets the name for the named range.
  late String _name;

  /// Represents the referred worksheet range for the named  range.
  late Range _refersToRange;

  /// Represents the value of the worksheet.
  late String _value;

  /// Indicates whether the named range is visible.
  late bool _isVisible;

  /// Indicates whether named range is local.
  late bool _isLocal;

  /// Returns parent worksheet of the named range
  late Worksheet _worksheet;

  /// Represents the scope of the named range whether it is workbook/worksheet.
  late String _scope;

  /// Represents the comments for the named range.
  late String _description;

  /// Get the comments for the named range.
  @override
  String get description {
    return _description;
  }

  /// Set the comments for the named range.
  @override
  set description(String value) {
    _description = value;
  }

  /// Get the named range index from the named range collection.
  @override
  int get index {
    for (int i = 0; i < _book.innerNamesCollection.length; i++) {
      if (_book.innerNamesCollection[i].name == name) {
        return i;
      }
    }
    return _index;
  }

  @override
  set index(int value) {}

  /// Indicates whether the named range is local.
  @override
  bool get isLocal {
    return _isLocal;
  }

  @override
  set isLocal(bool value) {}

  /// Get the name for the named range.
  @override
  String get name {
    return _name;
  }

  /// Set the name for the named range.
  @override
  set name(String value) {
    _name = value;
  }

  /// Get the referred worksheet range for the named range.
  @override
  Range get refersToRange {
    return _refersToRange;
  }

  /// Set the scope of the named range whether it is workbook/worksheet.
  @override
  set refersToRange(Range value) {
    _value = value.addressGlobal;
    _worksheet = value._worksheet;
    if (_isLocal) {
      _scope = value._worksheet._name;
    } else {
      _scope = 'workbook';
    }
    _refersToRange = value;
  }

  /// Get the scope of the named range whether it is workbook/worksheet.
  @override
  String get value {
    return _value;
  }

  /// Set the value of the worksheet.
  @override
  set value(String value) {
    _value = value;
  }

  /// Get whether the named range is visible.
  @override
  bool get isVisible {
    return _isVisible;
  }

  /// Set whether the named range is visible.
  @override
  set isVisible(bool value) {
    _isVisible = value;
  }

  /// Get the scope of the named range whether it is workbook/worksheet.
  @override
  String get scope {
    return _scope;
  }

  @override
  set scope(String value) {}

  /// Get parent worksheet of the named range.
  @override
  Worksheet get worksheet {
    return _worksheet;
  }

  @override
  set worksheet(Worksheet value) {}

  /// Deletes a named range from the workbook/worksheet.
  @override
  void delete() {
    _book.innerNamesCollection.remove(this);
  }
}
