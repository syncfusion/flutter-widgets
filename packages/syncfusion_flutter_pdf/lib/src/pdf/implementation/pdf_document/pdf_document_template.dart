import '../general/pdf_collection.dart';
import '../pages/enum.dart';
import '../pages/pdf_page.dart';
import '../pages/pdf_page_collection.dart';
import '../pages/pdf_page_template_element.dart';
import '../pages/pdf_section.dart';

/// Encapsulates a page template for all the pages in the document.
class PdfDocumentTemplate {
  //Constructors
  /// Initializes a new instance of the [PdfDocumentTemplate] class.
  PdfDocumentTemplate(
      {PdfPageTemplateElement? left,
      PdfPageTemplateElement? top,
      PdfPageTemplateElement? right,
      PdfPageTemplateElement? bottom,
      PdfPageTemplateElement? evenLeft,
      PdfPageTemplateElement? evenTop,
      PdfPageTemplateElement? evenRight,
      PdfPageTemplateElement? evenBottom,
      PdfPageTemplateElement? oddLeft,
      PdfPageTemplateElement? oddTop,
      PdfPageTemplateElement? oddRight,
      PdfPageTemplateElement? oddBottom,
      PdfStampCollection? stamps}) {
    _helper = PdfDocumentTemplateHelper(this);
    _intialize(left, top, right, bottom, evenLeft, evenTop, evenRight,
        evenBottom, oddLeft, oddTop, oddRight, oddBottom, stamps);
  }

  //Fields
  late PdfDocumentTemplateHelper _helper;
  PdfPageTemplateElement? _left;
  PdfPageTemplateElement? _top;
  PdfPageTemplateElement? _right;
  PdfPageTemplateElement? _bottom;
  PdfPageTemplateElement? _evenLeft;
  PdfPageTemplateElement? _evenTop;
  PdfPageTemplateElement? _evenRight;
  PdfPageTemplateElement? _evenBottom;
  PdfPageTemplateElement? _oddLeft;
  PdfPageTemplateElement? _oddTop;
  PdfPageTemplateElement? _oddRight;
  PdfPageTemplateElement? _oddBottom;
  PdfStampCollection? _stamps;

  //Properties
  /// Gets a left page template.
  PdfPageTemplateElement? get left => _left;

  /// Sets a left page template.
  set left(PdfPageTemplateElement? value) {
    _left = _checkElement(value, TemplateType.left);
  }

  /// Gets a right page template.
  PdfPageTemplateElement? get right => _right;

  /// Sets a right page template.
  set right(PdfPageTemplateElement? value) {
    _right = _checkElement(value, TemplateType.right);
  }

  /// Gets a top page template.
  PdfPageTemplateElement? get top => _top;

  /// Sets a top page template.
  set top(PdfPageTemplateElement? value) {
    _top = _checkElement(value, TemplateType.top);
  }

  /// Gets a bottom page template.
  PdfPageTemplateElement? get bottom => _bottom;

  /// Sets a bottom page template.
  set bottom(PdfPageTemplateElement? value) {
    _bottom = _checkElement(value, TemplateType.bottom);
  }

  /// Gets a even left page template.
  PdfPageTemplateElement? get evenLeft => _evenLeft;

  /// Sets a even left page template.
  set evenLeft(PdfPageTemplateElement? value) {
    _evenLeft = _checkElement(value, TemplateType.left);
  }

  /// Gets a even right page template.
  PdfPageTemplateElement? get evenRight => _evenRight;

  /// Sets a even right page template.
  set evenRight(PdfPageTemplateElement? value) {
    _evenRight = _checkElement(value, TemplateType.right);
  }

  /// Gets a even top page template.
  PdfPageTemplateElement? get evenTop => _evenTop;

  /// Sets a even top page template.
  set evenTop(PdfPageTemplateElement? value) {
    _evenTop = _checkElement(value, TemplateType.top);
  }

  /// Gets a even bottom page template.
  PdfPageTemplateElement? get evenBottom => _evenBottom;

  /// Sets a even bottom page template.
  set evenBottom(PdfPageTemplateElement? value) {
    _evenBottom = _checkElement(value, TemplateType.bottom);
  }

  /// Gets a odd left page template.
  PdfPageTemplateElement? get oddLeft => _oddLeft;

  /// Sets a odd left page template.
  set oddLeft(PdfPageTemplateElement? value) {
    _oddLeft = _checkElement(value, TemplateType.left);
  }

  /// Gets a odd right page template.
  PdfPageTemplateElement? get oddRight => _oddRight;

  /// Sets a odd right page template.
  set oddRight(PdfPageTemplateElement? value) {
    _oddRight = _checkElement(value, TemplateType.right);
  }

  /// Gets a odd top page template.
  PdfPageTemplateElement? get oddTop => _oddTop;

  /// Sets a odd top page template.
  set oddTop(PdfPageTemplateElement? value) {
    _oddTop = _checkElement(value, TemplateType.top);
  }

  /// Gets a odd bottom page template.
  PdfPageTemplateElement? get oddBottom => _oddBottom;

  /// Sets a odd bottom page template.
  set oddBottom(PdfPageTemplateElement? value) {
    _oddBottom = _checkElement(value, TemplateType.bottom);
  }

  /// Gets a collection of stamp elements.
  PdfStampCollection get stamps {
    _stamps ??= PdfStampCollection();
    return _stamps!;
  }

