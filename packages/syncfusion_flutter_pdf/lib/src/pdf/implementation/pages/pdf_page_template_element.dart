import 'dart:ui';

import '../drawing/drawing.dart';
import '../graphics/figures/pdf_template.dart';
import '../graphics/pdf_graphics.dart';
import '../pdf_document/pdf_document.dart';
import 'enum.dart';
import 'pdf_page.dart';
import 'pdf_page_layer.dart';
import 'pdf_page_settings.dart';
import 'pdf_section.dart';

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
/// List<int> bytes = await document.save();
/// //Dispose the document.
/// document.dispose();
/// ```
class PdfPageTemplateElement {
  //Constructor
  /// Initializes a new instance of the [PdfPageTemplateElement] class.
  /// ```dart
  /// //Create a new pdf document
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
  /// List<int> bytes = await document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  PdfPageTemplateElement(Rect bounds, [PdfPage? page]) {
    _helper = PdfPageTemplateElementHelper(this);
    x = bounds.left;
    y = bounds.top;
    _helper._pdfTemplate = PdfTemplate(bounds.width, bounds.height);
    if (page != null) {
      graphics.colorSpace = PdfPageHelper.getHelper(page).document!.colorSpace;
    }
  }

  //Fields
  /// Indicates whether the page template is located in front of the
  /// page layers or behind of it. If false, the page template will be located
  /// behind of page layer.
  bool foreground = false;
  PdfPoint _currentLocation = PdfPoint.empty;
  late PdfPageTemplateElementHelper _helper;

  //Properties
  /// Gets or sets the dock style of the page template element.
  /// ```dart
  /// //Create a new pdf document
  /// PdfDocument document = PdfDocument();
  /// //Set margins.
  /// document.pageSettings.setMargins(25);
  /// //Create the page template with specific bounds
  /// PdfPageTemplateElement custom = PdfPageTemplateElement(
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
  /// List<int> bytes = await document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  PdfDockStyle get dock {
    _helper._dockStyle ??= PdfDockStyle.none;
    return _helper._dockStyle!;
  }

  set dock(PdfDockStyle value) {
    _helper._dockStyle = value;
    _helper._resetAlignment();
  }

  /// Gets or sets the alignment of the page template element.
  /// ```dart
  /// //Create a new pdf document
  /// PdfDocument document = PdfDocument();
  /// //Set margins.
  /// document.pageSettings.setMargins(25);
  /// //Create the page template with specific bounds
  /// PdfPageTemplateElement custom = PdfPageTemplateElement(
  ///     Rect.fromLTWH(0, 0, 100, 100), document.pages.add());
  /// document.template.stamps.add(custom);
  /// //Gets or sets  dock style.
  /// custom.dock = PdfDockStyle.right;
  /// //Gets or sets  alignment style.
  /// custom.alignment = PdfAlignmentStyle.middleCenter;
  /// //Draw template into pdf page.
  /// custom.graphics.drawRectangle(
  ///     pen: PdfPen(PdfColor(255, 165, 0), width: 3),
  ///     brush: PdfSolidBrush(PdfColor(173, 255, 47)),
  ///     bounds: Rect.fromLTWH(0, 0, 100, 100));
  /// //Save the document.
  /// List<int> bytes = await document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  PdfAlignmentStyle get alignment => _helper._alignmentStyle;
  set alignment(PdfAlignmentStyle value) {
    if (_helper._alignmentStyle != value) {
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
  /// PdfPageTemplateElement custom = PdfPageTemplateElement(
  ///     const Offset(5, 5) & const Size(110, 110), document.pages.add());
  /// document.template.stamps.add(custom);
  /// //Gets or sets  background.
  /// custom.background = true;
  /// //Draw template into pdf page.
  /// custom.graphics.drawRectangle(
  ///     pen: PdfPen(PdfColor(255, 165, 0), width: 3),
  ///     brush: PdfSolidBrush(PdfColor(173, 255, 47)),
  ///     bounds: Rect.fromLTWH(0, 0, 100, 100));
  /// //Save the document.
  /// List<int> bytes = await document.save();
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
  /// PdfPageTemplateElement custom = PdfPageTemplateElement(
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
  /// List<int> bytes = await document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  Offset get location => _currentLocation.offset;
  set location(Offset value) {
    if (_helper._templateType == TemplateType.none) {
      _currentLocation = PdfPoint.fromOffset(value);
    }
  }

  /// Gets or sets X co-ordinate of the template element on the page.
  /// ```dart
  /// //Create a new pdf document
  /// PdfDocument document = PdfDocument();
  /// //Set margins.
  /// document.pageSettings.setMargins(25);
  /// //Create the page template with specific bounds
  /// PdfPageTemplateElement custom = PdfPageTemplateElement(
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
  /// List<int> bytes = await document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  double get x => _currentLocation.x;
  set x(double value) {
    if (_helper.type == TemplateType.none) {
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
  /// PdfPageTemplateElement custom = PdfPageTemplateElement(
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
  /// List<int> bytes = await document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  double get y => _currentLocation.y;
  set y(double value) {
    if (_helper.type == TemplateType.none) {
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
  /// PdfPageTemplateElement custom = PdfPageTemplateElement(
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
  /// List<int> bytes = await document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  Size get size => _helper._template!.size;
  set size(Size value) {
    if (_helper.type == TemplateType.none) {
      _helper._template!.reset(value.width, value.height);
    }
  }

  /// Gets or sets width of the page template element.
  /// ```dart
  /// //Create a new pdf document
  /// PdfDocument document = PdfDocument();
  /// //Set margins.
  /// document.pageSettings.setMargins(25);
  /// //Create the page template with specific bounds
  /// PdfPageTemplateElement custom = PdfPageTemplateElement(
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
  /// List<int> bytes = await document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  double get width => _helper._template!.size.width;
  set width(double value) {
    if (_helper._template!.size.width != value &&
        _helper.type == TemplateType.none) {
      _helper._template!.reset(value, _helper._template!.size.height);
    }
  }

  /// Gets or sets height of the page template element.
  /// ```dart
  /// //Create a new pdf document
  /// PdfDocument document = PdfDocument();
  /// //Set margins.
  /// document.pageSettings.setMargins(25);
  /// //Create the page template with specific bounds
  /// PdfPageTemplateElement custom = PdfPageTemplateElement(
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
  /// List<int> bytes = await document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  double get height => _helper._template!.size.height;
  set height(double value) {
    if (_helper._template!.size.height != value &&
        _helper.type == TemplateType.none) {
      _helper._template!.reset(_helper._template!.size.width, value);
    }
  }

  /// Gets or sets graphics context of the page template element.
  /// ```dart
  /// //Create a new pdf document
  /// PdfDocument document = PdfDocument();
  /// //Set margins.
  /// document.pageSettings.setMargins(25);
  /// //Create the page template with specific bounds
  /// PdfPageTemplateElement custom = PdfPageTemplateElement(
  ///     Rect.fromLTWH(0, 0, 100, 100), document.pages.add());
  /// document.template.stamps.add(custom);
  /// //Draw template into pdf page.
  /// custom.graphics.drawRectangle(
  ///     pen: PdfPen(PdfColor(255, 165, 0), width: 3),
  ///     brush: PdfSolidBrush(PdfColor(173, 255, 47)),
  ///     bounds: Rect.fromLTWH(0, 0, 100, 100));
  /// //Save the document.
  /// List<int> bytes = await document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  PdfGraphics get graphics => _helper._template!.graphics!;

  /// Gets or sets bounds of the page template element.
  /// ```dart
  /// //Create a new pdf document
  /// PdfDocument document = PdfDocument();
  /// //Set margins.
  /// document.pageSettings.setMargins(25);
  /// //Create the page template with specific bounds
  /// PdfPageTemplateElement custom = PdfPageTemplateElement(
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
  /// List<int> bytes = await document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  Rect get bounds => Rect.fromLTWH(x, y, width, height);
  set bounds(Rect value) {
    if (_helper.type == TemplateType.none) {
      location = Offset(value.left, value.top);
      size = Size(value.width, value.height);
    }
  }

  //Implementation
  void _setAlignment(PdfAlignmentStyle alignment) {
    if (dock == PdfDockStyle.none) {
      _helper._alignmentStyle = alignment;
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
        case PdfDockStyle.none:
          break;
      }
      if (canBeSet) {
        _helper._alignmentStyle = alignment;
      }
    }
  }
}

/// [PdfPageTemplateElement] helper
class PdfPageTemplateElementHelper {
  /// internal constructor
  PdfPageTemplateElementHelper(this.base);

  /// internal field
  late PdfPageTemplateElement base;

  /// internal method
  static PdfPageTemplateElementHelper getHelper(PdfPageTemplateElement base) {
    return base._helper;
  }

  TemplateType _templateType = TemplateType.none;
  PdfTemplate? _pdfTemplate;
  PdfAlignmentStyle _alignmentStyle = PdfAlignmentStyle.none;
  PdfDockStyle? _dockStyle;

  /// Gets type of the usage of this page template.
  TemplateType get type => _templateType;

  /// Sets type of the usage of this page template.
  set type(TemplateType value) {
    _updateDocking(value);
    _templateType = value;
  }

  void _updateDocking(TemplateType type) {
    if (type != TemplateType.none) {
      switch (type) {
        case TemplateType.top:
          base.dock = PdfDockStyle.top;
          break;
        case TemplateType.bottom:
          base.dock = PdfDockStyle.bottom;
          break;
        case TemplateType.left:
          base.dock = PdfDockStyle.left;
          break;
        case TemplateType.right:
          base.dock = PdfDockStyle.right;
          break;
        case TemplateType.none:
          break;
      }
      _resetAlignment();
    }
  }

  void _resetAlignment() {
    base.alignment = PdfAlignmentStyle.none;
  }

  /// Gets PDF template object.
  PdfTemplate? get _template => _pdfTemplate;

  /// internal method
  void draw(PdfPageLayer layer, PdfDocument document) {
    final PdfPage page = layer.page;
    final Rect bounds = _calculateBounds(page, document);
    PdfPageHelper.getHelper(layer.page).isDefaultGraphics = true;
    layer.graphics.drawPdfTemplate(_template!, bounds.topLeft, bounds.size);
  }

  Rect _calculateBounds(PdfPage page, PdfDocument document) {
    Rect result = base.bounds;
    if (_alignmentStyle != PdfAlignmentStyle.none) {
      result = _getAlignmentBounds(page, document);
    } else if (_dockStyle != PdfDockStyle.none) {
      result = _getDockBounds(page, document);
    }
    return result;
  }

  Rect _getAlignmentBounds(PdfPage page, PdfDocument document) {
    Rect result = base.bounds;
    if (type == TemplateType.none) {
      result = _getSimpleAlignmentBounds(page, document);
    }
    return result;
  }

  Rect _getSimpleAlignmentBounds(PdfPage page, PdfDocument document) {
    final Rect result = base.bounds;
    final PdfSection section = PdfPageHelper.getHelper(page).section!;
    final PdfRectangle actualBounds = PdfSectionHelper.getHelper(section)
        .getActualBounds(page, false, document);
    double x = base.location.dx;
    double y = base.location.dy;

    switch (_alignmentStyle) {
      case PdfAlignmentStyle.topLeft:
        {
          x = 0.0;
          y = 0.0;
        }
        break;

      case PdfAlignmentStyle.topCenter:
        {
          x = (actualBounds.width - base.width) / 2.0;
          y = 0.0;
        }
        break;

      case PdfAlignmentStyle.topRight:
        {
          x = actualBounds.width - base.width;
          y = 0.0;
        }
        break;

      case PdfAlignmentStyle.middleLeft:
        {
          x = 0.0;
          y = (actualBounds.height - base.height) / 2.0;
        }
        break;

      case PdfAlignmentStyle.middleCenter:
        {
          x = (actualBounds.width - base.width) / 2.0;
          y = (actualBounds.height - base.height) / 2.0;
        }
        break;

      case PdfAlignmentStyle.middleRight:
        {
          x = actualBounds.width - base.width;
          y = (actualBounds.height - base.height) / 2.0;
        }
        break;

      case PdfAlignmentStyle.bottomLeft:
        {
          x = 0.0;
          y = actualBounds.height - base.height;
        }
        break;

      case PdfAlignmentStyle.bottomCenter:
        {
          x = (actualBounds.width - base.width) / 2.0;
          y = actualBounds.height - base.height;
        }
        break;

      case PdfAlignmentStyle.bottomRight:
        {
          x = actualBounds.width - base.width;
          y = actualBounds.height - base.height;
        }
        break;
      case PdfAlignmentStyle.none:
        break;
    }

    return Offset(x, y) & result.size;
  }

  Rect _getDockBounds(PdfPage page, PdfDocument document) {
    Rect result = base.bounds;

    if (type == TemplateType.none) {
      result = _getSimpleDockBounds(page, document);
    } else {
      result = _getTemplateDockBounds(page, document);
    }
    return result;
  }

  Rect _getSimpleDockBounds(PdfPage page, PdfDocument document) {
    Rect result = base.bounds;
    final PdfSection section = PdfPageHelper.getHelper(page).section!;
    final PdfRectangle actualBounds = PdfSectionHelper.getHelper(section)
        .getActualBounds(page, false, document);
    double x = base.location.dx;
    double y = base.location.dy;
    double? width = base.width;
    double? height = base.height;

    switch (_dockStyle) {
      case PdfDockStyle.left:
        x = 0.0;
        y = 0.0;
        width = base.width;
        height = actualBounds.height;
        break;

      case PdfDockStyle.top:
        x = 0.0;
        y = 0.0;
        width = actualBounds.width;
        height = base.height;
        break;

      case PdfDockStyle.right:
        x = actualBounds.width - base.width;
        y = 0.0;
        width = base.width;
        height = actualBounds.height;
        break;

      case PdfDockStyle.bottom:
        x = 0.0;
        y = actualBounds.height - base.height;
        width = actualBounds.width;
        height = base.height;
        break;

      case PdfDockStyle.fill:
        x = 0.0;
        x = 0.0;
        width = actualBounds.width;
        height = actualBounds.height;
        break;
      case PdfDockStyle.none:
        break;
      // ignore: no_default_cases
      default:
        break;
    }

    result = Rect.fromLTWH(x, y, width, height);

    return result;
  }

  Rect _getTemplateDockBounds(PdfPage page, PdfDocument document) {
    final PdfSection section = PdfPageHelper.getHelper(page).section!;
    final PdfRectangle actualBounds = PdfSectionHelper.getHelper(section)
        .getActualBounds(page, false, document);
    final PdfSize actualSize = PdfSize.fromSize(
        PdfPageSettingsHelper.getHelper(section.pageSettings).getActualSize());
    double x = base.location.dx;
    double y = base.location.dy;
    double? width = base.width;
    double? height = base.height;

    switch (_dockStyle) {
      case PdfDockStyle.left:
        x = -actualBounds.x;
        y = 0.0;
        width = base.width;
        height = actualBounds.height;
        break;

      case PdfDockStyle.top:
        x = -actualBounds.x;
        y = -actualBounds.y;
        width = actualSize.width;
        height = base.height;

        if (actualBounds.height < 0) {
          y = -actualBounds.y + actualSize.height;
        }
        break;

      case PdfDockStyle.right:
        x = actualBounds.width +
            PdfSectionHelper.getHelper(section)
                .getRightIndentWidth(document, page, false) -
            base.width;
        y = 0.0;
        width = base.width;
        height = actualBounds.height;
        break;

      case PdfDockStyle.bottom:
        x = -actualBounds.x;
        y = actualBounds.height +
            PdfSectionHelper.getHelper(section)
                .getBottomIndentHeight(document, page, false) -
            base.height;
        width = actualSize.width;
        height = base.height;
        if (actualBounds.height < 0) {
          y -= actualSize.height;
        }
        break;

      case PdfDockStyle.fill:
        x = 0.0;
        x = 0.0;
        width = actualBounds.width;
        height = actualBounds.height;
        break;
      case PdfDockStyle.none:
        break;
      // ignore: no_default_cases
      default:
        break;
    }
    return Rect.fromLTWH(x, y, width, height);
  }
}
