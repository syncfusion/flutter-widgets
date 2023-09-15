import 'dart:ui';

import '../drawing/drawing.dart';
import '../graphics/pdf_margins.dart';
import 'enum.dart';

/// The class provides various setting related with PDF pages.
class PdfPageSettings {
  //Constructor
  /// Initalizes the [PdfPageSettings] class.
  ///
  /// ```dart
  /// //Create a PDF document.
  /// PdfDocument document = PdfDocument();
  /// //Create a PDF page settings.
  /// document.pageSettings =
  ///     PdfPageSettings(PdfPageSize.a4, PdfPageOrientation.portrait);
  /// //Set margins.
  /// document.pageSettings.margins.all = 50;
  /// //Create page and draw text.
  /// document.pages.add().graphics.drawString(
  ///     'Hello World!', PdfStandardFont(PdfFontFamily.helvetica, 12),
  ///     brush: PdfBrushes.black, bounds: Rect.fromLTWH(0, 0, 0, 0));
  /// //Save and dispose document.
  /// List<int> bytes = await document.save();
  /// document.dispose();
  /// ```
  PdfPageSettings([Size? size, PdfPageOrientation? orientation]) {
    _helper = PdfPageSettingsHelper(this);
    if (size != null) {
      _size = PdfSize.fromSize(size);
    }
    if (orientation != null) {
      _orientation = orientation;
      _updateSize(orientation);
    }
    _helper.origin = PdfPoint(0, 0);
    _margins = PdfMargins();
  }

  //Fields
  late PdfPageSettingsHelper _helper;
  late PdfMargins _margins;
  PdfPageOrientation _orientation = PdfPageOrientation.portrait;
  PdfSize _size = PdfSize.fromSize(PdfPageSize.a4);
  PdfPageRotateAngle _rotateAngle = PdfPageRotateAngle.rotateAngle0;

  //Properties
  /// Gets or sets the margins of the PDF page.
  ///
  /// ```dart
  /// //Create a PDF document.
  /// PdfDocument document = PdfDocument();
  /// //Set margins.
  /// document.pageSettings.margins.all = 50;
  /// //Create page and draw text.
  /// document.pages.add().graphics.drawString(
  ///     'Hello World!', PdfStandardFont(PdfFontFamily.helvetica, 12),
  ///     brush: PdfBrushes.black, bounds: Rect.fromLTWH(0, 0, 0, 0));
  /// //Save and dispose document.
  /// List<int> bytes = await document.save();
  /// document.dispose();
  /// ```
  PdfMargins get margins => _margins;
  set margins(PdfMargins value) {
    if (!PdfMarginsHelper.getHelper(_margins).equals(value) &&
        !_helper.isPageAdded) {
      _margins = value;
    }
  }

  /// Gets the width of the page.
  ///
  /// ```dart
  /// //Create a PDF document.
  /// PdfDocument document = PdfDocument();
  /// //Get page width.
  /// double width = document.pageSettings.width;
  /// //Get page height.
  /// double height = document.pageSettings.height;
  /// //Create page and draw text.
  /// document.pages.add().graphics.drawString(
  ///     'Hello World!', PdfStandardFont(PdfFontFamily.helvetica, 12),
  ///     brush: PdfBrushes.black, bounds: Rect.fromLTWH(0, 0, width, height));
  /// //Save and dispose document.
  /// List<int> bytes = await document.save();
  /// document.dispose();
  /// ```
  double get width => _size.width;

  /// Gets the height of the page.
  ///
  /// ```dart
  /// //Create a PDF document.
  /// PdfDocument document = PdfDocument();
  /// //Get page width.
  /// double width = document.pageSettings.width;
  /// //Get page height.
  /// double height = document.pageSettings.height;
  /// //Create page and draw text.
  /// document.pages.add().graphics.drawString(
  ///     'Hello World!', PdfStandardFont(PdfFontFamily.helvetica, 12),
  ///     brush: PdfBrushes.black, bounds: Rect.fromLTWH(0, 0, width, height));
  /// //Save and dispose document.
  /// List<int> bytes = await document.save();
  /// document.dispose();
  /// ```
  double get height => _size.height;

  /// Gets the page orientation.
  ///
  /// ```dart
  /// //Create a PDF document.
  /// PdfDocument document = PdfDocument();
  /// //Get the page orientation.
  /// PdfPageOrientation orientation = document.pageSettings.orientation;
  /// //Create page and draw text.
  /// document.pages.add().graphics.drawString(
  ///     'Hello World!', PdfStandardFont(PdfFontFamily.helvetica, 12),
  ///     brush: PdfBrushes.black, bounds: Rect.fromLTWH.(0, 0, 0, 0));
  /// //Save and dispose document.
  /// List<int> bytes = await document.save();
  /// document.dispose();
  /// ```
  PdfPageOrientation get orientation => _orientation;

