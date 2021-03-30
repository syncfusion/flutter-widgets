part of pdf;

/// Represents list field item collection.
class PdfListFieldItemCollection extends PdfObjectCollection
    implements _IPdfWrapper {
  //Constructor
  PdfListFieldItemCollection._([PdfListField? field]) : super() {
    if (field != null) {
      _field = field;
    }
  }

  //Fields
  final _PdfArray _items = _PdfArray();
  PdfListField? _field;

  //Properties
  /// Gets the [PdfListFieldItem] at the specified index.
  PdfListFieldItem operator [](int index) {
    if (index < 0 || index >= count) {
      throw RangeError('index');
    }
    return _list[index] as PdfListFieldItem;
  }

  //Public methods
  /// Adds the specified item in the collection and returns its index.
  int add(PdfListFieldItem item) {
    return _doAdd(item);
  }

  /// Inserts the list item field at the specified index.
  void insert(int index, PdfListFieldItem item) {
    if (index < 0 || index > count) {
      throw RangeError('index');
    }
    _doInsert(index, item);
  }

  /// Removes the specified [PdfListFieldItem].
  void remove(PdfListFieldItem item) {
    if (_list.contains(item)) {
      _doRemove(item);
    }
  }

  /// Removes the item at the specified position.
  void removeAt(int index) {
    if ((index < 0) || (index >= count)) {
      throw RangeError('index');
    }
    _doRemove(null, index);
  }

  /// Determines whether the item is present in the collection.
  bool contains(PdfListFieldItem item) {
    return _list.contains(item);
  }

  /// Gets the index of the specified item.
  int indexOf(PdfListFieldItem item) {
    return _list.indexOf(item);
  }

  /// Clears the collection.
  void clear() {
    if (_field != null && _field!._isLoadedField) {
      final _PdfArray list = _getItems().._clear();
      _field!._dictionary.setProperty(_DictionaryProperties.opt, list);
    } else {
      _items._clear();
    }
    _list.clear();
  }

  //Implementations
  int _doAdd(PdfListFieldItem item) {
    if (_field != null && _field!._isLoadedField) {
      final _PdfArray list = _getItems();
      final _PdfArray itemArray = _getArray(item);
      list._add(itemArray);
      _field!._dictionary.setProperty(_DictionaryProperties.opt, list);
    } else {
      _items._add(item._element);
    }
    _list.add(item);
    return count - 1;
  }

  void _doInsert(int index, PdfListFieldItem item) {
    if (_field != null && _field!._isLoadedField) {
      final _PdfArray list = _getItems();
      final _PdfArray itemArray = _getArray(item);
      list._insert(index, itemArray);
      _field!._dictionary.setProperty(_DictionaryProperties.opt, list);
    } else {
      _items._insert(index, item._element);
    }
    _list.insert(index, item);
  }

  void _doRemove(PdfListFieldItem? item, [int? index]) {
    if (index == null && item != null) {
      index = _list.indexOf(item);
    }
    if (_field != null && _field!._isLoadedField) {
      final _PdfArray list = _getItems().._removeAt(index!);
      _field!._dictionary.setProperty(_DictionaryProperties.opt, list);
    } else {
      _items._removeAt(index!);
    }
    _list.removeAt(index);
  }

  _PdfArray _getItems() {
    _PdfArray? items;
    if (_field!._dictionary.containsKey(_DictionaryProperties.opt)) {
      final _IPdfPrimitive? obj = _field!._crossTable!
          ._getObject(_field!._dictionary[_DictionaryProperties.opt]);
      if (obj != null && obj is _PdfArray) {
        items = obj;
      }
    }
    return items ?? _PdfArray();
  }

  _PdfArray _getArray(PdfListFieldItem item) {
    final _PdfArray array = _PdfArray();
    if (item.value != '') {
      array._add(_PdfString(item.value));
    }
    if (item.value != '') {
      array._add(_PdfString(item.text));
    }
    return array;
  }

  int _addItem(PdfListFieldItem item) {
    _list.add(item);
    return count - 1;
  }

  //overrides
  @override
  _IPdfPrimitive get _element => _items;

  @override
  // ignore: unused_element
  set _element(_IPdfPrimitive? value) {
    throw ArgumentError('Primitive element can\'t be set');
  }
}
