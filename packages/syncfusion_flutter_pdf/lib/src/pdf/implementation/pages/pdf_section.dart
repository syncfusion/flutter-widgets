import 'dart:ui';

import '../../interfaces/pdf_interface.dart';
import '../drawing/drawing.dart';
import '../general/pdf_collection.dart';
import '../graphics/pdf_margins.dart';
import '../io/pdf_constants.dart';
import '../pdf_document/pdf_document.dart';
import '../pdf_document/pdf_document_template.dart';
import '../primitives/pdf_array.dart';
import '../primitives/pdf_dictionary.dart';
import '../primitives/pdf_name.dart';
import '../primitives/pdf_number.dart';
import '../primitives/pdf_reference_holder.dart';
import 'enum.dart';
import 'pdf_page.dart';
import 'pdf_page_collection.dart';
import 'pdf_page_layer.dart';
import 'pdf_page_settings.dart';
import 'pdf_page_template_element.dart';
import 'pdf_section_collection.dart';
import 'pdf_section_template.dart';

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
/// List<int> bytes = await document.save();
/// //Dispose the document.
/// document.dispose();
/// ```
class PdfSection implements IPdfWrapper {
  //Constructor
  /// Initializes a new instance of the [PdfSection] class.
  PdfSection._(PdfDocument? document, [PdfPageSettings? settings]) {
    _helper = PdfSectionHelper(this);
    _helper.pageReferences = PdfArray();
    _helper._section = PdfDictionary();
    _helper._section!.beginSave = _helper.beginSave;
    _helper._pageCount = PdfNumber(0);
    _helper._section![PdfDictionaryProperties.count] = _helper._pageCount;
    _helper._section![PdfDictionaryProperties.type] =
        PdfName(PdfDictionaryProperties.pages);
    _helper._section![PdfDictionaryProperties.kids] = _helper.pageReferences;
    _helper.pdfDocument = document;
    _helper.settings = settings != null
        ? PdfPageSettingsHelper.getHelper(settings).clone()
        : PdfPageSettingsHelper.getHelper(document!.pageSettings).clone();
  }

  /// Event rises when the new page has been added
  PageAddedCallback? pageAdded;
  PdfSectionTemplate? _template;
  PdfPageCollection? _pageCollection;
  late PdfSectionHelper _helper;

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
  /// List<int> bytes = await document.save();
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
  /// List<int> bytes = await document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  PdfPageCollection get pages {
    _pageCollection ??= PdfPageCollectionHelper.load(_helper.pdfDocument, this);
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
  /// List<int> bytes = await document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  PdfPageSettings get pageSettings {
    PdfMarginsHelper.getHelper(_helper.settings.margins).isPageAdded =
        _helper._pages.isNotEmpty;
    PdfPageSettingsHelper.getHelper(_helper.settings).isPageAdded =
        _helper._pages.isNotEmpty;
    return _helper.settings;
  }

  set pageSettings(PdfPageSettings settings) {
    if (_helper._pages.isEmpty) {
      _helper.settings = settings;
    }
  }
}

/// [PdfSection] helper
class PdfSectionHelper {
  /// internal constructor
  PdfSectionHelper(this.base);

  /// internal field
  late PdfSection base;

  /// internal method
  static PdfSectionHelper getHelper(PdfSection base) {
    return base._helper;
  }

  /// internal method
  static PdfSection load(PdfDocument? document, [PdfPageSettings? settings]) {
    return PdfSection._(document, settings);
  }

  /// internal field
  PdfDictionary? _section;
  PdfSectionCollection? _sectionCollection;
  final List<PdfPage> _pages = <PdfPage>[];
  PdfNumber? _pageCount;

  /// internal method
  IPdfPrimitive? get element => _section;
  //ignore: unused_element
  set element(IPdfPrimitive? value) {
    _section = value as PdfDictionary?;
  }

  /// internal method
  PdfArray? pageReferences;

  /// internal method
  PdfDocument? pdfDocument;

  /// internal method
  late PdfPageSettings settings;

  /// internal method
  bool? isNewPageSection = false;

  /// internal method
  PdfSectionCollection? get parent => _sectionCollection;

  /// Sets the parent.
  set parent(PdfSectionCollection? sections) {
    _sectionCollection = sections;
    if (sections != null) {
      _section![PdfDictionaryProperties.parent] = PdfReferenceHolder(sections);
    } else {
      _section!.remove(PdfDictionaryProperties.parent);
    }
  }

