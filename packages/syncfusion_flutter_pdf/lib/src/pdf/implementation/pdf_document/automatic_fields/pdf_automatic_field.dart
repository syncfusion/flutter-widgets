part of pdf;

/// Represents a fields which is calculated before the document saves.
abstract class PdfAutomaticField {
  // constructor
  PdfAutomaticField._(PdfFont font, {Rect bounds, PdfBrush brush}) : super() {
    _font = font;
    if (bounds != null) {
      _bounds = _Rectangle.fromRect(bounds);
    }
    _brush = brush;
  }
  // fields
  _Rectangle _bounds;

  PdfFont _font;

  PdfBrush _brush;

  PdfPen _pen;

  Size _templateSize = const Size(0, 0);

  /// Gets or sets the stringFormat of the field.
  PdfStringFormat stringFormat;

  // properties
  /// Gets the bounds of the field.
  Rect get bounds {
    _bounds ??= _Rectangle.empty;
    return _bounds.rect;
  }

  /// Sets the bounds of the field.
  set bounds(Rect value) {
    _bounds = _Rectangle.fromRect(value);
  }

  /// Gets the font of the field.
  PdfFont get font => _font;

  /// Sets the font of the field.
  set font(PdfFont value) {
    _font = (value == null) ? throw ArgumentError.value('font') : value;
  }

  /// Gets the brush of the field.
  PdfBrush get brush => _brush;

  /// Sets the brush of the field.
  set brush(PdfBrush value) {
    _brush = (value == null) ? throw ArgumentError.value('brush') : value;
  }

  /// Gets the pen of the field.
  PdfPen get pen => _pen;

  /// Sets the pen of the field.
  set pen(PdfPen value) {
    _pen = (value == null) ? throw ArgumentError.value('brush') : value;
  }

  // implementation
  /// Draws an element on the Graphics.
  /// Graphics context where the element should be printed.
  /// location has contains X co-ordinate of the element,
  /// Y co-ordinate of the element.
  void draw(PdfGraphics graphics, [Offset location]) {
    location ??= const Offset(0, 0);
    graphics._autoFields
        .add(_PdfAutomaticFieldInfo(this, _Point.fromOffset(location)));
  }

  String _getValue(PdfGraphics graphics) {
    return graphics as String;
  }

  PdfFont _obtainFont() {
    return _font ?? PdfStandardFont(PdfFontFamily.helvetica, 8);
  }

  void _performDraw(
      PdfGraphics graphics, _Point location, double scalingX, double scalingY) {
    if (bounds.height == 0 || bounds.width == 0) {
      final String text = _getValue(graphics);
      _templateSize = _obtainFont()
          .measureString(text, layoutArea: bounds.size, format: stringFormat);
    }
  }

  Size _obtainSize() {
    if (bounds.height == 0 || bounds.width == 0) {
      return _templateSize;
    } else {
      return bounds.size;
    }
  }

  PdfBrush _obtainBrush() {
    return _brush ?? PdfBrushes.black;
  }
}
