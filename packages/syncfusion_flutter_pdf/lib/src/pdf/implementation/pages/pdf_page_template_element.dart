part of pdf;

/// Describes a page template object that can be used as header/footer, watermark or stamp.
/// ```dart
/// //Create a new pdf document
/// PdfDocument document = PdfDocument();
/// //Create a header and add the top of the document.
/// document.template.top = PdfPageTemplateElement(Rect.fromLTWH(0, 0, 515, 50))
///   ..graphics.drawString(
///       'Header', PdfStandardFont(PdfFontFamily.helvetica, 14),
///       brush: PdfBrushes.black);
/// //Create footer and add the bottom of the document.
/// document.template.bottom =
///     PdfPageTemplateElement(Rect.fromLTWH(0, 0, 515, 50))
///       ..graphics.drawString(
///           'Footer', PdfStandardFont(PdfFontFamily.helvetica, 11),
///           brush: PdfBrushes.black);
/// //Add the pages to the document
/// for (int i = 1; i <= 5; i++) {
///   document.pages.add().graphics.drawString(
///       'Page $i', PdfStandardFont(PdfFontFamily.timesRoman, 11),
///       bounds: Rect.fromLTWH(250, 0, 515, 100));
/// }
/// //Save the document.
/// List<int> bytes = document.save();
/// //Dispose the document.
/// document.dispose();
/// ```
class PdfPageTemplateElement {
  //Constructor
  /// Initializes a new instance of the [PdfPageTemplateElement] class.
  /// ```dart
  /// Create a new pdf document
  /// PdfDocument document = PdfDocument();
  /// //Add the pages to the document
  /// for (int i = 1; i <= 5; i++) {
  ///   document.pages.add().graphics.drawString(
  ///       'page$i', PdfStandardFont(PdfFontFamily.timesRoman, 11),
  ///       bounds: Rect.fromLTWH(250, 0, 615, 100));
  /// }
  /// //Create the header with specific bounds
  /// PdfPageTemplateElement header = PdfPageTemplateElement(
  ///     Rect.fromLTWH(0, 0, document.pages[0].getClientSize().width, 300));
  /// header.graphics.drawString(
  ///     'Header', PdfStandardFont(PdfFontFamily.helvetica, 14),
  ///     brush: PdfBrushes.black);
  /// //Add the header at top of the document
  /// document.template.top = header;
  /// //Create the footer with specific bounds
  /// PdfPageTemplateElement footer = PdfPageTemplateElement(
  ///     Rect.fromLTWH(0, 0, document.pages[0].getClientSize().width, 50));
  /// header.graphics.drawString(
  ///     'Footer', PdfStandardFont(PdfFontFamily.helvetica, 11),
  ///     brush: PdfBrushes.black);
  /// //Add the footer at the bottom of the document
  /// document.template.bottom = footer;
  /// //Save the document.
  /// List<int> bytes = document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  PdfPageTemplateElement(Rect bounds, [PdfPage? page]) {
    x = bounds.left;
    y = bounds.top;
    _pdfTemplate = PdfTemplate(bounds.width, bounds.height);
    if (page != null) {
      graphics.colorSpace = page._document!.colorSpace;
    }
  }

  //Fields
  /// Indicates whether the page template is located in front of the
  /// page layers or behind of it. If false, the page template will be located
  /// behind of page layer.
  bool foreground = false;
  PdfDockStyle? _dockStyle;
  PdfAlignmentStyle _alignmentStyle = PdfAlignmentStyle.none;
  PdfTemplate? _pdfTemplate;
  _TemplateType _templateType = _TemplateType.none;
  _Point _currentLocation = _Point.empty;

  //Properties
  /// Gets or sets the dock style of the page template element.
  /// ```dart
  /// //Create a new pdf document
  /// PdfDocument document = PdfDocument();
  /// //Set margins.
  /// document.pageSettings.setMargins(25);
  /// //Create the page template with specific bounds
  /// final PdfPageTemplateElement custom = PdfPageTemplateElement(
  ///     Rect.fromLTWH(0, 0, 100, 100), document.pages.add());
  /// document.template.stamps.add(custom);
  /// //Gets or sets the dock style
  /// custom.dock = PdfDockStyle.right;
  /// //Draw template into pdf page.
  /// custom.graphics.drawRectangle(
  ///     pen: PdfPen(PdfColor(255, 165, 0), width: 3),
  ///     brush: PdfSolidBrush(PdfColor(173, 255, 47)),
  ///    bounds: Rect.fromLTWH(0, 0, 100, 100));
  /// //Save the document.
  /// List<int> bytes = document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  PdfDockStyle get dock {
    _dockStyle ??= PdfDockStyle.none;
    return _dockStyle!;
  }

  set dock(PdfDockStyle value) {
    _dockStyle = value;
    _resetAlignment();
  }

  /// Gets or sets the alignment of the page template element.
  /// ```dart
  /// //Create a new pdf document
  /// PdfDocument document = PdfDocument();
  /// //Set margins.
  /// document.pageSettings.setMargins(25);
  /// //Create the page template with specific bounds
  /// final PdfPageTemplateElement custom = PdfPageTemplateElement(
  ///     Rect.fromLTWH(0, 0, 100, 100), document.pages.add());
  /// document.template.stamps.add(custom);
  /// //Gets or sets  dock style.
  /// custom.dock = PdfDockStyle.right;
  /// Gets or sets  alignment style.
  /// custom.alignment = PdfAlignmentStyle.middleCenter;
  /// //Draw template into pdf page.
  /// custom.graphics.drawRectangle(
  ///     pen: PdfPen(PdfColor(255, 165, 0), width: 3),
  ///     brush: PdfSolidBrush(PdfColor(173, 255, 47)),
  ///     bounds: Rect.fromLTWH(0, 0, 100, 100));
  /// //Save the document.
  /// List<int> bytes = document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  PdfAlignmentStyle get alignment => _alignmentStyle;
  set alignment(PdfAlignmentStyle value) {
    if (_alignmentStyle != value) {
      _setAlignment(value);
    }
  }

  /// Indicates whether the page template is located behind of the page layers
  /// or in front of it.
  /// ```dart
  /// //Create a new pdf document
  /// PdfDocument document = PdfDocument();
  /// //Set margins.
  /// document.pageSettings.setMargins(25);
  /// //Create the page template with specific bounds
  /// final PdfPageTemplateElement custom = PdfPageTemplateElement(
  ///     const Offset(5, 5) & const Size(110, 110), document.pages.add());
  /// document.template.stamps.add(custom);
  /// Gets or sets  background.
  /// custom.background = true;
  /// //Draw template into pdf page.
  /// custom.graphics.drawRectangle(
  ///     pen: PdfPen(PdfColor(255, 165, 0), width: 3),
  ///     brush: PdfSolidBrush(PdfColor(173, 255, 47)),
  ///     bounds: Rect.fromLTWH(0, 0, 100, 100));
  /// //Save the document.
  /// List<int> bytes = document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  bool get background => !foreground;
  set background(bool value) {
    foreground = !value;
  }

  /// Gets or sets location of the page template element.
  /// ```dart
  /// //Create a new pdf document
  /// PdfDocument document = PdfDocument();
  /// //Set margins.
  /// document.pageSettings.setMargins(25);
  /// //Create the page template with specific bounds
  /// final PdfPageTemplateElement custom = PdfPageTemplateElement(
  ///     Rect.fromLTWH(0, 0, 100, 100), document.pages.add());
  /// document.template.stamps.add(custom);
  /// //Gets or sets  location.
  /// custom.location = Offset(5, 5);
  /// //Draw template into pdf page.
  /// custom.graphics.drawRectangle(
  ///     pen: PdfPen(PdfColor(255, 165, 0), width: 3),
  ///     brush: PdfSolidBrush(PdfColor(173, 255, 47)),
  ///     bounds: Rect.fromLTWH(0, 0, 100, 100));
  /// //Save the document.
  /// List<int> bytes = document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  Offset get location => _currentLocation.offset;
  set location(Offset value) {
    if (_templateType == _TemplateType.none) {
      _currentLocation = _Point.fromOffset(value);
    }
  }

  /// Gets or sets X co-ordinate of the template element on the page.
  /// ```dart
  /// //Create a new pdf document
  /// PdfDocument document = PdfDocument();
  /// //Set margins.
  /// document.pageSettings.setMargins(25);
  /// //Create the page template with specific bounds
  /// final PdfPageTemplateElement custom = PdfPageTemplateElement(
  ///     Rect.fromLTWH(0, 0, 100, 100), document.pages.add());
  /// document.template.stamps.add(custom);
  /// //Gets or sets  X co-ordinate.
  /// custom.x = 10.10;
  /// //Draw template into pdf page.
  /// custom.graphics.drawRectangle(
  ///     pen: PdfPen(PdfColor(255, 165, 0), width: 3),
  ///     brush: PdfSolidBrush(PdfColor(173, 255, 47)),
  ///     bounds: Rect.fromLTWH(0, 0, 100, 100));
  /// //Save the document.
  /// List<int> bytes = document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  double get x => _currentLocation.x;
  set x(double value) {
    if (_type == _TemplateType.none) {
      _currentLocation.x = value;
    }
  }

  /// Gets or sets Y co-ordinate of the template element on the page.
  /// ```dart
  /// //Create a new pdf document
  /// PdfDocument document = PdfDocument();
  /// //Set margins.
  /// document.pageSettings.setMargins(25);
  /// //Create the page template with specific bounds
  /// final PdfPageTemplateElement custom = PdfPageTemplateElement(
  ///     Rect.fromLTWH(0, 0, 100, 100), document.pages.add());
  /// document.template.stamps.add(custom);
  /// //Gets or sets  Y co-ordinate.
  /// custom.y = 10.10;
  /// //Draw template into pdf page.
  /// custom.graphics.drawRectangle(
  ///     pen: PdfPen(PdfColor(255, 165, 0), width: 3),
  ///     brush: PdfSolidBrush(PdfColor(173, 255, 47)),
  ///     bounds: Rect.fromLTWH(0, 0, 100, 100));
  /// //Save the document.
  /// List<int> bytes = document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  double get y => _currentLocation.y;
  set y(double value) {
    if (_type == _TemplateType.none) {
      _currentLocation.y = value;
    }
  }

  /// Gets or sets the size of the page template element.
  /// ```dart
  /// //Create a new pdf document
  /// PdfDocument document = PdfDocument();
  /// //Set margins.
  /// document.pageSettings.setMargins(25);
  /// //Create the page template with specific bounds
  /// final PdfPageTemplateElement custom = PdfPageTemplateElement(
  ///     Rect.fromLTWH(0, 0, 100, 100), document.pages.add());
  /// document.template.stamps.add(custom);
  /// //Gets or sets  size.
  /// custom.size = Size(110, 110);
  /// //Draw template into pdf page.
  /// custom.graphics.drawRectangle(
  ///     pen: PdfPen(PdfColor(255, 165, 0), width: 3),
  ///     brush: PdfSolidBrush(PdfColor(173, 255, 47)),
  ///     bounds: Rect.fromLTWH(0, 0, 100, 100));
  /// //Save the document.
  /// List<int> bytes = document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  Size get size => _template!.size;
  set size(Size value) {
    if (_type == _TemplateType.none) {
      _template!.reset(value.width, value.height);
    }
  }

  /// Gets or sets width of the page template element.
  /// ```dart
  /// //Create a new pdf document
  /// PdfDocument document = PdfDocument();
  /// //Set margins.
  /// document.pageSettings.setMargins(25);
  /// //Create the page template with specific bounds
  /// final PdfPageTemplateElement custom = PdfPageTemplateElement(
  ///     Rect.fromLTWH(0, 0, 100, 100), document.pages.add());
  /// document.template.stamps.add(custom);
  /// //Gets or sets  width.
  /// custom.width = 110;
  /// //Draw template into pdf page.
  /// custom.graphics.drawRectangle(
  ///     pen: PdfPen(PdfColor(255, 165, 0), width: 3),
  ///     brush: PdfSolidBrush(PdfColor(173, 255, 47)),
  ///     bounds: Rect.fromLTWH(0, 0, 100, 100));
  /// //Save the document.
  /// List<int> bytes = document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  double get width => _template!.size.width;
  set width(double value) {
    if (_template!.size.width != value && _type == _TemplateType.none) {
      _template!.reset(value, _template!.size.height);
    }
  }

  /// Gets or sets height of the page template element.
  /// ```dart
  /// //Create a new pdf document
  /// PdfDocument document = PdfDocument();
  /// //Set margins.
  /// document.pageSettings.setMargins(25);
  /// //Create the page template with specific bounds
  /// final PdfPageTemplateElement custom = PdfPageTemplateElement(
  ///     Rect.fromLTWH(0, 0, 100, 100), document.pages.add());
  /// document.template.stamps.add(custom);
  /// //Gets or sets  height.
  /// custom.height = 110;
  /// //Draw template into pdf page.
  /// custom.graphics.drawRectangle(
  ///     pen: PdfPen(PdfColor(255, 165, 0), width: 3),
  ///     brush: PdfSolidBrush(PdfColor(173, 255, 47)),
  ///     bounds: Rect.fromLTWH(0, 0, 100, 100));
  /// //Save the document.
  /// List<int> bytes = document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  double get height => _template!.size.height;
  set height(double value) {
    if (_template!.size.height != value && _type == _TemplateType.none) {
      _template!.reset(_template!.size.width, value);
    }
  }

  /// Gets or sets graphics context of the page template element.
  /// ```dart
  /// //Create a new pdf document
  /// PdfDocument document = PdfDocument();
  /// //Set margins.
  /// document.pageSettings.setMargins(25);
  /// //Create the page template with specific bounds
  /// final PdfPageTemplateElement custom = PdfPageTemplateElement(
  ///     Rect.fromLTWH(0, 0, 100, 100), document.pages.add());
  /// document.template.stamps.add(custom);
  /// //Draw template into pdf page.
  /// custom.graphics.drawRectangle(
  ///     pen: PdfPen(PdfColor(255, 165, 0), width: 3),
  ///     brush: PdfSolidBrush(PdfColor(173, 255, 47)),
  ///     bounds: Rect.fromLTWH(0, 0, 100, 100));
  /// //Save the document.
  /// List<int> bytes = document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  PdfGraphics get graphics => _template!.graphics!;

  /// Gets PDF template object.
  PdfTemplate? get _template => _pdfTemplate;

  /// Gets type of the usage of this page template.
  _TemplateType get _type => _templateType;

  /// Sets type of the usage of this page template.
  set _type(_TemplateType value) {
    _updateDocking(value);
    _templateType = value;
  }

  /// Gets or sets bounds of the page template element.
  /// ```dart
  /// //Create a new pdf document
  /// PdfDocument document = PdfDocument();
  /// //Set margins.
  /// document.pageSettings.setMargins(25);
  /// //Create the page template with specific bounds
  /// final PdfPageTemplateElement custom = PdfPageTemplateElement(
  ///     Rect.fromLTWH(0, 0, 100, 100), document.pages.add());
  /// document.template.stamps.add(custom);
  /// //Gets or sets  bounds.
  /// Rect bounds = custom.bounds;
  /// //Draw template into pdf page.
  /// custom.graphics.drawRectangle(
  ///     pen: PdfPen(PdfColor(255, 165, 0), width: 3),
  ///     brush: PdfSolidBrush(PdfColor(173, 255, 47)),
  ///     bounds: Rect.fromLTWH(0, 0, 100, 100));
  /// //Save the document.
  /// List<int> bytes = document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  Rect get bounds => Rect.fromLTWH(x, y, width, height);
  set bounds(Rect value) {
    if (_type == _TemplateType.none) {
      location = Offset(value.left, value.top);
      size = Size(value.width, value.height);
    }
  }

  //Implementation
  void _draw(PdfPageLayer layer, PdfDocument document) {
    final PdfPage page = layer.page;
    final Rect bounds = _calculateBounds(page, document);
    layer._page._isDefaultGraphics = true;
    layer.graphics.drawPdfTemplate(_template!, bounds.topLeft, bounds.size);
  }

  Rect _calculateBounds(PdfPage page, PdfDocument document) {
    Rect result = bounds;
    if (_alignmentStyle != PdfAlignmentStyle.none) {
      result = _getAlignmentBounds(page, document);
    } else if (_dockStyle != PdfDockStyle.none) {
      result = _getDockBounds(page, document);
    }
    return result;
  }

  Rect _getAlignmentBounds(PdfPage page, PdfDocument document) {
    Rect result = bounds;
    if (_type == _TemplateType.none) {
      result = _getSimpleAlignmentBounds(page, document);
    }
    return result;
  }

  Rect _getSimpleAlignmentBounds(PdfPage page, PdfDocument document) {
    final Rect result = bounds;
    final PdfSection section = page._section!;
    final _Rectangle actualBounds =
        section._getActualBounds(page, false, document);
    double x = location.dx;
    double y = location.dy;

    switch (_alignmentStyle) {
      case PdfAlignmentStyle.topLeft:
        {
          x = 0.0;
          y = 0.0;
        }
        break;

      case PdfAlignmentStyle.topCenter:
        {
          x = (actualBounds.width - width) / 2.0;
          y = 0.0;
        }
        break;

      case PdfAlignmentStyle.topRight:
        {
          x = actualBounds.width - width;
          y = 0.0;
        }
        break;

      case PdfAlignmentStyle.middleLeft:
        {
          x = 0.0;
          y = (actualBounds.height - height) / 2.0;
        }
        break;

      case PdfAlignmentStyle.middleCenter:
        {
          x = (actualBounds.width - width) / 2.0;
          y = (actualBounds.height - height) / 2.0;
        }
        break;

      case PdfAlignmentStyle.middleRight:
        {
          x = actualBounds.width - width;
          y = (actualBounds.height - height) / 2.0;
        }
        break;

      case PdfAlignmentStyle.bottomLeft:
        {
          x = 0.0;
          y = actualBounds.height - height;
        }
        break;

      case PdfAlignmentStyle.bottomCenter:
        {
          x = (actualBounds.width - width) / 2.0;
          y = actualBounds.height - height;
        }
        break;

      case PdfAlignmentStyle.bottomRight:
        {
          x = actualBounds.width - width;
          y = actualBounds.height - height;
        }
        break;
      case PdfAlignmentStyle.none:
        break;
      default:
        break;
    }

    return Offset(x, y) & result.size;
  }

  Rect _getDockBounds(PdfPage page, PdfDocument document) {
    Rect result = bounds;

    if (_type == _TemplateType.none) {
      result = _getSimpleDockBounds(page, document);
    } else {
      result = _getTemplateDockBounds(page, document);
    }
    return result;
  }

  Rect _getSimpleDockBounds(PdfPage page, PdfDocument document) {
    Rect result = bounds;
    final PdfSection section = page._section!;
    final _Rectangle actualBounds =
        section._getActualBounds(page, false, document);
    double x = location.dx;
    double y = location.dy;
    double? _width = width;
    double? _height = height;

    switch (_dockStyle) {
      case PdfDockStyle.left:
        x = 0.0;
        y = 0.0;
        _width = width;
        _height = actualBounds.height;
        break;

      case PdfDockStyle.top:
        x = 0.0;
        y = 0.0;
        _width = actualBounds.width;
        _height = height;
        break;

      case PdfDockStyle.right:
        x = actualBounds.width - width;
        y = 0.0;
        _width = width;
        _height = actualBounds.height;
        break;

      case PdfDockStyle.bottom:
        x = 0.0;
        y = actualBounds.height - height;
        _width = actualBounds.width;
        _height = height;
        break;

      case PdfDockStyle.fill:
        x = 0.0;
        x = 0.0;
        _width = actualBounds.width;
        _height = actualBounds.height;
        break;
      case PdfDockStyle.none:
        break;
      default:
        break;
    }

    result = Rect.fromLTWH(x, y, _width, _height);

    return result;
  }

  Rect _getTemplateDockBounds(PdfPage page, PdfDocument document) {
    final PdfSection section = page._section!;
    final _Rectangle actualBounds =
        section._getActualBounds(page, false, document);
    final _Size actualSize =
        _Size.fromSize(section.pageSettings._getActualSize());
    double x = location.dx;
    double y = location.dy;
    double? _width = width;
    double? _height = height;

    switch (_dockStyle) {
      case PdfDockStyle.left:
        x = -actualBounds.x;
        y = 0.0;
        _width = width;
        _height = actualBounds.height;
        break;

      case PdfDockStyle.top:
        x = -actualBounds.x;
        y = -actualBounds.y;
        _width = actualSize.width;
        _height = height;

        if (actualBounds.height < 0) {
          y = -actualBounds.y + actualSize.height;
        }
        break;

      case PdfDockStyle.right:
        x = actualBounds.width +
            section._getRightIndentWidth(document, page, false) -
            width;
        y = 0.0;
        _width = width;
        _height = actualBounds.height;
        break;

      case PdfDockStyle.bottom:
        x = -actualBounds.x;
        y = actualBounds.height +
            section._getBottomIndentHeight(document, page, false) -
            height;
        _width = actualSize.width;
        _height = height;
        if (actualBounds.height < 0) {
          y -= actualSize.height;
        }
        break;

      case PdfDockStyle.fill:
        x = 0.0;
        x = 0.0;
        _width = actualBounds.width;
        _height = actualBounds.height;
        break;
      case PdfDockStyle.none:
        break;
      default:
        break;
    }
    return Rect.fromLTWH(x, y, _width, _height);
  }

  void _updateDocking(_TemplateType type) {
    if (type != _TemplateType.none) {
      switch (type) {
        case _TemplateType.top:
          dock = PdfDockStyle.top;
          break;
        case _TemplateType.bottom:
          dock = PdfDockStyle.bottom;
          break;
        case _TemplateType.left:
          dock = PdfDockStyle.left;
          break;
        case _TemplateType.right:
          dock = PdfDockStyle.right;
          break;
        default:
          break;
      }
      _resetAlignment();
    }
  }

  void _resetAlignment() {
    alignment = PdfAlignmentStyle.none;
  }

  void _setAlignment(PdfAlignmentStyle alignment) {
    if (dock == PdfDockStyle.none) {
      _alignmentStyle = alignment;
    } else {
      bool canBeSet = false;
      switch (dock) {
        case PdfDockStyle.left:
          canBeSet = alignment == PdfAlignmentStyle.topLeft ||
              alignment == PdfAlignmentStyle.middleLeft ||
              alignment == PdfAlignmentStyle.bottomLeft ||
              alignment == PdfAlignmentStyle.none;
          break;
        case PdfDockStyle.top:
          canBeSet = alignment == PdfAlignmentStyle.topLeft ||
              alignment == PdfAlignmentStyle.topCenter ||
              alignment == PdfAlignmentStyle.topRight ||
              alignment == PdfAlignmentStyle.none;
          break;
        case PdfDockStyle.right:
          canBeSet = alignment == PdfAlignmentStyle.topRight ||
              alignment == PdfAlignmentStyle.middleRight ||
              alignment == PdfAlignmentStyle.bottomRight ||
              alignment == PdfAlignmentStyle.none;
          break;
        case PdfDockStyle.bottom:
          canBeSet = alignment == PdfAlignmentStyle.bottomLeft ||
              alignment == PdfAlignmentStyle.bottomCenter ||
              alignment == PdfAlignmentStyle.bottomRight ||
              alignment == PdfAlignmentStyle.none;
          break;
        case PdfDockStyle.fill:
          canBeSet = alignment == PdfAlignmentStyle.middleCenter ||
              alignment == PdfAlignmentStyle.none;
          break;
        default:
          break;
      }
      if (canBeSet) {
        _alignmentStyle = alignment;
      }
    }
  }
}
