part of pdf;

/// The collection of default pens.
///
/// ```dart
/// //Create a new PDF document.
/// PdfDocument doc = PdfDocument();
/// //Draw rectangle.
/// doc.pages
///     .add()
///     .graphics
///     .drawRectangle(pen: PdfPens.black,
///     bounds: Rect.fromLTWH(0, 0, 200, 100));
/// // Save the document.
/// List<int> bytes = doc.save();
/// // Dispose the document.
/// doc.dispose();
/// ```
class PdfPens {
  PdfPens._();
  static final Map<_KnownColor, PdfPen> _pens = <_KnownColor, PdfPen>{};

  /// Gets the AliceBlue pen.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages
  ///     .add()
  ///     .graphics
  ///     .drawRectangle(pen: PdfPens.aliceBlue,
  ///     bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfPen get aliceBlue {
    if (_pens.containsKey(_KnownColor.aliceBlue)) {
      return _pens[_KnownColor.aliceBlue];
    } else {
      return _getPen(_KnownColor.aliceBlue);
    }
  }

  /// Gets the Antique white pen.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages.add().graphics.drawRectangle(
  ///     pen: PdfPens.antiqueWhite, bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfPen get antiqueWhite {
    if (_pens.containsKey(_KnownColor.antiqueWhite)) {
      return _pens[_KnownColor.antiqueWhite];
    } else {
      return _getPen(_KnownColor.antiqueWhite);
    }
  }

  /// Gets the Aqua default pen.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages
  ///     .add()
  ///     .graphics
  ///     .drawRectangle(pen: PdfPens.aqua,
  ///     bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfPen get aqua {
    if (_pens.containsKey(_KnownColor.aqua)) {
      return _pens[_KnownColor.aqua];
    } else {
      return _getPen(_KnownColor.aqua);
    }
  }

  /// Gets the Aquamarine default pen.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages.add().graphics.drawRectangle(
  ///     pen: PdfPens.aquamarine, bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfPen get aquamarine {
    if (_pens.containsKey(_KnownColor.aquamarine)) {
      return _pens[_KnownColor.aquamarine];
    } else {
      return _getPen(_KnownColor.aquamarine);
    }
  }

  /// Gets the Azure default pen.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages
  ///     .add()
  ///     .graphics
  ///     .drawRectangle(pen: PdfPens.azure,
  ///     bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfPen get azure {
    if (_pens.containsKey(_KnownColor.azure)) {
      return _pens[_KnownColor.azure];
    } else {
      return _getPen(_KnownColor.azure);
    }
  }

  /// Gets the Beige default pen.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages
  ///     .add()
  ///     .graphics
  ///     .drawRectangle(pen: PdfPens.beige,
  ///     bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfPen get beige {
    if (_pens.containsKey(_KnownColor.beige)) {
      return _pens[_KnownColor.beige];
    } else {
      return _getPen(_KnownColor.beige);
    }
  }

  /// Gets the Bisque default pen.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages
  ///     .add()
  ///     .graphics
  ///     .drawRectangle(pen: PdfPens.bisque,
  ///     bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfPen get bisque {
    if (_pens.containsKey(_KnownColor.bisque)) {
      return _pens[_KnownColor.bisque];
    } else {
      return _getPen(_KnownColor.bisque);
    }
  }

  /// Gets the Black default pen.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages
  ///     .add()
  ///     .graphics
  ///     .drawRectangle(pen: PdfPens.black,
  ///     bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfPen get black {
    if (_pens.containsKey(_KnownColor.black)) {
      return _pens[_KnownColor.black];
    } else {
      return _getPen(_KnownColor.black);
    }
  }

  /// Gets the BlanchedAlmond default pen.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages.add().graphics.drawRectangle(
  ///     pen: PdfPens.blanchedAlmond, bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfPen get blanchedAlmond {
    if (_pens.containsKey(_KnownColor.blanchedAlmond)) {
      return _pens[_KnownColor.blanchedAlmond];
    } else {
      return _getPen(_KnownColor.blanchedAlmond);
    }
  }

  /// Gets the Blue default pen.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages
  ///     .add()
  ///     .graphics
  ///     .drawRectangle(pen: PdfPens.blue,
  ///     bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfPen get blue {
    if (_pens.containsKey(_KnownColor.blue)) {
      return _pens[_KnownColor.blue];
    } else {
      return _getPen(_KnownColor.blue);
    }
  }

  /// Gets the BlueViolet default pen.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages.add().graphics.drawRectangle(
  ///     pen: PdfPens.blueViolet, bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfPen get blueViolet {
    if (_pens.containsKey(_KnownColor.blueViolet)) {
      return _pens[_KnownColor.blueViolet];
    } else {
      return _getPen(_KnownColor.blueViolet);
    }
  }

  /// Gets the Brown default pen.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages
  ///     .add()
  ///     .graphics
  ///     .drawRectangle(pen: PdfPens.brown,
  ///     bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfPen get brown {
    if (_pens.containsKey(_KnownColor.brown)) {
      return _pens[_KnownColor.brown];
    } else {
      return _getPen(_KnownColor.brown);
    }
  }

  /// Gets the BurlyWood default pen.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages
  ///     .add()
  ///     .graphics
  ///     .drawRectangle(pen: PdfPens.burlyWood,
  ///     bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfPen get burlyWood {
    if (_pens.containsKey(_KnownColor.burlyWood)) {
      return _pens[_KnownColor.burlyWood];
    } else {
      return _getPen(_KnownColor.burlyWood);
    }
  }

  /// Gets the CadetBlue default pen.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages
  ///     .add()
  ///     .graphics
  ///     .drawRectangle(pen: PdfPens.cadetBlue,
  ///     bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfPen get cadetBlue {
    if (_pens.containsKey(_KnownColor.cadetBlue)) {
      return _pens[_KnownColor.cadetBlue];
    } else {
      return _getPen(_KnownColor.cadetBlue);
    }
  }

  /// Gets the Chartreuse default pen.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages.add().graphics.drawRectangle(
  ///     pen: PdfPens.chartreuse, bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfPen get chartreuse {
    if (_pens.containsKey(_KnownColor.chartreuse)) {
      return _pens[_KnownColor.chartreuse];
    } else {
      return _getPen(_KnownColor.chartreuse);
    }
  }

  /// Gets the Chocolate default pen.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages
  ///     .add()
  ///     .graphics
  ///     .drawRectangle(pen: PdfPens.chocolate,
  ///     bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfPen get chocolate {
    if (_pens.containsKey(_KnownColor.chocolate)) {
      return _pens[_KnownColor.chocolate];
    } else {
      return _getPen(_KnownColor.chocolate);
    }
  }

  /// Gets the Coral default pen.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages
  ///     .add()
  ///     .graphics
  ///     .drawRectangle(pen: PdfPens.coral,
  ///     bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfPen get coral {
    if (_pens.containsKey(_KnownColor.coral)) {
      return _pens[_KnownColor.coral];
    } else {
      return _getPen(_KnownColor.coral);
    }
  }

  /// Gets the CornflowerBlue default pen.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages.add().graphics.drawRectangle(
  ///     pen: PdfPens.cornflowerBlue, bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfPen get cornflowerBlue {
    if (_pens.containsKey(_KnownColor.cornflowerBlue)) {
      return _pens[_KnownColor.cornflowerBlue];
    } else {
      return _getPen(_KnownColor.cornflowerBlue);
    }
  }

  /// Gets the Corn silk default pen.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages
  ///     .add()
  ///     .graphics
  ///     .drawRectangle(pen: PdfPens.cornsilk,
  ///     bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfPen get cornsilk {
    if (_pens.containsKey(_KnownColor.cornsilk)) {
      return _pens[_KnownColor.cornsilk];
    } else {
      return _getPen(_KnownColor.cornsilk);
    }
  }

  /// Gets the Crimson default pen.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages
  ///     .add()
  ///     .graphics
  ///     .drawRectangle(pen: PdfPens.crimson,
  ///     bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfPen get crimson {
    if (_pens.containsKey(_KnownColor.crimson)) {
      return _pens[_KnownColor.crimson];
    } else {
      return _getPen(_KnownColor.crimson);
    }
  }

  /// Gets the Cyan default pen.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages
  ///     .add()
  ///     .graphics
  ///     .drawRectangle(pen: PdfPens.cyan,
  ///     bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfPen get cyan {
    if (_pens.containsKey(_KnownColor.cyan)) {
      return _pens[_KnownColor.cyan];
    } else {
      return _getPen(_KnownColor.cyan);
    }
  }

  /// Gets the DarkBlue default pen.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages
  ///     .add()
  ///     .graphics
  ///     .drawRectangle(pen: PdfPens.darkBlue,
  ///     bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfPen get darkBlue {
    if (_pens.containsKey(_KnownColor.darkBlue)) {
      return _pens[_KnownColor.darkBlue];
    } else {
      return _getPen(_KnownColor.darkBlue);
    }
  }

  /// Gets the DarkCyan default pen.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages
  ///     .add()
  ///     .graphics
  ///     .drawRectangle(pen: PdfPens.darkCyan,
  ///     bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfPen get darkCyan {
    if (_pens.containsKey(_KnownColor.darkCyan)) {
      return _pens[_KnownColor.darkCyan];
    } else {
      return _getPen(_KnownColor.darkCyan);
    }
  }

  /// Gets the DarkGoldenrod default pen.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages.add().graphics.drawRectangle(
  ///     pen: PdfPens.darkGoldenrod, bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfPen get darkGoldenrod {
    if (_pens.containsKey(_KnownColor.darkGoldenrod)) {
      return _pens[_KnownColor.darkGoldenrod];
    } else {
      return _getPen(_KnownColor.darkGoldenrod);
    }
  }

  /// Gets the DarkGray default pen.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages
  ///     .add()
  ///     .graphics
  ///     .drawRectangle(pen: PdfPens.darkGray,
  ///     bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfPen get darkGray {
    if (_pens.containsKey(_KnownColor.darkGray)) {
      return _pens[_KnownColor.darkGray];
    } else {
      return _getPen(_KnownColor.darkGray);
    }
  }

  /// Gets the DarkGreen default pen.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages
  ///     .add()
  ///     .graphics
  ///     .drawRectangle(pen: PdfPens.darkGreen,
  ///     bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfPen get darkGreen {
    if (_pens.containsKey(_KnownColor.darkGreen)) {
      return _pens[_KnownColor.darkGreen];
    } else {
      return _getPen(_KnownColor.darkGreen);
    }
  }

  /// Gets the DarkKhaki default pen.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages
  ///     .add()
  ///     .graphics
  ///     .drawRectangle(pen: PdfPens.darkKhaki,
  ///     bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfPen get darkKhaki {
    if (_pens.containsKey(_KnownColor.darkKhaki)) {
      return _pens[_KnownColor.darkKhaki];
    } else {
      return _getPen(_KnownColor.darkKhaki);
    }
  }

  /// Gets the DarkMagenta default pen.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages.add().graphics.drawRectangle(
  ///     pen: PdfPens.darkMagenta, bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfPen get darkMagenta {
    if (_pens.containsKey(_KnownColor.darkMagenta)) {
      return _pens[_KnownColor.darkMagenta];
    } else {
      return _getPen(_KnownColor.darkMagenta);
    }
  }

  /// Gets the DarkOliveGreen default pen.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages.add().graphics.drawRectangle(
  ///     pen: PdfPens.darkOliveGreen, bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfPen get darkOliveGreen {
    if (_pens.containsKey(_KnownColor.darkOliveGreen)) {
      return _pens[_KnownColor.darkOliveGreen];
    } else {
      return _getPen(_KnownColor.darkOliveGreen);
    }
  }

  /// Gets the DarkOrange default pen.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages.add().graphics.drawRectangle(
  ///     pen: PdfPens.darkOrange, bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfPen get darkOrange {
    if (_pens.containsKey(_KnownColor.darkOrange)) {
      return _pens[_KnownColor.darkOrange];
    } else {
      return _getPen(_KnownColor.darkOrange);
    }
  }

  /// Gets the DarkOrchid default pen.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages.add().graphics.drawRectangle(
  ///     pen: PdfPens.darkOrchid, bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfPen get darkOrchid {
    if (_pens.containsKey(_KnownColor.darkOrchid)) {
      return _pens[_KnownColor.darkOrchid];
    } else {
      return _getPen(_KnownColor.darkOrchid);
    }
  }

  /// Gets the DarkRed default pen.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages
  ///     .add()
  ///     .graphics
  ///     .drawRectangle(pen: PdfPens.darkRed,
  ///     bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfPen get darkRed {
    if (_pens.containsKey(_KnownColor.darkRed)) {
      return _pens[_KnownColor.darkRed];
    } else {
      return _getPen(_KnownColor.darkRed);
    }
  }

  /// Gets the DarkSalmon default pen.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages.add().graphics.drawRectangle(
  ///     pen: PdfPens.darkSalmon, bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfPen get darkSalmon {
    if (_pens.containsKey(_KnownColor.darkSalmon)) {
      return _pens[_KnownColor.darkSalmon];
    } else {
      return _getPen(_KnownColor.darkSalmon);
    }
  }

  /// Gets the DarkSeaGreen default pen.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages.add().graphics.drawRectangle(
  ///     pen: PdfPens.darkSeaGreen, bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfPen get darkSeaGreen {
    if (_pens.containsKey(_KnownColor.darkSeaGreen)) {
      return _pens[_KnownColor.darkSeaGreen];
    } else {
      return _getPen(_KnownColor.darkSeaGreen);
    }
  }

  /// Gets the DarkSlateBlue default pen.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages.add().graphics.drawRectangle(
  ///     pen: PdfPens.darkSlateBlue, bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfPen get darkSlateBlue {
    if (_pens.containsKey(_KnownColor.darkSlateBlue)) {
      return _pens[_KnownColor.darkSlateBlue];
    } else {
      return _getPen(_KnownColor.darkSlateBlue);
    }
  }

  /// Gets the DarkSlateGray default pen.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages.add().graphics.drawRectangle(
  ///     pen: PdfPens.darkSlateGray, bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfPen get darkSlateGray {
    if (_pens.containsKey(_KnownColor.darkSlateGray)) {
      return _pens[_KnownColor.darkSlateGray];
    } else {
      return _getPen(_KnownColor.darkSlateGray);
    }
  }

  /// Gets the DarkTurquoise default pen.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages.add().graphics.drawRectangle(
  ///     pen: PdfPens.darkTurquoise, bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfPen get darkTurquoise {
    if (_pens.containsKey(_KnownColor.darkTurquoise)) {
      return _pens[_KnownColor.darkTurquoise];
    } else {
      return _getPen(_KnownColor.darkTurquoise);
    }
  }

  /// Gets the DarkViolet default pen.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages.add().graphics.drawRectangle(
  ///     pen: PdfPens.darkViolet, bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfPen get darkViolet {
    if (_pens.containsKey(_KnownColor.darkViolet)) {
      return _pens[_KnownColor.darkViolet];
    } else {
      return _getPen(_KnownColor.darkViolet);
    }
  }

  /// Gets the DeepPink default pen.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages
  ///     .add()
  ///     .graphics
  ///     .drawRectangle(pen: PdfPens.deepPink,
  ///     bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfPen get deepPink {
    if (_pens.containsKey(_KnownColor.deepPink)) {
      return _pens[_KnownColor.deepPink];
    } else {
      return _getPen(_KnownColor.deepPink);
    }
  }

  /// Gets the DeepSkyBlue default pen.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages.add().graphics.drawRectangle(
  ///     pen: PdfPens.deepSkyBlue, bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfPen get deepSkyBlue {
    if (_pens.containsKey(_KnownColor.deepSkyBlue)) {
      return _pens[_KnownColor.deepSkyBlue];
    } else {
      return _getPen(_KnownColor.deepSkyBlue);
    }
  }

  /// Gets the DimGray default pen.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages
  ///     .add()
  ///     .graphics
  ///     .drawRectangle(pen: PdfPens.dimGray,
  ///     bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfPen get dimGray {
    if (_pens.containsKey(_KnownColor.dimGray)) {
      return _pens[_KnownColor.dimGray];
    } else {
      return _getPen(_KnownColor.dimGray);
    }
  }

  /// Gets the DodgerBlue default pen.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages.add().graphics.drawRectangle(
  ///     pen: PdfPens.dodgerBlue, bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfPen get dodgerBlue {
    if (_pens.containsKey(_KnownColor.dodgerBlue)) {
      return _pens[_KnownColor.dodgerBlue];
    } else {
      return _getPen(_KnownColor.dodgerBlue);
    }
  }

  /// Gets the Firebrick default pen.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages
  ///     .add()
  ///     .graphics
  ///     .drawRectangle(pen: PdfPens.firebrick,
  ///     bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfPen get firebrick {
    if (_pens.containsKey(_KnownColor.firebrick)) {
      return _pens[_KnownColor.firebrick];
    } else {
      return _getPen(_KnownColor.firebrick);
    }
  }

  /// Gets the FloralWhite default pen.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages.add().graphics.drawRectangle(
  ///     pen: PdfPens.floralWhite, bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfPen get floralWhite {
    if (_pens.containsKey(_KnownColor.floralWhite)) {
      return _pens[_KnownColor.floralWhite];
    } else {
      return _getPen(_KnownColor.floralWhite);
    }
  }

  /// Gets the ForestGreen default pen.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages.add().graphics.drawRectangle(
  ///     pen: PdfPens.forestGreen, bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfPen get forestGreen {
    if (_pens.containsKey(_KnownColor.forestGreen)) {
      return _pens[_KnownColor.forestGreen];
    } else {
      return _getPen(_KnownColor.forestGreen);
    }
  }

  /// Gets the Fuchsia default pen.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages
  ///     .add()
  ///     .graphics
  ///     .drawRectangle(pen: PdfPens.fuchsia,
  ///     bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfPen get fuchsia {
    if (_pens.containsKey(_KnownColor.fuchsia)) {
      return _pens[_KnownColor.fuchsia];
    } else {
      return _getPen(_KnownColor.fuchsia);
    }
  }

  /// Gets the Gainsborough default pen.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages
  ///     .add()
  ///     .graphics
  ///     .drawRectangle(pen: PdfPens.gainsboro,
  ///     bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfPen get gainsboro {
    if (_pens.containsKey(_KnownColor.gainsboro)) {
      return _pens[_KnownColor.gainsboro];
    } else {
      return _getPen(_KnownColor.gainsboro);
    }
  }

  /// Gets the GhostWhite default pen.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages.add().graphics.drawRectangle(
  ///     pen: PdfPens.ghostWhite, bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfPen get ghostWhite {
    if (_pens.containsKey(_KnownColor.ghostWhite)) {
      return _pens[_KnownColor.ghostWhite];
    } else {
      return _getPen(_KnownColor.ghostWhite);
    }
  }

  /// Gets the Gold default pen.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages
  ///     .add()
  ///     .graphics
  ///     .drawRectangle(pen: PdfPens.gold,
  ///     bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfPen get gold {
    if (_pens.containsKey(_KnownColor.gold)) {
      return _pens[_KnownColor.gold];
    } else {
      return _getPen(_KnownColor.gold);
    }
  }

  /// Gets the Goldenrod default pen.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages
  ///     .add()
  ///     .graphics
  ///     .drawRectangle(pen: PdfPens.goldenrod, bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfPen get goldenrod {
    if (_pens.containsKey(_KnownColor.goldenrod)) {
      return _pens[_KnownColor.goldenrod];
    } else {
      return _getPen(_KnownColor.goldenrod);
    }
  }

  /// Gets the Gray default pen.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages
  ///     .add()
  ///     .graphics
  ///     .drawRectangle(pen: PdfPens.gray,
  ///     bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfPen get gray {
    if (_pens.containsKey(_KnownColor.gray)) {
      return _pens[_KnownColor.gray];
    } else {
      return _getPen(_KnownColor.gray);
    }
  }

  /// Gets the Green default pen.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages
  ///     .add()
  ///     .graphics
  ///     .drawRectangle(pen: PdfPens.green,
  ///     bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfPen get green {
    if (_pens.containsKey(_KnownColor.green)) {
      return _pens[_KnownColor.green];
    } else {
      return _getPen(_KnownColor.green);
    }
  }

  /// Gets the GreenYellow default pen.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages.add().graphics.drawRectangle(
  ///     pen: PdfPens.greenYellow, bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfPen get greenYellow {
    if (_pens.containsKey(_KnownColor.greenYellow)) {
      return _pens[_KnownColor.greenYellow];
    } else {
      return _getPen(_KnownColor.greenYellow);
    }
  }

  /// Gets the Honeydew default pen.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages
  ///     .add()
  ///     .graphics
  ///     .drawRectangle(pen: PdfPens.honeydew,
  ///     bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfPen get honeydew {
    if (_pens.containsKey(_KnownColor.honeydew)) {
      return _pens[_KnownColor.honeydew];
    } else {
      return _getPen(_KnownColor.honeydew);
    }
  }

  /// Gets the HotPink default pen.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages
  ///     .add()
  ///     .graphics
  ///     .drawRectangle(pen: PdfPens.hotPink,
  ///     bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfPen get hotPink {
    if (_pens.containsKey(_KnownColor.hotPink)) {
      return _pens[_KnownColor.hotPink];
    } else {
      return _getPen(_KnownColor.hotPink);
    }
  }

  /// Gets the IndianRed default pen.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages
  ///     .add()
  ///     .graphics
  ///     .drawRectangle(pen: PdfPens.indianRed,
  ///     bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfPen get indianRed {
    if (_pens.containsKey(_KnownColor.indianRed)) {
      return _pens[_KnownColor.indianRed];
    } else {
      return _getPen(_KnownColor.indianRed);
    }
  }

  /// Gets the Indigo default pen.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages
  ///     .add()
  ///     .graphics
  ///     .drawRectangle(pen: PdfPens.indigo, bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfPen get indigo {
    if (_pens.containsKey(_KnownColor.indigo)) {
      return _pens[_KnownColor.indigo];
    } else {
      return _getPen(_KnownColor.indigo);
    }
  }

  /// Gets the Ivory default pen.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages
  ///     .add()
  ///     .graphics
  ///     .drawRectangle(pen: PdfPens.ivory,
  ///     bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfPen get ivory {
    if (_pens.containsKey(_KnownColor.ivory)) {
      return _pens[_KnownColor.ivory];
    } else {
      return _getPen(_KnownColor.ivory);
    }
  }

  /// Gets the Khaki default pen.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages
  ///     .add()
  ///     .graphics
  ///     .drawRectangle(pen: PdfPens.khaki,
  ///     bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfPen get khaki {
    if (_pens.containsKey(_KnownColor.khaki)) {
      return _pens[_KnownColor.khaki];
    } else {
      return _getPen(_KnownColor.khaki);
    }
  }

  /// Gets the Lavender default pen.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages
  ///     .add()
  ///     .graphics
  ///     .drawRectangle(pen: PdfPens.lavender,
  ///     bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfPen get lavender {
    if (_pens.containsKey(_KnownColor.lavender)) {
      return _pens[_KnownColor.lavender];
    } else {
      return _getPen(_KnownColor.lavender);
    }
  }

  /// Gets the LavenderBlush default pen.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages.add().graphics.drawRectangle(
  ///     pen: PdfPens.lavenderBlush, bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfPen get lavenderBlush {
    if (_pens.containsKey(_KnownColor.lavenderBlush)) {
      return _pens[_KnownColor.lavenderBlush];
    } else {
      return _getPen(_KnownColor.lavenderBlush);
    }
  }

  /// Gets the LawnGreen default pen.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages
  ///     .add()
  ///     .graphics
  ///     .drawRectangle(pen: PdfPens.lawnGreen,
  ///     bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfPen get lawnGreen {
    if (_pens.containsKey(_KnownColor.lawnGreen)) {
      return _pens[_KnownColor.lawnGreen];
    } else {
      return _getPen(_KnownColor.lawnGreen);
    }
  }

  /// Gets the LemonChiffon default pen.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages.add().graphics.drawRectangle(
  ///     pen: PdfPens.lemonChiffon, bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfPen get lemonChiffon {
    if (_pens.containsKey(_KnownColor.lemonChiffon)) {
      return _pens[_KnownColor.lemonChiffon];
    } else {
      return _getPen(_KnownColor.lemonChiffon);
    }
  }

  /// Gets the LightBlue default pen.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages
  ///     .add()
  ///     .graphics
  ///     .drawRectangle(pen: PdfPens.lightBlue,
  ///     bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfPen get lightBlue {
    if (_pens.containsKey(_KnownColor.lightBlue)) {
      return _pens[_KnownColor.lightBlue];
    } else {
      return _getPen(_KnownColor.lightBlue);
    }
  }

  /// Gets the LightCoral default pen.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages.add().graphics.drawRectangle(
  ///     pen: PdfPens.lightCoral, bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfPen get lightCoral {
    if (_pens.containsKey(_KnownColor.lightCoral)) {
      return _pens[_KnownColor.lightCoral];
    } else {
      return _getPen(_KnownColor.lightCoral);
    }
  }

  /// Gets the LightCyan default pen.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages
  ///     .add()
  ///     .graphics
  ///     .drawRectangle(pen: PdfPens.lightCyan,
  ///     bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfPen get lightCyan {
    if (_pens.containsKey(_KnownColor.lightCyan)) {
      return _pens[_KnownColor.lightCyan];
    } else {
      return _getPen(_KnownColor.lightCyan);
    }
  }

  /// Gets the LightGoldenrodYellow default pen.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages.add().graphics.drawRectangle(
  ///     pen: PdfPens.lightGoldenrodYellow,
  ///     bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfPen get lightGoldenrodYellow {
    if (_pens.containsKey(_KnownColor.lightGoldenrodYellow)) {
      return _pens[_KnownColor.lightGoldenrodYellow];
    } else {
      return _getPen(_KnownColor.lightGoldenrodYellow);
    }
  }

  /// Gets the LightGray default pen.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages
  ///     .add()
  ///     .graphics
  ///     .drawRectangle(pen: PdfPens.lightGray,
  ///     bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfPen get lightGray {
    if (_pens.containsKey(_KnownColor.lightGray)) {
      return _pens[_KnownColor.lightGray];
    } else {
      return _getPen(_KnownColor.lightGray);
    }
  }

  /// Gets the LightGreen default pen.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages.add().graphics.drawRectangle(
  ///     pen: PdfPens.lightGreen, bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfPen get lightGreen {
    if (_pens.containsKey(_KnownColor.lightGreen)) {
      return _pens[_KnownColor.lightGreen];
    } else {
      return _getPen(_KnownColor.lightGreen);
    }
  }

  /// Gets the LightPink default pen.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages
  ///     .add()
  ///     .graphics
  ///     .drawRectangle(pen: PdfPens.lightPink,
  ///     bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfPen get lightPink {
    if (_pens.containsKey(_KnownColor.lightPink)) {
      return _pens[_KnownColor.lightPink];
    } else {
      return _getPen(_KnownColor.lightPink);
    }
  }

  /// Gets the LightSalmon default pen.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages.add().graphics.drawRectangle(
  ///     pen: PdfPens.lightSalmon, bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfPen get lightSalmon {
    if (_pens.containsKey(_KnownColor.lightSalmon)) {
      return _pens[_KnownColor.lightSalmon];
    } else {
      return _getPen(_KnownColor.lightSalmon);
    }
  }

  /// Gets the LightSeaGreen default pen.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages.add().graphics.drawRectangle(
  ///     pen: PdfPens.lightSeaGreen, bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfPen get lightSeaGreen {
    if (_pens.containsKey(_KnownColor.lightSeaGreen)) {
      return _pens[_KnownColor.lightSeaGreen];
    } else {
      return _getPen(_KnownColor.lightSeaGreen);
    }
  }

  /// Gets the LightSkyBlue default pen.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages.add().graphics.drawRectangle(
  ///     pen: PdfPens.lightSkyBlue, bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfPen get lightSkyBlue {
    if (_pens.containsKey(_KnownColor.lightSkyBlue)) {
      return _pens[_KnownColor.lightSkyBlue];
    } else {
      return _getPen(_KnownColor.lightSkyBlue);
    }
  }

  /// Gets the LightSlateGray default pen.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages.add().graphics.drawRectangle(
  ///     pen: PdfPens.lightSlateGray, bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfPen get lightSlateGray {
    if (_pens.containsKey(_KnownColor.lightSlateGray)) {
      return _pens[_KnownColor.lightSlateGray];
    } else {
      return _getPen(_KnownColor.lightSlateGray);
    }
  }

  /// Gets the LightSteelBlue default pen.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages.add().graphics.drawRectangle(
  ///     pen: PdfPens.lightSteelBlue, bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfPen get lightSteelBlue {
    if (_pens.containsKey(_KnownColor.lightSteelBlue)) {
      return _pens[_KnownColor.lightSteelBlue];
    } else {
      return _getPen(_KnownColor.lightSteelBlue);
    }
  }

  /// Gets the LightYellow default pen.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages.add().graphics.drawRectangle(
  ///     pen: PdfPens.lightYellow, bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfPen get lightYellow {
    if (_pens.containsKey(_KnownColor.lightYellow)) {
      return _pens[_KnownColor.lightYellow];
    } else {
      return _getPen(_KnownColor.lightYellow);
    }
  }

  /// Gets the Lime default pen.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages
  ///     .add()
  ///     .graphics
  ///     .drawRectangle(pen: PdfPens.lime,
  ///     bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfPen get lime {
    if (_pens.containsKey(_KnownColor.lime)) {
      return _pens[_KnownColor.lime];
    } else {
      return _getPen(_KnownColor.lime);
    }
  }

  /// Gets the LimeGreen default pen.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages
  ///     .add()
  ///     .graphics
  ///     .drawRectangle(pen: PdfPens.limeGreen,
  ///     bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfPen get limeGreen {
    if (_pens.containsKey(_KnownColor.limeGreen)) {
      return _pens[_KnownColor.limeGreen];
    } else {
      return _getPen(_KnownColor.limeGreen);
    }
  }

  /// Gets the Linen default pen.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages
  ///     .add()
  ///     .graphics
  ///     .drawRectangle(pen: PdfPens.linen,
  ///     bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfPen get linen {
    if (_pens.containsKey(_KnownColor.linen)) {
      return _pens[_KnownColor.linen];
    } else {
      return _getPen(_KnownColor.linen);
    }
  }

  /// Gets the Magenta default pen.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages
  ///     .add()
  ///     .graphics
  ///     .drawRectangle(pen: PdfPens.magenta,
  ///     bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfPen get magenta {
    if (_pens.containsKey(_KnownColor.magenta)) {
      return _pens[_KnownColor.magenta];
    } else {
      return _getPen(_KnownColor.magenta);
    }
  }

  /// Gets the Maroon default pen.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages
  ///     .add()
  ///     .graphics
  ///     .drawRectangle(pen: PdfPens.maroon,
  ///     bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfPen get maroon {
    if (_pens.containsKey(_KnownColor.maroon)) {
      return _pens[_KnownColor.maroon];
    } else {
      return _getPen(_KnownColor.maroon);
    }
  }

  /// Gets the MediumAquamarine default pen.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages.add().graphics.drawRectangle(
  ///     pen: PdfPens.mediumAquamarine, bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfPen get mediumAquamarine {
    if (_pens.containsKey(_KnownColor.mediumAquamarine)) {
      return _pens[_KnownColor.mediumAquamarine];
    } else {
      return _getPen(_KnownColor.mediumAquamarine);
    }
  }

  /// Gets the MediumBlue default pen.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages.add().graphics.drawRectangle(
  ///     pen: PdfPens.mediumBlue, bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfPen get mediumBlue {
    if (_pens.containsKey(_KnownColor.mediumBlue)) {
      return _pens[_KnownColor.mediumBlue];
    } else {
      return _getPen(_KnownColor.mediumBlue);
    }
  }

  /// Gets the MediumOrchid default pen.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages.add().graphics.drawRectangle(
  ///     pen: PdfPens.mediumOrchid, bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfPen get mediumOrchid {
    if (_pens.containsKey(_KnownColor.mediumOrchid)) {
      return _pens[_KnownColor.mediumOrchid];
    } else {
      return _getPen(_KnownColor.mediumOrchid);
    }
  }

  /// Gets the MediumPurple default pen.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages.add().graphics.drawRectangle(
  ///     pen: PdfPens.mediumPurple, bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfPen get mediumPurple {
    if (_pens.containsKey(_KnownColor.mediumPurple)) {
      return _pens[_KnownColor.mediumPurple];
    } else {
      return _getPen(_KnownColor.mediumPurple);
    }
  }

  /// Gets the MediumSeaGreen default pen.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages.add().graphics.drawRectangle(
  ///     pen: PdfPens.mediumSeaGreen, bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfPen get mediumSeaGreen {
    if (_pens.containsKey(_KnownColor.mediumSeaGreen)) {
      return _pens[_KnownColor.mediumSeaGreen];
    } else {
      return _getPen(_KnownColor.mediumSeaGreen);
    }
  }

  /// Gets the MediumSlateBlue default pen.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages.add().graphics.drawRectangle(
  ///     pen: PdfPens.mediumSlateBlue, bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfPen get mediumSlateBlue {
    if (_pens.containsKey(_KnownColor.mediumSlateBlue)) {
      return _pens[_KnownColor.mediumSlateBlue];
    } else {
      return _getPen(_KnownColor.mediumSlateBlue);
    }
  }

  /// Gets the MediumSpringGreen default pen.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages.add().graphics.drawRectangle(
  ///     pen: PdfPens.mediumSpringGreen, bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfPen get mediumSpringGreen {
    if (_pens.containsKey(_KnownColor.mediumSpringGreen)) {
      return _pens[_KnownColor.mediumSpringGreen];
    } else {
      return _getPen(_KnownColor.mediumSpringGreen);
    }
  }

  /// Gets the MediumTurquoise default pen.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages.add().graphics.drawRectangle(
  ///     pen: PdfPens.mediumTurquoise, bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfPen get mediumTurquoise {
    if (_pens.containsKey(_KnownColor.mediumTurquoise)) {
      return _pens[_KnownColor.mediumTurquoise];
    } else {
      return _getPen(_KnownColor.mediumTurquoise);
    }
  }

  /// Gets the MediumVioletRed default pen.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages.add().graphics.drawRectangle(
  ///     pen: PdfPens.mediumVioletRed, bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfPen get mediumVioletRed {
    if (_pens.containsKey(_KnownColor.mediumVioletRed)) {
      return _pens[_KnownColor.mediumVioletRed];
    } else {
      return _getPen(_KnownColor.mediumVioletRed);
    }
  }

  /// Gets the MidnightBlue default pen.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages.add().graphics.drawRectangle(
  ///     pen: PdfPens.midnightBlue, bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfPen get midnightBlue {
    if (_pens.containsKey(_KnownColor.midnightBlue)) {
      return _pens[_KnownColor.midnightBlue];
    } else {
      return _getPen(_KnownColor.midnightBlue);
    }
  }

  /// Gets the MintCream default pen.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages
  ///     .add()
  ///     .graphics
  ///     .drawRectangle(pen: PdfPens.mintCream,
  ///     bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfPen get mintCream {
    if (_pens.containsKey(_KnownColor.mintCream)) {
      return _pens[_KnownColor.mintCream];
    } else {
      return _getPen(_KnownColor.mintCream);
    }
  }

  /// Gets the MistyRose default pen.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages
  ///     .add()
  ///     .graphics
  ///     .drawRectangle(pen: PdfPens.mistyRose,
  ///     bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfPen get mistyRose {
    if (_pens.containsKey(_KnownColor.mistyRose)) {
      return _pens[_KnownColor.mistyRose];
    } else {
      return _getPen(_KnownColor.mistyRose);
    }
  }

  /// Gets the Moccasin default pen.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages
  ///     .add()
  ///     .graphics
  ///     .drawRectangle(pen: PdfPens.moccasin, bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfPen get moccasin {
    if (_pens.containsKey(_KnownColor.moccasin)) {
      return _pens[_KnownColor.moccasin];
    } else {
      return _getPen(_KnownColor.moccasin);
    }
  }

  /// Gets the NavajoWhite default pen.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages.add().graphics.drawRectangle(
  ///     pen: PdfPens.navajoWhite, bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfPen get navajoWhite {
    if (_pens.containsKey(_KnownColor.navajoWhite)) {
      return _pens[_KnownColor.navajoWhite];
    } else {
      return _getPen(_KnownColor.navajoWhite);
    }
  }

  /// Gets the Navy default pen.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages
  ///     .add()
  ///     .graphics
  ///     .drawRectangle(pen: PdfPens.navy,
  ///     bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfPen get navy {
    if (_pens.containsKey(_KnownColor.navy)) {
      return _pens[_KnownColor.navy];
    } else {
      return _getPen(_KnownColor.navy);
    }
  }

  /// Gets the OldLace default pen.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages
  ///     .add()
  ///     .graphics
  ///     .drawRectangle(pen: PdfPens.oldLace,
  ///     bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfPen get oldLace {
    if (_pens.containsKey(_KnownColor.oldLace)) {
      return _pens[_KnownColor.oldLace];
    } else {
      return _getPen(_KnownColor.oldLace);
    }
  }

  /// Gets the Olive default pen.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages
  ///     .add()
  ///     .graphics
  ///     .drawRectangle(pen: PdfPens.olive,
  ///     bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfPen get olive {
    if (_pens.containsKey(_KnownColor.olive)) {
      return _pens[_KnownColor.olive];
    } else {
      return _getPen(_KnownColor.olive);
    }
  }

  /// Gets the OliveDrab default pen.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages
  ///     .add()
  ///     .graphics
  ///     .drawRectangle(pen: PdfPens.oliveDrab, bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfPen get oliveDrab {
    if (_pens.containsKey(_KnownColor.oliveDrab)) {
      return _pens[_KnownColor.oliveDrab];
    } else {
      return _getPen(_KnownColor.oliveDrab);
    }
  }

  /// Gets the Orange default pen.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages
  ///     .add()
  ///     .graphics
  ///     .drawRectangle(pen: PdfPens.orange, bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfPen get orange {
    if (_pens.containsKey(_KnownColor.orange)) {
      return _pens[_KnownColor.orange];
    } else {
      return _getPen(_KnownColor.orange);
    }
  }

  /// Gets the OrangeRed default pen.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages
  ///     .add()
  ///     .graphics
  ///     .drawRectangle(pen: PdfPens.orangeRed, bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfPen get orangeRed {
    if (_pens.containsKey(_KnownColor.orangeRed)) {
      return _pens[_KnownColor.orangeRed];
    } else {
      return _getPen(_KnownColor.orangeRed);
    }
  }

  /// Gets the Orchid default pen.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages
  ///     .add()
  ///     .graphics
  ///     .drawRectangle(pen: PdfPens.orchid,
  ///     bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfPen get orchid {
    if (_pens.containsKey(_KnownColor.orchid)) {
      return _pens[_KnownColor.orchid];
    } else {
      return _getPen(_KnownColor.orchid);
    }
  }

  /// Gets the PaleGoldenrod default pen.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages.add().graphics.drawRectangle(
  ///     pen: PdfPens.paleGoldenrod, bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfPen get paleGoldenrod {
    if (_pens.containsKey(_KnownColor.paleGoldenrod)) {
      return _pens[_KnownColor.paleGoldenrod];
    } else {
      return _getPen(_KnownColor.paleGoldenrod);
    }
  }

  /// Gets the PaleGreen default pen.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages
  ///     .add()
  ///     .graphics
  ///     .drawRectangle(pen: PdfPens.paleGreen, bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfPen get paleGreen {
    if (_pens.containsKey(_KnownColor.paleGreen)) {
      return _pens[_KnownColor.paleGreen];
    } else {
      return _getPen(_KnownColor.paleGreen);
    }
  }

  /// Gets the PaleTurquoise default pen.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages.add().graphics.drawRectangle(
  ///     pen: PdfPens.paleTurquoise, bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfPen get paleTurquoise {
    if (_pens.containsKey(_KnownColor.paleTurquoise)) {
      return _pens[_KnownColor.paleTurquoise];
    } else {
      return _getPen(_KnownColor.paleTurquoise);
    }
  }

  /// Gets the PaleVioletRed default pen.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages.add().graphics.drawRectangle(
  ///     pen: PdfPens.paleVioletRed, bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfPen get paleVioletRed {
    if (_pens.containsKey(_KnownColor.paleVioletRed)) {
      return _pens[_KnownColor.paleVioletRed];
    } else {
      return _getPen(_KnownColor.paleVioletRed);
    }
  }

  /// Gets the PapayaWhip default pen.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages.add().graphics.drawRectangle(
  ///     pen: PdfPens.papayaWhip, bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfPen get papayaWhip {
    if (_pens.containsKey(_KnownColor.papayaWhip)) {
      return _pens[_KnownColor.papayaWhip];
    } else {
      return _getPen(_KnownColor.papayaWhip);
    }
  }

  /// Gets the PeachPuff default pen.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages
  ///     .add()
  ///     .graphics
  ///     .drawRectangle(pen: PdfPens.peachPuff, bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfPen get peachPuff {
    if (_pens.containsKey(_KnownColor.peachPuff)) {
      return _pens[_KnownColor.peachPuff];
    } else {
      return _getPen(_KnownColor.peachPuff);
    }
  }

  /// Gets the Peru default pen.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages
  ///     .add()
  ///     .graphics
  ///     .drawRectangle(pen: PdfPens.peru,
  ///     bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfPen get peru {
    if (_pens.containsKey(_KnownColor.peru)) {
      return _pens[_KnownColor.peru];
    } else {
      return _getPen(_KnownColor.peru);
    }
  }

  /// Gets the Pink default pen.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages
  ///     .add()
  ///     .graphics
  ///     .drawRectangle(pen: PdfPens.pink, bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfPen get pink {
    if (_pens.containsKey(_KnownColor.pink)) {
      return _pens[_KnownColor.pink];
    } else {
      return _getPen(_KnownColor.pink);
    }
  }

  /// Gets the Plum default pen.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages
  ///     .add()
  ///     .graphics
  ///     .drawRectangle(pen: PdfPens.plum, bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfPen get plum {
    if (_pens.containsKey(_KnownColor.plum)) {
      return _pens[_KnownColor.plum];
    } else {
      return _getPen(_KnownColor.plum);
    }
  }

  /// Gets the PowderBlue default pen.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages.add().graphics.drawRectangle(
  ///     pen: PdfPens.powderBlue, bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfPen get powderBlue {
    if (_pens.containsKey(_KnownColor.powderBlue)) {
      return _pens[_KnownColor.powderBlue];
    } else {
      return _getPen(_KnownColor.powderBlue);
    }
  }

  /// Gets the Purple default pen.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages
  ///     .add()
  ///     .graphics
  ///     .drawRectangle(pen: PdfPens.purple, bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfPen get purple {
    if (_pens.containsKey(_KnownColor.purple)) {
      return _pens[_KnownColor.purple];
    } else {
      return _getPen(_KnownColor.purple);
    }
  }

  /// Gets the Red default pen.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages
  ///     .add()
  ///     .graphics
  ///     .drawRectangle(pen: PdfPens.red, bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfPen get red {
    if (_pens.containsKey(_KnownColor.red)) {
      return _pens[_KnownColor.red];
    } else {
      return _getPen(_KnownColor.red);
    }
  }

  /// Gets the RosyBrown default pen.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages
  ///     .add()
  ///     .graphics
  ///     .drawRectangle(pen: PdfPens.rosyBrown, bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfPen get rosyBrown {
    if (_pens.containsKey(_KnownColor.rosyBrown)) {
      return _pens[_KnownColor.rosyBrown];
    } else {
      return _getPen(_KnownColor.rosyBrown);
    }
  }

  /// Gets the RoyalBlue default pen.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages
  ///     .add()
  ///     .graphics
  ///     .drawRectangle(pen: PdfPens.royalBlue, bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfPen get royalBlue {
    if (_pens.containsKey(_KnownColor.royalBlue)) {
      return _pens[_KnownColor.royalBlue];
    } else {
      return _getPen(_KnownColor.royalBlue);
    }
  }

  /// Gets the SaddleBrown default pen.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages.add().graphics.drawRectangle(
  ///     pen: PdfPens.saddleBrown, bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfPen get saddleBrown {
    if (_pens.containsKey(_KnownColor.saddleBrown)) {
      return _pens[_KnownColor.saddleBrown];
    } else {
      return _getPen(_KnownColor.saddleBrown);
    }
  }

  /// Gets the Salmon default pen.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages
  ///     .add()
  ///     .graphics
  ///     .drawRectangle(pen: PdfPens.salmon, bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfPen get salmon {
    if (_pens.containsKey(_KnownColor.salmon)) {
      return _pens[_KnownColor.salmon];
    } else {
      return _getPen(_KnownColor.salmon);
    }
  }

  /// Gets the SandyBrown default pen.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages.add().graphics.drawRectangle(
  ///     pen: PdfPens.sandyBrown, bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfPen get sandyBrown {
    if (_pens.containsKey(_KnownColor.sandyBrown)) {
      return _pens[_KnownColor.sandyBrown];
    } else {
      return _getPen(_KnownColor.sandyBrown);
    }
  }

  /// Gets the SeaGreen default pen.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages
  ///     .add()
  ///     .graphics
  ///     .drawRectangle(pen: PdfPens.seaGreen, bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfPen get seaGreen {
    if (_pens.containsKey(_KnownColor.seaGreen)) {
      return _pens[_KnownColor.seaGreen];
    } else {
      return _getPen(_KnownColor.seaGreen);
    }
  }

  /// Gets the SeaShell default pen.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages
  ///     .add()
  ///     .graphics
  ///     .drawRectangle(pen: PdfPens.seaShell, bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfPen get seaShell {
    if (_pens.containsKey(_KnownColor.seaShell)) {
      return _pens[_KnownColor.seaShell];
    } else {
      return _getPen(_KnownColor.seaShell);
    }
  }

  /// Gets the Sienna default pen.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages
  ///     .add()
  ///     .graphics
  ///     .drawRectangle(pen: PdfPens.sienna, bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfPen get sienna {
    if (_pens.containsKey(_KnownColor.sienna)) {
      return _pens[_KnownColor.sienna];
    } else {
      return _getPen(_KnownColor.sienna);
    }
  }

  /// Gets the Silver default pen.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages
  ///     .add()
  ///     .graphics
  ///     .drawRectangle(pen: PdfPens.silver, bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfPen get silver {
    if (_pens.containsKey(_KnownColor.silver)) {
      return _pens[_KnownColor.silver];
    } else {
      return _getPen(_KnownColor.silver);
    }
  }

  /// Gets the SkyBlue default pen.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages
  ///     .add()
  ///     .graphics
  ///     .drawRectangle(pen: PdfPens.skyBlue, bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfPen get skyBlue {
    if (_pens.containsKey(_KnownColor.skyBlue)) {
      return _pens[_KnownColor.skyBlue];
    } else {
      return _getPen(_KnownColor.skyBlue);
    }
  }

  /// Gets the SlateBlue default pen.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages
  ///     .add()
  ///     .graphics
  ///     .drawRectangle(pen: PdfPens.slateBlue, bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfPen get slateBlue {
    if (_pens.containsKey(_KnownColor.slateBlue)) {
      return _pens[_KnownColor.slateBlue];
    } else {
      return _getPen(_KnownColor.slateBlue);
    }
  }

  /// Gets the SlateGray default pen.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages
  ///     .add()
  ///     .graphics
  ///     .drawRectangle(pen: PdfPens.slateGray, bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfPen get slateGray {
    if (_pens.containsKey(_KnownColor.slateGray)) {
      return _pens[_KnownColor.slateGray];
    } else {
      return _getPen(_KnownColor.slateGray);
    }
  }

  /// Gets the Snow default pen.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages
  ///     .add()
  ///     .graphics
  ///     .drawRectangle(pen: PdfPens.snow, bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfPen get snow {
    if (_pens.containsKey(_KnownColor.snow)) {
      return _pens[_KnownColor.snow];
    } else {
      return _getPen(_KnownColor.snow);
    }
  }

  /// Gets the SpringGreen default pen.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages.add().graphics.drawRectangle(
  ///     pen: PdfPens.springGreen, bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfPen get springGreen {
    if (_pens.containsKey(_KnownColor.springGreen)) {
      return _pens[_KnownColor.springGreen];
    } else {
      return _getPen(_KnownColor.springGreen);
    }
  }

  /// Gets the SteelBlue default pen.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages
  ///     .add()
  ///     .graphics
  ///     .drawRectangle(pen: PdfPens.steelBlue, bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfPen get steelBlue {
    if (_pens.containsKey(_KnownColor.steelBlue)) {
      return _pens[_KnownColor.steelBlue];
    } else {
      return _getPen(_KnownColor.steelBlue);
    }
  }

  /// Gets the Tan default pen.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages
  ///     .add()
  ///     .graphics
  ///     .drawRectangle(pen: PdfPens.tan, bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfPen get tan {
    if (_pens.containsKey(_KnownColor.tan)) {
      return _pens[_KnownColor.tan];
    } else {
      return _getPen(_KnownColor.tan);
    }
  }

  /// Gets the Teal default pen.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages
  ///     .add()
  ///     .graphics
  ///     .drawRectangle(pen: PdfPens.teal, bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfPen get teal {
    if (_pens.containsKey(_KnownColor.teal)) {
      return _pens[_KnownColor.teal];
    } else {
      return _getPen(_KnownColor.teal);
    }
  }

  /// Gets the Thistle default pen.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages
  ///     .add()
  ///     .graphics
  ///     .drawRectangle(pen: PdfPens.thistle, bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfPen get thistle {
    if (_pens.containsKey(_KnownColor.thistle)) {
      return _pens[_KnownColor.thistle];
    } else {
      return _getPen(_KnownColor.thistle);
    }
  }

  /// Gets the Tomato default pen.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages
  ///     .add()
  ///     .graphics
  ///     .drawRectangle(pen: PdfPens.tomato, bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfPen get tomato {
    if (_pens.containsKey(_KnownColor.tomato)) {
      return _pens[_KnownColor.tomato];
    } else {
      return _getPen(_KnownColor.tomato);
    }
  }

  /// Gets the Transparent default pen.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages.add().graphics.drawRectangle(
  ///     pen: PdfPens.transparent, bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfPen get transparent {
    if (_pens.containsKey(_KnownColor.transparent)) {
      return _pens[_KnownColor.transparent];
    } else {
      return _getPen(_KnownColor.transparent);
    }
  }

  /// Gets the Turquoise default pen.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages
  ///     .add()
  ///     .graphics
  ///     .drawRectangle(pen: PdfPens.turquoise, bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfPen get turquoise {
    if (_pens.containsKey(_KnownColor.turquoise)) {
      return _pens[_KnownColor.turquoise];
    } else {
      return _getPen(_KnownColor.turquoise);
    }
  }

  /// Gets the Violet default pen.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages
  ///     .add()
  ///     .graphics
  ///     .drawRectangle(pen: PdfPens.violet, bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfPen get violet {
    if (_pens.containsKey(_KnownColor.violet)) {
      return _pens[_KnownColor.violet];
    } else {
      return _getPen(_KnownColor.violet);
    }
  }

  /// Gets the Wheat default pen.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages
  ///     .add()
  ///     .graphics
  ///     .drawRectangle(pen: PdfPens.wheat, bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfPen get wheat {
    if (_pens.containsKey(_KnownColor.wheat)) {
      return _pens[_KnownColor.wheat];
    } else {
      return _getPen(_KnownColor.wheat);
    }
  }

  /// Gets the White default pen.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages
  ///     .add()
  ///     .graphics
  ///     .drawRectangle(pen: PdfPens.white, bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfPen get white {
    if (_pens.containsKey(_KnownColor.white)) {
      return _pens[_KnownColor.white];
    } else {
      return _getPen(_KnownColor.white);
    }
  }

  /// Gets the WhiteSmoke default pen.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages.add().graphics.drawRectangle(
  ///     pen: PdfPens.whiteSmoke, bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfPen get whiteSmoke {
    if (_pens.containsKey(_KnownColor.whiteSmoke)) {
      return _pens[_KnownColor.whiteSmoke];
    } else {
      return _getPen(_KnownColor.whiteSmoke);
    }
  }

  /// Gets the Yellow default pen.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages
  ///     .add()
  ///     .graphics
  ///     .drawRectangle(pen: PdfPens.yellow, bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfPen get yellow {
    if (_pens.containsKey(_KnownColor.yellow)) {
      return _pens[_KnownColor.yellow];
    } else {
      return _getPen(_KnownColor.yellow);
    }
  }

  /// Gets the YellowGreen default pen.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw rectangle.
  /// doc.pages.add().graphics.drawRectangle(
  ///     pen: PdfPens.yellowGreen, bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  static PdfPen get yellowGreen {
    if (_pens.containsKey(_KnownColor.yellowGreen)) {
      return _pens[_KnownColor.yellowGreen];
    } else {
      return _getPen(_KnownColor.yellowGreen);
    }
  }

  static PdfPen _getPen(_KnownColor kColor) {
    final _Color color = _Color(kColor);
    final PdfPen pen = PdfPen._immutable(PdfColor(color.r, color.g, color.b));
    _pens[kColor] = pen;
    return pen;
  }

  static void _dispose() {
    _pens.clear();
  }
}
