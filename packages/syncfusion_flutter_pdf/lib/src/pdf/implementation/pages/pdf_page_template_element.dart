part of pdf;

/// Describes a page template object that can be used as header/footer, watermark or stamp.
class PdfPageTemplateElement {
  //Constructor
  /// Initializes a new instance of the [PdfPageTemplateElement] class
  PdfPageTemplateElement(Rect bounds, [PdfPage page]) {
    x = bounds.left;
    y = bounds.top;
    _pdfTemplate = PdfTemplate(bounds.width, bounds.height);
    if (page != null) {
      graphics.colorSpace = page._document.colorSpace;
    }
  }

  //Fields
  /// Indicates whether the page template is located in front of the
  /// page layers or behind of it. If false, the page template will be located
  /// behind of page layer.
  bool foreground = false;
  PdfDockStyle _dockStyle;
  PdfAlignmentStyle _alignmentStyle;
  PdfTemplate _pdfTemplate;
  _TemplateType _templateType = _TemplateType.none;
  _Point _currentLocation = _Point.empty;

  //Properties
  /// Gets the dock style of the page template element.
  PdfDockStyle get dock {
    _dockStyle ??= PdfDockStyle.none;
    return _dockStyle;
  }

  /// Sets the dock style of the page template element.
  set dock(PdfDockStyle value) {
    _dockStyle = value;
    _resetAlignment();
  }

  /// Gets alignment of the page template element.
  PdfAlignmentStyle get alignment => _alignmentStyle;

  /// Sets alignment of the page template element.
  set alignment(PdfAlignmentStyle value) {
    if (_alignmentStyle != value) {
      _setAlignment(value);
    }
  }

  /// Indicates whether the page template is located behind of the page layers
  /// or in front of it.
  bool get background => !foreground;

  /// Indicates whether the page template is located behind of the page layers
  /// or in front of it.
  set background(bool value) {
    foreground = !value;
  }

  /// Gets location of the page template element.
  Offset get location => _currentLocation.offset;

  /// Sets location of the page template element.
  set location(Offset value) {
    ArgumentError.checkNotNull(value);
    if (_templateType == _TemplateType.none) {
      _currentLocation = _Point.fromOffset(value);
    }
  }

  /// Gets X co-ordinate of the template element on the page.
  double get x => _currentLocation != null ? _currentLocation.x : 0;

  /// Sets X co-ordinate of the template element on the page.
  set x(double value) {
    if (_type == _TemplateType.none) {
      _currentLocation.x = value;
    }
  }

  /// Gets Y co-ordinate of the template element on the page.
  double get y => _currentLocation != null ? _currentLocation.y : 0;

  /// Sets Y co-ordinate of the template element on the page.
  set y(double value) {
    if (_type == _TemplateType.none) {
      _currentLocation.y = value;
    }
  }

  /// Gets size of the page template element.
  Size get size => _template.size;

  /// Sets size of the page template element.
  set size(Size value) {
    if (_type == _TemplateType.none) {
      _template.reset(value.width, value.height);
    }
  }

  /// Gets width of the page template element.
  double get width => _template.size.width;

  /// Sets width of the page template element.
  set width(double value) {
    if (_template.size.width != value && _type == _TemplateType.none) {
      _template.reset(value, _template.size.height);
    }
  }

  /// Gets height of the page template element.
  double get height => _template.size.height;

  /// Sets height of the page template element.
  set height(double value) {
    if (_template.size.height != value && _type == _TemplateType.none) {
      _template.reset(_template.size.width, value);
    }
  }

  /// Gets graphics context of the page template element.
  PdfGraphics get graphics => _template.graphics;

  /// Gets PDF template object.
  PdfTemplate get _template => _pdfTemplate;

  /// Gets type of the usage of this page template.
  _TemplateType get _type => _templateType;

  /// Sets type of the usage of this page template.
  set _type(_TemplateType value) {
    _updateDocking(value);
    _templateType = value;
  }

  /// Gets bounds of the page template element.
  Rect get bounds => Rect.fromLTWH(x, y, width, height);

  /// Sets bounds of the page template element.
  set bounds(Rect value) {
    if (_type == _TemplateType.none) {
      location = Offset(value.left, value.top);
      size = Size(value.width, value.height);
    }
  }

  //Implementation
  void _draw(PdfPageLayer layer, PdfDocument document) {
    ArgumentError.checkNotNull(layer, 'layer');
    ArgumentError.checkNotNull(document, 'document');
    final PdfPage page = layer.page;
    final Rect bounds = _calculateBounds(page, document);
    layer.graphics.drawPdfTemplate(_template, bounds.topLeft, bounds.size);
  }

  Rect _calculateBounds(PdfPage page, PdfDocument document) {
    ArgumentError.checkNotNull(page, 'page');
    ArgumentError.checkNotNull(document, 'document');
    Rect result = bounds;
    if (_alignmentStyle != PdfAlignmentStyle.none) {
      result = _getAlignmentBounds(page, document);
    } else if (_dockStyle != PdfDockStyle.none) {
      result = _getDockBounds(page, document);
    }
    return result;
  }

  Rect _getAlignmentBounds(PdfPage page, PdfDocument document) {
    ArgumentError.checkNotNull(page, 'page');
    ArgumentError.checkNotNull(document, 'document');
    Rect result = bounds;
    if (_type == _TemplateType.none) {
      result = _getSimpleAlignmentBounds(page, document);
    }
    return result;
  }

  Rect _getSimpleAlignmentBounds(PdfPage page, PdfDocument document) {
    ArgumentError.checkNotNull(page, 'page');
    ArgumentError.checkNotNull(document, 'document');
    final Rect result = bounds;
    final PdfSection section = page._section;
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
    }

    return Offset(x, y) & result.size;
  }

  Rect _getDockBounds(PdfPage page, PdfDocument document) {
    ArgumentError.checkNotNull(page, 'page');
    ArgumentError.checkNotNull(document, 'document');
    Rect result = bounds;

    if (_type == _TemplateType.none) {
      result = _getSimpleDockBounds(page, document);
    } else {
      result = _getTemplateDockBounds(page, document);
    }
    return result;
  }

  Rect _getSimpleDockBounds(PdfPage page, PdfDocument document) {
    ArgumentError.checkNotNull(page, 'page');
    ArgumentError.checkNotNull(document, 'document');
    Rect result = bounds;
    final PdfSection section = page._section;
    final _Rectangle actualBounds =
        section._getActualBounds(page, false, document);
    double x = location.dx;
    double y = location.dy;
    double _width = width;
    double _height = height;

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
    }

    result = Rect.fromLTWH(x, y, _width, _height);

    return result;
  }

  Rect _getTemplateDockBounds(PdfPage page, PdfDocument document) {
    ArgumentError.checkNotNull(page, 'page');
    ArgumentError.checkNotNull(document, 'document');
    final PdfSection section = page._section;
    final _Rectangle actualBounds =
        section._getActualBounds(page, false, document);
    final _Size actualSize =
        _Size.fromSize(section.pageSettings._getActualSize());
    double x = location.dx;
    double y = location.dy;
    double _width = width;
    double _height = height;

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
