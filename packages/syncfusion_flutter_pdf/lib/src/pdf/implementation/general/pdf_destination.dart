import 'dart:ui';

import '../../interfaces/pdf_interface.dart';
import '../drawing/drawing.dart';
import '../io/pdf_constants.dart';
import '../pages/pdf_page.dart';
import '../pages/pdf_section.dart';
import '../primitives/pdf_array.dart';
import '../primitives/pdf_name.dart';
import '../primitives/pdf_number.dart';
import '../primitives/pdf_reference_holder.dart';
import 'enum.dart';

/// Represents an anchor in the document where bookmarks
/// or annotations can direct when clicked.
class PdfDestination implements IPdfWrapper {
  // constructor
  /// Initializes a new instance of the [PdfDestination] class with
  /// specified page and location.
  PdfDestination(PdfPage page, [Offset? location]) {
    _helper = PdfDestinationHelper(this);
    this.page = page;
    this.location = (location == null) ? Offset(0, _location.y) : location;
  }

  PdfDestination._(PdfPage page, PdfRectangle rect) {
    _helper = PdfDestinationHelper(this);
    this.page = page;
    location = rect.location.offset;
    _bounds = rect;
  }

  // fields
  late PdfDestinationHelper _helper;
  double _zoom = 0;
  PdfPoint _location = PdfPoint.empty;
  PdfRectangle _rect = PdfRectangle.empty;
  PdfPage? _page;
  final PdfArray _array = PdfArray();
  PdfDestinationMode _destinationMode = PdfDestinationMode.location;

  // Properties
  /// Gets zoom factor.
  double get zoom => _zoom;

  /// Sets zoom factor.
  set zoom(double value) {
    if (value != _zoom) {
      _zoom = value;
      _initializePrimitive();
    }
  }

  /// Gets a page where the destination is situated.
  PdfPage get page => _page!;

  /// Sets a page where the destination is situated.
  set page(PdfPage value) {
    if (value != _page) {
      _page = value;
      _initializePrimitive();
    }
  }

  /// Gets mode of the destination.
  PdfDestinationMode get mode {
    return _destinationMode;
  }

  /// Sets mode of the destination.
  set mode(PdfDestinationMode value) {
    if (value != _destinationMode) {
      _destinationMode = value;
      _initializePrimitive();
    }
  }

  /// Gets a location of the destination.
  Offset get location => _location.offset;

  /// Sets a location of the destination.
  set location(Offset value) {
    final PdfPoint position = PdfPoint.fromOffset(value);
    if (position != _location) {
      _location = position;
      _initializePrimitive();
    }
  }

  PdfRectangle get _bounds => _rect;

  set _bounds(PdfRectangle value) {
    if (_rect != value) {
      _rect = value;
      _initializePrimitive();
    }
  }

  // implementation
  void _initializePrimitive() {
    _array.clear();
    _array.add(PdfReferenceHolder(_page));
    switch (mode) {
      case PdfDestinationMode.location:
        PdfPoint point = PdfPoint.empty;
        if (PdfPageHelper.getHelper(page).isLoadedPage) {
          point.x = _location.x;
          point.y = page.size.height - _location.y;
        } else {
          point = _pointToNativePdf(page, PdfPoint(_location.x, _location.y));
        }
        _array.add(PdfName(PdfDictionaryProperties.xyz));
        _array.add(PdfNumber(point.x));
        _array.add(PdfNumber(point.y));
        _array.add(PdfNumber(_zoom));
        break;

      case PdfDestinationMode.fitToPage:
        _array.add(PdfName(PdfDictionaryProperties.fit));
        break;

      case PdfDestinationMode.fitR:
        {
          _array.add(PdfName(PdfDictionaryProperties.fitR));
          _array.add(PdfNumber(_bounds.x));
          _array.add(PdfNumber(_bounds.y));
          _array.add(PdfNumber(_bounds.width));
          _array.add(PdfNumber(_bounds.height));
        }
        break;

      case PdfDestinationMode.fitH:
        final PdfPage page = _page!;
        double value = 0;
        if (PdfPageHelper.getHelper(page).isLoadedPage) {
          value = page.size.height - _location.y;
        } else {
          value = page.size.height - _location.y;
        }
        _array.add(PdfName(PdfDictionaryProperties.fitH));
        _array.add(PdfNumber(value));
        break;
    }
    _helper.element = _array;
  }

  PdfPoint _pointToNativePdf(PdfPage page, PdfPoint point) {
    return PdfSectionHelper.getHelper(PdfPageHelper.getHelper(page).section!)
        .pointToNativePdf(page, point);
  }
}

/// [PdfDestination] helper
class PdfDestinationHelper {
  /// internal constructor
  PdfDestinationHelper(this.destination);

  /// internal field
  late PdfDestination destination;

  /// internal method
  static PdfDestinationHelper getHelper(PdfDestination destination) {
    return destination._helper;
  }

  /// internal method
  static PdfDestination getDestination(PdfPage page, PdfRectangle rect) {
    return PdfDestination._(page, rect);
  }

  /// internal field
  IPdfPrimitive? element;
}
