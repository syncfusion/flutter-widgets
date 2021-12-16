import '../../interfaces/pdf_interface.dart';
import '../general/pdf_collection.dart';
import '../primitives/pdf_array.dart';
import '../primitives/pdf_reference_holder.dart';
import 'pdf_check_box_field.dart';
import 'pdf_radio_button_list_field.dart';

/// Represents an item of a radio button list.
class PdfRadioButtonItemCollection extends PdfObjectCollection
    implements IPdfWrapper {
  //Constructor
  /// Initializes a new instance of the [PdfRadioButtonItemCollection]
  /// class with the specific [PdfRadioButtonListField].
  PdfRadioButtonItemCollection._(PdfRadioButtonListField field) {
    _helper = PdfRadioButtonItemCollectionHelper(this, field);
  }

  //Fields
  late PdfRadioButtonItemCollectionHelper _helper;

  //Properties
  /// Gets the PdfRadioButtonListItem at the specified index.
  PdfRadioButtonListItem operator [](int index) =>
      _helper.list[index] as PdfRadioButtonListItem;

  //Implementation

  /// Adds the specified item.
  int add(PdfRadioButtonListItem item) {
    return _helper.doAdd(item, false);
  }

  /// Inserts an item at the specified index.
  void insert(int index, PdfRadioButtonListItem item) {
    _helper.doInsert(index, item);
  }

  /// Removes the specified item from the collection.
  void remove(PdfRadioButtonListItem item) {
    _helper.doRemove(item);
  }

  /// Removes the item at the specified index.
  void removeAt(int index) {
    _helper.removeAt(index);
  }

  /// Gets the index of the item within the collection.
  int indexOf(PdfRadioButtonListItem item) => _helper.indexOf(item);

  /// Determines whether the collection contains the specified item.
  bool contains(PdfRadioButtonListItem item) => _helper.contains(item);

  /// Clears the item collection.
  void clear() => _helper.doClear();
}

/// [PdfRadioButtonItemCollection] helper
class PdfRadioButtonItemCollectionHelper extends PdfObjectCollectionHelper {
  /// internal constructor
  PdfRadioButtonItemCollectionHelper(this.radioButtonItemCollection, this.field)
      : super(radioButtonItemCollection);

  /// internal field
  PdfRadioButtonItemCollection radioButtonItemCollection;

  /// internal field
  PdfRadioButtonListField? field;

  /// internal field
  PdfArray array = PdfArray();

  /// internal method
  static PdfRadioButtonItemCollectionHelper getHelper(
      PdfRadioButtonItemCollection collection) {
    return collection._helper;
  }

  /// internal method
  static PdfRadioButtonItemCollection getCollection(
      PdfRadioButtonListField field) {
    return PdfRadioButtonItemCollection._(field);
  }

  /// internal property
  IPdfPrimitive get element => array;
  // ignore: unused_element
  set element(IPdfPrimitive? value) {
    if (value != null && value is PdfArray) {
      array = value;
    }
  }

  /// Gets the index of the item within the collection.
  int indexOf(PdfRadioButtonListItem item) => list.indexOf(item);

  /// Determines whether the collection contains the specified item.
  bool contains(PdfRadioButtonListItem item) => list.contains(item);

  /// internal method
  int doAdd(PdfRadioButtonListItem item, bool isItem) {
    array.add(PdfReferenceHolder(item));
    PdfRadioButtonListItemHelper.getHelper(item).setField(field, isItem);
    list.add(item);
    return list.length - 1;
  }

  /// internal method
  void removeAt(int index) {
    RangeError.range(index, 0, list.length);
    array.removeAt(index);
    final PdfRadioButtonListItem item = list[index] as PdfRadioButtonListItem;
    PdfRadioButtonListItemHelper.getHelper(item).setField(null);
    list.removeAt(index);
    if ((field != null &&
            PdfRadioButtonListFieldHelper.getHelper(field!).selectedIndex >=
                index) ||
        (list.isEmpty)) {
      PdfRadioButtonListFieldHelper.getHelper(field!).selectedIndex = -1;
    }
  }

  /// internal method
  void doInsert(int index, PdfRadioButtonListItem item) {
    array.insert(index, PdfReferenceHolder(item));
    PdfRadioButtonListItemHelper.getHelper(item).setField(field);
    list.insert(index, item);
  }

  /// internal method
  void doRemove(PdfRadioButtonListItem item) {
    if (list.contains(item)) {
      final int index = list.indexOf(item);
      array.removeAt(index);
      PdfRadioButtonListItemHelper.getHelper(item).setField(null);
      list.removeAt(index);
      if ((field != null &&
              PdfRadioButtonListFieldHelper.getHelper(field!).selectedIndex >=
                  index) ||
          (list.isEmpty)) {
        PdfRadioButtonListFieldHelper.getHelper(field!).selectedIndex = -1;
      }
    }
  }

  /// internal method
  void doClear() {
    final List<Object> objects = list;
    for (final Object? item in objects) {
      if (item is PdfRadioButtonListItem) {
        PdfRadioButtonListItemHelper.getHelper(item).setField(null);
      }
    }
    array.clear();
    list.clear();
    PdfRadioButtonListFieldHelper.getHelper(field!).selectedIndex = -1;
  }
}
