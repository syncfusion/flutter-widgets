part of pdf;

/// Represents an item of a radio button list.
class PdfRadioButtonItemCollection extends PdfObjectCollection
    implements _IPdfWrapper {
  //Constructor
  /// Initializes a new instance of the [PdfRadioButtonItemCollection]
  /// class with the specific [PdfRadioButtonListField].
  PdfRadioButtonItemCollection._(PdfRadioButtonListField field) {
    _field = field;
  }
  //Fields
  PdfRadioButtonListField? _field;
  final _PdfArray _array = _PdfArray();

  //Properties
  /// Gets the PdfRadioButtonListItem at the specified index.
  PdfRadioButtonListItem operator [](int index) =>
      _list[index] as PdfRadioButtonListItem;

  //Implementation
  /// Adds the specified item.
  int add(PdfRadioButtonListItem item) {
    return _doAdd(item);
  }

  /// Inserts an item at the specified index.
  void insert(int index, PdfRadioButtonListItem item) {
    _doInsert(index, item);
  }

  /// Removes the specified item from the collection.
  void remove(PdfRadioButtonListItem item) {
    _doRemove(item);
  }

  /// Removes the item at the specified index.
  void removeAt(int index) {
    RangeError.range(index, 0, _list.length);
    _array._removeAt(index);
    final PdfRadioButtonListItem item = _list[index] as PdfRadioButtonListItem;
    item._setField(null);
    _list.removeAt(index);
    if ((_field != null && _field!._selectedIndex >= index) ||
        (_list.isEmpty)) {
      _field?._selectedIndex = -1;
    }
  }

  /// Gets the index of the item within the collection.
  int indexOf(PdfRadioButtonListItem item) => _list.indexOf(item);

  /// Determines whether the collection contains the specified item.
  bool contains(PdfRadioButtonListItem item) => _list.contains(item);

  /// Clears the item collection.
  void clear() => _doClear();

  int _doAdd(PdfRadioButtonListItem item, [bool isItem = false]) {
    _array._add(_PdfReferenceHolder(item));
    item._setField(_field, isItem);
    _list.add(item);
    return _list.length - 1;
  }

  void _doInsert(int index, PdfRadioButtonListItem item) {
    _array._insert(index, _PdfReferenceHolder(item));
    item._setField(_field);
    _list.insert(index, item);
  }

  void _doRemove(PdfRadioButtonListItem item) {
    if (_list.contains(item)) {
      final int index = _list.indexOf(item);
      _array._removeAt(index);
      item._setField(null);
      _list.removeAt(index);
      if ((_field != null && _field!._selectedIndex >= index) ||
          (_list.isEmpty)) {
        _field?._selectedIndex = -1;
      }
    }
  }

  void _doClear() {
    for (final Object? item in _list) {
      if (item is PdfRadioButtonListItem) {
        item._setField(null);
      }
    }
    _array._clear();
    _list.clear();
    _field?._selectedIndex = -1;
  }

  @override
  _IPdfPrimitive get _element => _array;

  @override
  // ignore: unused_element
  set _element(_IPdfPrimitive? value) {
    _element = value;
  }
}
