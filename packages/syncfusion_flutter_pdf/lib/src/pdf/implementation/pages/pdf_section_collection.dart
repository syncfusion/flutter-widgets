part of pdf;

/// Represents the collection of the [PdfSection].
class PdfSectionCollection implements _IPdfWrapper {
  //Constructor
  /// Initializes a new instance of the [PdfSectionCollection] class.
  PdfSectionCollection._(PdfDocument document) {
    _document = document;
    _initialize();
  }

  //Constants
  static const int _rotateFactor = 90;

  //Fields
  PdfDocument? _document;
  _PdfNumber? _count;
  _PdfDictionary? _pages;
  final List<PdfSection> _sections = <PdfSection>[];
  _PdfArray? _sectionCollection;

  //Properties
  /// Gets the [PdfSection] at the specified index (Read only).
  PdfSection operator [](int index) => _returnValue(index);

  ///Gets the total number of [PdfSection] in a document. Read only.
  int get count => _sections.length;

  //Public methods
  /// Creates a new [PdfSection] and adds it to the collection.
  PdfSection add() {
    final PdfSection section = PdfSection._(_document);
    _addSection(section);
    return section;
  }

  //Implementation
  /// Adds the specified section.
  void _addSection(PdfSection section) {
    final _PdfReferenceHolder holder = _PdfReferenceHolder(section);
    _sections.add(section);
    section._parent = this;
    _sectionCollection!._add(holder);
  }

  void _initialize() {
    _count = _PdfNumber(0);
    _sectionCollection = _PdfArray();
    _pages = _PdfDictionary();
    _pages!._beginSave = _beginSave;
    _pages![_DictionaryProperties.type] = _PdfName('Pages');
    _pages![_DictionaryProperties.kids] = _sectionCollection;
    _pages![_DictionaryProperties.count] = _count;
    _pages![_DictionaryProperties.resources] = _PdfDictionary();
    _setPageSettings(_pages!, _document!.pageSettings);
  }

  /// Check key and return the value.
  PdfSection _returnValue(int index) {
    if (index < 0 || index >= _sections.length) {
      throw ArgumentError.value(index, 'index out of range');
    }
    return _sections[index];
  }

  void _setPageSettings(
      _PdfDictionary dictionary, PdfPageSettings pageSettings) {
    final List<double?> list = <double?>[
      0,
      0,
      pageSettings._size.width,
      pageSettings._size.height
    ];
    dictionary[_DictionaryProperties.mediaBox] = _PdfArray(list);
    if (pageSettings.rotate != PdfPageRotateAngle.rotateAngle0) {
      dictionary[_DictionaryProperties.rotate] =
          _PdfNumber(_rotateFactor * pageSettings.rotate.index);
    }
  }

  int _countPages() {
    int count = 0;
    for (int i = 0; i < _sections.length; i++) {
      final PdfSection section = _sections[i];
      count += section._count;
    }
    return count;
  }

  void _beginSave(Object sender, _SavePdfPrimitiveArgs? args) {
    _count!.value = _countPages();
    _setPageSettings(_pages!, _document!.pageSettings);
  }

  @override
  _IPdfPrimitive? get _element => _pages;

  @override
  //ignore: unused_element
  set _element(_IPdfPrimitive? value) {
    _pages = value as _PdfDictionary?;
  }
}
