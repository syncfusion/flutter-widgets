part of pdf;

/// Represents collection of list items.
class PdfListItemCollection extends PdfObjectCollection {
  /// Initializes a new instance of the [PdfListItemCollection] class.
  PdfListItemCollection([List<String> items]) {
    if (items != null) {
      for (int i = 0; i < items.length; i++) {
        _add(items[i]);
      }
    }
  }

  /// Gets the [PdfListItem] from collection at the specified index.
  PdfListItem operator [](int index) {
    if (index < 0 || index >= count) {
      throw RangeError(
          'The index should be less than item\'s count or more or equal to 0');
    }
    return _list[index];
  }

  PdfListItem _add(String text) {
    ArgumentError.checkNotNull(text, 'text');
    final PdfListItem item = PdfListItem(text: text);
    _list.add(item);
    return item;
  }

  /// Adds the specified item.
  int add(PdfListItem item, [double itemIndent]) {
    if (itemIndent != null) {
      item.textIndent = itemIndent;
    }
    ArgumentError.checkNotNull(item, 'item');
    _list.add(item);
    return _list.length - 1;
  }

  /// Inserts item at the specified index.
  void insert(int index, PdfListItem item, [double itemIndent]) {
    if (index < 0 || index >= count) {
      throw ArgumentError('''The index should be less than item\'s count 
          or more or equal to 0, $index''');
    }
    ArgumentError.checkNotNull(item, 'item');
    if (itemIndent != null) {
      item.textIndent = itemIndent;
    }
    _list.insert(index, item);
  }

  /// Removes the specified item from the list.
  void remove(PdfListItem item) {
    ArgumentError.checkNotNull(item, 'item');
    if (!_list.contains(item)) {
      throw ArgumentError('The list doesn\'t contain this item, $item');
    }
    _list.remove(item);
  }

  /// Removes the item at the specified index from the list.
  void removeAt(int index) {
    if (index < 0 || index >= count) {
      throw ArgumentError('''The index should be less than item's count 
          or more or equal to 0, $index''');
    }
    _list.removeAt(index);
  }

  /// Determines the index of a specific item in the list.
  int indexOf(PdfListItem item) {
    ArgumentError.checkNotNull(item, 'item');
    return _list.indexOf(item);
  }

  /// Clears collection
  void clear() {
    _list.clear();
  }
}
