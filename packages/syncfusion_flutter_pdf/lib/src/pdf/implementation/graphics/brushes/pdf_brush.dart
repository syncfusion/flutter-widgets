part of pdf;

/// Provides objects used to fill the interiors of graphical shapes
/// such as rectangles, ellipses, pies, polygons, and paths.
///
/// ```dart
/// //Create a new PDF document.
/// PdfDocument doc = PdfDocument();
/// //Create a new PDF solid brush.
/// PdfBrush solidBrush = PdfSolidBrush(PdfColor(1, 0, 0));
/// //Add a page and draw a rectangle using the brush.
/// doc.pages
///     .add()
///     .graphics
///     .drawRectangle(brush: solidBrush,
///     bounds: Rect.fromLTWH(0, 0, 200, 100));
/// //Save the document.
/// List<int> bytes = doc.save();
/// //Dispose the document.
/// doc.dispose();
/// ```
abstract class PdfBrush {
  bool _monitorChanges(PdfBrush brush, _PdfStreamWriter streamWriter,
      Function getResources, bool saveChanges, PdfColorSpace currentColorSpace);
  void _resetChanges(_PdfStreamWriter streamWriter);
}

/// Brushes for all the standard colors.
///
/// ```dart
/// //Create a new PDF document.
/// PdfDocument doc = PdfDocument();
/// //Draw rectangle.
/// doc.pages.add().graphics.drawRectangle(
///     brush: PdfBrushes.black, bounds: Rect.fromLTWH(0, 0, 200, 100));
/// //Save the document.
/// List<int> bytes = doc.save();
/// //Dispose the document.
/// doc.dispose();
/// ```
class PdfBrushes {
  PdfBrushes._();
  static final Map<_KnownColor, PdfBrush> _brushes = <_KnownColor, PdfBrush>{};

