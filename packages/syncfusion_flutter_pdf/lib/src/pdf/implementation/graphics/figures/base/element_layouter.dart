import 'dart:ui';

import '../../../drawing/drawing.dart';
import '../../../pages/pdf_page.dart';
import '../../../pages/pdf_section.dart';
import '../enums.dart';
import 'layout_element.dart';
import 'text_layouter.dart';

/// Base class for elements lay outing.
abstract class ElementLayouter {
  //Constructor
  /// Initializes a new instance of the [ElementLayouter] class.
  ElementLayouter(PdfLayoutElement element) {
    _element = element;
  }

  //Fields
  /// Layout the element.
  PdfLayoutElement? _element;

  //Properties
  /// Gets  element`s layout.
  PdfLayoutElement? get element => _element;

  //Implementation
  /// internal method
  PdfLayoutResult? layout(PdfLayoutParams param) {
    return layoutInternal(param);
  }

  /// internal method
  PdfLayoutResult? layoutInternal(PdfLayoutParams param);

  /// internal method
  PdfPage? getNextPage(PdfPage currentPage) {
    final PdfSection section = PdfPageHelper.getHelper(currentPage).section!;
    PdfPage? nextPage;
    final int index = PdfSectionHelper.getHelper(section).indexOf(currentPage);
    if (index == PdfSectionHelper.getHelper(section).count - 1) {
      nextPage = section.pages.add();
    } else {
      nextPage = PdfSectionHelper.getHelper(section).getPageByIndex(index + 1);
    }
    return nextPage;
  }

  /// internal method
  PdfRectangle getPaginateBounds(PdfLayoutParams param) {
    return param.format!._boundsSet
        ? PdfRectangle.fromRect(param.format!.paginateBounds)
        : PdfRectangle(
            param.bounds!.x, 0, param.bounds!.width, param.bounds!.height);
  }
}

/// Represents a layouting format
class PdfLayoutFormat {
  //Constructor
  /// Initializes a new instance of the [PdfLayoutFormat] class.
  PdfLayoutFormat(
      {PdfLayoutType? layoutType,
      PdfLayoutBreakType? breakType,
      Rect? paginateBounds}) {
    this.breakType = breakType ?? PdfLayoutBreakType.fitPage;
    this.layoutType = layoutType ?? PdfLayoutType.paginate;
    if (paginateBounds != null) {
      _paginateBounds = PdfRectangle.fromRect(paginateBounds);
      _boundsSet = true;
    } else {
      _paginateBounds = PdfRectangle.empty;
      _boundsSet = false;
    }
  }

  /// Initializes a new instance of the [PdfLayoutFormat] class
  /// from an existing format.
  PdfLayoutFormat.fromFormat(PdfLayoutFormat baseFormat) {
    breakType = baseFormat.breakType;
    layoutType = baseFormat.layoutType;
    _paginateBounds = baseFormat._paginateBounds;
    _boundsSet = baseFormat._boundsSet;
  }

  //Fields
  /// Layout type of the element.
  PdfLayoutType layoutType = PdfLayoutType.paginate;

  /// Gets the bounds on the next page.
  Rect get paginateBounds => _paginateBounds.rect;

  /// Sets the bounds on the next page.
  set paginateBounds(Rect value) {
    _paginateBounds = PdfRectangle.fromRect(value);
    _boundsSet = true;
  }

  /// Break type of the element.
  PdfLayoutBreakType breakType = PdfLayoutBreakType.fitPage;

  /// Indicates whether PaginateBounds were set and should be used or not.
  late bool _boundsSet;

  /// Bounds for the paginating.
  late PdfRectangle _paginateBounds;
}

// ignore: avoid_classes_with_only_static_members
/// [PdfLayoutFormat] helper
class PdfLayoutFormatHelper {
  /// internal method
  static bool isBoundsSet(PdfLayoutFormat format, [bool? value]) {
    if (value != null) {
      format._boundsSet = value;
    }
    return format._boundsSet;
  }
}

/// Represents the layouting parameters.
class PdfLayoutParams {
  /// Gets and Sets Start lay outing page.
  PdfPage? page;

  /// Gets and Sets Lay outing bounds.
  PdfRectangle? bounds;

  /// Gets and Sets Layout settings.
  PdfLayoutFormat? format;
}
