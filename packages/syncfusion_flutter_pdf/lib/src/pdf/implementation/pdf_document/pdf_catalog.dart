part of pdf;

/// Represents internal catalog of the PDF document.
class _PdfCatalog extends _PdfDictionary {
  /// Initializes a new instance of the [PdfCatalog] class.
  _PdfCatalog() {
    this[_DictionaryProperties.type] = _PdfName('Catalog');
  }

  _PdfCatalog.fromDocument(PdfDocument document, _PdfDictionary catalog)
      : super(catalog) {
    _document = document;
    freezeChanges(this);
  }

  PdfSectionCollection _sections;
  // ignore: unused_field
  PdfDocument _document;
  // ignore: unused_field
  PdfSectionCollection get _pages => _sections;
  set _pages(PdfSectionCollection sections) {
    if (_sections != sections) {
      _sections = sections;
      this[_DictionaryProperties.pages] = _PdfReferenceHolder(sections);
    }
  }

  _PdfDictionary get _destinations {
    _PdfDictionary dests;
    if (containsKey(_DictionaryProperties.dests)) {
      dests = _PdfCrossTable._dereference(this[_DictionaryProperties.dests])
          as _PdfDictionary;
    }
    return dests;
  }
}