  //Implementation
  void _intialize(
      PdfPageTemplateElement? left,
      PdfPageTemplateElement? top,
      PdfPageTemplateElement? right,
      PdfPageTemplateElement? bottom,
      PdfPageTemplateElement? evenLeft,
      PdfPageTemplateElement? evenTop,
      PdfPageTemplateElement? evenRight,
      PdfPageTemplateElement? evenBottom,
      PdfPageTemplateElement? oddLeft,
      PdfPageTemplateElement? oddTop,
      PdfPageTemplateElement? oddRight,
      PdfPageTemplateElement? oddBottom,
      PdfStampCollection? stamps) {
    if (left != null) {
      this.left = left;
    }
    if (top != null) {
      this.top = top;
    }
    if (bottom != null) {
      this.bottom = bottom;
    }
    if (right != null) {
      this.right = right;
    }
    if (evenLeft != null) {
      this.evenLeft = evenLeft;
    }
    if (evenTop != null) {
      this.evenTop = evenTop;
    }
    if (evenRight != null) {
      this.evenRight = evenRight;
    }
    if (evenBottom != null) {
      this.evenBottom = evenBottom;
    }
    if (oddLeft != null) {
      this.oddLeft = oddLeft;
    }
    if (oddTop != null) {
      this.oddTop = oddTop;
    }
    if (oddRight != null) {
      this.oddRight = oddRight;
    }
    if (oddBottom != null) {
      this.oddBottom = oddBottom;
    }
    if (stamps != null) {
      _stamps = stamps;
    }
  }

  PdfPageTemplateElement? _checkElement(
      PdfPageTemplateElement? templateElement, TemplateType type) {
    if (templateElement != null) {
      if (PdfPageTemplateElementHelper.getHelper(templateElement).type !=
          TemplateType.none) {
        throw ArgumentError.value(type,
            "Can't reassign the template element. Please, create new one.");
      }
      PdfPageTemplateElementHelper.getHelper(templateElement).type = type;
    }
    return templateElement;
  }
}

/// A collection of stamps that are applied to the page templates.
class PdfStampCollection extends PdfObjectCollection {
  /// Initializes a new instance of the [PdfStampCollection] class.
  PdfStampCollection() : super() {
    _helper = PdfStampCollectionHelper(this);
  }

  late PdfStampCollectionHelper _helper;

  /// Adds a stamp element to the collection.
  /// [PdfPageTemplateElement] used here to create stamp element.
  int add(PdfPageTemplateElement template) {
    return _helper.add(template);
  }
}

/// [PdfStampCollection] helper
class PdfStampCollectionHelper extends PdfObjectCollectionHelper {
  /// internal constructor
  PdfStampCollectionHelper(this.base) : super(base);

  /// internal field
  late PdfStampCollection base;

  /// internal method
  int add(PdfPageTemplateElement template) {
    list.add(template);
    return base.count - 1;
  }
}

/// [PdfDocumentTemplate] helper
class PdfDocumentTemplateHelper {
  /// internal constructor
  PdfDocumentTemplateHelper(this.base);

  /// internal field
  PdfDocumentTemplate base;

  /// internal method
  static PdfDocumentTemplateHelper getHelper(PdfDocumentTemplate template) {
    return template._helper;
  }

  /// internal method
  PdfPageTemplateElement? getLeft(PdfPage page) {
    PdfPageTemplateElement? template;
    if (base.evenLeft != null || base.oddLeft != null || base.left != null) {
      if (_isEven(page)) {
        template = (base.evenLeft != null) ? base.evenLeft : base.left;
      } else {
        template = (base.oddLeft != null) ? base.oddLeft : base.left;
      }
    }
    return template;
  }

  /// internal method
  PdfPageTemplateElement? getRight(PdfPage page) {
    PdfPageTemplateElement? template;
    if (base.evenRight != null || base.oddRight != null || base.right != null) {
      if (_isEven(page)) {
        template = (base.evenRight != null) ? base.evenRight : base.right;
      } else {
        template = (base.oddRight != null) ? base.oddRight : base.right;
      }
    }
    return template;
  }

  /// internal method
  PdfPageTemplateElement? getTop(PdfPage page) {
    PdfPageTemplateElement? template;
    if (base.evenTop != null || base.oddTop != null || base.top != null) {
      if (_isEven(page)) {
        template = (base.evenTop != null) ? base.evenTop : base.top;
      } else {
        template = (base.oddTop != null) ? base.oddTop : base.top;
      }
    }
    return template;
  }

  /// internal method
  PdfPageTemplateElement? getBottom(PdfPage page) {
    PdfPageTemplateElement? template;
    if (base.evenBottom != null ||
        base.oddBottom != null ||
        base.bottom != null) {
      if (_isEven(page)) {
        template = (base.evenBottom != null) ? base.evenBottom : base.bottom;
      } else {
        template = (base.oddBottom != null) ? base.oddBottom : base.bottom;
      }
    }
    return template;
  }

  bool _isEven(PdfPage page) {
    final PdfPageCollection pages =
        PdfSectionHelper.getHelper(PdfPageHelper.getHelper(page).section!)
            .document!
            .pages;
    int index = 0;
    if (PdfPageCollectionHelper.getHelper(pages)
        .pageCollectionIndex
        .containsKey(page)) {
      index =
          PdfPageCollectionHelper.getHelper(pages).pageCollectionIndex[page]! +
              1;
    } else {
      index = pages.indexOf(page) + 1;
    }
    return (index % 2) == 0;
  }
}
