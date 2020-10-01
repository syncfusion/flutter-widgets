part of pdf;

/// Encapsulates a page template for all the pages in the document.
class PdfDocumentTemplate {
  //Constructors
  /// Initializes a new instance of the [PdfDocumentTemplate] class.
  PdfDocumentTemplate();

  //Fields
  PdfPageTemplateElement _left;
  PdfPageTemplateElement _top;
  PdfPageTemplateElement _right;
  PdfPageTemplateElement _bottom;
  PdfPageTemplateElement _evenLeft;
  PdfPageTemplateElement _evenTop;
  PdfPageTemplateElement _evenRight;
  PdfPageTemplateElement _evenBottom;
  PdfPageTemplateElement _oddLeft;
  PdfPageTemplateElement _oddTop;
  PdfPageTemplateElement _oddRight;
  PdfPageTemplateElement _oddBottom;
  PdfStampCollection _stamps;

  //Properties
  /// Gets a left page template.
  PdfPageTemplateElement get left => _left;

  /// Sets a left page template.
  set left(PdfPageTemplateElement value) {
    _left = _checkElement(value, _TemplateType.left);
  }

  /// Gets a right page template.
  PdfPageTemplateElement get right => _right;

  /// Sets a right page template.
  set right(PdfPageTemplateElement value) {
    _right = _checkElement(value, _TemplateType.right);
  }

  /// Gets a top page template.
  PdfPageTemplateElement get top => _top;

  /// Sets a top page template.
  set top(PdfPageTemplateElement value) {
    _top = _checkElement(value, _TemplateType.top);
  }

  /// Gets a bottom page template.
  PdfPageTemplateElement get bottom => _bottom;

  /// Sets a bottom page template.
  set bottom(PdfPageTemplateElement value) {
    _bottom = _checkElement(value, _TemplateType.bottom);
  }

  /// Gets a even left page template.
  PdfPageTemplateElement get evenLeft => _evenLeft;

  /// Sets a even left page template.
  set evenLeft(PdfPageTemplateElement value) {
    _evenLeft = _checkElement(value, _TemplateType.left);
  }

  /// Gets a even right page template.
  PdfPageTemplateElement get evenRight => _evenRight;

  /// Sets a even right page template.
  set evenRight(PdfPageTemplateElement value) {
    _evenRight = _checkElement(value, _TemplateType.right);
  }

  /// Gets a even top page template.
  PdfPageTemplateElement get evenTop => _evenTop;

  /// Sets a even top page template.
  set evenTop(PdfPageTemplateElement value) {
    _evenTop = _checkElement(value, _TemplateType.top);
  }

  /// Gets a even bottom page template.
  PdfPageTemplateElement get evenBottom => _evenBottom;

  /// Sets a even bottom page template.
  set evenBottom(PdfPageTemplateElement value) {
    _evenBottom = _checkElement(value, _TemplateType.bottom);
  }

  /// Gets a odd left page template.
  PdfPageTemplateElement get oddLeft => _oddLeft;

  /// Sets a odd left page template.
  set oddLeft(PdfPageTemplateElement value) {
    _oddLeft = _checkElement(value, _TemplateType.left);
  }

  /// Gets a odd right page template.
  PdfPageTemplateElement get oddRight => _oddRight;

  /// Sets a odd right page template.
  set oddRight(PdfPageTemplateElement value) {
    _oddRight = _checkElement(value, _TemplateType.right);
  }

  /// Gets a odd top page template.
  PdfPageTemplateElement get oddTop => _oddTop;

  /// Sets a odd top page template.
  set oddTop(PdfPageTemplateElement value) {
    _oddTop = _checkElement(value, _TemplateType.top);
  }

  /// Gets a odd bottom page template.
  PdfPageTemplateElement get oddBottom => _oddBottom;

  /// Sets a odd bottom page template.
  set oddBottom(PdfPageTemplateElement value) {
    _oddBottom = _checkElement(value, _TemplateType.bottom);
  }

  /// Gets a collection of stamp elements.
  PdfStampCollection get stamps {
    _stamps ??= PdfStampCollection();
    return _stamps;
  }

  //Implementation
  PdfPageTemplateElement _getLeft(PdfPage page) {
    ArgumentError.checkNotNull(page, 'page');
    PdfPageTemplateElement template;
    if (page._document.pages != null &&
        (evenLeft != null || oddLeft != null || left != null)) {
      if (_isEven(page)) {
        template = (evenLeft != null) ? evenLeft : left;
      } else {
        template = (oddLeft != null) ? oddLeft : left;
      }
    }
    return template;
  }

  PdfPageTemplateElement _getRight(PdfPage page) {
    ArgumentError.checkNotNull(page, 'page');
    PdfPageTemplateElement template;
    if (page._document.pages != null &&
        (evenRight != null || oddRight != null || right != null)) {
      if (_isEven(page)) {
        template = (evenRight != null) ? evenRight : right;
      } else {
        template = (oddRight != null) ? oddRight : right;
      }
    }
    return template;
  }

  PdfPageTemplateElement _getTop(PdfPage page) {
    ArgumentError.checkNotNull(page, 'page');
    PdfPageTemplateElement template;
    if (page._document.pages != null &&
        (evenTop != null || oddTop != null || top != null)) {
      if (_isEven(page)) {
        template = (evenTop != null) ? evenTop : top;
      } else {
        template = (oddTop != null) ? oddTop : top;
      }
    }
    return template;
  }

  PdfPageTemplateElement _getBottom(PdfPage page) {
    ArgumentError.checkNotNull(page, 'page');
    PdfPageTemplateElement template;
    if (page._document.pages != null &&
        (evenBottom != null || oddBottom != null || bottom != null)) {
      if (_isEven(page)) {
        template = (evenBottom != null) ? evenBottom : bottom;
      } else {
        template = (oddBottom != null) ? oddBottom : bottom;
      }
    }
    return template;
  }

  bool _isEven(PdfPage page) {
    ArgumentError.checkNotNull(page, 'page');
    final PdfPageCollection pages = page._section._document.pages;
    int index = 0;
    if (pages._pageCollectionIndex.containsKey(page)) {
      index = pages._pageCollectionIndex[page] + 1;
    } else {
      index = pages.indexOf(page) + 1;
    }
    return (index % 2) == 0;
  }

  PdfPageTemplateElement _checkElement(
      PdfPageTemplateElement templateElement, _TemplateType type) {
    if (templateElement != null) {
      if (templateElement._type != _TemplateType.none) {
        throw ArgumentError.value(type,
            "Can't reassign the template element. Please, create new one.");
      }
      templateElement._type = type;
    }
    return templateElement;
  }
}

/// A collection of stamps that are applied to the page templates.
class PdfStampCollection extends PdfObjectCollection {
  /// Initializes a new instance of the [PdfStampCollection] class.
  PdfStampCollection() : super();

  /// Adds a stamp element to the collection.
  /// [PdfPageTemplateElement] used here to create stamp element.
  int add(PdfPageTemplateElement template) {
    ArgumentError.checkNotNull(template, 'template');
    _list.add(template);
    return count - 1;
  }
}
