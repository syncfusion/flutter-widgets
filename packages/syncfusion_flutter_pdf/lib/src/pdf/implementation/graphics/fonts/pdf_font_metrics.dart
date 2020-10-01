part of pdf;

/// Metrics of the font.
class _PdfFontMetrics {
  //Fields
  /// Gets ascent of the font.
  double ascent = 0;

  /// Gets descent of the font.
  double descent = 0;

  /// Gets name of the font.
  String name;

  /// Gets PostScript Name of the font.
  String postScriptName;

  /// Gets size of the font.
  double size = 0;

  /// Gets height of the font.
  double height = 0;

  /// Gets a first character of the font.
  int firstChar = 0;

  /// Gets a last character of the font.
  int lastChar = 0;

  /// Gets line gap of the font.
  int lineGap = 0;

  /// Subscript size factor.
  double subscriptSizeFactor = 0;

  /// Superscript size factor.
  double superscriptSizeFactor;
  _WidthTable _widthTable;

  /// Indicate whether the true type font reader font has bold style.
  bool isBold;

  //Implementation
  /// Calculates size of the font depending on the subscript/superscript value.
  double _getSize([PdfStringFormat format]) {
    double _size = size;
    if (format != null) {
      switch (format.subSuperscript) {
        case PdfSubSuperscript.subscript:
          _size /= 1.5;
          break;
        case PdfSubSuperscript.superscript:
          _size /= 1.5;
          break;
        case PdfSubSuperscript.none:
          break;
      }
    }
    return _size;
  }

  /// Returns height taking into consideration font's size.
  double _getHeight(PdfStringFormat format) {
    return _getDescent(format) < 0
        ? (_getAscent(format) - _getDescent(format) + _getLineGap(format))
        : (_getAscent(format) + _getDescent(format) + _getLineGap(format));
  }

  /// Returns descent taking into consideration font's size.
  double _getDescent(PdfStringFormat format) {
    return descent * PdfFont._characterSizeMultiplier * _getSize(format);
  }

  /// Returns ascent taking into consideration font's size.
  double _getAscent(PdfStringFormat format) {
    return ascent * PdfFont._characterSizeMultiplier * _getSize(format);
  }

  /// Returns Line gap taking into consideration font's size.
  double _getLineGap(PdfStringFormat format) {
    return lineGap * PdfFont._characterSizeMultiplier * _getSize(format);
  }
}

/// The base class for a width table.
abstract class _WidthTable {
  int operator [](int index);

  /// Toes the array.
  _PdfArray toArray();
}

/// Implements a width table for standard fonts.
class _StandardWidthTable extends _WidthTable {
  //Constructor
  _StandardWidthTable(List<int> widths) : super() {
    ArgumentError.checkNotNull(widths, 'widths');
    _widths = widths;
  }
  // Fields
  List<int> _widths;
  //Properties
  @override
  int operator [](int index) => _returnValue(index);
  int _returnValue(int index) {
    if (index < 0 || index >= _widths.length) {
      throw ArgumentError.value(
          index, 'The character is not supported by the font.');
    }
    return _widths[index];
  }

  @override
  _PdfArray toArray() {
    final _PdfArray arr = _PdfArray(_widths);
    return arr;
  }
}

class _CjkWidthTable extends _WidthTable {
  /// Initializes a new instance of the [CjkWidthTable] class.
  _CjkWidthTable(this.defaultWidth) {
    width = <_CjkWidth>[];
  }

  /// Local variable to store the width.
  List<_CjkWidth> width;

  /// Local variable to store the default width.
  int defaultWidth;

  @override
  int operator [](int index) {
    int newWidth = defaultWidth;
    for (final _CjkWidth widths in width) {
      if (index >= widths.from && index <= widths.to) {
        newWidth = widths[index];
      }
    }
    return newWidth;
  }

  void add(_CjkWidth widths) {
    if (widths == null) {
      throw ArgumentError('widths');
    }
    width.add(widths);
  }

  @override
  _PdfArray toArray() {
    final _PdfArray arr = _PdfArray();
    for (final _CjkWidth widths in width) {
      widths.appendToArray(arr);
    }
    return arr;
  }
}

/// The base class of CJK widths types.
abstract class _CjkWidth {
  /// Gets the starting character.
  int get from;

  /// Gets the ending character.
  int get to;

  /// Gets the width of the specified character.
  int operator [](int index);

  /// Appends internal data to a PDF array.
  void appendToArray(_PdfArray arr);
}

/// Implements capabilities to control a range of character with the same width.
class _CjkSameWidth extends _CjkWidth {
  _CjkSameWidth(this.from, this.to, this.width) {
    if (from > to) {
      throw ArgumentError("'From' can't be grater than 'to'.");
    }
  }

  /// The Form
  @override
  int from;

  /// The to
  @override
  int to;

  /// The Width
  int width;

  @override
  int operator [](int index) {
    if (index < from || index > to) {
      throw RangeError('$index, Index is out of range.');
    }
    return width;
  }

  @override
  void appendToArray(_PdfArray arr) {
    arr._add(_PdfNumber(from));
    arr._add(_PdfNumber(to));
    arr._add(_PdfNumber(width));
  }
}

/// Implements capabilities to control a sequent range of characters
/// with different width.
class _CjkDifferentWidth extends _CjkWidth {
  _CjkDifferentWidth(this.from, this.width) {
    if (width == null) {
      throw ArgumentError('widths');
    }
  }

  /// The form
  @override
  int from;

  /// The width
  List<int> width;

  /// Gets the ending character.
  @override
  int get to {
    final int value = from + width.length - 1;
    return value;
  }

  @override
  int operator [](int index) {
    if (index < from || index > to) {
      throw RangeError('$index, Index is out of range.');
    }
    final int newWidth = width[index - from];
    return newWidth;
  }

  @override
  void appendToArray(_PdfArray arr) {
    arr._add(_PdfNumber(from));
    final _PdfArray widths = _PdfArray(width);
    arr._add(widths);
  }
}
