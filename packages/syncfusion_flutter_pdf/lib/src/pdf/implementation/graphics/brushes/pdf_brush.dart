import '../../drawing/color.dart';
import '../../graphics/pdf_color.dart';
import 'pdf_solid_brush.dart';

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
  static final Map<KnownColor, PdfBrush> _brushes = <KnownColor, PdfBrush>{};

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
    if (_brushes.containsKey(KnownColor.aliceBlue)) {
      return _brushes[KnownColor.aliceBlue]!;
    } else {
      return _getBrush(KnownColor.aliceBlue);
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
    if (_brushes.containsKey(KnownColor.antiqueWhite)) {
      return _brushes[KnownColor.antiqueWhite]!;
    } else {
      return _getBrush(KnownColor.antiqueWhite);
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
    if (_brushes.containsKey(KnownColor.aqua)) {
      return _brushes[KnownColor.aqua]!;
    } else {
      return _getBrush(KnownColor.aqua);
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
    if (_brushes.containsKey(KnownColor.aquamarine)) {
      return _brushes[KnownColor.aquamarine]!;
    } else {
      return _getBrush(KnownColor.aquamarine);
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
    if (_brushes.containsKey(KnownColor.azure)) {
      return _brushes[KnownColor.azure]!;
    } else {
      return _getBrush(KnownColor.azure);
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
    if (_brushes.containsKey(KnownColor.beige)) {
      return _brushes[KnownColor.beige]!;
    } else {
      return _getBrush(KnownColor.beige);
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
    if (_brushes.containsKey(KnownColor.bisque)) {
      return _brushes[KnownColor.bisque]!;
    } else {
      return _getBrush(KnownColor.bisque);
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
    if (_brushes.containsKey(KnownColor.black)) {
      return _brushes[KnownColor.black]!;
    } else {
      return _getBrush(KnownColor.black);
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
    if (_brushes.containsKey(KnownColor.blanchedAlmond)) {
      return _brushes[KnownColor.blanchedAlmond]!;
    } else {
      return _getBrush(KnownColor.blanchedAlmond);
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
    if (_brushes.containsKey(KnownColor.blue)) {
      return _brushes[KnownColor.blue]!;
    } else {
      return _getBrush(KnownColor.blue);
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
    if (_brushes.containsKey(KnownColor.blueViolet)) {
      return _brushes[KnownColor.blueViolet]!;
    } else {
      return _getBrush(KnownColor.blueViolet);
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
    if (_brushes.containsKey(KnownColor.brown)) {
      return _brushes[KnownColor.brown]!;
    } else {
      return _getBrush(KnownColor.brown);
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
    if (_brushes.containsKey(KnownColor.burlyWood)) {
      return _brushes[KnownColor.burlyWood]!;
    } else {
      return _getBrush(KnownColor.burlyWood);
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
    if (_brushes.containsKey(KnownColor.cadetBlue)) {
      return _brushes[KnownColor.cadetBlue]!;
    } else {
      return _getBrush(KnownColor.cadetBlue);
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
    if (_brushes.containsKey(KnownColor.chartreuse)) {
      return _brushes[KnownColor.chartreuse]!;
    } else {
      return _getBrush(KnownColor.chartreuse);
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
    if (_brushes.containsKey(KnownColor.chocolate)) {
      return _brushes[KnownColor.chocolate]!;
    } else {
      return _getBrush(KnownColor.chocolate);
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
    if (_brushes.containsKey(KnownColor.coral)) {
      return _brushes[KnownColor.coral]!;
    } else {
      return _getBrush(KnownColor.coral);
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
    if (_brushes.containsKey(KnownColor.cornflowerBlue)) {
      return _brushes[KnownColor.cornflowerBlue]!;
    } else {
      return _getBrush(KnownColor.cornflowerBlue);
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
    if (_brushes.containsKey(KnownColor.cornsilk)) {
      return _brushes[KnownColor.cornsilk]!;
    } else {
      return _getBrush(KnownColor.cornsilk);
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
    if (_brushes.containsKey(KnownColor.crimson)) {
      return _brushes[KnownColor.crimson]!;
    } else {
      return _getBrush(KnownColor.crimson);
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
    if (_brushes.containsKey(KnownColor.cyan)) {
      return _brushes[KnownColor.cyan]!;
    } else {
      return _getBrush(KnownColor.cyan);
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
    if (_brushes.containsKey(KnownColor.darkBlue)) {
      return _brushes[KnownColor.darkBlue]!;
    } else {
      return _getBrush(KnownColor.darkBlue);
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
    if (_brushes.containsKey(KnownColor.darkCyan)) {
      return _brushes[KnownColor.darkCyan]!;
    } else {
      return _getBrush(KnownColor.darkCyan);
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
    if (_brushes.containsKey(KnownColor.darkGoldenrod)) {
      return _brushes[KnownColor.darkGoldenrod]!;
    } else {
      return _getBrush(KnownColor.darkGoldenrod);
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
    if (_brushes.containsKey(KnownColor.darkGray)) {
      return _brushes[KnownColor.darkGray]!;
    } else {
      return _getBrush(KnownColor.darkGray);
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
    if (_brushes.containsKey(KnownColor.darkGreen)) {
      return _brushes[KnownColor.darkGreen]!;
    } else {
      return _getBrush(KnownColor.darkGreen);
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
    if (_brushes.containsKey(KnownColor.darkKhaki)) {
      return _brushes[KnownColor.darkKhaki]!;
    } else {
      return _getBrush(KnownColor.darkKhaki);
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
    if (_brushes.containsKey(KnownColor.darkMagenta)) {
      return _brushes[KnownColor.darkMagenta]!;
    } else {
      return _getBrush(KnownColor.darkMagenta);
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
    if (_brushes.containsKey(KnownColor.darkOliveGreen)) {
      return _brushes[KnownColor.darkOliveGreen]!;
    } else {
      return _getBrush(KnownColor.darkOliveGreen);
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
    if (_brushes.containsKey(KnownColor.darkOrange)) {
      return _brushes[KnownColor.darkOrange]!;
    } else {
      return _getBrush(KnownColor.darkOrange);
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
    if (_brushes.containsKey(KnownColor.darkOrchid)) {
      return _brushes[KnownColor.darkOrchid]!;
    } else {
      return _getBrush(KnownColor.darkOrchid);
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
    if (_brushes.containsKey(KnownColor.darkRed)) {
      return _brushes[KnownColor.darkRed]!;
    } else {
      return _getBrush(KnownColor.darkRed);
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
    if (_brushes.containsKey(KnownColor.darkSalmon)) {
      return _brushes[KnownColor.darkSalmon]!;
    } else {
      return _getBrush(KnownColor.darkSalmon);
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
    if (_brushes.containsKey(KnownColor.darkSeaGreen)) {
      return _brushes[KnownColor.darkSeaGreen]!;
    } else {
      return _getBrush(KnownColor.darkSeaGreen);
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
    if (_brushes.containsKey(KnownColor.darkSlateBlue)) {
      return _brushes[KnownColor.darkSlateBlue]!;
    } else {
      return _getBrush(KnownColor.darkSlateBlue);
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
    if (_brushes.containsKey(KnownColor.darkSlateGray)) {
      return _brushes[KnownColor.darkSlateGray]!;
    } else {
      return _getBrush(KnownColor.darkSlateGray);
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
    if (_brushes.containsKey(KnownColor.darkTurquoise)) {
      return _brushes[KnownColor.darkTurquoise]!;
    } else {
      return _getBrush(KnownColor.darkTurquoise);
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
    if (_brushes.containsKey(KnownColor.darkViolet)) {
      return _brushes[KnownColor.darkViolet]!;
    } else {
      return _getBrush(KnownColor.darkViolet);
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
    if (_brushes.containsKey(KnownColor.deepPink)) {
      return _brushes[KnownColor.deepPink]!;
    } else {
      return _getBrush(KnownColor.deepPink);
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
    if (_brushes.containsKey(KnownColor.deepSkyBlue)) {
      return _brushes[KnownColor.deepSkyBlue]!;
    } else {
      return _getBrush(KnownColor.deepSkyBlue);
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
    if (_brushes.containsKey(KnownColor.dimGray)) {
      return _brushes[KnownColor.dimGray]!;
    } else {
      return _getBrush(KnownColor.dimGray);
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
    if (_brushes.containsKey(KnownColor.dodgerBlue)) {
      return _brushes[KnownColor.dodgerBlue]!;
    } else {
      return _getBrush(KnownColor.dodgerBlue);
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
    if (_brushes.containsKey(KnownColor.firebrick)) {
      return _brushes[KnownColor.firebrick]!;
    } else {
      return _getBrush(KnownColor.firebrick);
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
    if (_brushes.containsKey(KnownColor.floralWhite)) {
      return _brushes[KnownColor.floralWhite]!;
    } else {
      return _getBrush(KnownColor.floralWhite);
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
    if (_brushes.containsKey(KnownColor.forestGreen)) {
      return _brushes[KnownColor.forestGreen]!;
    } else {
      return _getBrush(KnownColor.forestGreen);
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
    if (_brushes.containsKey(KnownColor.fuchsia)) {
      return _brushes[KnownColor.fuchsia]!;
    } else {
      return _getBrush(KnownColor.fuchsia);
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
    if (_brushes.containsKey(KnownColor.gainsboro)) {
      return _brushes[KnownColor.gainsboro]!;
    } else {
      return _getBrush(KnownColor.gainsboro);
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
    if (_brushes.containsKey(KnownColor.ghostWhite)) {
      return _brushes[KnownColor.ghostWhite]!;
    } else {
      return _getBrush(KnownColor.ghostWhite);
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
    if (_brushes.containsKey(KnownColor.gold)) {
      return _brushes[KnownColor.gold]!;
    } else {
      return _getBrush(KnownColor.gold);
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
    if (_brushes.containsKey(KnownColor.goldenrod)) {
      return _brushes[KnownColor.goldenrod]!;
    } else {
      return _getBrush(KnownColor.goldenrod);
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
    if (_brushes.containsKey(KnownColor.gray)) {
      return _brushes[KnownColor.gray]!;
    } else {
      return _getBrush(KnownColor.gray);
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
    if (_brushes.containsKey(KnownColor.green)) {
      return _brushes[KnownColor.green]!;
    } else {
      return _getBrush(KnownColor.green);
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
    if (_brushes.containsKey(KnownColor.greenYellow)) {
      return _brushes[KnownColor.greenYellow]!;
    } else {
      return _getBrush(KnownColor.greenYellow);
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
    if (_brushes.containsKey(KnownColor.honeydew)) {
      return _brushes[KnownColor.honeydew]!;
    } else {
      return _getBrush(KnownColor.honeydew);
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
    if (_brushes.containsKey(KnownColor.hotPink)) {
      return _brushes[KnownColor.hotPink]!;
    } else {
      return _getBrush(KnownColor.hotPink);
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
    if (_brushes.containsKey(KnownColor.indianRed)) {
      return _brushes[KnownColor.indianRed]!;
    } else {
      return _getBrush(KnownColor.indianRed);
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
    if (_brushes.containsKey(KnownColor.indigo)) {
      return _brushes[KnownColor.indigo]!;
    } else {
      return _getBrush(KnownColor.indigo);
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
    if (_brushes.containsKey(KnownColor.ivory)) {
      return _brushes[KnownColor.ivory]!;
    } else {
      return _getBrush(KnownColor.ivory);
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
    if (_brushes.containsKey(KnownColor.khaki)) {
      return _brushes[KnownColor.khaki]!;
    } else {
      return _getBrush(KnownColor.khaki);
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
    if (_brushes.containsKey(KnownColor.lavender)) {
      return _brushes[KnownColor.lavender]!;
    } else {
      return _getBrush(KnownColor.lavender);
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
    if (_brushes.containsKey(KnownColor.lavenderBlush)) {
      return _brushes[KnownColor.lavenderBlush]!;
    } else {
      return _getBrush(KnownColor.lavenderBlush);
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
    if (_brushes.containsKey(KnownColor.lawnGreen)) {
      return _brushes[KnownColor.lawnGreen]!;
    } else {
      return _getBrush(KnownColor.lawnGreen);
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
    if (_brushes.containsKey(KnownColor.lemonChiffon)) {
      return _brushes[KnownColor.lemonChiffon]!;
    } else {
      return _getBrush(KnownColor.lemonChiffon);
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
    if (_brushes.containsKey(KnownColor.lightBlue)) {
      return _brushes[KnownColor.lightBlue]!;
    } else {
      return _getBrush(KnownColor.lightBlue);
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
    if (_brushes.containsKey(KnownColor.lightCoral)) {
      return _brushes[KnownColor.lightCoral]!;
    } else {
      return _getBrush(KnownColor.lightCoral);
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
    if (_brushes.containsKey(KnownColor.lightCyan)) {
      return _brushes[KnownColor.lightCyan]!;
    } else {
      return _getBrush(KnownColor.lightCyan);
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
    if (_brushes.containsKey(KnownColor.lightGoldenrodYellow)) {
      return _brushes[KnownColor.lightGoldenrodYellow]!;
    } else {
      return _getBrush(KnownColor.lightGoldenrodYellow);
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
    if (_brushes.containsKey(KnownColor.lightGray)) {
      return _brushes[KnownColor.lightGray]!;
    } else {
      return _getBrush(KnownColor.lightGray);
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
    if (_brushes.containsKey(KnownColor.lightGreen)) {
      return _brushes[KnownColor.lightGreen]!;
    } else {
      return _getBrush(KnownColor.lightGreen);
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
    if (_brushes.containsKey(KnownColor.lightPink)) {
      return _brushes[KnownColor.lightPink]!;
    } else {
      return _getBrush(KnownColor.lightPink);
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
    if (_brushes.containsKey(KnownColor.lightSalmon)) {
      return _brushes[KnownColor.lightSalmon]!;
    } else {
      return _getBrush(KnownColor.lightSalmon);
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
    if (_brushes.containsKey(KnownColor.lightSeaGreen)) {
      return _brushes[KnownColor.lightSeaGreen]!;
    } else {
      return _getBrush(KnownColor.lightSeaGreen);
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
    if (_brushes.containsKey(KnownColor.lightSkyBlue)) {
      return _brushes[KnownColor.lightSkyBlue]!;
    } else {
      return _getBrush(KnownColor.lightSkyBlue);
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
    if (_brushes.containsKey(KnownColor.lightSlateGray)) {
      return _brushes[KnownColor.lightSlateGray]!;
    } else {
      return _getBrush(KnownColor.lightSlateGray);
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
    if (_brushes.containsKey(KnownColor.lightSteelBlue)) {
      return _brushes[KnownColor.lightSteelBlue]!;
    } else {
      return _getBrush(KnownColor.lightSteelBlue);
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
    if (_brushes.containsKey(KnownColor.lightYellow)) {
      return _brushes[KnownColor.lightYellow]!;
    } else {
      return _getBrush(KnownColor.lightYellow);
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
    if (_brushes.containsKey(KnownColor.lime)) {
      return _brushes[KnownColor.lime]!;
    } else {
      return _getBrush(KnownColor.lime);
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
    if (_brushes.containsKey(KnownColor.limeGreen)) {
      return _brushes[KnownColor.limeGreen]!;
    } else {
      return _getBrush(KnownColor.limeGreen);
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
    if (_brushes.containsKey(KnownColor.linen)) {
      return _brushes[KnownColor.linen]!;
    } else {
      return _getBrush(KnownColor.linen);
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
    if (_brushes.containsKey(KnownColor.magenta)) {
      return _brushes[KnownColor.magenta]!;
    } else {
      return _getBrush(KnownColor.magenta);
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
    if (_brushes.containsKey(KnownColor.maroon)) {
      return _brushes[KnownColor.maroon]!;
    } else {
      return _getBrush(KnownColor.maroon);
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
    if (_brushes.containsKey(KnownColor.mediumAquamarine)) {
      return _brushes[KnownColor.mediumAquamarine]!;
    } else {
      return _getBrush(KnownColor.mediumAquamarine);
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
    if (_brushes.containsKey(KnownColor.mediumBlue)) {
      return _brushes[KnownColor.mediumBlue]!;
    } else {
      return _getBrush(KnownColor.mediumBlue);
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
    if (_brushes.containsKey(KnownColor.mediumOrchid)) {
      return _brushes[KnownColor.mediumOrchid]!;
    } else {
      return _getBrush(KnownColor.mediumOrchid);
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
    if (_brushes.containsKey(KnownColor.mediumPurple)) {
      return _brushes[KnownColor.mediumPurple]!;
    } else {
      return _getBrush(KnownColor.mediumPurple);
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
    if (_brushes.containsKey(KnownColor.mediumSeaGreen)) {
      return _brushes[KnownColor.mediumSeaGreen]!;
    } else {
      return _getBrush(KnownColor.mediumSeaGreen);
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
    if (_brushes.containsKey(KnownColor.mediumSlateBlue)) {
      return _brushes[KnownColor.mediumSlateBlue]!;
    } else {
      return _getBrush(KnownColor.mediumSlateBlue);
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
    if (_brushes.containsKey(KnownColor.mediumSpringGreen)) {
      return _brushes[KnownColor.mediumSpringGreen]!;
    } else {
      return _getBrush(KnownColor.mediumSpringGreen);
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
    if (_brushes.containsKey(KnownColor.mediumTurquoise)) {
      return _brushes[KnownColor.mediumTurquoise]!;
    } else {
      return _getBrush(KnownColor.mediumTurquoise);
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
    if (_brushes.containsKey(KnownColor.mediumVioletRed)) {
      return _brushes[KnownColor.mediumVioletRed]!;
    } else {
      return _getBrush(KnownColor.mediumVioletRed);
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
    if (_brushes.containsKey(KnownColor.midnightBlue)) {
      return _brushes[KnownColor.midnightBlue]!;
    } else {
      return _getBrush(KnownColor.midnightBlue);
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
    if (_brushes.containsKey(KnownColor.mintCream)) {
      return _brushes[KnownColor.mintCream]!;
    } else {
      return _getBrush(KnownColor.mintCream);
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
    if (_brushes.containsKey(KnownColor.mistyRose)) {
      return _brushes[KnownColor.mistyRose]!;
    } else {
      return _getBrush(KnownColor.mistyRose);
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
    if (_brushes.containsKey(KnownColor.moccasin)) {
      return _brushes[KnownColor.moccasin]!;
    } else {
      return _getBrush(KnownColor.moccasin);
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
    if (_brushes.containsKey(KnownColor.navajoWhite)) {
      return _brushes[KnownColor.navajoWhite]!;
    } else {
      return _getBrush(KnownColor.navajoWhite);
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
    if (_brushes.containsKey(KnownColor.navy)) {
      return _brushes[KnownColor.navy]!;
    } else {
      return _getBrush(KnownColor.navy);
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
    if (_brushes.containsKey(KnownColor.oldLace)) {
      return _brushes[KnownColor.oldLace]!;
    } else {
      return _getBrush(KnownColor.oldLace);
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
    if (_brushes.containsKey(KnownColor.olive)) {
      return _brushes[KnownColor.olive]!;
    } else {
      return _getBrush(KnownColor.olive);
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
    if (_brushes.containsKey(KnownColor.oliveDrab)) {
      return _brushes[KnownColor.oliveDrab]!;
    } else {
      return _getBrush(KnownColor.oliveDrab);
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
    if (_brushes.containsKey(KnownColor.orange)) {
      return _brushes[KnownColor.orange]!;
    } else {
      return _getBrush(KnownColor.orange);
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
    if (_brushes.containsKey(KnownColor.orangeRed)) {
      return _brushes[KnownColor.orangeRed]!;
    } else {
      return _getBrush(KnownColor.orangeRed);
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
    if (_brushes.containsKey(KnownColor.orchid)) {
      return _brushes[KnownColor.orchid]!;
    } else {
      return _getBrush(KnownColor.orchid);
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
    if (_brushes.containsKey(KnownColor.paleGoldenrod)) {
      return _brushes[KnownColor.paleGoldenrod]!;
    } else {
      return _getBrush(KnownColor.paleGoldenrod);
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
    if (_brushes.containsKey(KnownColor.paleGreen)) {
      return _brushes[KnownColor.paleGreen]!;
    } else {
      return _getBrush(KnownColor.paleGreen);
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
    if (_brushes.containsKey(KnownColor.paleTurquoise)) {
      return _brushes[KnownColor.paleTurquoise]!;
    } else {
      return _getBrush(KnownColor.paleTurquoise);
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
    if (_brushes.containsKey(KnownColor.paleVioletRed)) {
      return _brushes[KnownColor.paleVioletRed]!;
    } else {
      return _getBrush(KnownColor.paleVioletRed);
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
    if (_brushes.containsKey(KnownColor.papayaWhip)) {
      return _brushes[KnownColor.papayaWhip]!;
    } else {
      return _getBrush(KnownColor.papayaWhip);
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
    if (_brushes.containsKey(KnownColor.peachPuff)) {
      return _brushes[KnownColor.peachPuff]!;
    } else {
      return _getBrush(KnownColor.peachPuff);
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
    if (_brushes.containsKey(KnownColor.peru)) {
      return _brushes[KnownColor.peru]!;
    } else {
      return _getBrush(KnownColor.peru);
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
    if (_brushes.containsKey(KnownColor.pink)) {
      return _brushes[KnownColor.pink]!;
    } else {
      return _getBrush(KnownColor.pink);
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
    if (_brushes.containsKey(KnownColor.plum)) {
      return _brushes[KnownColor.plum]!;
    } else {
      return _getBrush(KnownColor.plum);
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
    if (_brushes.containsKey(KnownColor.powderBlue)) {
      return _brushes[KnownColor.powderBlue]!;
    } else {
      return _getBrush(KnownColor.powderBlue);
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
    if (_brushes.containsKey(KnownColor.purple)) {
      return _brushes[KnownColor.purple]!;
    } else {
      return _getBrush(KnownColor.purple);
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
    if (_brushes.containsKey(KnownColor.red)) {
      return _brushes[KnownColor.red]!;
    } else {
      return _getBrush(KnownColor.red);
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
    if (_brushes.containsKey(KnownColor.rosyBrown)) {
      return _brushes[KnownColor.rosyBrown]!;
    } else {
      return _getBrush(KnownColor.rosyBrown);
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
    if (_brushes.containsKey(KnownColor.royalBlue)) {
      return _brushes[KnownColor.royalBlue]!;
    } else {
      return _getBrush(KnownColor.royalBlue);
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
    if (_brushes.containsKey(KnownColor.saddleBrown)) {
      return _brushes[KnownColor.saddleBrown]!;
    } else {
      return _getBrush(KnownColor.saddleBrown);
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
    if (_brushes.containsKey(KnownColor.salmon)) {
      return _brushes[KnownColor.salmon]!;
    } else {
      return _getBrush(KnownColor.salmon);
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
    if (_brushes.containsKey(KnownColor.sandyBrown)) {
      return _brushes[KnownColor.sandyBrown]!;
    } else {
      return _getBrush(KnownColor.sandyBrown);
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
    if (_brushes.containsKey(KnownColor.seaGreen)) {
      return _brushes[KnownColor.seaGreen]!;
    } else {
      return _getBrush(KnownColor.seaGreen);
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
    if (_brushes.containsKey(KnownColor.seaShell)) {
      return _brushes[KnownColor.seaShell]!;
    } else {
      return _getBrush(KnownColor.seaShell);
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
    if (_brushes.containsKey(KnownColor.sienna)) {
      return _brushes[KnownColor.sienna]!;
    } else {
      return _getBrush(KnownColor.sienna);
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
    if (_brushes.containsKey(KnownColor.silver)) {
      return _brushes[KnownColor.silver]!;
    } else {
      return _getBrush(KnownColor.silver);
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
    if (_brushes.containsKey(KnownColor.skyBlue)) {
      return _brushes[KnownColor.skyBlue]!;
    } else {
      return _getBrush(KnownColor.skyBlue);
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
    if (_brushes.containsKey(KnownColor.slateBlue)) {
      return _brushes[KnownColor.slateBlue]!;
    } else {
      return _getBrush(KnownColor.slateBlue);
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
    if (_brushes.containsKey(KnownColor.slateGray)) {
      return _brushes[KnownColor.slateGray]!;
    } else {
      return _getBrush(KnownColor.slateGray);
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
    if (_brushes.containsKey(KnownColor.snow)) {
      return _brushes[KnownColor.snow]!;
    } else {
      return _getBrush(KnownColor.snow);
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
    if (_brushes.containsKey(KnownColor.springGreen)) {
      return _brushes[KnownColor.springGreen]!;
    } else {
      return _getBrush(KnownColor.springGreen);
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
    if (_brushes.containsKey(KnownColor.steelBlue)) {
      return _brushes[KnownColor.steelBlue]!;
    } else {
      return _getBrush(KnownColor.steelBlue);
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
    if (_brushes.containsKey(KnownColor.tan)) {
      return _brushes[KnownColor.tan]!;
    } else {
      return _getBrush(KnownColor.tan);
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
    if (_brushes.containsKey(KnownColor.teal)) {
      return _brushes[KnownColor.teal]!;
    } else {
      return _getBrush(KnownColor.teal);
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
    if (_brushes.containsKey(KnownColor.thistle)) {
      return _brushes[KnownColor.thistle]!;
    } else {
      return _getBrush(KnownColor.thistle);
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
    if (_brushes.containsKey(KnownColor.tomato)) {
      return _brushes[KnownColor.tomato]!;
    } else {
      return _getBrush(KnownColor.tomato);
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
    if (_brushes.containsKey(KnownColor.transparent)) {
      return _brushes[KnownColor.transparent]!;
    } else {
      return _getBrush(KnownColor.transparent);
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
    if (_brushes.containsKey(KnownColor.turquoise)) {
      return _brushes[KnownColor.turquoise]!;
    } else {
      return _getBrush(KnownColor.turquoise);
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
    if (_brushes.containsKey(KnownColor.violet)) {
      return _brushes[KnownColor.violet]!;
    } else {
      return _getBrush(KnownColor.violet);
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
    if (_brushes.containsKey(KnownColor.wheat)) {
      return _brushes[KnownColor.wheat]!;
    } else {
      return _getBrush(KnownColor.wheat);
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
    if (_brushes.containsKey(KnownColor.white)) {
      return _brushes[KnownColor.white]!;
    } else {
      return _getBrush(KnownColor.white);
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
    if (_brushes.containsKey(KnownColor.whiteSmoke)) {
      return _brushes[KnownColor.whiteSmoke]!;
    } else {
      return _getBrush(KnownColor.whiteSmoke);
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
    if (_brushes.containsKey(KnownColor.yellow)) {
      return _brushes[KnownColor.yellow]!;
    } else {
      return _getBrush(KnownColor.yellow);
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
    if (_brushes.containsKey(KnownColor.yellowGreen)) {
      return _brushes[KnownColor.yellowGreen]!;
    } else {
      return _getBrush(KnownColor.yellowGreen);
    }
  }

  static PdfBrush _getBrush(KnownColor kColor) {
    final ColorHelper color = ColorHelper(kColor);
    final PdfBrush brush =
        PdfSolidBrush(PdfColor(color.r, color.g, color.b, color.a));
    _brushes[kColor] = brush;
    return brush;
  }

  static void _dispose() {
    _brushes.clear();
  }
}

// ignore: avoid_classes_with_only_static_members
/// [PdfBrushes] helper
class PdfBrushesHelper {
  /// internal method
  static void dispose() {
    PdfBrushes._dispose();
  }
}
