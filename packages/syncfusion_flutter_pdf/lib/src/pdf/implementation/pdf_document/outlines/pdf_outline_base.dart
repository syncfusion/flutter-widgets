part of pdf;

/// This class plays two roles: it's a base class for all bookmarks
/// and it's a root of a bookmarks tree.
///
/// ```dart
/// //Load the PDF document.
/// PdfDocument document = PdfDocument(inputBytes: inputBytes);
/// //Get the bookmark from index.
/// PdfBookmark bookmarks = document.bookmarks[0]
///   ..destination = PdfDestination(document.pages[1])
///   ..color = PdfColor(0, 255, 0)
///   ..textStyle = [PdfTextStyle.bold]
///   ..title = 'Changed title';
/// //Save the document.
/// List<int> bytes = document.save();
/// //Dispose the document.
/// document.dispose();
/// ```
class PdfBookmarkBase implements _IPdfWrapper {
  //Constructor
  /// Initializes a new instance of the [PdfBookmarkBase] class.
  PdfBookmarkBase._internal() : super();

  PdfBookmarkBase._load(
      _PdfDictionary? dictionary, _PdfCrossTable? crossTable) {
    _isLoadedBookmark = true;
    _dictionary = dictionary;
    if (crossTable != null) {
      _crossTable = crossTable;
    }
  }

  //Fields
  /// Collection of the descend outlines.
  final List<PdfBookmarkBase> _bookmarkList = <PdfBookmarkBase>[];

  /// Internal variable to store loaded bookmark.
  List<PdfBookmark>? _bookmark;

  /// Internal variable to store dictinary.
  _PdfDictionary? _dictionary = _PdfDictionary();

  /// Whether the bookmark tree is expanded or not
  bool _expanded = false;

  _PdfCrossTable _crossTable = _PdfCrossTable();
  List<PdfBookmarkBase>? _booklist;
  bool _isLoadedBookmark = false;