  /// internal method
  PdfDocument? get document {
    if (_sectionCollection != null) {
      return PdfSectionCollectionHelper.getHelper(_sectionCollection!).document;
    } else {
      return null;
    }
  }

  /// internal method
  int get count => pageReferences!.count;

  /// internal method
  void add(PdfPage page) {
    if (!isNewPageSection!) {
      isNewPageSection = PdfPageHelper.getHelper(page).isNewPage;
    }
    final PdfReferenceHolder holder = PdfReferenceHolder(page);
    isNewPageSection = false;
    _pages.add(page);
    pageReferences!.add(holder);
    PdfPageHelper.getHelper(page).assignSection(base);
    _pdfPageAdded(page);
  }

  void _pdfPageAdded(PdfPage page) {
    final PageAddedArgs args = PageAddedArgs(page);
    _onPageAdded(args);
    final PdfSectionCollection? sectionCollection = parent;
    if (sectionCollection != null) {
      PdfPageCollectionHelper.getHelper(
              PdfSectionCollectionHelper.getHelper(sectionCollection)
                  .document!
                  .pages)
          .onPageAdded(args);
    }
    _pageCount!.value = count;
  }

  void _onPageAdded(PageAddedArgs args) {
    if (base.pageAdded != null) {
      base.pageAdded!(base, args);
    }
  }

  /// internal method
  void remove(PdfPage page) {
    for (int i = 0; i < pageReferences!.elements.length; i++) {
      final IPdfPrimitive? pageReference = pageReferences!.elements[i];
      if (pageReference != null &&
          pageReference is PdfReferenceHolder &&
          pageReference.object == PdfPageHelper.getHelper(page).element) {
        pageReferences!.elements.removeAt(i);
        _pages.remove(page);
        break;
      }
    }
  }

  /// internal method
  PdfPage? getPageByIndex(int index) {
    if (index < 0 || index >= count) {
      throw ArgumentError.value(index, 'our of range');
    }
    return _pages[index];
  }

  /// internal method
  PdfRectangle getActualBounds(PdfPage page, bool includeMargins,
      [PdfDocument? document]) {
    if (document == null) {
      if (parent != null) {
        final PdfDocument? pdfDocument =
            PdfSectionCollectionHelper.getHelper(parent!).document;
        return getActualBounds(page, includeMargins, pdfDocument);
      } else {
        final PdfSize size = includeMargins
            ? PdfSize.fromSize(
                PdfPageSettingsHelper.getHelper(base.pageSettings)
                    .getActualSize())
            : base.pageSettings.size as PdfSize;
        final double left = includeMargins ? base.pageSettings.margins.left : 0;
        final double top = includeMargins ? base.pageSettings.margins.top : 0;
        return PdfRectangle(left, top, size.width, size.height);
      }
    } else {
      final PdfRectangle bounds = PdfRectangle.empty;
      final Size size = includeMargins
          ? base.pageSettings.size
          : PdfPageSettingsHelper.getHelper(base.pageSettings).getActualSize();
      bounds.width = size.width;
      bounds.height = size.height;
      final double left = getLeftIndentWidth(document, page, includeMargins);
      final double top = getTopIndentHeight(document, page, includeMargins);
      final double right = getRightIndentWidth(document, page, includeMargins);
      final double bottom =
          getBottomIndentHeight(document, page, includeMargins);
      bounds.x += left;
      bounds.y += top;
      bounds.width -= left + right;
      bounds.height -= top + bottom;
      return bounds;
    }
  }

  /// internal method
  double getLeftIndentWidth(
      PdfDocument document, PdfPage page, bool includeMargins) {
    double value = includeMargins ? base.pageSettings.margins.left : 0;
    final double templateWidth =
        PdfDocumentTemplateHelper.getHelper(base.template).getLeft(page) != null
            ? PdfDocumentTemplateHelper.getHelper(base.template)
                .getLeft(page)!
                .width
            : 0;
    final double docTemplateWidth =
        PdfDocumentTemplateHelper.getHelper(document.template).getLeft(page) !=
                null
            ? PdfDocumentTemplateHelper.getHelper(document.template)
                .getLeft(page)!
                .width
            : 0;
    value += base.template.leftTemplate
        ? (templateWidth >= docTemplateWidth ? templateWidth : docTemplateWidth)
        : templateWidth;
    return value;
  }