  /// Gets the AliceBlue brush.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages.add().graphics.drawRectangle(
  ///     brush: PdfBrushes.aliceBlue, bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfBrush get aliceBlue {
    if (_brushes.containsKey(_KnownColor.aliceBlue)) {
      return _brushes[_KnownColor.aliceBlue];
    } else {
      return _getBrush(_KnownColor.aliceBlue);
    }
  }

  /// Gets the Antique white brush.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages.add().graphics.drawRectangle(
  ///     brush: PdfBrushes.antiqueWhite,
  ///     bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfBrush get antiqueWhite {
    if (_brushes.containsKey(_KnownColor.antiqueWhite)) {
      return _brushes[_KnownColor.antiqueWhite];
    } else {
      return _getBrush(_KnownColor.antiqueWhite);
    }
  }

  /// Gets the Aqua default brush.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages.add().graphics.drawRectangle(
  ///     brush: PdfBrushes.aqua, bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfBrush get aqua {
    if (_brushes.containsKey(_KnownColor.aqua)) {
      return _brushes[_KnownColor.aqua];
    } else {
      return _getBrush(_KnownColor.aqua);
    }
  }

  /// Gets the Aquamarine default brush.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages.add().graphics.drawRectangle(
  ///     brush: PdfBrushes.aquamarine, bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfBrush get aquamarine {
    if (_brushes.containsKey(_KnownColor.aquamarine)) {
      return _brushes[_KnownColor.aquamarine];
    } else {
      return _getBrush(_KnownColor.aquamarine);
    }
  }

  /// Gets the Azure default brush.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages.add().graphics.drawRectangle(
  ///     brush: PdfBrushes.azure, bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfBrush get azure {
    if (_brushes.containsKey(_KnownColor.azure)) {
      return _brushes[_KnownColor.azure];
    } else {
      return _getBrush(_KnownColor.azure);
    }
  }

  /// Gets the Beige default brush.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages.add().graphics.drawRectangle(
  ///     brush: PdfBrushes.beige, bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfBrush get beige {
    if (_brushes.containsKey(_KnownColor.beige)) {
      return _brushes[_KnownColor.beige];
    } else {
      return _getBrush(_KnownColor.beige);
    }
  }

  /// Gets the Bisque default brush.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages.add().graphics.drawRectangle(
  ///     brush: PdfBrushes.bisque, bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfBrush get bisque {
    if (_brushes.containsKey(_KnownColor.bisque)) {
      return _brushes[_KnownColor.bisque];
    } else {
      return _getBrush(_KnownColor.bisque);
    }
  }

  /// Gets the Black default brush.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages.add().graphics.drawRectangle(
  ///     brush: PdfBrushes.black, bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfBrush get black {
    if (_brushes.containsKey(_KnownColor.black)) {
      return _brushes[_KnownColor.black];
    } else {
      return _getBrush(_KnownColor.black);
    }
  }

  /// Gets the BlanchedAlmond default brush.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages.add().graphics.drawRectangle(
  ///     brush: PdfBrushes.blanchedAlmond,
  ///     bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfBrush get blanchedAlmond {
    if (_brushes.containsKey(_KnownColor.blanchedAlmond)) {
      return _brushes[_KnownColor.blanchedAlmond];
    } else {
      return _getBrush(_KnownColor.blanchedAlmond);
    }
  }

  /// Gets the Blue default brush.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages.add().graphics.drawRectangle(
  ///     brush: PdfBrushes.blue, bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfBrush get blue {
    if (_brushes.containsKey(_KnownColor.blue)) {
      return _brushes[_KnownColor.blue];
    } else {
      return _getBrush(_KnownColor.blue);
    }
  }

  /// Gets the BlueViolet default brush.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages.add().graphics.drawRectangle(
  ///     brush: PdfBrushes.blueViolet, bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfBrush get blueViolet {
    if (_brushes.containsKey(_KnownColor.blueViolet)) {
      return _brushes[_KnownColor.blueViolet];
    } else {
      return _getBrush(_KnownColor.blueViolet);
    }
  }

  /// Gets the Brown default brush.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages.add().graphics.drawRectangle(
  ///     brush: PdfBrushes.brown, bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfBrush get brown {
    if (_brushes.containsKey(_KnownColor.brown)) {
      return _brushes[_KnownColor.brown];
    } else {
      return _getBrush(_KnownColor.brown);
    }
  }

  /// Gets the BurlyWood default brush.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages.add().graphics.drawRectangle(
  ///     brush: PdfBrushes.burlyWood, bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfBrush get burlyWood {
    if (_brushes.containsKey(_KnownColor.burlyWood)) {
      return _brushes[_KnownColor.burlyWood];
    } else {
      return _getBrush(_KnownColor.burlyWood);
    }
  }

  /// Gets the CadetBlue default brush.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages.add().graphics.drawRectangle(
  ///     brush: PdfBrushes.cadetBlue, bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfBrush get cadetBlue {
    if (_brushes.containsKey(_KnownColor.cadetBlue)) {
      return _brushes[_KnownColor.cadetBlue];
    } else {
      return _getBrush(_KnownColor.cadetBlue);
    }
  }

  /// Gets the Chartreuse default brush.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages.add().graphics.drawRectangle(
  ///     brush: PdfBrushes.chartreuse, bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfBrush get chartreuse {
    if (_brushes.containsKey(_KnownColor.chartreuse)) {
      return _brushes[_KnownColor.chartreuse];
    } else {
      return _getBrush(_KnownColor.chartreuse);
    }
  }

  /// Gets the Chocolate default brush.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages.add().graphics.drawRectangle(
  ///     brush: PdfBrushes.chocolate, bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfBrush get chocolate {
    if (_brushes.containsKey(_KnownColor.chocolate)) {
      return _brushes[_KnownColor.chocolate];
    } else {
      return _getBrush(_KnownColor.chocolate);
    }
  }

  /// Gets the Coral default brush.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages.add().graphics.drawRectangle(
  ///     brush: PdfBrushes.coral, bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfBrush get coral {
    if (_brushes.containsKey(_KnownColor.coral)) {
      return _brushes[_KnownColor.coral];
    } else {
      return _getBrush(_KnownColor.coral);
    }
  }

  /// Gets the CornflowerBlue default brush.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages.add().graphics.drawRectangle(
  ///     brush: PdfBrushes.cornflowerBlue,
  ///     bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfBrush get cornflowerBlue {
    if (_brushes.containsKey(_KnownColor.cornflowerBlue)) {
      return _brushes[_KnownColor.cornflowerBlue];
    } else {
      return _getBrush(_KnownColor.cornflowerBlue);
    }
  }

  /// Gets the Corn silk default brush.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages.add().graphics.drawRectangle(
  ///     brush: PdfBrushes.cornsilk, bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfBrush get cornsilk {
    if (_brushes.containsKey(_KnownColor.cornsilk)) {
      return _brushes[_KnownColor.cornsilk];
    } else {
      return _getBrush(_KnownColor.cornsilk);
    }
  }

  /// Gets the Crimson default brush.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages.add().graphics.drawRectangle(
  ///     brush: PdfBrushes.crimson, bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfBrush get crimson {
    if (_brushes.containsKey(_KnownColor.crimson)) {
      return _brushes[_KnownColor.crimson];
    } else {
      return _getBrush(_KnownColor.crimson);
    }
  }

  /// Gets the Cyan default brush.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages.add().graphics.drawRectangle(
  ///     brush: PdfBrushes.cyan, bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfBrush get cyan {
    if (_brushes.containsKey(_KnownColor.cyan)) {
      return _brushes[_KnownColor.cyan];
    } else {
      return _getBrush(_KnownColor.cyan);
    }
  }

  /// Gets the DarkBlue default brush.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages.add().graphics.drawRectangle(
  ///     brush: PdfBrushes.darkBlue, bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfBrush get darkBlue {
    if (_brushes.containsKey(_KnownColor.darkBlue)) {
      return _brushes[_KnownColor.darkBlue];
    } else {
      return _getBrush(_KnownColor.darkBlue);
    }
  }

  /// Gets the DarkCyan default brush.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages.add().graphics.drawRectangle(
  ///     brush: PdfBrushes.darkCyan, bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfBrush get darkCyan {
    if (_brushes.containsKey(_KnownColor.darkCyan)) {
      return _brushes[_KnownColor.darkCyan];
    } else {
      return _getBrush(_KnownColor.darkCyan);
    }
  }

  /// Gets the DarkGoldenrod default brush.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages.add().graphics.drawRectangle(
  ///     brush: PdfBrushes.darkGoldenrod,
  ///     bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfBrush get darkGoldenrod {
    if (_brushes.containsKey(_KnownColor.darkGoldenrod)) {
      return _brushes[_KnownColor.darkGoldenrod];
    } else {
      return _getBrush(_KnownColor.darkGoldenrod);
    }
  }

  /// Gets the DarkGray default brush.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages.add().graphics.drawRectangle(
  ///     brush: PdfBrushes.darkGray, bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfBrush get darkGray {
    if (_brushes.containsKey(_KnownColor.darkGray)) {
      return _brushes[_KnownColor.darkGray];
    } else {
      return _getBrush(_KnownColor.darkGray);
    }
  }

  /// Gets the DarkGreen default brush.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages.add().graphics.drawRectangle(
  ///     brush: PdfBrushes.darkGreen, bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfBrush get darkGreen {
    if (_brushes.containsKey(_KnownColor.darkGreen)) {
      return _brushes[_KnownColor.darkGreen];
    } else {
      return _getBrush(_KnownColor.darkGreen);
    }
  }

  /// Gets the DarkKhaki default brush.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages.add().graphics.drawRectangle(
  ///     brush: PdfBrushes.darkKhaki, bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfBrush get darkKhaki {
    if (_brushes.containsKey(_KnownColor.darkKhaki)) {
      return _brushes[_KnownColor.darkKhaki];
    } else {
      return _getBrush(_KnownColor.darkKhaki);
    }
  }

  /// Gets the DarkMagenta default brush.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages.add().graphics.drawRectangle(
  ///     brush: PdfBrushes.darkMagenta, bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfBrush get darkMagenta {
    if (_brushes.containsKey(_KnownColor.darkMagenta)) {
      return _brushes[_KnownColor.darkMagenta];
    } else {
      return _getBrush(_KnownColor.darkMagenta);
    }
  }

  /// Gets the DarkOliveGreen default brush.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages.add().graphics.drawRectangle(
  ///     brush: PdfBrushes.darkOliveGreen,
  ///     bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfBrush get darkOliveGreen {
    if (_brushes.containsKey(_KnownColor.darkOliveGreen)) {
      return _brushes[_KnownColor.darkOliveGreen];
    } else {
      return _getBrush(_KnownColor.darkOliveGreen);
    }
  }

  /// Gets the DarkOrange default brush.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages.add().graphics.drawRectangle(
  ///     brush: PdfBrushes.darkOrange, bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfBrush get darkOrange {
    if (_brushes.containsKey(_KnownColor.darkOrange)) {
      return _brushes[_KnownColor.darkOrange];
    } else {
      return _getBrush(_KnownColor.darkOrange);
    }
  }

  /// Gets the DarkOrchid default brush.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages.add().graphics.drawRectangle(
  ///     brush: PdfBrushes.darkOrchid, bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfBrush get darkOrchid {
    if (_brushes.containsKey(_KnownColor.darkOrchid)) {
      return _brushes[_KnownColor.darkOrchid];
    } else {
      return _getBrush(_KnownColor.darkOrchid);
    }
  }

  /// Gets the DarkRed default brush.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages.add().graphics.drawRectangle(
  ///     brush: PdfBrushes.darkRed, bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfBrush get darkRed {
    if (_brushes.containsKey(_KnownColor.darkRed)) {
      return _brushes[_KnownColor.darkRed];
    } else {
      return _getBrush(_KnownColor.darkRed);
    }
  }

  /// Gets the DarkSalmon default brush.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages.add().graphics.drawRectangle(
  ///     brush: PdfBrushes.darkSalmon, bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfBrush get darkSalmon {
    if (_brushes.containsKey(_KnownColor.darkSalmon)) {
      return _brushes[_KnownColor.darkSalmon];
    } else {
      return _getBrush(_KnownColor.darkSalmon);
    }
  }

  /// Gets the DarkSeaGreen default brush.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages.add().graphics.drawRectangle(
  ///     brush: PdfBrushes.darkSeaGreen,
  ///     bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfBrush get darkSeaGreen {
    if (_brushes.containsKey(_KnownColor.darkSeaGreen)) {
      return _brushes[_KnownColor.darkSeaGreen];
    } else {
      return _getBrush(_KnownColor.darkSeaGreen);
    }
  }

  /// Gets the DarkSlateBlue default brush.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages.add().graphics.drawRectangle(
  ///     brush: PdfBrushes.darkSlateBlue,
  ///     bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfBrush get darkSlateBlue {
    if (_brushes.containsKey(_KnownColor.darkSlateBlue)) {
      return _brushes[_KnownColor.darkSlateBlue];
    } else {
      return _getBrush(_KnownColor.darkSlateBlue);
    }
  }

  /// Gets the DarkSlateGray default brush.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages.add().graphics.drawRectangle(
  ///     brush: PdfBrushes.darkSlateGray,
  ///     bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfBrush get darkSlateGray {
    if (_brushes.containsKey(_KnownColor.darkSlateGray)) {
      return _brushes[_KnownColor.darkSlateGray];
    } else {
      return _getBrush(_KnownColor.darkSlateGray);
    }
  }

  /// Gets the DarkTurquoise default brush.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages.add().graphics.drawRectangle(
  ///     brush: PdfBrushes.darkTurquoise,
  ///     bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfBrush get darkTurquoise {
    if (_brushes.containsKey(_KnownColor.darkTurquoise)) {
      return _brushes[_KnownColor.darkTurquoise];
    } else {
      return _getBrush(_KnownColor.darkTurquoise);
    }
  }

  /// Gets the DarkViolet default brush.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages.add().graphics.drawRectangle(
  ///     brush: PdfBrushes.darkViolet, bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfBrush get darkViolet {
    if (_brushes.containsKey(_KnownColor.darkViolet)) {
      return _brushes[_KnownColor.darkViolet];
    } else {
      return _getBrush(_KnownColor.darkViolet);
    }
  }

  /// Gets the DeepPink default brush.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages.add().graphics.drawRectangle(
  ///     brush: PdfBrushes.deepPink, bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfBrush get deepPink {
    if (_brushes.containsKey(_KnownColor.deepPink)) {
      return _brushes[_KnownColor.deepPink];
    } else {
      return _getBrush(_KnownColor.deepPink);
    }
  }

  /// Gets the DeepSkyBlue default brush.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages.add().graphics.drawRectangle(
  ///     brush: PdfBrushes.deepSkyBlue, bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfBrush get deepSkyBlue {
    if (_brushes.containsKey(_KnownColor.deepSkyBlue)) {
      return _brushes[_KnownColor.deepSkyBlue];
    } else {
      return _getBrush(_KnownColor.deepSkyBlue);
    }
  }

  /// Gets the DimGray default brush.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages.add().graphics.drawRectangle(
  ///     brush: PdfBrushes.dimGray, bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfBrush get dimGray {
    if (_brushes.containsKey(_KnownColor.dimGray)) {
      return _brushes[_KnownColor.dimGray];
    } else {
      return _getBrush(_KnownColor.dimGray);
    }
  }

  /// Gets the DodgerBlue default brush.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages.add().graphics.drawRectangle(
  ///     brush: PdfBrushes.dodgerBlue, bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfBrush get dodgerBlue {
    if (_brushes.containsKey(_KnownColor.dodgerBlue)) {
      return _brushes[_KnownColor.dodgerBlue];
    } else {
      return _getBrush(_KnownColor.dodgerBlue);
    }
  }

  /// Gets the Firebrick default brush.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages.add().graphics.drawRectangle(
  ///     brush: PdfBrushes.firebrick, bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfBrush get firebrick {
    if (_brushes.containsKey(_KnownColor.firebrick)) {
      return _brushes[_KnownColor.firebrick];
    } else {
      return _getBrush(_KnownColor.firebrick);
    }
  }

  /// Gets the FloralWhite default brush.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages.add().graphics.drawRectangle(
  ///     brush: PdfBrushes.floralWhite, bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfBrush get floralWhite {
    if (_brushes.containsKey(_KnownColor.floralWhite)) {
      return _brushes[_KnownColor.floralWhite];
    } else {
      return _getBrush(_KnownColor.floralWhite);
    }
  }

  /// Gets the ForestGreen default brush.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages.add().graphics.drawRectangle(
  ///     brush: PdfBrushes.forestGreen, bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfBrush get forestGreen {
    if (_brushes.containsKey(_KnownColor.forestGreen)) {
      return _brushes[_KnownColor.forestGreen];
    } else {
      return _getBrush(_KnownColor.forestGreen);
    }
  }

  /// Gets the Fuchsia default brush.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages.add().graphics.drawRectangle(
  ///     brush: PdfBrushes.fuchsia, bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfBrush get fuchsia {
    if (_brushes.containsKey(_KnownColor.fuchsia)) {
      return _brushes[_KnownColor.fuchsia];
    } else {
      return _getBrush(_KnownColor.fuchsia);
    }
  }

  /// Gets the Gainsborough default brush.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages.add().graphics.drawRectangle(
  ///     brush: PdfBrushes.gainsboro, bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfBrush get gainsboro {
    if (_brushes.containsKey(_KnownColor.gainsboro)) {
      return _brushes[_KnownColor.gainsboro];
    } else {
      return _getBrush(_KnownColor.gainsboro);
    }
  }

  /// Gets the GhostWhite default brush.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages.add().graphics.drawRectangle(
  ///     brush: PdfBrushes.ghostWhite, bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfBrush get ghostWhite {
    if (_brushes.containsKey(_KnownColor.ghostWhite)) {
      return _brushes[_KnownColor.ghostWhite];
    } else {
      return _getBrush(_KnownColor.ghostWhite);
    }
  }

  /// Gets the Gold default brush.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages.add().graphics.drawRectangle(
  ///     brush: PdfBrushes.gold, bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfBrush get gold {
    if (_brushes.containsKey(_KnownColor.gold)) {
      return _brushes[_KnownColor.gold];
    } else {
      return _getBrush(_KnownColor.gold);
    }
  }

  /// Gets the Goldenrod default brush.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages.add().graphics.drawRectangle(
  ///     brush: PdfBrushes.goldenrod, bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfBrush get goldenrod {
    if (_brushes.containsKey(_KnownColor.goldenrod)) {
      return _brushes[_KnownColor.goldenrod];
    } else {
      return _getBrush(_KnownColor.goldenrod);
    }
  }

  /// Gets the Gray default brush.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages.add().graphics.drawRectangle(
  ///     brush: PdfBrushes.gray, bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfBrush get gray {
    if (_brushes.containsKey(_KnownColor.gray)) {
      return _brushes[_KnownColor.gray];
    } else {
      return _getBrush(_KnownColor.gray);
    }
  }

  /// Gets the Green default brush.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages.add().graphics.drawRectangle(
  ///     brush: PdfBrushes.green, bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfBrush get green {
    if (_brushes.containsKey(_KnownColor.green)) {
      return _brushes[_KnownColor.green];
    } else {
      return _getBrush(_KnownColor.green);
    }
  }

  /// Gets the GreenYellow default brush.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages.add().graphics.drawRectangle(
  ///     brush: PdfBrushes.greenYellow, bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfBrush get greenYellow {
    if (_brushes.containsKey(_KnownColor.greenYellow)) {
      return _brushes[_KnownColor.greenYellow];
    } else {
      return _getBrush(_KnownColor.greenYellow);
    }
  }

  /// Gets the Honeydew default brush.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages.add().graphics.drawRectangle(
  ///     brush: PdfBrushes.honeydew, bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfBrush get honeydew {
    if (_brushes.containsKey(_KnownColor.honeydew)) {
      return _brushes[_KnownColor.honeydew];
    } else {
      return _getBrush(_KnownColor.honeydew);
    }
  }

  /// Gets the HotPink default brush.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages.add().graphics.drawRectangle(
  ///     brush: PdfBrushes.hotPink, bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfBrush get hotPink {
    if (_brushes.containsKey(_KnownColor.hotPink)) {
      return _brushes[_KnownColor.hotPink];
    } else {
      return _getBrush(_KnownColor.hotPink);
    }
  }

  /// Gets the IndianRed default brush.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages.add().graphics.drawRectangle(
  ///     brush: PdfBrushes.indianRed, bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfBrush get indianRed {
    if (_brushes.containsKey(_KnownColor.indianRed)) {
      return _brushes[_KnownColor.indianRed];
    } else {
      return _getBrush(_KnownColor.indianRed);
    }
  }

  /// Gets the Indigo default brush.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages.add().graphics.drawRectangle(
  ///     brush: PdfBrushes.indigo, bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfBrush get indigo {
    if (_brushes.containsKey(_KnownColor.indigo)) {
      return _brushes[_KnownColor.indigo];
    } else {
      return _getBrush(_KnownColor.indigo);
    }
  }

  /// Gets the Ivory default brush.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages.add().graphics.drawRectangle(
  ///     brush: PdfBrushes.ivory, bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfBrush get ivory {
    if (_brushes.containsKey(_KnownColor.ivory)) {
      return _brushes[_KnownColor.ivory];
    } else {
      return _getBrush(_KnownColor.ivory);
    }
  }

  /// Gets the Khaki default brush.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages.add().graphics.drawRectangle(
  ///     brush: PdfBrushes.khaki, bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfBrush get khaki {
    if (_brushes.containsKey(_KnownColor.khaki)) {
      return _brushes[_KnownColor.khaki];
    } else {
      return _getBrush(_KnownColor.khaki);
    }
  }

  /// Gets the Lavender default brush.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages.add().graphics.drawRectangle(
  ///     brush: PdfBrushes.lavender, bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfBrush get lavender {
    if (_brushes.containsKey(_KnownColor.lavender)) {
      return _brushes[_KnownColor.lavender];
    } else {
      return _getBrush(_KnownColor.lavender);
    }
  }

  /// Gets the LavenderBlush default brush.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages.add().graphics.drawRectangle(
  ///     brush: PdfBrushes.lavenderBlush,
  ///     bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfBrush get lavenderBlush {
    if (_brushes.containsKey(_KnownColor.lavenderBlush)) {
      return _brushes[_KnownColor.lavenderBlush];
    } else {
      return _getBrush(_KnownColor.lavenderBlush);
    }
  }

  /// Gets the LawnGreen default brush.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages.add().graphics.drawRectangle(
  ///     brush: PdfBrushes.lawnGreen, bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfBrush get lawnGreen {
    if (_brushes.containsKey(_KnownColor.lawnGreen)) {
      return _brushes[_KnownColor.lawnGreen];
    } else {
      return _getBrush(_KnownColor.lawnGreen);
    }
  }

  /// Gets the LemonChiffon default brush.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages.add().graphics.drawRectangle(
  ///     brush: PdfBrushes.lemonChiffon,
  ///     bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfBrush get lemonChiffon {
    if (_brushes.containsKey(_KnownColor.lemonChiffon)) {
      return _brushes[_KnownColor.lemonChiffon];
    } else {
      return _getBrush(_KnownColor.lemonChiffon);
    }
  }

  /// Gets the LightBlue default brush.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages.add().graphics.drawRectangle(
  ///     brush: PdfBrushes.lightBlue, bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfBrush get lightBlue {
    if (_brushes.containsKey(_KnownColor.lightBlue)) {
      return _brushes[_KnownColor.lightBlue];
    } else {
      return _getBrush(_KnownColor.lightBlue);
    }
  }

  /// Gets the LightCoral default brush.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages.add().graphics.drawRectangle(
  ///     brush: PdfBrushes.lightCoral, bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfBrush get lightCoral {
    if (_brushes.containsKey(_KnownColor.lightCoral)) {
      return _brushes[_KnownColor.lightCoral];
    } else {
      return _getBrush(_KnownColor.lightCoral);
    }
  }

  /// Gets the LightCyan default brush.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages.add().graphics.drawRectangle(
  ///     brush: PdfBrushes.lightCyan, bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfBrush get lightCyan {
    if (_brushes.containsKey(_KnownColor.lightCyan)) {
      return _brushes[_KnownColor.lightCyan];
    } else {
      return _getBrush(_KnownColor.lightCyan);
    }
  }

  /// Gets the LightGoldenrodYellow default brush.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages.add().graphics.drawRectangle(
  ///     brush: PdfBrushes.lightGoldenrodYellow,
  ///     bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfBrush get lightGoldenrodYellow {
    if (_brushes.containsKey(_KnownColor.lightGoldenrodYellow)) {
      return _brushes[_KnownColor.lightGoldenrodYellow];
    } else {
      return _getBrush(_KnownColor.lightGoldenrodYellow);
    }
  }

  /// Gets the LightGray default brush.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages.add().graphics.drawRectangle(
  ///     brush: PdfBrushes.lightGray, bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfBrush get lightGray {
    if (_brushes.containsKey(_KnownColor.lightGray)) {
      return _brushes[_KnownColor.lightGray];
    } else {
      return _getBrush(_KnownColor.lightGray);
    }
  }

  /// Gets the LightGreen default brush.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages.add().graphics.drawRectangle(
  ///     brush: PdfBrushes.lightGreen, bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfBrush get lightGreen {
    if (_brushes.containsKey(_KnownColor.lightGreen)) {
      return _brushes[_KnownColor.lightGreen];
    } else {
      return _getBrush(_KnownColor.lightGreen);
    }
  }

  /// Gets the LightPink default brush.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages.add().graphics.drawRectangle(
  ///     brush: PdfBrushes.lightPink, bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfBrush get lightPink {
    if (_brushes.containsKey(_KnownColor.lightPink)) {
      return _brushes[_KnownColor.lightPink];
    } else {
      return _getBrush(_KnownColor.lightPink);
    }
  }

  /// Gets the LightSalmon default brush.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages.add().graphics.drawRectangle(
  ///     brush: PdfBrushes.lightSalmon, bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfBrush get lightSalmon {
    if (_brushes.containsKey(_KnownColor.lightSalmon)) {
      return _brushes[_KnownColor.lightSalmon];
    } else {
      return _getBrush(_KnownColor.lightSalmon);
    }
  }

  /// Gets the LightSeaGreen default brush.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages.add().graphics.drawRectangle(
  ///     brush: PdfBrushes.lightSeaGreen,
  ///     bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfBrush get lightSeaGreen {
    if (_brushes.containsKey(_KnownColor.lightSeaGreen)) {
      return _brushes[_KnownColor.lightSeaGreen];
    } else {
      return _getBrush(_KnownColor.lightSeaGreen);
    }
  }

  /// Gets the LightSkyBlue default brush.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages.add().graphics.drawRectangle(
  ///     brush: PdfBrushes.lightSkyBlue,
  ///     bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfBrush get lightSkyBlue {
    if (_brushes.containsKey(_KnownColor.lightSkyBlue)) {
      return _brushes[_KnownColor.lightSkyBlue];
    } else {
      return _getBrush(_KnownColor.lightSkyBlue);
    }
  }

  /// Gets the LightSlateGray default brush.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages.add().graphics.drawRectangle(
  ///     brush: PdfBrushes.lightSlateGray,
  ///     bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfBrush get lightSlateGray {
    if (_brushes.containsKey(_KnownColor.lightSlateGray)) {
      return _brushes[_KnownColor.lightSlateGray];
    } else {
      return _getBrush(_KnownColor.lightSlateGray);
    }
  }

  /// Gets the LightSteelBlue default brush.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages.add().graphics.drawRectangle(
  ///     brush: PdfBrushes.lightSteelBlue,
  ///     bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfBrush get lightSteelBlue {
    if (_brushes.containsKey(_KnownColor.lightSteelBlue)) {
      return _brushes[_KnownColor.lightSteelBlue];
    } else {
      return _getBrush(_KnownColor.lightSteelBlue);
    }
  }

  /// Gets the LightYellow default brush.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages.add().graphics.drawRectangle(
  ///     brush: PdfBrushes.lightYellow, bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfBrush get lightYellow {
    if (_brushes.containsKey(_KnownColor.lightYellow)) {
      return _brushes[_KnownColor.lightYellow];
    } else {
      return _getBrush(_KnownColor.lightYellow);
    }
  }

  /// Gets the Lime default brush.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages.add().graphics.drawRectangle(
  ///     brush: PdfBrushes.lime, bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfBrush get lime {
    if (_brushes.containsKey(_KnownColor.lime)) {
      return _brushes[_KnownColor.lime];
    } else {
      return _getBrush(_KnownColor.lime);
    }
  }

  /// Gets the LimeGreen default brush.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages.add().graphics.drawRectangle(
  ///     brush: PdfBrushes.limeGreen, bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfBrush get limeGreen {
    if (_brushes.containsKey(_KnownColor.limeGreen)) {
      return _brushes[_KnownColor.limeGreen];
    } else {
      return _getBrush(_KnownColor.limeGreen);
    }
  }

  /// Gets the Linen default brush.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages.add().graphics.drawRectangle(
  ///     brush: PdfBrushes.linen, bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfBrush get linen {
    if (_brushes.containsKey(_KnownColor.linen)) {
      return _brushes[_KnownColor.linen];
    } else {
      return _getBrush(_KnownColor.linen);
    }
  }

  /// Gets the Magenta default brush.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages.add().graphics.drawRectangle(
  ///     brush: PdfBrushes.magenta, bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfBrush get magenta {
    if (_brushes.containsKey(_KnownColor.magenta)) {
      return _brushes[_KnownColor.magenta];
    } else {
      return _getBrush(_KnownColor.magenta);
    }
  }

  /// Gets the Maroon default brush.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages.add().graphics.drawRectangle(
  ///     brush: PdfBrushes.maroon, bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfBrush get maroon {
    if (_brushes.containsKey(_KnownColor.maroon)) {
      return _brushes[_KnownColor.maroon];
    } else {
      return _getBrush(_KnownColor.maroon);
    }
  }

  /// Gets the MediumAquamarine default brush.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages.add().graphics.drawRectangle(
  ///     brush: PdfBrushes.mediumAquamarine,
  ///     bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfBrush get mediumAquamarine {
    if (_brushes.containsKey(_KnownColor.mediumAquamarine)) {
      return _brushes[_KnownColor.mediumAquamarine];
    } else {
      return _getBrush(_KnownColor.mediumAquamarine);
    }
  }

  /// Gets the MediumBlue default brush.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages.add().graphics.drawRectangle(
  ///     brush: PdfBrushes.mediumBlue, bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfBrush get mediumBlue {
    if (_brushes.containsKey(_KnownColor.mediumBlue)) {
      return _brushes[_KnownColor.mediumBlue];
    } else {
      return _getBrush(_KnownColor.mediumBlue);
    }
  }

  /// Gets the MediumOrchid default brush.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages.add().graphics.drawRectangle(
  ///     brush: PdfBrushes.mediumOrchid,
  ///     bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfBrush get mediumOrchid {
    if (_brushes.containsKey(_KnownColor.mediumOrchid)) {
      return _brushes[_KnownColor.mediumOrchid];
    } else {
      return _getBrush(_KnownColor.mediumOrchid);
    }
  }

  /// Gets the MediumPurple default brush.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages.add().graphics.drawRectangle(
  ///     brush: PdfBrushes.mediumPurple,
  ///     bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfBrush get mediumPurple {
    if (_brushes.containsKey(_KnownColor.mediumPurple)) {
      return _brushes[_KnownColor.mediumPurple];
    } else {
      return _getBrush(_KnownColor.mediumPurple);
    }
  }

  /// Gets the MediumSeaGreen default brush.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages.add().graphics.drawRectangle(
  ///     brush: PdfBrushes.mediumSeaGreen,
  ///     bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfBrush get mediumSeaGreen {
    if (_brushes.containsKey(_KnownColor.mediumSeaGreen)) {
      return _brushes[_KnownColor.mediumSeaGreen];
    } else {
      return _getBrush(_KnownColor.mediumSeaGreen);
    }
  }

  /// Gets the MediumSlateBlue default brush.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages.add().graphics.drawRectangle(
  ///     brush: PdfBrushes.mediumSlateBlue,
  ///     bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfBrush get mediumSlateBlue {
    if (_brushes.containsKey(_KnownColor.mediumSlateBlue)) {
      return _brushes[_KnownColor.mediumSlateBlue];
    } else {
      return _getBrush(_KnownColor.mediumSlateBlue);
    }
  }

  /// Gets the MediumSpringGreen default brush.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages.add().graphics.drawRectangle(
  ///     brush: PdfBrushes.mediumSpringGreen,
  ///     bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfBrush get mediumSpringGreen {
    if (_brushes.containsKey(_KnownColor.mediumSpringGreen)) {
      return _brushes[_KnownColor.mediumSpringGreen];
    } else {
      return _getBrush(_KnownColor.mediumSpringGreen);
    }
  }

  /// Gets the MediumTurquoise default brush.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages.add().graphics.drawRectangle(
  ///     brush: PdfBrushes.mediumTurquoise,
  ///     bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfBrush get mediumTurquoise {
    if (_brushes.containsKey(_KnownColor.mediumTurquoise)) {
      return _brushes[_KnownColor.mediumTurquoise];
    } else {
      return _getBrush(_KnownColor.mediumTurquoise);
    }
  }

  /// Gets the MediumVioletRed default brush.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages.add().graphics.drawRectangle(
  ///     brush: PdfBrushes.mediumVioletRed,
  ///     bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfBrush get mediumVioletRed {
    if (_brushes.containsKey(_KnownColor.mediumVioletRed)) {
      return _brushes[_KnownColor.mediumVioletRed];
    } else {
      return _getBrush(_KnownColor.mediumVioletRed);
    }
  }

  /// Gets the MidnightBlue default brush.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages.add().graphics.drawRectangle(
  ///     brush: PdfBrushes.midnightBlue,
  ///     bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfBrush get midnightBlue {
    if (_brushes.containsKey(_KnownColor.midnightBlue)) {
      return _brushes[_KnownColor.midnightBlue];
    } else {
      return _getBrush(_KnownColor.midnightBlue);
    }
  }

  /// Gets the MintCream default brush.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages.add().graphics.drawRectangle(
  ///     brush: PdfBrushes.mintCream, bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfBrush get mintCream {
    if (_brushes.containsKey(_KnownColor.mintCream)) {
      return _brushes[_KnownColor.mintCream];
    } else {
      return _getBrush(_KnownColor.mintCream);
    }
  }

  /// Gets the MistyRose default brush.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages.add().graphics.drawRectangle(
  ///     brush: PdfBrushes.mistyRose, bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfBrush get mistyRose {
    if (_brushes.containsKey(_KnownColor.mistyRose)) {
      return _brushes[_KnownColor.mistyRose];
    } else {
      return _getBrush(_KnownColor.mistyRose);
    }
  }

  /// Gets the Moccasin default brush.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages.add().graphics.drawRectangle(
  ///     brush: PdfBrushes.moccasin, bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfBrush get moccasin {
    if (_brushes.containsKey(_KnownColor.moccasin)) {
      return _brushes[_KnownColor.moccasin];
    } else {
      return _getBrush(_KnownColor.moccasin);
    }
  }

  /// Gets the NavajoWhite default brush.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages.add().graphics.drawRectangle(
  ///     brush: PdfBrushes.navajoWhite, bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfBrush get navajoWhite {
    if (_brushes.containsKey(_KnownColor.navajoWhite)) {
      return _brushes[_KnownColor.navajoWhite];
    } else {
      return _getBrush(_KnownColor.navajoWhite);
    }
  }

  /// Gets the Navy default brush.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages.add().graphics.drawRectangle(
  ///     brush: PdfBrushes.navy, bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfBrush get navy {
    if (_brushes.containsKey(_KnownColor.navy)) {
      return _brushes[_KnownColor.navy];
    } else {
      return _getBrush(_KnownColor.navy);
    }
  }

  /// Gets the OldLace default brush.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages.add().graphics.drawRectangle(
  ///     brush: PdfBrushes.oldLace, bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfBrush get oldLace {
    if (_brushes.containsKey(_KnownColor.oldLace)) {
      return _brushes[_KnownColor.oldLace];
    } else {
      return _getBrush(_KnownColor.oldLace);
    }
  }

  /// Gets the Olive default brush.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages.add().graphics.drawRectangle(
  ///     brush: PdfBrushes.olive, bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfBrush get olive {
    if (_brushes.containsKey(_KnownColor.olive)) {
      return _brushes[_KnownColor.olive];
    } else {
      return _getBrush(_KnownColor.olive);
    }
  }

  /// Gets the OliveDrab default brush.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages.add().graphics.drawRectangle(
  ///     brush: PdfBrushes.oliveDrab, bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfBrush get oliveDrab {
    if (_brushes.containsKey(_KnownColor.oliveDrab)) {
      return _brushes[_KnownColor.oliveDrab];
    } else {
      return _getBrush(_KnownColor.oliveDrab);
    }
  }

  /// Gets the Orange default brush.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages.add().graphics.drawRectangle(
  ///     brush: PdfBrushes.orange, bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfBrush get orange {
    if (_brushes.containsKey(_KnownColor.orange)) {
      return _brushes[_KnownColor.orange];
    } else {
      return _getBrush(_KnownColor.orange);
    }
  }

  /// Gets the OrangeRed default brush.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages.add().graphics.drawRectangle(
  ///     brush: PdfBrushes.orangeRed, bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfBrush get orangeRed {
    if (_brushes.containsKey(_KnownColor.orangeRed)) {
      return _brushes[_KnownColor.orangeRed];
    } else {
      return _getBrush(_KnownColor.orangeRed);
    }
  }

  /// Gets the Orchid default brush.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages.add().graphics.drawRectangle(
  ///     brush: PdfBrushes.orchid, bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfBrush get orchid {
    if (_brushes.containsKey(_KnownColor.orchid)) {
      return _brushes[_KnownColor.orchid];
    } else {
      return _getBrush(_KnownColor.orchid);
    }
  }

  /// Gets the PaleGoldenrod default brush.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages.add().graphics.drawRectangle(
  ///     brush: PdfBrushes.paleGoldenrod,
  ///     bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfBrush get paleGoldenrod {
    if (_brushes.containsKey(_KnownColor.paleGoldenrod)) {
      return _brushes[_KnownColor.paleGoldenrod];
    } else {
      return _getBrush(_KnownColor.paleGoldenrod);
    }
  }

  /// Gets the PaleGreen default brush.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages.add().graphics.drawRectangle(
  ///     brush: PdfBrushes.paleGreen, bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfBrush get paleGreen {
    if (_brushes.containsKey(_KnownColor.paleGreen)) {
      return _brushes[_KnownColor.paleGreen];
    } else {
      return _getBrush(_KnownColor.paleGreen);
    }
  }

  /// Gets the PaleTurquoise default brush.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages.add().graphics.drawRectangle(
  ///     brush: PdfBrushes.paleTurquoise,
  ///     bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfBrush get paleTurquoise {
    if (_brushes.containsKey(_KnownColor.paleTurquoise)) {
      return _brushes[_KnownColor.paleTurquoise];
    } else {
      return _getBrush(_KnownColor.paleTurquoise);
    }
  }

  /// Gets the PaleVioletRed default brush.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages.add().graphics.drawRectangle(
  ///     brush: PdfBrushes.paleVioletRed,
  ///     bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfBrush get paleVioletRed {
    if (_brushes.containsKey(_KnownColor.paleVioletRed)) {
      return _brushes[_KnownColor.paleVioletRed];
    } else {
      return _getBrush(_KnownColor.paleVioletRed);
    }
  }

  /// Gets the PapayaWhip default brush.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages.add().graphics.drawRectangle(
  ///     brush: PdfBrushes.papayaWhip, bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfBrush get papayaWhip {
    if (_brushes.containsKey(_KnownColor.papayaWhip)) {
      return _brushes[_KnownColor.papayaWhip];
    } else {
      return _getBrush(_KnownColor.papayaWhip);
    }
  }

  /// Gets the PeachPuff default brush.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages.add().graphics.drawRectangle(
  ///     brush: PdfBrushes.peachPuff, bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfBrush get peachPuff {
    if (_brushes.containsKey(_KnownColor.peachPuff)) {
      return _brushes[_KnownColor.peachPuff];
    } else {
      return _getBrush(_KnownColor.peachPuff);
    }
  }

  /// Gets the Peru default brush.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages.add().graphics.drawRectangle(
  ///     brush: PdfBrushes.peru, bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfBrush get peru {
    if (_brushes.containsKey(_KnownColor.peru)) {
      return _brushes[_KnownColor.peru];
    } else {
      return _getBrush(_KnownColor.peru);
    }
  }

  /// Gets the Pink default brush.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages.add().graphics.drawRectangle(
  ///     brush: PdfBrushes.pink, bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfBrush get pink {
    if (_brushes.containsKey(_KnownColor.pink)) {
      return _brushes[_KnownColor.pink];
    } else {
      return _getBrush(_KnownColor.pink);
    }
  }

  /// Gets the Plum default brush.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages.add().graphics.drawRectangle(
  ///     brush: PdfBrushes.plum, bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfBrush get plum {
    if (_brushes.containsKey(_KnownColor.plum)) {
      return _brushes[_KnownColor.plum];
    } else {
      return _getBrush(_KnownColor.plum);
    }
  }

  /// Gets the PowderBlue default brush.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages.add().graphics.drawRectangle(
  ///     brush: PdfBrushes.powderBlue, bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfBrush get powderBlue {
    if (_brushes.containsKey(_KnownColor.powderBlue)) {
      return _brushes[_KnownColor.powderBlue];
    } else {
      return _getBrush(_KnownColor.powderBlue);
    }
  }

  /// Gets the Purple default brush.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages.add().graphics.drawRectangle(
  ///     brush: PdfBrushes.purple, bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfBrush get purple {
    if (_brushes.containsKey(_KnownColor.purple)) {
      return _brushes[_KnownColor.purple];
    } else {
      return _getBrush(_KnownColor.purple);
    }
  }

  /// Gets the Red default brush.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages.add().graphics.drawRectangle(
  ///     brush: PdfBrushes.red, bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfBrush get red {
    if (_brushes.containsKey(_KnownColor.red)) {
      return _brushes[_KnownColor.red];
    } else {
      return _getBrush(_KnownColor.red);
    }
  }

  /// Gets the RosyBrown default brush.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages.add().graphics.drawRectangle(
  ///     brush: PdfBrushes.rosyBrown, bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfBrush get rosyBrown {
    if (_brushes.containsKey(_KnownColor.rosyBrown)) {
      return _brushes[_KnownColor.rosyBrown];
    } else {
      return _getBrush(_KnownColor.rosyBrown);
    }
  }

  /// Gets the RoyalBlue default brush.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages.add().graphics.drawRectangle(
  ///     brush: PdfBrushes.royalBlue, bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfBrush get royalBlue {
    if (_brushes.containsKey(_KnownColor.royalBlue)) {
      return _brushes[_KnownColor.royalBlue];
    } else {
      return _getBrush(_KnownColor.royalBlue);
    }
  }

  /// Gets the SaddleBrown default brush.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages.add().graphics.drawRectangle(
  ///     brush: PdfBrushes.saddleBrown, bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfBrush get saddleBrown {
    if (_brushes.containsKey(_KnownColor.saddleBrown)) {
      return _brushes[_KnownColor.saddleBrown];
    } else {
      return _getBrush(_KnownColor.saddleBrown);
    }
  }

  /// Gets the Salmon default brush.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages.add().graphics.drawRectangle(
  ///     brush: PdfBrushes.salmon, bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfBrush get salmon {
    if (_brushes.containsKey(_KnownColor.salmon)) {
      return _brushes[_KnownColor.salmon];
    } else {
      return _getBrush(_KnownColor.salmon);
    }
  }

  /// Gets the SandyBrown default brush.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages.add().graphics.drawRectangle(
  ///     brush: PdfBrushes.sandyBrown, bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfBrush get sandyBrown {
    if (_brushes.containsKey(_KnownColor.sandyBrown)) {
      return _brushes[_KnownColor.sandyBrown];
    } else {
      return _getBrush(_KnownColor.sandyBrown);
    }
  }

  /// Gets the SeaGreen default brush.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages.add().graphics.drawRectangle(
  ///     brush: PdfBrushes.seaGreen, bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfBrush get seaGreen {
    if (_brushes.containsKey(_KnownColor.seaGreen)) {
      return _brushes[_KnownColor.seaGreen];
    } else {
      return _getBrush(_KnownColor.seaGreen);
    }
  }

  /// Gets the SeaShell default brush.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages.add().graphics.drawRectangle(
  ///     brush: PdfBrushes.seaShell, bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfBrush get seaShell {
    if (_brushes.containsKey(_KnownColor.seaShell)) {
      return _brushes[_KnownColor.seaShell];
    } else {
      return _getBrush(_KnownColor.seaShell);
    }
  }

  /// Gets the Sienna default brush.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages.add().graphics.drawRectangle(
  ///     brush: PdfBrushes.sienna, bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfBrush get sienna {
    if (_brushes.containsKey(_KnownColor.sienna)) {
      return _brushes[_KnownColor.sienna];
    } else {
      return _getBrush(_KnownColor.sienna);
    }
  }

  /// Gets the Silver default brush.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages.add().graphics.drawRectangle(
  ///     brush: PdfBrushes.silver, bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfBrush get silver {
    if (_brushes.containsKey(_KnownColor.silver)) {
      return _brushes[_KnownColor.silver];
    } else {
      return _getBrush(_KnownColor.silver);
    }
  }

  /// Gets the SkyBlue default brush.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages.add().graphics.drawRectangle(
  ///     brush: PdfBrushes.skyBlue, bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfBrush get skyBlue {
    if (_brushes.containsKey(_KnownColor.skyBlue)) {
      return _brushes[_KnownColor.skyBlue];
    } else {
      return _getBrush(_KnownColor.skyBlue);
    }
  }

  /// Gets the SlateBlue default brush.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages.add().graphics.drawRectangle(
  ///     brush: PdfBrushes.slateBlue, bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfBrush get slateBlue {
    if (_brushes.containsKey(_KnownColor.slateBlue)) {
      return _brushes[_KnownColor.slateBlue];
    } else {
      return _getBrush(_KnownColor.slateBlue);
    }
  }

  /// Gets the SlateGray default brush.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages.add().graphics.drawRectangle(
  ///     brush: PdfBrushes.slateGray, bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfBrush get slateGray {
    if (_brushes.containsKey(_KnownColor.slateGray)) {
      return _brushes[_KnownColor.slateGray];
    } else {
      return _getBrush(_KnownColor.slateGray);
    }
  }

  /// Gets the Snow default brush.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages.add().graphics.drawRectangle(
  ///     brush: PdfBrushes.snow, bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfBrush get snow {
    if (_brushes.containsKey(_KnownColor.snow)) {
      return _brushes[_KnownColor.snow];
    } else {
      return _getBrush(_KnownColor.snow);
    }
  }

  /// Gets the SpringGreen default brush.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages.add().graphics.drawRectangle(
  ///     brush: PdfBrushes.springGreen, bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfBrush get springGreen {
    if (_brushes.containsKey(_KnownColor.springGreen)) {
      return _brushes[_KnownColor.springGreen];
    } else {
      return _getBrush(_KnownColor.springGreen);
    }
  }

  /// Gets the SteelBlue default brush.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages.add().graphics.drawRectangle(
  ///     brush: PdfBrushes.steelBlue, bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfBrush get steelBlue {
    if (_brushes.containsKey(_KnownColor.steelBlue)) {
      return _brushes[_KnownColor.steelBlue];
    } else {
      return _getBrush(_KnownColor.steelBlue);
    }
  }

  /// Gets the Tan default brush.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages.add().graphics.drawRectangle(
  ///     brush: PdfBrushes.tan, bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfBrush get tan {
    if (_brushes.containsKey(_KnownColor.tan)) {
      return _brushes[_KnownColor.tan];
    } else {
      return _getBrush(_KnownColor.tan);
    }
  }

  /// Gets the Teal default brush.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages.add().graphics.drawRectangle(
  ///     brush: PdfBrushes.teal, bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfBrush get teal {
    if (_brushes.containsKey(_KnownColor.teal)) {
      return _brushes[_KnownColor.teal];
    } else {
      return _getBrush(_KnownColor.teal);
    }
  }

  /// Gets the Thistle default brush.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages.add().graphics.drawRectangle(
  ///     brush: PdfBrushes.thistle, bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfBrush get thistle {
    if (_brushes.containsKey(_KnownColor.thistle)) {
      return _brushes[_KnownColor.thistle];
    } else {
      return _getBrush(_KnownColor.thistle);
    }
  }

  /// Gets the Tomato default brush.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages.add().graphics.drawRectangle(
  ///     brush: PdfBrushes.tomato, bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfBrush get tomato {
    if (_brushes.containsKey(_KnownColor.tomato)) {
      return _brushes[_KnownColor.tomato];
    } else {
      return _getBrush(_KnownColor.tomato);
    }
  }

  /// Gets the Transparent default brush.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages.add().graphics.drawRectangle(
  ///     brush: PdfBrushes.transparent, bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfBrush get transparent {
    if (_brushes.containsKey(_KnownColor.transparent)) {
      return _brushes[_KnownColor.transparent];
    } else {
      return _getBrush(_KnownColor.transparent);
    }
  }

  /// Gets the Turquoise default brush.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages.add().graphics.drawRectangle(
  ///     brush: PdfBrushes.turquoise, bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfBrush get turquoise {
    if (_brushes.containsKey(_KnownColor.turquoise)) {
      return _brushes[_KnownColor.turquoise];
    } else {
      return _getBrush(_KnownColor.turquoise);
    }
  }

  /// Gets the Violet default brush.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages.add().graphics.drawRectangle(
  ///     brush: PdfBrushes.violet, bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfBrush get violet {
    if (_brushes.containsKey(_KnownColor.violet)) {
      return _brushes[_KnownColor.violet];
    } else {
      return _getBrush(_KnownColor.violet);
    }
  }

  /// Gets the Wheat default brush.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages.add().graphics.drawRectangle(
  ///     brush: PdfBrushes.wheat, bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfBrush get wheat {
    if (_brushes.containsKey(_KnownColor.wheat)) {
      return _brushes[_KnownColor.wheat];
    } else {
      return _getBrush(_KnownColor.wheat);
    }
  }

  /// Gets the White default brush.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages.add().graphics.drawRectangle(
  ///     brush: PdfBrushes.white, bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfBrush get white {
    if (_brushes.containsKey(_KnownColor.white)) {
      return _brushes[_KnownColor.white];
    } else {
      return _getBrush(_KnownColor.white);
    }
  }

  /// Gets the WhiteSmoke default brush.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages.add().graphics.drawRectangle(
  ///     brush: PdfBrushes.whiteSmoke, bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfBrush get whiteSmoke {
    if (_brushes.containsKey(_KnownColor.whiteSmoke)) {
      return _brushes[_KnownColor.whiteSmoke];
    } else {
      return _getBrush(_KnownColor.whiteSmoke);
    }
  }

  /// Gets the Yellow default brush.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages.add().graphics.drawRectangle(
  ///     brush: PdfBrushes.yellow, bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfBrush get yellow {
    if (_brushes.containsKey(_KnownColor.yellow)) {
      return _brushes[_KnownColor.yellow];
    } else {
      return _getBrush(_KnownColor.yellow);
    }
  }

  /// Gets the YellowGreen default brush.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages.add().graphics.drawRectangle(
  ///     brush: PdfBrushes.yellowGreen, bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfBrush get yellowGreen {
    if (_brushes.containsKey(_KnownColor.yellowGreen)) {
      return _brushes[_KnownColor.yellowGreen];
    } else {
      return _getBrush(_KnownColor.yellowGreen);
    }
  }

  static PdfBrush _getBrush(_KnownColor kColor) {
    final _Color color = _Color(kColor);
    final PdfBrush brush = PdfSolidBrush(PdfColor(color.r, color.g, color.b));
    _brushes[kColor] = brush;
    return brush;
  }

  static void _dispose() {
    _brushes.clear();
  }
}