  /// Sets the page orientation.
  ///
  /// ```dart
  /// //Create a PDF document.
  /// PdfDocument document = PdfDocument();
  /// //Set the page orientation.
  /// document.pageSettings.orientation = PdfPageOrientation.landscape;
  /// //Create page and draw text.
  /// document.pages.add().graphics.drawString(
  ///     'Hello World!', PdfStandardFont(PdfFontFamily.helvetica, 12),
  ///     brush: PdfBrushes.black, bounds: Rect.fromLTWH(0, 0, 0, 0));
  /// //Save and dispose document.
  /// List<int> bytes = await document.save();
  /// document.dispose();
  /// ```
  set orientation(PdfPageOrientation value) {
    if (value != _orientation && !_helper.isPageAdded) {
      _orientation = value;
      _updateSize(_orientation);
    }
  }

  /// Gets the size fo the page.
  ///
  /// ```dart
  /// //Create a PDF document.
  /// PdfDocument document = PdfDocument();
  /// //Get the page size.
  /// Size pageSize = document.pageSettings.size;
  /// //Create page and draw text.
  /// document.pages.add().graphics.drawString(
  ///     'Hello World!', PdfStandardFont(PdfFontFamily.helvetica, 12),
  ///     brush: PdfBrushes.black, bounds: Rect.fromLTWH(0, 0, 0, 0));
  /// //Save and dispose document.
  /// List<int> bytes = await document.save();
  /// document.dispose();
  /// ```
  Size get size => _size.size;

  /// Sets the page size.
  ///
  /// ```dart
  /// //Create a PDF document.
  /// PdfDocument document = PdfDocument();
  /// //Set the page size.
  /// document.pageSettings.size = Size(595, 842);
  /// //Create page and draw text.
  /// document.pages.add().graphics.drawString(
  ///     'Hello World!', PdfStandardFont(PdfFontFamily.helvetica, 12),
  ///     brush: PdfBrushes.black, bounds: Rect.fromLTWH(0, 0, 0, 0));
  /// //Save and dispose document.
  /// List<int> bytes = await document.save();
  /// document.dispose();
  /// ```
  set size(Size value) {
    if (!_helper.isPageAdded) {
      _updateSize(_orientation, value);
    }
  }

  /// Gets the number of degrees by which the page should be rotated clockwise
  /// when displayed or printed.
  ///
  /// ```dart
  /// //Create a PDF document.
  /// PdfDocument document = PdfDocument();
  /// //Get the rotate angle.
  /// PdfPageRotateAngle angle = document.pageSettings.rotate;
  /// //Set the rotation angle.
  /// document.pageSettings.rotate = PdfPageRotateAngle.rotateAngle90;
  /// //Create page and draw text.
  /// document.pages.add().graphics.drawString(
  ///     'Hello World!', PdfStandardFont(PdfFontFamily.helvetica, 12),
  ///     brush: PdfBrushes.black, bounds: Rect.fromLTWH(0, 0, 0, 0));
  /// //Save and dispose document.
  /// List<int> bytes = await document.save();
  /// document.dispose();
  /// ```
  PdfPageRotateAngle get rotate => _rotateAngle;

  /// Sets the number of degrees by which the page should be rotated clockwise
  /// when displayed or printed.
  ///
  ///```dart
  /// //Create a PDF document.
  /// PdfDocument document = PdfDocument();
  /// //Get the rotate angle.
  /// PdfPageRotateAngle angle = document.pageSettings.rotate;
  /// //Set the rotation angle.
  /// document.pageSettings.rotate = PdfPageRotateAngle.rotateAngle90;
  /// //Create page and draw text.
  /// document.pages.add().graphics.drawString(
  ///     'Hello World!', PdfStandardFont(PdfFontFamily.helvetica, 12),
  ///     brush: PdfBrushes.black, bounds: Rect.fromLTWH(0, 0, 0, 0));
  /// //Save and dispose document.
  /// List<int> bytes = await document.save();
  /// document.dispose();
  /// ```
  set rotate(PdfPageRotateAngle value) {
    if (!_helper.isPageAdded) {
      _rotateAngle = value;
      _helper.isRotation = true;
    }
  }

  //Public methods
  /// Sets the margins.
  ///
  /// ```dart
  /// //Create a PDF document.
  /// PdfDocument document = PdfDocument();
  /// //Set margins.
  /// document.pageSettings.setMargins(50);
  /// //Create page and draw text.
  /// document.pages.add().graphics.drawString(
  ///     'Hello World!', PdfStandardFont(PdfFontFamily.helvetica, 12),
  ///     brush: PdfBrushes.black, bounds: Rect.fromLTWH(0, 0, 0, 0));
  /// //Save and dispose document.
  /// List<int> bytes = await document.save();
  /// document.dispose();
  /// ```
  void setMargins(double all, [double? top, double? right, double? bottom]) {
    if (!_helper.isPageAdded) {
      if (top != null && right != null && bottom != null) {
        PdfMarginsHelper.getHelper(margins)
            .setMarginsAll(all, top, right, bottom);
      } else if (top != null && right == null) {
        PdfMarginsHelper.getHelper(margins).setMarginsLT(all, top);
      } else if (top == null && bottom != null) {
        PdfMarginsHelper.getHelper(margins).setMarginsLT(all, bottom);
      } else {
        PdfMarginsHelper.getHelper(margins).setMargins(all);
      }
    }
  }