  /// internal method
  double getTopIndentHeight(
      PdfDocument document, PdfPage page, bool includeMargins) {
    double value = includeMargins ? base.pageSettings.margins.top : 0;
    final double templateHeight =
        PdfDocumentTemplateHelper.getHelper(base.template).getTop(page) != null
            ? PdfDocumentTemplateHelper.getHelper(base.template)
                .getTop(page)!
                .height
            : 0;
    final double docTemplateHeight =
        PdfDocumentTemplateHelper.getHelper(document.template).getTop(page) !=
                null
            ? PdfDocumentTemplateHelper.getHelper(document.template)
                .getTop(page)!
                .height
            : 0;
    value += base.template.topTemplate
        ? (templateHeight >= docTemplateHeight
            ? templateHeight
            : docTemplateHeight)
        : templateHeight;
    return value;
  }

  /// internal method
  double getRightIndentWidth(
      PdfDocument document, PdfPage page, bool includeMargins) {
    double value = includeMargins ? base.pageSettings.margins.right : 0;
    final double templateWidth =
        PdfDocumentTemplateHelper.getHelper(base.template).getRight(page) !=
                null
            ? PdfDocumentTemplateHelper.getHelper(base.template)
                .getRight(page)!
                .width
            : 0;
    final double docTemplateWidth =
        PdfDocumentTemplateHelper.getHelper(document.template).getRight(page) !=
                null
            ? PdfDocumentTemplateHelper.getHelper(document.template)
                .getRight(page)!
                .width
            : 0;
    value += base.template.rightTemplate
        ? (templateWidth >= docTemplateWidth ? templateWidth : docTemplateWidth)
        : templateWidth;
    return value;
  }

  /// internal method
  double getBottomIndentHeight(
      PdfDocument document, PdfPage page, bool includeMargins) {
    double value = includeMargins ? base.pageSettings.margins.bottom : 0;
    final double templateHeight =
        PdfDocumentTemplateHelper.getHelper(base.template).getBottom(page) !=
                null
            ? PdfDocumentTemplateHelper.getHelper(base.template)
                .getBottom(page)!
                .height
            : 0;
    final double docTemplateHeight =
        PdfDocumentTemplateHelper.getHelper(document.template)
                    .getBottom(page) !=
                null
            ? PdfDocumentTemplateHelper.getHelper(document.template)
                .getBottom(page)!
                .height
            : 0;
    value += base.template.bottomTemplate
        ? (templateHeight >= docTemplateHeight
            ? templateHeight
            : docTemplateHeight)
        : templateHeight;
    return value;
  }

  /// internal method
  void beginSave(Object sender, SavePdfPrimitiveArgs? args) {
    _pageCount!.value = count;
    final PdfDocument? document = args!.writer!.document;
    if (document == null) {
      _setPageSettings(_section!);
    } else {
      _setPageSettings(_section!, document.pageSettings);
    }
  }

  void _setPageSettings(PdfDictionary container,
      [PdfPageSettings? parentSettings]) {
    if (parentSettings == null ||
        base.pageSettings.size != parentSettings.size) {
      final PdfRectangle bounds = PdfRectangle(
          PdfPageSettingsHelper.getHelper(settings).origin.x,
          PdfPageSettingsHelper.getHelper(settings).origin.y,
          settings.size.width,
          settings.size.height);
      container[PdfDictionaryProperties.mediaBox] =
          PdfArray.fromRectangle(bounds);
    }
    if (parentSettings == null ||
        base.pageSettings.rotate != parentSettings.rotate) {
      int rotate = 0;
      if (_sectionCollection != null) {
        if (PdfPageSettingsHelper.getHelper(base.pageSettings).isRotation &&
            !PdfPageSettingsHelper.getHelper(document!.pageSettings)
                .isRotation) {
          rotate = PdfSectionCollectionHelper.rotateFactor *
              base.pageSettings.rotate.index;
        } else {
          if (!PdfPageSettingsHelper.getHelper(document!.pageSettings)
                  .isRotation &&
              base.pageSettings.rotate != PdfPageRotateAngle.rotateAngle0) {
            rotate = PdfSectionCollectionHelper.rotateFactor *
                base.pageSettings.rotate.index;
          } else {
            if (PdfPageSettingsHelper.getHelper(base.pageSettings).isRotation) {
              rotate = PdfSectionCollectionHelper.rotateFactor *
                  base.pageSettings.rotate.index;
            } else if (parentSettings != null) {
              rotate = PdfSectionCollectionHelper.rotateFactor *
                  parentSettings.rotate.index;
            }
          }
        }
      } else {
        rotate = PdfSectionCollectionHelper.rotateFactor *
            base.pageSettings.rotate.index;
      }
      final PdfNumber angle = PdfNumber(rotate);
      if (angle.value != 0) {
        container[PdfDictionaryProperties.rotate] = angle;
      }
    }
  }

