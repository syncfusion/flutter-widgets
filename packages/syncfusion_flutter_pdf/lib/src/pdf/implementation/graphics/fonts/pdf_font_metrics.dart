import '../../primitives/pdf_array.dart';
import '../../primitives/pdf_number.dart';
import 'enums.dart';
import 'pdf_font.dart';
import 'pdf_string_format.dart';

/// Metrics of the font.
class PdfFontMetrics {
  //Fields
  /// Gets ascent of the font.
  double ascent = 0;

  /// Gets descent of the font.
  double descent = 0;

  /// Gets name of the font.
  String name = '';

  /// Gets PostScript Name of the font.
  String? postScriptName;

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
  double? subscriptSizeFactor = 0;

  /// Superscript size factor.
  double? superscriptSizeFactor;

  /// internal field
  WidthTable? widthTable;

  /// Indicate whether the true type font reader font has bold style.
  bool? isBold;

  //Implementation
  /// Calculates size of the font depending on the subscript/superscript value.
  double? getSize([PdfStringFormat? format]) {
    double? sizeValue = size;
    if (format != null) {
      switch (format.subSuperscript) {
        case PdfSubSuperscript.subscript:
          sizeValue = sizeValue / 1.5;
          break;
        case PdfSubSuperscript.superscript:
          sizeValue = sizeValue / 1.5;
          break;
        // ignore: no_default_cases
        default:
          break;
      }
    }
    return sizeValue;
  }

  /// Returns height taking into consideration font's size.
  double getHeight(PdfStringFormat? format) {
    return getDescent(format) < 0
        ? (getAscent(format) - getDescent(format) + _getLineGap(format))
        : (getAscent(format) + getDescent(format) + _getLineGap(format));
  }

  /// Returns descent taking into consideration font's size.
  double getDescent(PdfStringFormat? format) {
    return descent * PdfFontHelper.characterSizeMultiplier * getSize(format)!;
  }

  /// Returns ascent taking into consideration font's size.
  double getAscent(PdfStringFormat? format) {
    return ascent * PdfFontHelper.characterSizeMultiplier * getSize(format)!;
  }

  /// Returns Line gap taking into consideration font's size.
  double _getLineGap(PdfStringFormat? format) {
    return lineGap * PdfFontHelper.characterSizeMultiplier * getSize(format)!;
  }
}

/// The base class for a width table.
abstract class WidthTable {
  /// internal property
  int? operator [](int index);

  /// Toes the array.
  PdfArray toArray();
}

/// Implements a width table for standard fonts.
class StandardWidthTable extends WidthTable {
  //Constructor
  /// internal constructor
  StandardWidthTable(List<int> widths) : super() {
    _widths = widths;
  }
  // Fields
  List<int>? _widths;
  //Properties
  @override
  int? operator [](int index) => _returnValue(index);
  int? _returnValue(int index) {
    if (index < 0 || index >= _widths!.length) {
      throw ArgumentError.value(
          index, 'The character is not supported by the font.');
    }
    return _widths![index];
  }

  @override
  PdfArray toArray() {
    final PdfArray arr = PdfArray(_widths);
    return arr;
  }
}

/// internal class
class CjkWidthTable extends WidthTable {
  /// Initializes a new instance of the [CjkWidthTable] class.
  CjkWidthTable(this.defaultWidth) {
    width = <_CjkWidth>[];
  }

  /// Local variable to store the width.
  late List<_CjkWidth> width;

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

  /// internal method
  void add(_CjkWidth widths) {
    width.add(widths);
  }

  @override
  PdfArray toArray() {
    final PdfArray arr = PdfArray();
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
  void appendToArray(PdfArray arr);
}

/// Implements capabilities to control a range of character with the same width.
class CjkSameWidth extends _CjkWidth {
  /// internal constructor
  CjkSameWidth(this.from, this.to, this.width) {
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
  void appendToArray(PdfArray arr) {
    arr.add(PdfNumber(from));
    arr.add(PdfNumber(to));
    arr.add(PdfNumber(width));
  }
}

/// Implements capabilities to control a sequent range of characters
/// with different width.
class CjkDifferentWidth extends _CjkWidth {
  /// internal constructor
  CjkDifferentWidth(this.from, this.width);

  /// The form
  @override
  late int from;

  /// The width
  late List<int> width;

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
  void appendToArray(PdfArray arr) {
    arr.add(PdfNumber(from));
    final PdfArray widths = PdfArray(width);
    arr.add(widths);
  }
}
