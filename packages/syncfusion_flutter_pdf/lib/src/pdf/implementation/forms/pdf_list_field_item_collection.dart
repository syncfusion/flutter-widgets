import '../../interfaces/pdf_interface.dart';
import '../general/pdf_collection.dart';
import '../io/pdf_constants.dart';
import '../primitives/pdf_array.dart';
import '../primitives/pdf_string.dart';
import 'pdf_field.dart';
import 'pdf_list_field.dart';
import 'pdf_list_field_item.dart';

/// Represents list field item collection.
class PdfListFieldItemCollection extends PdfObjectCollection
    implements IPdfWrapper {
  //Constructor
  PdfListFieldItemCollection._([PdfListField? field]) : super() {
    _helper = PdfListFieldItemCollectionHelper(this);
    if (field != null) {
      _field = field;
    }
  }

  //Fields
  late PdfListFieldItemCollectionHelper _helper;
  PdfListField? _field;

  //Properties
  /// Gets the [PdfListFieldItem] at the specified index.
  PdfListFieldItem operator [](int index) {
    if (index < 0 || index >= count) {
      throw RangeError('index');
    }
    return _helper.list[index] as PdfListFieldItem;
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
    if (_helper.list.contains(item)) {
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
    return _helper.list.contains(item);
  }

  /// Gets the index of the specified item.
  int indexOf(PdfListFieldItem item) {
    return _helper.list.indexOf(item);
  }

  /// Clears the collection.
  void clear() {
    if (_field != null && PdfFieldHelper.getHelper(_field!).isLoadedField) {
      final PdfArray list = _getItems()..clear();
      PdfFieldHelper.getHelper(_field!)
          .dictionary!
          .setProperty(PdfDictionaryProperties.opt, list);
    } else {
      _helper._items.clear();
    }
    _helper.list.clear();
  }

  //Implementations
  int _doAdd(PdfListFieldItem item) {
    if (_field != null && PdfFieldHelper.getHelper(_field!).isLoadedField) {
      final PdfArray list = _getItems();
      final PdfArray itemArray = _getArray(item);
      list.add(itemArray);
      PdfFieldHelper.getHelper(_field!)
          .dictionary!
          .setProperty(PdfDictionaryProperties.opt, list);
    } else {
      _helper._items.add(IPdfWrapper.getElement(item)!);
    }
    _helper.list.add(item);
    return count - 1;
  }

  void _doInsert(int index, PdfListFieldItem item) {
    if (_field != null && PdfFieldHelper.getHelper(_field!).isLoadedField) {
      final PdfArray list = _getItems();
      final PdfArray itemArray = _getArray(item);
      list.insert(index, itemArray);
      PdfFieldHelper.getHelper(_field!)
          .dictionary!
          .setProperty(PdfDictionaryProperties.opt, list);
    } else {
      _helper._items.insert(index, IPdfWrapper.getElement(item)!);
    }
    _helper.list.insert(index, item);
  }

  void _doRemove(PdfListFieldItem? item, [int? index]) {
    if (index == null && item != null) {
      index = _helper.list.indexOf(item);
    }
    if (_field != null && PdfFieldHelper.getHelper(_field!).isLoadedField) {
      final PdfArray list = _getItems()..removeAt(index!);
      PdfFieldHelper.getHelper(_field!)
          .dictionary!
          .setProperty(PdfDictionaryProperties.opt, list);
    } else {
      _helper._items.removeAt(index!);
    }
    _helper.list.removeAt(index);
  }

  PdfArray _getItems() {
    PdfArray? items;
    if (PdfFieldHelper.getHelper(_field!)
        .dictionary!
        .containsKey(PdfDictionaryProperties.opt)) {
      final IPdfPrimitive? obj = PdfFieldHelper.getHelper(_field!)
          .crossTable!
          .getObject(PdfFieldHelper.getHelper(_field!)
              .dictionary![PdfDictionaryProperties.opt]);
      if (obj != null && obj is PdfArray) {
        items = obj;
      }
    }
    return items ?? PdfArray();
  }

  PdfArray _getArray(PdfListFieldItem item) {
    final PdfArray array = PdfArray();
    if (item.value != '') {
      array.add(PdfString(item.value));
    }
    if (item.value != '') {
      array.add(PdfString(item.text));
    }
    return array;
  }
}

/// [PdfListFieldItemCollection] helper
class PdfListFieldItemCollectionHelper extends PdfObjectCollectionHelper {
  /// internal constructor
  PdfListFieldItemCollectionHelper(this.listFieldItemCollection)
      : super(listFieldItemCollection);

  /// internal field
  PdfListFieldItemCollection listFieldItemCollection;
  final PdfArray _items = PdfArray();

  /// internal property
  IPdfPrimitive? get element => _items;
  // ignore: unused_element
  set element(IPdfPrimitive? value) {
    throw ArgumentError("Primitive element can't be set");
  }

  /// internal method
  static PdfListFieldItemCollectionHelper getHelper(
      PdfListFieldItemCollection itemCollection) {
    return itemCollection._helper;
  }

  /// internal method
  static PdfListFieldItemCollection itemCollection([PdfListField? field]) {
    return PdfListFieldItemCollection._(field);
  }

  /// internal method
  int addItem(PdfListFieldItem item) {
    list.add(item);
    return listFieldItemCollection.count - 1;
  }
}