  //Implementation
  void _updateSize(PdfPageOrientation orientation, [Size? size]) {
    double min;
    double max;
    if (size != null) {
      min = size.width < size.height ? size.width : size.height;
      max = size.width > size.height ? size.width : size.height;
    } else {
      min = width < height ? width : height;
      max = width > height ? width : height;
    }
    switch (orientation) {
      case PdfPageOrientation.portrait:
        _size = PdfSize(min, max);
        break;

      case PdfPageOrientation.landscape:
        _size = PdfSize(max, min);
        break;
    }
  }
}

/// [PdfPageSettings] helper
class PdfPageSettingsHelper {
  /// internal constructor
  PdfPageSettingsHelper(this.base);

  /// internal field
  late PdfPageSettings base;

  /// internal method
  static PdfPageSettingsHelper getHelper(PdfPageSettings base) {
    return base._helper;
  }

  /// internal field
  late PdfPoint origin;

  /// internal method
  bool isRotation = false;

  /// internal method
  // ignore: prefer_final_fields
  bool isPageAdded = false;

  /// internal method
  Size getActualSize() {
    return Size(base.width - (base.margins.left + base.margins.right),
        base.height - (base.margins.top + base.margins.bottom));
  }

  /// internal method
  PdfPageSettings clone() {
    final PdfPageSettings result = PdfPageSettings();
    result.size = Size(base.size.width, base.size.height);
    switch (base.rotate) {
      case PdfPageRotateAngle.rotateAngle90:
        result.rotate = PdfPageRotateAngle.rotateAngle90;
        break;
      case PdfPageRotateAngle.rotateAngle180:
        result.rotate = PdfPageRotateAngle.rotateAngle180;
        break;
      case PdfPageRotateAngle.rotateAngle270:
        result.rotate = PdfPageRotateAngle.rotateAngle270;
        break;
      case PdfPageRotateAngle.rotateAngle0:
        result.rotate = PdfPageRotateAngle.rotateAngle0;
        break;
    }
    if (base.orientation == PdfPageOrientation.landscape) {
      result.orientation = PdfPageOrientation.landscape;
    } else {
      result.orientation = PdfPageOrientation.portrait;
    }
    result.margins = PdfMarginsHelper.getHelper(base.margins).clone();
    return result;
  }
}

/// Represents information about various predefined page sizes.
class PdfPageSize {
  PdfPageSize._();

  /// Letter format.
  static const Size letter = Size(612, 792);

  /// Note format.
  static const Size note = Size(540, 720);

  /// Legal format.
  static const Size legal = Size(612, 1008);

  /// A0 format.
  static const Size a0 = Size(2380, 3368);

  /// A1 format.
  static const Size a1 = Size(1684, 2380);

  /// A2 format.
  static const Size a2 = Size(1190, 1684);

  /// A3 format.
  static const Size a3 = Size(842, 1190);

  /// A4 format.
  static const Size a4 = Size(595, 842);

  /// A5 format.
  static const Size a5 = Size(421, 595);

  /// A6 format.
  static const Size a6 = Size(297, 421);

  /// A7 format.
  static const Size a7 = Size(210, 297);

  /// A8 format.
  static const Size a8 = Size(148, 210);

  /// A9 format.
  static const Size a9 = Size(105, 148);

  /// A10 format.
  static const Size a10 = Size(74, 105);

  /// B0 format.
  static const Size b0 = Size(2836, 4008);

  /// B1 format.
  static const Size b1 = Size(2004, 2836);

  /// B2 format.
  static const Size b2 = Size(1418, 2004);

  /// B3 format.
  static const Size b3 = Size(1002, 1418);

  /// B4 format.
  static const Size b4 = Size(709, 1002);

  /// B5 format.
  static const Size b5 = Size(501, 709);

  /// ArchE format.
  static const Size archE = Size(2592, 3456);

  /// ArchD format.
  static const Size archD = Size(1728, 2592);

  /// ArchC format.
  static const Size archC = Size(1296, 1728);

  /// ArchB format.
  static const Size archB = Size(864, 1296);

  /// ArchA format.
  static const Size archA = Size(648, 864);

  /// The American Foolscap format.
  static const Size flsa = Size(612, 936);

  /// HalfLetter format.
  static const Size halfLetter = Size(396, 612);

  /// 11x17 format.
  static const Size letter11x17 = Size(792, 1224);

  /// Ledger format.
  static const Size ledger = Size(1224, 792);
}