  /// internal method
  int indexOf(PdfPage page) {
    if (_pages.contains(page)) {
      return _pages.indexOf(page);
    }
    final PdfReferenceHolder holder = PdfReferenceHolder(page);
    return pageReferences!.indexOf(holder);
  }

  /// internal method
  bool containsTemplates(PdfDocument document, PdfPage page, bool foreground) {
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
      if (base.template.topTemplate &&
          PdfDocumentTemplateHelper.getHelper(document.template).getTop(page) !=
              null &&
          PdfDocumentTemplateHelper.getHelper(document.template)
                  .getTop(page)!
                  .foreground ==
              foreground) {
        templates.add(PdfDocumentTemplateHelper.getHelper(document.template)
            .getTop(page)!);
      }
      if (base.template.bottomTemplate &&
          PdfDocumentTemplateHelper.getHelper(document.template)
                  .getBottom(page) !=
              null &&
          PdfDocumentTemplateHelper.getHelper(document.template)
                  .getBottom(page)!
                  .foreground ==
              foreground) {
        templates.add(PdfDocumentTemplateHelper.getHelper(document.template)
            .getBottom(page)!);
      }
      if (base.template.leftTemplate &&
          PdfDocumentTemplateHelper.getHelper(document.template)
                  .getLeft(page) !=
              null &&
          PdfDocumentTemplateHelper.getHelper(document.template)
                  .getLeft(page)!
                  .foreground ==
              foreground) {
        templates.add(PdfDocumentTemplateHelper.getHelper(document.template)
            .getLeft(page)!);
      }
      if (base.template.rightTemplate &&
          PdfDocumentTemplateHelper.getHelper(document.template)
                  .getRight(page) !=
              null &&
          PdfDocumentTemplateHelper.getHelper(document.template)
                  .getRight(page)!
                  .foreground ==
              foreground) {
        templates.add(PdfDocumentTemplateHelper.getHelper(document.template)
            .getRight(page)!);
      }
    } else if (base.template.stamp) {
      final List<Object> list =
          PdfObjectCollectionHelper.getHelper(document.template.stamps).list;
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
      if (PdfDocumentTemplateHelper.getHelper(base.template).getTop(page) !=
              null &&
          PdfDocumentTemplateHelper.getHelper(base.template)
                  .getTop(page)!
                  .foreground ==
              foreground) {
        templates.add(
            PdfDocumentTemplateHelper.getHelper(base.template).getTop(page)!);
      }
      if (PdfDocumentTemplateHelper.getHelper(base.template).getBottom(page) !=
              null &&
          PdfDocumentTemplateHelper.getHelper(base.template)
                  .getBottom(page)!
                  .foreground ==
              foreground) {
        templates.add(PdfDocumentTemplateHelper.getHelper(base.template)
            .getBottom(page)!);
      }
      if (PdfDocumentTemplateHelper.getHelper(base.template).getLeft(page) !=
              null &&
          PdfDocumentTemplateHelper.getHelper(base.template)
                  .getLeft(page)!
                  .foreground ==
              foreground) {
        templates.add(
            PdfDocumentTemplateHelper.getHelper(base.template).getLeft(page)!);
      }
      if (PdfDocumentTemplateHelper.getHelper(base.template).getRight(page) !=
              null &&
          PdfDocumentTemplateHelper.getHelper(base.template)
                  .getRight(page)!
                  .foreground ==
              foreground) {
        templates.add(
            PdfDocumentTemplateHelper.getHelper(base.template).getRight(page)!);
      }
    } else {
      final List<Object> list =
          PdfObjectCollectionHelper.getHelper(base.template.stamps).list;
      for (int i = 0; i < list.length; i++) {
        final PdfPageTemplateElement temp = list[i] as PdfPageTemplateElement;
        if (temp.foreground == foreground) {
          templates.add(temp);
        }
      }
    }
    return templates;
  }

  /// internal method
  void drawTemplates(
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
        PdfPageTemplateElementHelper.getHelper(template).draw(layer, document);
      }
    }
  }

  /// internal method
  PdfPoint pointToNativePdf(PdfPage page, PdfPoint point) {
    final PdfRectangle bounds = getActualBounds(page, true);
    point.x += bounds.left;
    point.y = base.pageSettings.height - (bounds.top + point.y);
    return point;
  }

  /// internal method
  void dropCropBox() {
    _setPageSettings(_section!);
    _section![PdfDictionaryProperties.cropBox] =
        _section![PdfDictionaryProperties.mediaBox];
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
