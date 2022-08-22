import '../../general/pdf_collection.dart';
import 'pdf_list_item.dart';

/// Represents collection of list items.
///
/// ```dart
/// //Create a new PDF document.
/// PdfDocument document = PdfDocument();
/// //Create a new ordered list.
/// PdfOrderedList(
///     //Create a new list item collection.
///     items: PdfListItemCollection(['PDF', 'XlsIO', 'DocIO', 'PPT']),
///     font: PdfStandardFont(PdfFontFamily.helvetica, 16,
///         style: PdfFontStyle.italic),
///     format: PdfStringFormat(lineSpacing: 20),
///     marker: PdfOrderedMarker(style: PdfNumberStyle.numeric),
///     style: PdfNumberStyle.numeric,
///     indent: 15,
///     textIndent: 10)
///   ..draw(page: document.pages.add(), bounds: Rect.fromLTWH(20, 20, 0, 0));
/// //Save the document.
/// List<int> bytes = await document.save();
/// //Dispose the document.
/// document.dispose();
/// ```
class PdfListItemCollection extends PdfObjectCollection {
  //Constructor
  /// Initializes a new instance of the [PdfListItemCollection] class.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument document = PdfDocument();
  /// //Create a new ordered list.
  /// PdfOrderedList(
  ///     //Create a new list item collection.
  ///     items: PdfListItemCollection(['PDF', 'XlsIO', 'DocIO', 'PPT']),
  ///     font: PdfStandardFont(PdfFontFamily.helvetica, 16,
  ///         style: PdfFontStyle.italic),
  ///     format: PdfStringFormat(lineSpacing: 20),
  ///     marker: PdfOrderedMarker(style: PdfNumberStyle.numeric),
  ///     style: PdfNumberStyle.numeric,
  ///     indent: 15,
  ///     textIndent: 10)
  ///   ..draw(page: document.pages.add(), bounds: Rect.fromLTWH(20, 20, 0, 0));
  /// //Save the document.
  /// List<int> bytes = await document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  PdfListItemCollection([List<String>? items]) {
    _helper = PdfListItemCollectionHelper(this, items);
  }

  //Fields
  late PdfListItemCollectionHelper _helper;

  //Properties
  /// Gets the [PdfListItem] from collection at the specified index.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument document = PdfDocument();
  /// //Create a new ordered list.
  /// PdfOrderedList(
  ///     items: PdfListItemCollection(['Essential tools', 'Essential grid']),
  ///     font: PdfStandardFont(PdfFontFamily.helvetica, 16,
  ///         style: PdfFontStyle.italic))
  ///   ..items[0].subList =
  ///       PdfOrderedList(items: PdfListItemCollection(['PDF', 'DocIO']))
  ///   ..draw(
  ///       page: document.pages.add(), bounds: const Rect.fromLTWH(20, 20, 0, 0));
  /// //Save the document.
  /// List<int> bytes = await document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  PdfListItem operator [](int index) => _helper.getValue(index);

  //Public methods
  /// Adds the specified item.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument document = PdfDocument();
  /// //Create a new ordered list.
  /// PdfOrderedList(
  ///     items: PdfListItemCollection()
  ///       //Add items to list item collection
  ///       ..add(PdfListItem(text: 'PDF'))
  ///       ..add(PdfListItem(text: 'DocIO')),
  ///     font: PdfStandardFont(PdfFontFamily.helvetica, 16,
  ///         style: PdfFontStyle.italic))
  ///   ..draw(
  ///       page: document.pages.add(), bounds: const Rect.fromLTWH(20, 20, 0, 0));
  /// //Save the document.
  /// List<int> bytes = await document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  int add(PdfListItem item, [double? itemIndent]) {
    return _helper.add(item, itemIndent);
  }

  /// Inserts item at the specified index.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument document = PdfDocument();
  /// //Create a new ordered list.
  /// PdfOrderedList(
  ///     items: PdfListItemCollection()
  ///       ..add(PdfListItem(text: 'PDF'))
  ///       //insert items to list item collection
  ///       ..insert(0, PdfListItem(text: 'DocIO')),
  ///     font: PdfStandardFont(PdfFontFamily.helvetica, 16,
  ///         style: PdfFontStyle.italic))
  ///   ..draw(
  ///       page: document.pages.add(), bounds: const Rect.fromLTWH(20, 20, 0, 0));
  /// //Save the document.
  /// List<int> bytes = await document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  void insert(int index, PdfListItem item, [double? itemIndent]) {
    _helper.insert(index, item, itemIndent);
  }

  /// Removes the specified item from the list.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument document = PdfDocument();
  /// //Create a new ordered list.
  /// PdfList list = PdfOrderedList(
  ///     items: PdfListItemCollection()
  ///       ..add(PdfListItem(text: 'PDF'))
  ///       ..add(PdfListItem(text: 'DocIO')),
  ///     font: PdfStandardFont(PdfFontFamily.helvetica, 16,
  ///         style: PdfFontStyle.italic));
  /// //Remove a specific item
  /// list
  ///   ..items.remove(list.items[0])
  ///   ..draw(
  ///       page: document.pages.add(), bounds: const Rect.fromLTWH(20, 20, 0, 0));
  /// //Save the document.
  /// List<int> bytes = await document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  void remove(PdfListItem item) {
    _helper.remove(item);
  }

  /// Removes the item at the specified index from the list.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument document = PdfDocument();
  /// //Create a new ordered list.
  /// PdfOrderedList(
  ///     items: PdfListItemCollection()
  ///       ..add(PdfListItem(text: 'PDF'))
  ///       ..insert(0, PdfListItem(text: 'DocIO'))
  ///       //Remove item at specific index.
  ///       ..removeAt(1),
  ///     font: PdfStandardFont(PdfFontFamily.helvetica, 16,
  ///         style: PdfFontStyle.italic))
  ///   ..draw(
  ///       page: document.pages.add(), bounds: const Rect.fromLTWH(20, 20, 0, 0));
  /// //Save the document.
  /// List<int> bytes = await document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  void removeAt(int index) {
    _helper.removeAt(index);
  }

  /// Determines the index of a specific item in the list.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument document = PdfDocument();
  /// //Create a list item.
  /// PdfListItem item = PdfListItem(text: 'PDF');
  /// //Create a new ordered list.
  /// PdfOrderedList oList = PdfOrderedList(
  ///     items: PdfListItemCollection()
  ///       ..add(item)
  ///       ..add(PdfListItem(text: 'DocIO')),
  ///     font: PdfStandardFont(PdfFontFamily.helvetica, 16,
  ///         style: PdfFontStyle.italic));
  /// //Get the index of specific item.
  /// int index = oList.items.indexOf(item);
  /// //Draw the list to the page.
  /// oList.draw(
  ///     page: document.pages.add(), bounds: const Rect.fromLTWH(20, 20, 0, 0));
  /// //Save the document.
  /// List<int> bytes = await document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  int indexOf(PdfListItem item) {
    return _helper.indexOf(item);
  }

  /// Clears collection
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument document = PdfDocument();
  /// //Create a new ordered list.
  /// PdfOrderedList(
  ///     items: PdfListItemCollection()
  ///       ..add(PdfListItem(text: 'PDF'))
  ///       ..add(PdfListItem(text: 'DocIO'))
  ///       //Clears the all items in the collection.
  ///       ..clear()
  ///       ..add(PdfListItem(text: 'DocIO')),
  ///     font: PdfStandardFont(PdfFontFamily.helvetica, 16,
  ///         style: PdfFontStyle.italic))
  ///   ..draw(
  ///       page: document.pages.add(), bounds: const Rect.fromLTWH(20, 20, 0, 0));
  /// //Save the document.
  /// List<int> bytes = await document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  void clear() {
    _helper.clear();
  }
}

