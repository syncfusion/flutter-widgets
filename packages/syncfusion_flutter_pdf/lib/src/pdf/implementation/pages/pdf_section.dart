part of pdf;

/// Represents a section entity. A section is a set of the pages
/// with similar page settings.
/// ```dart
/// //Create a new PDF documentation
/// PdfDocument document = PdfDocument();
/// //Create a new PDF section
/// PdfSection section = document.sections!.add();
/// //Create a new PDF page and draw the text
/// section.pages.add().graphics.drawString(
///     'Hello World!!!', PdfStandardFont(PdfFontFamily.helvetica, 27),
///     brush: PdfBrushes.darkBlue, bounds: const Rect.fromLTWH(170, 100, 0, 0));
/// //Save the document.
/// List<int> bytes = document.save();
/// //Dispose the document.
/// document.dispose();
/// ```
class PdfSection implements _IPdfWrapper {
  //Constructor
  /// Initializes a new instance of the [PdfSection] class.
  PdfSection._(PdfDocument? document, [PdfPageSettings? settings]) {
    _pageReferences = _PdfArray();
    _section = _PdfDictionary();
    _section!._beginSave = _beginSave;
    _pageCount = _PdfNumber(0);
    _section![_DictionaryProperties.count] = _pageCount;
    _section![_DictionaryProperties.type] =
        _PdfName(_DictionaryProperties.pages);
    _section![_DictionaryProperties.kids] = _pageReferences;
    _pdfDocument = document;
    _settings =
        settings != null ? settings._clone() : document!.pageSettings._clone();
  }

  //Fields
  _PdfArray? _pageReferences;
  _PdfDictionary? _section;
  _PdfNumber? _pageCount;
  PdfDocument? _pdfDocument;
  late PdfPageSettings _settings;
  PdfSectionCollection? _sectionCollection;
  bool? _isNewPageSection = false;
  final List<PdfPage> _pages = <PdfPage>[];

  /// Event rises when the new page has been added
  PageAddedCallback? pageAdded;
  PdfSectionTemplate? _template;
  PdfPageCollection? _pageCollection;