  //Properties
  /// Gets number of the elements in the collection. Read-Only.
  ///
  /// ```dart
  /// //Load the PDF document.
  /// PdfDocument document = PdfDocument(inputBytes: inputBytes);
  /// //get the bookmark count.
  /// int count = document.bookmarks.count;
  /// //Save the document.
  /// List<int> bytes = document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  int get count {
    final PdfDocument? document = _crossTable._document;
    if (document != null) {
      if (_booklist == null) {
        _booklist = <PdfBookmarkBase>[];
        for (int n = 0; n < _list.length; n++) {
          _booklist!.add(_list[n]);
        }
      }
      return _list.length;
    } else {
      return _list.length;
    }
  }

  /// Gets the bookmark at specified index.
  ///
  /// ```dart
  /// //Load the PDF document.
  /// PdfDocument document = PdfDocument(inputBytes: inputBytes);
  /// //Get the bookmark from index.
  /// PdfBookmark bookmarks = document.bookmarks[0]
  ///   ..destination = PdfDestination(document.pages[1])
  ///   ..color = PdfColor(0, 255, 0)
  ///   ..textStyle = [PdfTextStyle.bold]
  ///   ..title = 'Changed title';
  /// //Save the document.
  /// List<int> bytes = document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  PdfBookmark operator [](int index) {
    if (index < 0 || index >= count) {
      throw RangeError('index');
    }
    return _list[index] as PdfBookmark;
  }

  List<PdfBookmarkBase> get _list {
    return _bookmarkList;
  }

  /// Gets whether to expand the node or not
  bool get _isExpanded {
    if (_dictionary!.containsKey('Count')) {
      final _PdfNumber number =
          _dictionary![_DictionaryProperties.count] as _PdfNumber;
      return number.value! < 0 ? false : true;
    } else {
      return _expanded;
    }
  }

  /// Sets whether to expand the node or not
  set _isExpanded(bool value) {
    _expanded = value;
    if (count > 0) {
      final int newCount = _expanded ? _list.length : -_list.length;
      _dictionary![_DictionaryProperties.count] = _PdfNumber(newCount);
    }
  }

  //Public methods
  /// Adds the bookmark from the document.
  ///
  /// ```dart
  /// //Create a new document.
  /// PdfDocument document = PdfDocument();
  /// //Add bookmarks to the document.
  /// document.bookmarks.add('Page 1')
  ///   ..destination = PdfDestination(document.pages.add(), Offset(20, 20))
  ///   ..textStyle = [PdfTextStyle.bold]
  ///   ..color = PdfColor(255, 0, 0);
  /// //Save the document.
  /// List<int> bytes = document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  PdfBookmark add(String title,
      {bool isExpanded = false,
      PdfColor? color,
      PdfDestination? destination,
      PdfNamedDestination? namedDestination,
      PdfAction? action,
      List<PdfTextStyle>? textStyle}) {
    final PdfBookmark? previous = (count < 1) ? null : this[count - 1];
    final PdfBookmark outline =
        PdfBookmark._internal(title, this, previous, null);
    if (previous != null) {
      previous._next = outline;
    }
    _list.add(outline);
    _updateFields();
    return outline;
  }

  /// Determines whether the specified outline presents in the collection.
  /// ```dart
  /// //Create a new document.
  /// PdfDocument document = PdfDocument();
  /// //Add bookmarks to the document.
  /// PdfBookmark bookmark = document.bookmarks.add('Page 1')
  ///   ..destination = PdfDestination(document.pages.add(), Offset(20, 20));
  /// //check whether the specified bookmark present in the collection
  /// bool contains = document.bookmarks.contains(bookmark);
  /// //Save the document.
  /// List<int> bytes = document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  bool contains(PdfBookmark outline) {
    return _list.contains(outline);
  }

  /// Remove the specified bookmark from the document.
  ///
  /// ```dart
  /// //Load the PDF document.
  /// PdfDocument document = PdfDocument(inputBytes: inputBytes);
  /// //Get all the bookmarks.
  /// PdfBookmarkBase bookmarks = document.bookmarks;
  /// //Remove specified bookmark.
  /// bookmarks.remove('bookmark');
  /// //Save the document.
  /// List<int> bytes = document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  void remove(String title) {
    int index = -1;
    if (_bookmark == null || _bookmark!.length < _list.length) {
      _bookmark = <PdfBookmark>[];
      for (int n = 0; n < _list.length; n++) {
        if (_list[n] is PdfBookmark) {
          _bookmark!.add(_list[n] as PdfBookmark);
        }
      }
    }
    for (int c = 0; c < _bookmark!.length; c++) {
      if (_bookmark![c] is PdfBookmark) {
        final PdfBookmark pdfbookmark = _bookmark![c];
        if (pdfbookmark.title == title) {
          index = c;
          break;
        }
      }
    }
    removeAt(index);
  }

  /// Remove the bookmark from the document at the specified index.
  ///
  /// ```dart
  /// //Load the PDF document.
  /// PdfDocument document = PdfDocument(inputBytes: inputBytes);
  /// //Remove specified bookmark using index.
  /// document.bookmarks.removeAt(0);
  /// //Save the document.
  /// List<int> bytes = document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  void removeAt(int index) {
    if (_bookmark == null || _bookmark!.length < _list.length) {
      _bookmark = <PdfBookmark>[];
      for (int n = 0; n < _list.length; n++) {
        if (_list[n] is PdfBookmark?) {
          _bookmark!.add(_list[n] as PdfBookmark);
        }
      }
    }
    if (index < 0 || index >= _bookmark!.length) {
      throw RangeError.value(index);
    }
    if (_bookmark![index] is PdfBookmark) {
      final PdfBookmark current = _bookmark![index];
      if (index == 0) {
        if (current._dictionary!.containsKey(_DictionaryProperties.next)) {
          _dictionary!.setProperty(_DictionaryProperties.first,
              current._dictionary![_DictionaryProperties.next]);
        } else {
          _dictionary!.remove(_DictionaryProperties.first);
          _dictionary!.remove(_DictionaryProperties.last);
        }
      } else if ((current._parent != null) &&
          (current._previous != null) &&
          (current._next != null)) {
        current._previous!._dictionary!.setProperty(_DictionaryProperties.next,
            current._dictionary![_DictionaryProperties.next]);
        current._next!._dictionary!.setProperty(_DictionaryProperties.prev,
            current._dictionary![_DictionaryProperties.prev]);
      } else if ((current._parent != null) &&
          (current._previous != null) &&
          (current._next == null)) {
        current._previous!._dictionary!.remove(_DictionaryProperties.next);
        current._parent!._dictionary!.setProperty(_DictionaryProperties.last,
            current._dictionary![_DictionaryProperties.prev]);
      }
      if (current._parent != null) {
        current._parent!._list.remove(current);
      }
    }
    _bookmark!.clear();
    _updateFields();
  }

  /// Removes all the bookmark from the collection.
  ///
  /// ```dart
  /// //Load the PDF document.
  /// PdfDocument document = PdfDocument(inputBytes: inputBytes);
  /// //Clear all the bookmarks.
  /// document.bookmarks.clear();
  /// //Save the document.
  /// List<int> bytes = document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  void clear() {
    _list.clear();
    if (_bookmark != null) {
      _bookmark!.clear();
    }
    if (_booklist != null) {
      _booklist!.clear();
    }
    _updateFields();
  }

  /// Inserts a new outline at the specified index.
  ///
  /// ```dart
  /// //Create a new document.
  /// PdfDocument document = PdfDocument();
  /// //Insert bookmark at specified index
  /// document.bookmarks.insert(0, 'bookmark')
  ///   ..destination = PdfDestination(document.pages.add(), Offset(20, 20));
  /// //Save the document.
  /// List<int> bytes = document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  PdfBookmark insert(int index, String title) {
    if (index < 0 || index > count) {
      throw RangeError.value(index);
    }
    PdfBookmark outline;
    if (index == count) {
      outline = add(title);
    } else {
      final PdfBookmark next = this[index];
      final PdfBookmark? prevoius = (index == 0) ? null : this[index - 1];
      outline = PdfBookmark._internal(title, this, prevoius, next);
      _list.insert(index, outline);
      if (prevoius != null) {
        prevoius._next = outline;
      }
      next._previous = outline;
      _updateFields();
    }
    return outline;
  }

  //Implementations
  /// Updates all outline dictionary fields.
  void _updateFields() {
    if (count > 0) {
      final int newCount = _isExpanded ? _list.length : -_list.length;
      _dictionary![_DictionaryProperties.count] = _PdfNumber(newCount);
      _dictionary!.setProperty(
          _DictionaryProperties.first, _PdfReferenceHolder(this[0]));
      _dictionary!.setProperty(
          _DictionaryProperties.last, _PdfReferenceHolder(this[count - 1]));
    } else {
      _dictionary!.clear();
    }
  }

  void _reproduceTree() {
    PdfBookmark? currentBookmark = _getFirstBookMark(this);
    bool isBookmark = currentBookmark != null;
    while (isBookmark && currentBookmark!._dictionary != null) {
      currentBookmark._setParent(this);
      _bookmarkList.add(currentBookmark);
      currentBookmark = currentBookmark._next;
      isBookmark = currentBookmark != null;
    }
  }

  PdfBookmark? _getFirstBookMark(PdfBookmarkBase bookmark) {
    PdfBookmark? firstBookmark;
    final _PdfDictionary dictionary = bookmark._dictionary!;
    if (dictionary.containsKey(_DictionaryProperties.first)) {
      final _PdfDictionary? first =
          _crossTable._getObject(dictionary[_DictionaryProperties.first])
              as _PdfDictionary?;
      firstBookmark = PdfBookmark._load(first, _crossTable);
    }
    return firstBookmark;
  }

  /// Gets the element.
  @override
  _IPdfPrimitive? get _element => _dictionary;

  @override
  // ignore: unused_element
  set _element(_IPdfPrimitive? value) {
    throw ArgumentError();
  }
}

class _CurrentNodeInfo {
  _CurrentNodeInfo(List<PdfBookmarkBase?> kids, [int? index]) {
    this.kids = kids;
    this.index = index ?? 0;
  }
  //Fields
  late List<PdfBookmarkBase?> kids;
  late int index;
}
