part of pdf;

/// The class used to handle the collection of PDF objects.
class PdfObjectCollection {
  //Constructor
  /// Initializes a new instance of the [PdfObjectCollection] class.
  PdfObjectCollection() {
    _list = <Object>[];
  }

  //Fields
  late List<Object> _list;

  //Properties
  /// Gets number of the elements in the collection.
  int get count => _list.length;
}
