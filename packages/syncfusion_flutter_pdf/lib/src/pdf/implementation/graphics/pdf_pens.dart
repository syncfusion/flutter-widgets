import '../drawing/color.dart';
import 'pdf_color.dart';
import 'pdf_pen.dart';

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
/// //Save the document.
/// List<int> bytes = doc.save();
/// //Dispose the document.
/// doc.dispose();
/// ```
class PdfPens {
  PdfPens._();
  static final Map<KnownColor, PdfPen> _pens = <KnownColor, PdfPen>{};

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
    if (_pens.containsKey(KnownColor.aliceBlue)) {
      return _pens[KnownColor.aliceBlue]!;
    } else {
      return _getPen(KnownColor.aliceBlue);
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
    if (_pens.containsKey(KnownColor.antiqueWhite)) {
      return _pens[KnownColor.antiqueWhite]!;
    } else {
      return _getPen(KnownColor.antiqueWhite);
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
    if (_pens.containsKey(KnownColor.aqua)) {
      return _pens[KnownColor.aqua]!;
    } else {
      return _getPen(KnownColor.aqua);
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
    if (_pens.containsKey(KnownColor.aquamarine)) {
      return _pens[KnownColor.aquamarine]!;
    } else {
      return _getPen(KnownColor.aquamarine);
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
    if (_pens.containsKey(KnownColor.azure)) {
      return _pens[KnownColor.azure]!;
    } else {
      return _getPen(KnownColor.azure);
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
    if (_pens.containsKey(KnownColor.beige)) {
      return _pens[KnownColor.beige]!;
    } else {
      return _getPen(KnownColor.beige);
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
    if (_pens.containsKey(KnownColor.bisque)) {
      return _pens[KnownColor.bisque]!;
    } else {
      return _getPen(KnownColor.bisque);
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
    if (_pens.containsKey(KnownColor.black)) {
      return _pens[KnownColor.black]!;
    } else {
      return _getPen(KnownColor.black);
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
    if (_pens.containsKey(KnownColor.blanchedAlmond)) {
      return _pens[KnownColor.blanchedAlmond]!;
    } else {
      return _getPen(KnownColor.blanchedAlmond);
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
    if (_pens.containsKey(KnownColor.blue)) {
      return _pens[KnownColor.blue]!;
    } else {
      return _getPen(KnownColor.blue);
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
    if (_pens.containsKey(KnownColor.blueViolet)) {
      return _pens[KnownColor.blueViolet]!;
    } else {
      return _getPen(KnownColor.blueViolet);
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
    if (_pens.containsKey(KnownColor.brown)) {
      return _pens[KnownColor.brown]!;
    } else {
      return _getPen(KnownColor.brown);
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
    if (_pens.containsKey(KnownColor.burlyWood)) {
      return _pens[KnownColor.burlyWood]!;
    } else {
      return _getPen(KnownColor.burlyWood);
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
    if (_pens.containsKey(KnownColor.cadetBlue)) {
      return _pens[KnownColor.cadetBlue]!;
    } else {
      return _getPen(KnownColor.cadetBlue);
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
    if (_pens.containsKey(KnownColor.chartreuse)) {
      return _pens[KnownColor.chartreuse]!;
    } else {
      return _getPen(KnownColor.chartreuse);
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
    if (_pens.containsKey(KnownColor.chocolate)) {
      return _pens[KnownColor.chocolate]!;
    } else {
      return _getPen(KnownColor.chocolate);
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
    if (_pens.containsKey(KnownColor.coral)) {
      return _pens[KnownColor.coral]!;
    } else {
      return _getPen(KnownColor.coral);
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
    if (_pens.containsKey(KnownColor.cornflowerBlue)) {
      return _pens[KnownColor.cornflowerBlue]!;
    } else {
      return _getPen(KnownColor.cornflowerBlue);
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
    if (_pens.containsKey(KnownColor.cornsilk)) {
      return _pens[KnownColor.cornsilk]!;
    } else {
      return _getPen(KnownColor.cornsilk);
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
    if (_pens.containsKey(KnownColor.crimson)) {
      return _pens[KnownColor.crimson]!;
    } else {
      return _getPen(KnownColor.crimson);
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
    if (_pens.containsKey(KnownColor.cyan)) {
      return _pens[KnownColor.cyan]!;
    } else {
      return _getPen(KnownColor.cyan);
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
    if (_pens.containsKey(KnownColor.darkBlue)) {
      return _pens[KnownColor.darkBlue]!;
    } else {
      return _getPen(KnownColor.darkBlue);
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
    if (_pens.containsKey(KnownColor.darkCyan)) {
      return _pens[KnownColor.darkCyan]!;
    } else {
      return _getPen(KnownColor.darkCyan);
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
    if (_pens.containsKey(KnownColor.darkGoldenrod)) {
      return _pens[KnownColor.darkGoldenrod]!;
    } else {
      return _getPen(KnownColor.darkGoldenrod);
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
    if (_pens.containsKey(KnownColor.darkGray)) {
      return _pens[KnownColor.darkGray]!;
    } else {
      return _getPen(KnownColor.darkGray);
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
    if (_pens.containsKey(KnownColor.darkGreen)) {
      return _pens[KnownColor.darkGreen]!;
    } else {
      return _getPen(KnownColor.darkGreen);
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
    if (_pens.containsKey(KnownColor.darkKhaki)) {
      return _pens[KnownColor.darkKhaki]!;
    } else {
      return _getPen(KnownColor.darkKhaki);
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
    if (_pens.containsKey(KnownColor.darkMagenta)) {
      return _pens[KnownColor.darkMagenta]!;
    } else {
      return _getPen(KnownColor.darkMagenta);
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
    if (_pens.containsKey(KnownColor.darkOliveGreen)) {
      return _pens[KnownColor.darkOliveGreen]!;
    } else {
      return _getPen(KnownColor.darkOliveGreen);
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
    if (_pens.containsKey(KnownColor.darkOrange)) {
      return _pens[KnownColor.darkOrange]!;
    } else {
      return _getPen(KnownColor.darkOrange);
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
    if (_pens.containsKey(KnownColor.darkOrchid)) {
      return _pens[KnownColor.darkOrchid]!;
    } else {
      return _getPen(KnownColor.darkOrchid);
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
    if (_pens.containsKey(KnownColor.darkRed)) {
      return _pens[KnownColor.darkRed]!;
    } else {
      return _getPen(KnownColor.darkRed);
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
    if (_pens.containsKey(KnownColor.darkSalmon)) {
      return _pens[KnownColor.darkSalmon]!;
    } else {
      return _getPen(KnownColor.darkSalmon);
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
    if (_pens.containsKey(KnownColor.darkSeaGreen)) {
      return _pens[KnownColor.darkSeaGreen]!;
    } else {
      return _getPen(KnownColor.darkSeaGreen);
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
    if (_pens.containsKey(KnownColor.darkSlateBlue)) {
      return _pens[KnownColor.darkSlateBlue]!;
    } else {
      return _getPen(KnownColor.darkSlateBlue);
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
    if (_pens.containsKey(KnownColor.darkSlateGray)) {
      return _pens[KnownColor.darkSlateGray]!;
    } else {
      return _getPen(KnownColor.darkSlateGray);
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
    if (_pens.containsKey(KnownColor.darkTurquoise)) {
      return _pens[KnownColor.darkTurquoise]!;
    } else {
      return _getPen(KnownColor.darkTurquoise);
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
    if (_pens.containsKey(KnownColor.darkViolet)) {
      return _pens[KnownColor.darkViolet]!;
    } else {
      return _getPen(KnownColor.darkViolet);
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
    if (_pens.containsKey(KnownColor.deepPink)) {
      return _pens[KnownColor.deepPink]!;
    } else {
      return _getPen(KnownColor.deepPink);
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
    if (_pens.containsKey(KnownColor.deepSkyBlue)) {
      return _pens[KnownColor.deepSkyBlue]!;
    } else {
      return _getPen(KnownColor.deepSkyBlue);
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
    if (_pens.containsKey(KnownColor.dimGray)) {
      return _pens[KnownColor.dimGray]!;
    } else {
      return _getPen(KnownColor.dimGray);
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
    if (_pens.containsKey(KnownColor.dodgerBlue)) {
      return _pens[KnownColor.dodgerBlue]!;
    } else {
      return _getPen(KnownColor.dodgerBlue);
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
    if (_pens.containsKey(KnownColor.firebrick)) {
      return _pens[KnownColor.firebrick]!;
    } else {
      return _getPen(KnownColor.firebrick);
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
    if (_pens.containsKey(KnownColor.floralWhite)) {
      return _pens[KnownColor.floralWhite]!;
    } else {
      return _getPen(KnownColor.floralWhite);
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
    if (_pens.containsKey(KnownColor.forestGreen)) {
      return _pens[KnownColor.forestGreen]!;
    } else {
      return _getPen(KnownColor.forestGreen);
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
    if (_pens.containsKey(KnownColor.fuchsia)) {
      return _pens[KnownColor.fuchsia]!;
    } else {
      return _getPen(KnownColor.fuchsia);
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
    if (_pens.containsKey(KnownColor.gainsboro)) {
      return _pens[KnownColor.gainsboro]!;
    } else {
      return _getPen(KnownColor.gainsboro);
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
    if (_pens.containsKey(KnownColor.ghostWhite)) {
      return _pens[KnownColor.ghostWhite]!;
    } else {
      return _getPen(KnownColor.ghostWhite);
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
    if (_pens.containsKey(KnownColor.gold)) {
      return _pens[KnownColor.gold]!;
    } else {
      return _getPen(KnownColor.gold);
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
    if (_pens.containsKey(KnownColor.goldenrod)) {
      return _pens[KnownColor.goldenrod]!;
    } else {
      return _getPen(KnownColor.goldenrod);
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
    if (_pens.containsKey(KnownColor.gray)) {
      return _pens[KnownColor.gray]!;
    } else {
      return _getPen(KnownColor.gray);
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
    if (_pens.containsKey(KnownColor.green)) {
      return _pens[KnownColor.green]!;
    } else {
      return _getPen(KnownColor.green);
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
    if (_pens.containsKey(KnownColor.greenYellow)) {
      return _pens[KnownColor.greenYellow]!;
    } else {
      return _getPen(KnownColor.greenYellow);
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
    if (_pens.containsKey(KnownColor.honeydew)) {
      return _pens[KnownColor.honeydew]!;
    } else {
      return _getPen(KnownColor.honeydew);
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
    if (_pens.containsKey(KnownColor.hotPink)) {
      return _pens[KnownColor.hotPink]!;
    } else {
      return _getPen(KnownColor.hotPink);
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
    if (_pens.containsKey(KnownColor.indianRed)) {
      return _pens[KnownColor.indianRed]!;
    } else {
      return _getPen(KnownColor.indianRed);
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
    if (_pens.containsKey(KnownColor.indigo)) {
      return _pens[KnownColor.indigo]!;
    } else {
      return _getPen(KnownColor.indigo);
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
    if (_pens.containsKey(KnownColor.ivory)) {
      return _pens[KnownColor.ivory]!;
    } else {
      return _getPen(KnownColor.ivory);
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
    if (_pens.containsKey(KnownColor.khaki)) {
      return _pens[KnownColor.khaki]!;
    } else {
      return _getPen(KnownColor.khaki);
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
    if (_pens.containsKey(KnownColor.lavender)) {
      return _pens[KnownColor.lavender]!;
    } else {
      return _getPen(KnownColor.lavender);
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
    if (_pens.containsKey(KnownColor.lavenderBlush)) {
      return _pens[KnownColor.lavenderBlush]!;
    } else {
      return _getPen(KnownColor.lavenderBlush);
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
    if (_pens.containsKey(KnownColor.lawnGreen)) {
      return _pens[KnownColor.lawnGreen]!;
    } else {
      return _getPen(KnownColor.lawnGreen);
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
    if (_pens.containsKey(KnownColor.lemonChiffon)) {
      return _pens[KnownColor.lemonChiffon]!;
    } else {
      return _getPen(KnownColor.lemonChiffon);
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
    if (_pens.containsKey(KnownColor.lightBlue)) {
      return _pens[KnownColor.lightBlue]!;
    } else {
      return _getPen(KnownColor.lightBlue);
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
    if (_pens.containsKey(KnownColor.lightCoral)) {
      return _pens[KnownColor.lightCoral]!;
    } else {
      return _getPen(KnownColor.lightCoral);
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
    if (_pens.containsKey(KnownColor.lightCyan)) {
      return _pens[KnownColor.lightCyan]!;
    } else {
      return _getPen(KnownColor.lightCyan);
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
    if (_pens.containsKey(KnownColor.lightGoldenrodYellow)) {
      return _pens[KnownColor.lightGoldenrodYellow]!;
    } else {
      return _getPen(KnownColor.lightGoldenrodYellow);
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
    if (_pens.containsKey(KnownColor.lightGray)) {
      return _pens[KnownColor.lightGray]!;
    } else {
      return _getPen(KnownColor.lightGray);
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
    if (_pens.containsKey(KnownColor.lightGreen)) {
      return _pens[KnownColor.lightGreen]!;
    } else {
      return _getPen(KnownColor.lightGreen);
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
    if (_pens.containsKey(KnownColor.lightPink)) {
      return _pens[KnownColor.lightPink]!;
    } else {
      return _getPen(KnownColor.lightPink);
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
    if (_pens.containsKey(KnownColor.lightSalmon)) {
      return _pens[KnownColor.lightSalmon]!;
    } else {
      return _getPen(KnownColor.lightSalmon);
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
    if (_pens.containsKey(KnownColor.lightSeaGreen)) {
      return _pens[KnownColor.lightSeaGreen]!;
    } else {
      return _getPen(KnownColor.lightSeaGreen);
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
    if (_pens.containsKey(KnownColor.lightSkyBlue)) {
      return _pens[KnownColor.lightSkyBlue]!;
    } else {
      return _getPen(KnownColor.lightSkyBlue);
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
    if (_pens.containsKey(KnownColor.lightSlateGray)) {
      return _pens[KnownColor.lightSlateGray]!;
    } else {
      return _getPen(KnownColor.lightSlateGray);
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
    if (_pens.containsKey(KnownColor.lightSteelBlue)) {
      return _pens[KnownColor.lightSteelBlue]!;
    } else {
      return _getPen(KnownColor.lightSteelBlue);
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
    if (_pens.containsKey(KnownColor.lightYellow)) {
      return _pens[KnownColor.lightYellow]!;
    } else {
      return _getPen(KnownColor.lightYellow);
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
    if (_pens.containsKey(KnownColor.lime)) {
      return _pens[KnownColor.lime]!;
    } else {
      return _getPen(KnownColor.lime);
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
    if (_pens.containsKey(KnownColor.limeGreen)) {
      return _pens[KnownColor.limeGreen]!;
    } else {
      return _getPen(KnownColor.limeGreen);
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
    if (_pens.containsKey(KnownColor.linen)) {
      return _pens[KnownColor.linen]!;
    } else {
      return _getPen(KnownColor.linen);
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
    if (_pens.containsKey(KnownColor.magenta)) {
      return _pens[KnownColor.magenta]!;
    } else {
      return _getPen(KnownColor.magenta);
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
    if (_pens.containsKey(KnownColor.maroon)) {
      return _pens[KnownColor.maroon]!;
    } else {
      return _getPen(KnownColor.maroon);
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
    if (_pens.containsKey(KnownColor.mediumAquamarine)) {
      return _pens[KnownColor.mediumAquamarine]!;
    } else {
      return _getPen(KnownColor.mediumAquamarine);
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
    if (_pens.containsKey(KnownColor.mediumBlue)) {
      return _pens[KnownColor.mediumBlue]!;
    } else {
      return _getPen(KnownColor.mediumBlue);
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
    if (_pens.containsKey(KnownColor.mediumOrchid)) {
      return _pens[KnownColor.mediumOrchid]!;
    } else {
      return _getPen(KnownColor.mediumOrchid);
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
    if (_pens.containsKey(KnownColor.mediumPurple)) {
      return _pens[KnownColor.mediumPurple]!;
    } else {
      return _getPen(KnownColor.mediumPurple);
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
    if (_pens.containsKey(KnownColor.mediumSeaGreen)) {
      return _pens[KnownColor.mediumSeaGreen]!;
    } else {
      return _getPen(KnownColor.mediumSeaGreen);
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
    if (_pens.containsKey(KnownColor.mediumSlateBlue)) {
      return _pens[KnownColor.mediumSlateBlue]!;
    } else {
      return _getPen(KnownColor.mediumSlateBlue);
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
    if (_pens.containsKey(KnownColor.mediumSpringGreen)) {
      return _pens[KnownColor.mediumSpringGreen]!;
    } else {
      return _getPen(KnownColor.mediumSpringGreen);
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
    if (_pens.containsKey(KnownColor.mediumTurquoise)) {
      return _pens[KnownColor.mediumTurquoise]!;
    } else {
      return _getPen(KnownColor.mediumTurquoise);
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
    if (_pens.containsKey(KnownColor.mediumVioletRed)) {
      return _pens[KnownColor.mediumVioletRed]!;
    } else {
      return _getPen(KnownColor.mediumVioletRed);
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
    if (_pens.containsKey(KnownColor.midnightBlue)) {
      return _pens[KnownColor.midnightBlue]!;
    } else {
      return _getPen(KnownColor.midnightBlue);
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
    if (_pens.containsKey(KnownColor.mintCream)) {
      return _pens[KnownColor.mintCream]!;
    } else {
      return _getPen(KnownColor.mintCream);
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
    if (_pens.containsKey(KnownColor.mistyRose)) {
      return _pens[KnownColor.mistyRose]!;
    } else {
      return _getPen(KnownColor.mistyRose);
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
    if (_pens.containsKey(KnownColor.moccasin)) {
      return _pens[KnownColor.moccasin]!;
    } else {
      return _getPen(KnownColor.moccasin);
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
    if (_pens.containsKey(KnownColor.navajoWhite)) {
      return _pens[KnownColor.navajoWhite]!;
    } else {
      return _getPen(KnownColor.navajoWhite);
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
    if (_pens.containsKey(KnownColor.navy)) {
      return _pens[KnownColor.navy]!;
    } else {
      return _getPen(KnownColor.navy);
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
    if (_pens.containsKey(KnownColor.oldLace)) {
      return _pens[KnownColor.oldLace]!;
    } else {
      return _getPen(KnownColor.oldLace);
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
    if (_pens.containsKey(KnownColor.olive)) {
      return _pens[KnownColor.olive]!;
    } else {
      return _getPen(KnownColor.olive);
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
    if (_pens.containsKey(KnownColor.oliveDrab)) {
      return _pens[KnownColor.oliveDrab]!;
    } else {
      return _getPen(KnownColor.oliveDrab);
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
    if (_pens.containsKey(KnownColor.orange)) {
      return _pens[KnownColor.orange]!;
    } else {
      return _getPen(KnownColor.orange);
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
    if (_pens.containsKey(KnownColor.orangeRed)) {
      return _pens[KnownColor.orangeRed]!;
    } else {
      return _getPen(KnownColor.orangeRed);
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
    if (_pens.containsKey(KnownColor.orchid)) {
      return _pens[KnownColor.orchid]!;
    } else {
      return _getPen(KnownColor.orchid);
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
    if (_pens.containsKey(KnownColor.paleGoldenrod)) {
      return _pens[KnownColor.paleGoldenrod]!;
    } else {
      return _getPen(KnownColor.paleGoldenrod);
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
    if (_pens.containsKey(KnownColor.paleGreen)) {
      return _pens[KnownColor.paleGreen]!;
    } else {
      return _getPen(KnownColor.paleGreen);
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
    if (_pens.containsKey(KnownColor.paleTurquoise)) {
      return _pens[KnownColor.paleTurquoise]!;
    } else {
      return _getPen(KnownColor.paleTurquoise);
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
    if (_pens.containsKey(KnownColor.paleVioletRed)) {
      return _pens[KnownColor.paleVioletRed]!;
    } else {
      return _getPen(KnownColor.paleVioletRed);
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
    if (_pens.containsKey(KnownColor.papayaWhip)) {
      return _pens[KnownColor.papayaWhip]!;
    } else {
      return _getPen(KnownColor.papayaWhip);
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
    if (_pens.containsKey(KnownColor.peachPuff)) {
      return _pens[KnownColor.peachPuff]!;
    } else {
      return _getPen(KnownColor.peachPuff);
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
    if (_pens.containsKey(KnownColor.peru)) {
      return _pens[KnownColor.peru]!;
    } else {
      return _getPen(KnownColor.peru);
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
    if (_pens.containsKey(KnownColor.pink)) {
      return _pens[KnownColor.pink]!;
    } else {
      return _getPen(KnownColor.pink);
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
    if (_pens.containsKey(KnownColor.plum)) {
      return _pens[KnownColor.plum]!;
    } else {
      return _getPen(KnownColor.plum);
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
    if (_pens.containsKey(KnownColor.powderBlue)) {
      return _pens[KnownColor.powderBlue]!;
    } else {
      return _getPen(KnownColor.powderBlue);
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
    if (_pens.containsKey(KnownColor.purple)) {
      return _pens[KnownColor.purple]!;
    } else {
      return _getPen(KnownColor.purple);
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
    if (_pens.containsKey(KnownColor.red)) {
      return _pens[KnownColor.red]!;
    } else {
      return _getPen(KnownColor.red);
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
    if (_pens.containsKey(KnownColor.rosyBrown)) {
      return _pens[KnownColor.rosyBrown]!;
    } else {
      return _getPen(KnownColor.rosyBrown);
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
    if (_pens.containsKey(KnownColor.royalBlue)) {
      return _pens[KnownColor.royalBlue]!;
    } else {
      return _getPen(KnownColor.royalBlue);
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
    if (_pens.containsKey(KnownColor.saddleBrown)) {
      return _pens[KnownColor.saddleBrown]!;
    } else {
      return _getPen(KnownColor.saddleBrown);
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
    if (_pens.containsKey(KnownColor.salmon)) {
      return _pens[KnownColor.salmon]!;
    } else {
      return _getPen(KnownColor.salmon);
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
    if (_pens.containsKey(KnownColor.sandyBrown)) {
      return _pens[KnownColor.sandyBrown]!;
    } else {
      return _getPen(KnownColor.sandyBrown);
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
    if (_pens.containsKey(KnownColor.seaGreen)) {
      return _pens[KnownColor.seaGreen]!;
    } else {
      return _getPen(KnownColor.seaGreen);
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
    if (_pens.containsKey(KnownColor.seaShell)) {
      return _pens[KnownColor.seaShell]!;
    } else {
      return _getPen(KnownColor.seaShell);
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
    if (_pens.containsKey(KnownColor.sienna)) {
      return _pens[KnownColor.sienna]!;
    } else {
      return _getPen(KnownColor.sienna);
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
    if (_pens.containsKey(KnownColor.silver)) {
      return _pens[KnownColor.silver]!;
    } else {
      return _getPen(KnownColor.silver);
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
    if (_pens.containsKey(KnownColor.skyBlue)) {
      return _pens[KnownColor.skyBlue]!;
    } else {
      return _getPen(KnownColor.skyBlue);
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
    if (_pens.containsKey(KnownColor.slateBlue)) {
      return _pens[KnownColor.slateBlue]!;
    } else {
      return _getPen(KnownColor.slateBlue);
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
    if (_pens.containsKey(KnownColor.slateGray)) {
      return _pens[KnownColor.slateGray]!;
    } else {
      return _getPen(KnownColor.slateGray);
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
    if (_pens.containsKey(KnownColor.snow)) {
      return _pens[KnownColor.snow]!;
    } else {
      return _getPen(KnownColor.snow);
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
    if (_pens.containsKey(KnownColor.springGreen)) {
      return _pens[KnownColor.springGreen]!;
    } else {
      return _getPen(KnownColor.springGreen);
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
    if (_pens.containsKey(KnownColor.steelBlue)) {
      return _pens[KnownColor.steelBlue]!;
    } else {
      return _getPen(KnownColor.steelBlue);
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
    if (_pens.containsKey(KnownColor.tan)) {
      return _pens[KnownColor.tan]!;
    } else {
      return _getPen(KnownColor.tan);
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
    if (_pens.containsKey(KnownColor.teal)) {
      return _pens[KnownColor.teal]!;
    } else {
      return _getPen(KnownColor.teal);
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
    if (_pens.containsKey(KnownColor.thistle)) {
      return _pens[KnownColor.thistle]!;
    } else {
      return _getPen(KnownColor.thistle);
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
    if (_pens.containsKey(KnownColor.tomato)) {
      return _pens[KnownColor.tomato]!;
    } else {
      return _getPen(KnownColor.tomato);
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
    if (_pens.containsKey(KnownColor.transparent)) {
      return _pens[KnownColor.transparent]!;
    } else {
      return _getPen(KnownColor.transparent);
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
    if (_pens.containsKey(KnownColor.turquoise)) {
      return _pens[KnownColor.turquoise]!;
    } else {
      return _getPen(KnownColor.turquoise);
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
    if (_pens.containsKey(KnownColor.violet)) {
      return _pens[KnownColor.violet]!;
    } else {
      return _getPen(KnownColor.violet);
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
    if (_pens.containsKey(KnownColor.wheat)) {
      return _pens[KnownColor.wheat]!;
    } else {
      return _getPen(KnownColor.wheat);
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
    if (_pens.containsKey(KnownColor.white)) {
      return _pens[KnownColor.white]!;
    } else {
      return _getPen(KnownColor.white);
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
    if (_pens.containsKey(KnownColor.whiteSmoke)) {
      return _pens[KnownColor.whiteSmoke]!;
    } else {
      return _getPen(KnownColor.whiteSmoke);
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
    if (_pens.containsKey(KnownColor.yellow)) {
      return _pens[KnownColor.yellow]!;
    } else {
      return _getPen(KnownColor.yellow);
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
    if (_pens.containsKey(KnownColor.yellowGreen)) {
      return _pens[KnownColor.yellowGreen]!;
    } else {
      return _getPen(KnownColor.yellowGreen);
    }
  }

  static PdfPen _getPen(KnownColor kColor) {
    final ColorHelper color = ColorHelper(kColor);
    final PdfPen pen =
        PdfPenHelper.immutable(PdfColor(color.r, color.g, color.b, color.a));
    _pens[kColor] = pen;
    return pen;
  }

  static void _dispose() {
    _pens.clear();
  }
}

// ignore: avoid_classes_with_only_static_members
/// [PdfPens] helper
class PdfPensHelper {
  /// internal method
  static void dispose() {
    PdfPens._dispose();
  }
}