  //Properties
  /// Gets or sets the [PdfSectionTemplate] for the pages in the section.
  /// ```dart
  /// //Create a new PDF documentation
  /// PdfDocument document = PdfDocument();
  /// //Create a new PDF section
  /// PdfSection section = document.sections!.add();
  /// //Sets the page settings of the section
  /// section.pageSettings =
  ///     PdfPageSettings(PdfPageSize.a4, PdfPageOrientation.portrait);
  /// //Sets the template for the page in the section
  /// section.template = PdfSectionTemplate();
  /// //Create a new PDF page and draw the text
  /// section.pages.add().graphics.drawString(
  ///     'Hello World!!!', PdfStandardFont(PdfFontFamily.helvetica, 27),
  ///     brush: PdfBrushes.darkBlue, bounds: const Rect.fromLTWH(170, 100, 0, 0));
  /// //Save the document.
  /// List<int> bytes = document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  PdfSectionTemplate get template {
    _template ??= PdfSectionTemplate();
    return _template!;
  }

  set template(PdfSectionTemplate value) {
    _template = value;
  }

  /// Gets the collection of pages in this section.
  /// ```dart
  /// //Create a new PDF documentation
  /// PdfDocument document = PdfDocument();
  /// //Create a new PDF section
  /// PdfSection section = document.sections!.add();
  /// //Create a new PDF page and draw the text
  /// section.pages.add().graphics.drawString(
  ///     'Hello World!!!', PdfStandardFont(PdfFontFamily.helvetica, 27),
  ///     brush: PdfBrushes.darkBlue, bounds: const Rect.fromLTWH(170, 100, 0, 0));
  /// //Save the document.
  /// List<int> bytes = document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  PdfPageCollection get pages {
    _pageCollection ??= PdfPageCollection._(_pdfDocument, this);
    return _pageCollection!;
  }

  /// Gets or sets the [PdfPageSettings] of the section.
  /// ```dart
  /// //Create a new PDF documentation
  /// PdfDocument document = PdfDocument();
  /// //Create a new PDF section
  /// PdfSection section = document.sections!.add();
  /// //Sets the page settings of the section
  /// section.pageSettings =
  ///     PdfPageSettings(PdfPageSize.a4, PdfPageOrientation.portrait);
  /// //Sets the template for the page in the section
  /// section.template = PdfSectionTemplate();
  /// //Create a new PDF page and draw the text
  /// section.pages.add().graphics.drawString(
  ///     'Hello World!!!', PdfStandardFont(PdfFontFamily.helvetica, 27),
  ///     brush: PdfBrushes.darkBlue, bounds: const Rect.fromLTWH(170, 100, 0, 0));
  /// //Save the document.
  /// List<int> bytes = document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  PdfPageSettings get pageSettings {
    _settings._isPageAdded = _settings.margins._isPageAdded = _pages.isNotEmpty;
    return _settings;
  }

  set pageSettings(PdfPageSettings settings) {
    if (_pages.isEmpty) {
      _settings = settings;
    }
  }

  /// Gets the parent.
  PdfSectionCollection? get _parent => _sectionCollection;

  /// Sets the parent.
  set _parent(PdfSectionCollection? sections) {
    _sectionCollection = sections;
    if (sections != null) {
      _section![_DictionaryProperties.parent] = _PdfReferenceHolder(sections);
    } else {
      _section!.remove(_DictionaryProperties.parent);
    }
  }

  /// Gets the document.
  PdfDocument? get _document {
    if (_sectionCollection != null) {
      return _sectionCollection!._document;
    } else {
      return null;
    }
  }

  /// Gets the count of the pages in the section.
  int get _count => _pageReferences!.count;

  //Implementation
  void _add(PdfPage page) {
    if (!_isNewPageSection!) {
      _isNewPageSection = page._isNewPage;
    }
    final _PdfReferenceHolder holder = _PdfReferenceHolder(page);
    _isNewPageSection = false;
    _pages.add(page);
    _pageReferences!._add(holder);
    page._assignSection(this);
    _pdfPageAdded(page);
  }

  void _remove(PdfPage page) {
    final _PdfReferenceHolder r = _PdfReferenceHolder(page);
    if (_pageReferences!._contains(r)) {
      _pageReferences!._elements.remove(r);
      _pages.remove(page);
    }
  }

  PdfPage? _getPageByIndex(int index) {
    if (index < 0 || index >= _count) {
      throw ArgumentError.value(index, 'our of range');
    }
    return _pages[index];
  }

  void _setPageSettings(_PdfDictionary container,
      [PdfPageSettings? parentSettings]) {
    if (parentSettings == null || pageSettings._size != parentSettings._size) {
      final _Rectangle bounds = _Rectangle(_settings._origin.x,
          _settings._origin.y, _settings.size.width, _settings.size.height);
      container[_DictionaryProperties.mediaBox] =
          _PdfArray.fromRectangle(bounds);
    }
    if (parentSettings == null ||
        pageSettings.rotate != parentSettings.rotate) {
      int rotate = 0;
      if (_sectionCollection != null) {
        if (pageSettings._isRotation && !_document!.pageSettings._isRotation) {
          rotate =
              PdfSectionCollection._rotateFactor * pageSettings.rotate.index;
        } else {
          if (!_document!.pageSettings._isRotation &&
              pageSettings.rotate != PdfPageRotateAngle.rotateAngle0) {
            rotate =
                PdfSectionCollection._rotateFactor * pageSettings.rotate.index;
          } else {
            if (pageSettings._isRotation) {
              rotate = PdfSectionCollection._rotateFactor *
                  pageSettings.rotate.index;
            } else if (parentSettings != null) {
              rotate = PdfSectionCollection._rotateFactor *
                  parentSettings.rotate.index;
            }
          }
        }
      } else {
        rotate = PdfSectionCollection._rotateFactor * pageSettings.rotate.index;
      }
      final _PdfNumber angle = _PdfNumber(rotate);
      if (angle.value != 0) {
        container[_DictionaryProperties.rotate] = angle;
      }
    }
  }

  _Rectangle _getActualBounds(PdfPage page, bool includeMargins,
      [PdfDocument? document]) {
    if (document == null) {
      if (_parent != null) {
        final PdfDocument? pdfDocument = _parent!._document;
        return _getActualBounds(page, includeMargins, pdfDocument!);
      } else {
        final _Size size = includeMargins
            ? _Size.fromSize(pageSettings._getActualSize())
            : pageSettings.size as _Size;
        final double left = includeMargins ? pageSettings.margins.left : 0;
        final double top = includeMargins ? pageSettings.margins.top : 0;
        return _Rectangle(left, top, size.width, size.height);
      }
    } else {
      final _Rectangle bounds = _Rectangle.empty;
      final Size size =
          includeMargins ? pageSettings.size : pageSettings._getActualSize();
      bounds.width = size.width;
      bounds.height = size.height;
      final double left = _getLeftIndentWidth(document, page, includeMargins);
      final double top = _getTopIndentHeight(document, page, includeMargins);
      final double right = _getRightIndentWidth(document, page, includeMargins);
      final double bottom =
          _getBottomIndentHeight(document, page, includeMargins);
      bounds.x += left;
      bounds.y += top;
      bounds.width -= left + right;
      bounds.height -= top + bottom;
      return bounds;
    }
  }

  double _getLeftIndentWidth(
      PdfDocument document, PdfPage page, bool includeMargins) {
    double value = includeMargins ? pageSettings.margins.left : 0;
    final double templateWidth =
        template._getLeft(page) != null ? template._getLeft(page)!.width : 0;
    final double docTemplateWidth = document.template._getLeft(page) != null
        ? document.template._getLeft(page)!.width
        : 0;
    value += template.leftTemplate
        ? (templateWidth >= docTemplateWidth ? templateWidth : docTemplateWidth)
        : templateWidth;
    return value;
  }

  double _getTopIndentHeight(
      PdfDocument document, PdfPage page, bool includeMargins) {
    double value = includeMargins ? pageSettings.margins.top : 0;
    final double templateHeight =
        template._getTop(page) != null ? template._getTop(page)!.height : 0;
    final double docTemplateHeight = document.template._getTop(page) != null
        ? document.template._getTop(page)!.height
        : 0;
    value += template.topTemplate
        ? (templateHeight >= docTemplateHeight
            ? templateHeight
            : docTemplateHeight)
        : templateHeight;
    return value;
  }

  double _getRightIndentWidth(
      PdfDocument document, PdfPage page, bool includeMargins) {
    double value = includeMargins ? pageSettings.margins.right : 0;
    final double templateWidth =
        template._getRight(page) != null ? template._getRight(page)!.width : 0;
    final double docTemplateWidth = document.template._getRight(page) != null
        ? document.template._getRight(page)!.width
        : 0;
    value += template.rightTemplate
        ? (templateWidth >= docTemplateWidth ? templateWidth : docTemplateWidth)
        : templateWidth;
    return value;
  }

  double _getBottomIndentHeight(
      PdfDocument document, PdfPage page, bool includeMargins) {
    double value = includeMargins ? pageSettings.margins.bottom : 0;
    final double templateHeight = template._getBottom(page) != null
        ? template._getBottom(page)!.height
        : 0;
    final double docTemplateHeight = document.template._getBottom(page) != null
        ? document.template._getBottom(page)!.height
        : 0;
    value += template.bottomTemplate
        ? (templateHeight >= docTemplateHeight
            ? templateHeight
            : docTemplateHeight)
        : templateHeight;
    return value;
  }

  void _beginSave(Object sender, _SavePdfPrimitiveArgs? args) {
    _pageCount!.value = _count;
    final PdfDocument? document = args!._writer!._document;
    if (document == null) {
      _setPageSettings(_section!);
    } else {
      _setPageSettings(_section!, document.pageSettings);
    }
  }

  void _pdfPageAdded(PdfPage page) {
    final PageAddedArgs args = PageAddedArgs(page);
    _onPageAdded(args);
    final PdfSectionCollection? sectionCollection = _parent;
    if (sectionCollection != null) {
      sectionCollection._document!.pages._onPageAdded(args);
    }
    _pageCount!.value = _count;
  }

  void _onPageAdded(PageAddedArgs args) {
    if (pageAdded != null) {
      pageAdded!(this, args);
    }
  }

  int _indexOf(PdfPage page) {
    if (_pages.contains(page)) {
      return _pages.indexOf(page);
    }
    final _PdfReferenceHolder holder = _PdfReferenceHolder(page);
    return _pageReferences!._indexOf(holder);
  }

  bool _containsTemplates(PdfDocument document, PdfPage page, bool foreground) {
    final List<PdfPageTemplateElement?> documentHeaders =
        _getDocumentTemplates(document, page, true, foreground);
    final List<PdfPageTemplateElement?> documentTemplates =
        _getDocumentTemplates(document, page, false, foreground);
    final List<PdfPageTemplateElement?> sectionHeaders =
        _getSectionTemplates(page, true, foreground);
    final List<PdfPageTemplateElement?> sectionTemplates =
        _getSectionTemplates(page, false, foreground);
    final bool contains = documentHeaders.isNotEmpty ||
        documentTemplates.isNotEmpty ||
        sectionHeaders.isNotEmpty ||
        sectionTemplates.isNotEmpty;
    return contains;
  }

  List<PdfPageTemplateElement> _getDocumentTemplates(
      PdfDocument document, PdfPage page, bool headers, bool foreground) {
    final List<PdfPageTemplateElement> templates = <PdfPageTemplateElement>[];
    if (headers) {
      if (template.topTemplate &&
          document.template._getTop(page) != null &&
          document.template._getTop(page)!.foreground == foreground) {
        templates.add(document.template._getTop(page)!);
      }
      if (template.bottomTemplate &&
          document.template._getBottom(page) != null &&
          document.template._getBottom(page)!.foreground == foreground) {
        templates.add(document.template._getBottom(page)!);
      }
      if (template.leftTemplate &&
          document.template._getLeft(page) != null &&
          document.template._getLeft(page)!.foreground == foreground) {
        templates.add(document.template._getLeft(page)!);
      }
      if (template.rightTemplate &&
          document.template._getRight(page) != null &&
          document.template._getRight(page)!.foreground == foreground) {
        templates.add(document.template._getRight(page)!);
      }
    } else if (template.stamp) {
      final List<Object> list = document.template.stamps._list;
      for (int i = 0; i < list.length; i++) {
        final PdfPageTemplateElement template =
            list[i] as PdfPageTemplateElement;
        if (template.foreground == foreground) {
          templates.add(template);
        }
      }
    }
    return templates;
  }

  List<PdfPageTemplateElement> _getSectionTemplates(
      PdfPage page, bool headers, bool foreground) {
    final List<PdfPageTemplateElement> templates = <PdfPageTemplateElement>[];
    if (headers) {
      if (template._getTop(page) != null &&
          template._getTop(page)!.foreground == foreground) {
        templates.add(template._getTop(page)!);
      }
      if (template._getBottom(page) != null &&
          template._getBottom(page)!.foreground == foreground) {
        templates.add(template._getBottom(page)!);
      }
      if (template._getLeft(page) != null &&
          template._getLeft(page)!.foreground == foreground) {
        templates.add(template._getLeft(page)!);
      }
      if (template._getRight(page) != null &&
          template._getRight(page)!.foreground == foreground) {
        templates.add(template._getRight(page)!);
      }
    } else {
      final List<Object> list = template.stamps._list;
      for (int i = 0; i < list.length; i++) {
        final PdfPageTemplateElement temp = list[i] as PdfPageTemplateElement;
        if (temp.foreground == foreground) {
          templates.add(temp);
        }
      }
    }
    return templates;
  }

  void _drawTemplates(
      PdfPage page, PdfPageLayer layer, PdfDocument document, bool foreground) {
    final List<PdfPageTemplateElement> documentHeaders =
        _getDocumentTemplates(document, page, true, foreground);
    final List<PdfPageTemplateElement> documentTemplates =
        _getDocumentTemplates(document, page, false, foreground);
    final List<PdfPageTemplateElement> sectionHeaders =
        _getSectionTemplates(page, true, foreground);
    final List<PdfPageTemplateElement> sectionTemplates =
        _getSectionTemplates(page, false, foreground);
    if (foreground) {
      _internaldrawTemplates(layer, document, sectionHeaders);
      _internaldrawTemplates(layer, document, sectionTemplates);
      _internaldrawTemplates(layer, document, documentHeaders);
      _internaldrawTemplates(layer, document, documentTemplates);
    } else {
      _internaldrawTemplates(layer, document, documentHeaders);
      _internaldrawTemplates(layer, document, documentTemplates);
      _internaldrawTemplates(layer, document, sectionHeaders);
      _internaldrawTemplates(layer, document, sectionTemplates);
    }
  }

  void _internaldrawTemplates(PdfPageLayer layer, PdfDocument document,
      List<PdfPageTemplateElement> templates) {
    if (templates.isNotEmpty) {
      for (final PdfPageTemplateElement template in templates) {
        template._draw(layer, document);
      }
    }
  }

  _Point _pointToNativePdf(PdfPage page, _Point point) {
    final _Rectangle bounds = _getActualBounds(page, true);
    point.x += bounds.left;
    point.y = pageSettings.height - (bounds.top + point.y);
    return point;
  }

  void _dropCropBox() {
    _setPageSettings(_section!, null);
    _section![_DictionaryProperties.cropBox] =
        _section![_DictionaryProperties.mediaBox];
  }

  @override
  _IPdfPrimitive? get _element => _section;

  @override
  //ignore: unused_element
  set _element(_IPdfPrimitive? value) {
    _section = value as _PdfDictionary?;
  }
}

/// Represents the method that executes on a [PdfDocument]
/// when a new page is created.
typedef PageAddedCallback = void Function(Object sender, PageAddedArgs args);

/// Provides data for [PageAddedCallback] event.
class PageAddedArgs {
  /// Initializes a new instance of the [PageAddedArgs] class.
  ///
  /// [page] - represending the page which is added in the document.
  PageAddedArgs([PdfPage? page]) {
    if (page != null) {
      this.page = page;
    }
  }

  /// Gets the newly added page.
  late PdfPage page;
}