/// [PdfListItemCollection] helper
class PdfListItemCollectionHelper extends PdfObjectCollectionHelper {
  /// internal constructor
  PdfListItemCollectionHelper(this.base, List<String>? items) : super(base) {
    if (items != null) {
      for (int i = 0; i < items.length; i++) {
        _add(items[i]);
      }
    }
  }

  /// internal field
  PdfListItemCollection base;

  /// internal method
  PdfListItem _add(String text) {
    final PdfListItem item = PdfListItem(text: text);
    list.add(item);
    return item;
  }

  /// internal method
  PdfListItem getValue(int index) {
    if (index < 0 || index >= base.count) {
      throw RangeError(
          "The index should be less than item's count or more or equal to 0");
    }
    return list[index] as PdfListItem;
  }

  /// internal method
  int add(PdfListItem item, double? itemIndent) {
    if (itemIndent != null) {
      item.textIndent = itemIndent;
    }
    list.add(item);
    return list.length - 1;
  }

  /// internal method
  void insert(int index, PdfListItem item, double? itemIndent) {
    if (index < 0 || index >= base.count) {
      throw ArgumentError(
          "The index should be less than item's count or more or equal to 0, $index");
    }
    if (itemIndent != null) {
      item.textIndent = itemIndent;
    }
    list.insert(index, item);
  }

  /// internal method
  void remove(PdfListItem item) {
    if (!list.contains(item)) {
      throw ArgumentError("The list doesn't contain this item, $item");
    }
    list.remove(item);
  }

  /// internal method
  void removeAt(int index) {
    if (index < 0 || index >= base.count) {
      throw ArgumentError(
          "The index should be less than item's count or more or equal to 0, $index");
    }
    list.removeAt(index);
  }

  /// Determines the index of a specific item in the list.
  int indexOf(PdfListItem item) {
    return list.indexOf(item);
  }

  /// Clears collection
  void clear() {
    list.clear();
  }
}
