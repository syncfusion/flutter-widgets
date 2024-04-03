import '../general/pdf_collection.dart';
import '../io/pdf_constants.dart';
import 'pdf_field.dart';
import 'pdf_field_item.dart';

/// Represents collection field items.
class PdfFieldItemCollection extends PdfObjectCollection {
  //Constructor
  PdfFieldItemCollection._(PdfField field) {
    _helper = PdfFieldItemCollectionHelper(this, field);
  }

  //Fields
  late PdfFieldItemCollectionHelper _helper;

  //Properties
  /// Gets the Field item at the specified index.
  PdfFieldItem operator [](int index) {
    if (index < 0 || index >= count) {
      throw RangeError('index');
    }
    return _helper.list[index] as PdfFieldItem;
  }

  //Implementations
  /// Clears all items in the list.
  void clear() {
    _helper.clear();
  }
}

/// [PdfFieldItemCollection] helper
class PdfFieldItemCollectionHelper extends PdfObjectCollectionHelper {
  /// internal constructor
  PdfFieldItemCollectionHelper(this.fieldItemCollection, this.field)
      : super(fieldItemCollection);

  /// internal field
  late PdfFieldItemCollection fieldItemCollection;

  /// internal field
  late PdfField field;

  /// internal field
  bool allowUncheck = true;

  /// internal method
  static PdfFieldItemCollection load(PdfField field) {
    return PdfFieldItemCollection._(field);
  }

  /// internal method
  static PdfFieldItemCollectionHelper getHelper(
      PdfFieldItemCollection collection) {
    return collection._helper;
  }

  /// internal method
  void add(PdfFieldItem item) {
    list.add(item);
  }

  /// internal method
  void clear() {
    PdfFieldHelper.getHelper(field).array.clear();
    list.clear();
    PdfFieldHelper.getHelper(field)
        .dictionary!
        .remove(PdfDictionaryProperties.kids);
  }
}
