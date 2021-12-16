/// The class used to handle the collection of PDF objects.
abstract class PdfObjectCollection {
  //Fields
  late PdfObjectCollectionHelper _objectCollectionHelper;

  //Properties
  /// Gets number of the elements in the collection.
  int get count => _objectCollectionHelper.list.length;
}

/// [PdfObjectCollection] helper
class PdfObjectCollectionHelper {
  /// internal constructor
  PdfObjectCollectionHelper(this.collection) {
    list = <Object>[];
    collection._objectCollectionHelper = this;
  }

  /// internal field
  late PdfObjectCollection collection;

  /// internal method
  static PdfObjectCollectionHelper getHelper(PdfObjectCollection collection) {
    return collection._objectCollectionHelper;
  }

  /// internal field
  late List<Object> list;
}
