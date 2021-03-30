part of pdf;

/// Represents collection field items.
class PdfFieldItemCollection extends PdfObjectCollection {
  //Constructor
  PdfFieldItemCollection._(PdfField field) {
    _field = field;
  }

  //Properties
  /// Gets the Field item at the specified index.
  PdfFieldItem operator [](int index) {
    if (index < 0 || index >= count) {
      throw RangeError('index');
    }
    return _list[index] as PdfFieldItem;
  }

  //Fields
  late PdfField _field;

  //Implementations
  /// Clears all items in the list.
  void clear() {
    _field._array._clear();
    _list.clear();
    _field._dictionary.remove(_DictionaryProperties.kids);
  }

  void _add(PdfFieldItem item) {
    _list.add(item);
  }
}
