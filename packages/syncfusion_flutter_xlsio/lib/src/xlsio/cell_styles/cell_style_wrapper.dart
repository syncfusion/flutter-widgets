part of xlsio;

/// Represent the Cell Style Wrapper class.
class CellStyleWrapper implements Style {
  /// Creates an new instances of the Workbook.
  CellStyleWrapper(Range range) {
    _arrRanges.addAll(range.cells);
    sheet = range.worksheet;
    workbook = sheet.workbook;
    _borders = BordersCollectionWrapper(_arrRanges, workbook);
  }

  /// Gets/sets borders.
  late Borders _borders;

  /// Represent the workbook.
  late Workbook workbook;

  /// Represent the sheet.
  late Worksheet sheet;

  final List<Range> _arrRanges = <Range>[];
  @override
  String get name {
    String nameStyle = '';
    bool first = true;

    final int last = _arrRanges.length;
    for (int index = 0; index < last; index++) {
      final Range range = _arrRanges[index];

      if (first) {
        nameStyle = range.cellStyle.name;
        first = false;
      } else if (range.cellStyle.name != nameStyle) {
        return '';
      }
    }
    return nameStyle;
  }

  @override
  set name(String value) {
    final int last = _arrRanges.length;
    for (int index = 0; index < last; index++) {
      final Range range = _arrRanges[index];
      range.cellStyle.name = value;
    }
  }

  @override
  int get index {
    int indexStyle = 0;
    bool first = true;
    final int last = _arrRanges.length;
    for (int index = 0; index < last; index++) {
      final Range range = _arrRanges[index];

      if (first) {
        indexStyle = range.cellStyle.index;
        first = false;
      } else if (range.cellStyle.index != indexStyle) {
        return 1;
      }
    }
    return indexStyle;
  }

  @override
  set index(int value) {
    final int last = _arrRanges.length;
    for (int index = 0; index < last; index++) {
      final Range range = _arrRanges[index];
      range.cellStyle.index = value;
    }
  }

  @override
  String get backColor {
    String backColorStyle = '';
    bool first = true;

    final int last = _arrRanges.length;
    for (int index = 0; index < last; index++) {
      final Range range = _arrRanges[index];

      if (first) {
        backColorStyle = range.cellStyle.backColor;
        first = false;
      } else if (range.cellStyle.backColor != backColorStyle) {
        return 'none';
      }
    }
    return backColorStyle;
  }

  @override
  set backColor(String value) {
    final int last = _arrRanges.length;
    for (int index = 0; index < last; index++) {
      final Range range = _arrRanges[index];
      range.cellStyle.backColor = value;
    }
  }

  @override
  Borders get borders {
    return _borders;
  }

  @override
  set borders(Borders value) {
    final int last = _arrRanges.length;
    for (int index = 0; index < last; index++) {
      final Range range = _arrRanges[index];
      range.cellStyle.borders = value;
    }
  }

  @override
  double get fontSize {
    double fontSizeStyle = 11;
    bool first = true;

    final int last = _arrRanges.length;
    for (int index = 0; index < last; index++) {
      final Range range = _arrRanges[index];

      if (first) {
        fontSizeStyle = range.cellStyle.fontSize;
        first = false;
      } else if (range.cellStyle.fontSize != fontSizeStyle) {
        return 11;
      }
    }
    return fontSizeStyle;
  }

  @override
  set fontSize(double value) {
    final int last = _arrRanges.length;
    for (int index = 0; index < last; index++) {
      final Range range = _arrRanges[index];
      range.cellStyle.fontSize = value;
    }
  }

  @override
  String get fontName {
    String fontNameStyle = 'Calibri';
    bool first = true;

    final int last = _arrRanges.length;
    for (int index = 0; index < last; index++) {
      final Range range = _arrRanges[index];

      if (first) {
        fontNameStyle = range.cellStyle.fontName;
        first = false;
      } else if (range.cellStyle.fontName != fontNameStyle) {
        return 'Calibri';
      }
    }
    return fontNameStyle;
  }

  @override
  set fontName(String value) {
    final int last = _arrRanges.length;
    for (int index = 0; index < last; index++) {
      final Range range = _arrRanges[index];
      range.cellStyle.fontName = value;
    }
  }

  @override
  int get rotation {
    int rotationStyle = 0;
    bool first = true;

    final int last = _arrRanges.length;
    for (int index = 0; index < last; index++) {
      final Range range = _arrRanges[index];

      if (first) {
        rotationStyle = range.cellStyle.rotation;
        first = false;
      } else if (range.cellStyle.rotation != rotationStyle) {
        return 0;
      }
    }
    return rotationStyle;
  }

  @override
  set rotation(int value) {
    final int last = _arrRanges.length;
    for (int index = 0; index < last; index++) {
      final Range range = _arrRanges[index];
      range.cellStyle.rotation = value;
    }
  }

  @override
  String get fontColor {
    String fontColorStyle = '';
    bool first = true;

    final int last = _arrRanges.length;
    for (int index = 0; index < last; index++) {
      final Range range = _arrRanges[index];

      if (first) {
        fontColorStyle = range.cellStyle.fontColor;
        first = false;
      } else if (range.cellStyle.fontColor != fontColorStyle) {
        return '#000000';
      }
    }
    return fontColorStyle;
  }

  @override
  set fontColor(String value) {
    final int last = _arrRanges.length;
    for (int index = 0; index < last; index++) {
      final Range range = _arrRanges[index];
      range.cellStyle.fontColor = value;
    }
  }

  @override
  bool get bold {
    bool boldStyle = false;
    bool first = true;

    final int last = _arrRanges.length;
    for (int index = 0; index < last; index++) {
      final Range range = _arrRanges[index];

      if (first) {
        boldStyle = range.cellStyle.bold;
        first = false;
      } else if (range.cellStyle.bold != boldStyle) {
        return false;
      }
    }
    return boldStyle;
  }

  @override
  set bold(bool value) {
    final int last = _arrRanges.length;
    for (int index = 0; index < last; index++) {
      final Range range = _arrRanges[index];
      range.cellStyle.bold = value;
    }
  }

  @override
  bool get italic {
    bool italicStyle = false;
    bool first = true;

    final int last = _arrRanges.length;
    for (int index = 0; index < last; index++) {
      final Range range = _arrRanges[index];

      if (first) {
        italicStyle = range.cellStyle.italic;
        first = false;
      } else if (range.cellStyle.italic != italicStyle) {
        return false;
      }
    }
    return italicStyle;
  }

  @override
  set italic(bool value) {
    final int last = _arrRanges.length;
    for (int index = 0; index < last; index++) {
      final Range range = _arrRanges[index];
      range.cellStyle.italic = value;
    }
  }

  @override
  HAlignType get hAlign {
    HAlignType hAlignStyle = HAlignType.general;
    bool first = true;

    final int last = _arrRanges.length;
    for (int index = 0; index < last; index++) {
      final Range range = _arrRanges[index];

      if (first) {
        hAlignStyle = range.cellStyle.hAlign;
        first = false;
      } else if (range.cellStyle.hAlign != hAlignStyle) {
        return HAlignType.general;
      }
    }
    return hAlignStyle;
  }

  @override
  set hAlign(HAlignType value) {
    final int last = _arrRanges.length;
    for (int index = 0; index < last; index++) {
      final Range range = _arrRanges[index];
      range.cellStyle.hAlign = value;
    }
  }

  @override
  VAlignType get vAlign {
    VAlignType vAlignStyle = VAlignType.bottom;
    bool first = true;

    final int last = _arrRanges.length;
    for (int index = 0; index < last; index++) {
      final Range range = _arrRanges[index];

      if (first) {
        vAlignStyle = range.cellStyle.vAlign;
        first = false;
      } else if (range.cellStyle.vAlign != vAlignStyle) {
        return VAlignType.bottom;
      }
    }
    return vAlignStyle;
  }

  @override
  set vAlign(VAlignType value) {
    final int last = _arrRanges.length;
    for (int index = 0; index < last; index++) {
      final Range range = _arrRanges[index];
      range.cellStyle.vAlign = value;
    }
  }

  @override
  int get indent {
    int indentStyle = 0;
    bool first = true;

    final int last = _arrRanges.length;
    for (int index = 0; index < last; index++) {
      final Range range = _arrRanges[index];

      if (first) {
        indentStyle = range.cellStyle.indent;
        first = false;
      } else if (range.cellStyle.indent != indentStyle) {
        return 0;
      }
    }
    return indentStyle;
  }

  @override
  set indent(int value) {
    final int last = _arrRanges.length;
    for (int index = 0; index < last; index++) {
      final Range range = _arrRanges[index];
      range.cellStyle.indent = value;
    }
  }

  @override
  bool get underline {
    bool underlineStyle = false;
    bool first = true;

    final int last = _arrRanges.length;
    for (int index = 0; index < last; index++) {
      final Range range = _arrRanges[index];

      if (first) {
        underlineStyle = range.cellStyle.underline;
        first = false;
      } else if (range.cellStyle.underline != underlineStyle) {
        return false;
      }
    }
    return underlineStyle;
  }

  @override
  set underline(bool value) {
    final int last = _arrRanges.length;
    for (int index = 0; index < last; index++) {
      final Range range = _arrRanges[index];
      range.cellStyle.underline = value;
    }
  }

  @override
  bool get wrapText {
    bool wrapTextStyle = false;
    bool first = true;

    final int last = _arrRanges.length;
    for (int index = 0; index < last; index++) {
      final Range range = _arrRanges[index];

      if (first) {
        wrapTextStyle = range.cellStyle.wrapText;
        first = false;
      } else if (range.cellStyle.wrapText != wrapTextStyle) {
        return false;
      }
    }
    return wrapTextStyle;
  }

  @override
  set wrapText(bool value) {
    final int last = _arrRanges.length;
    for (int index = 0; index < last; index++) {
      final Range range = _arrRanges[index];
      range.cellStyle.wrapText = value;
    }
  }

  @override
  int get numberFormatIndex {
    int numberFormatIndexStyle = 0;
    bool first = true;

    final int last = _arrRanges.length;
    for (int index = 0; index < last; index++) {
      final Range range = _arrRanges[index];

      if (first) {
        numberFormatIndexStyle = range.cellStyle.numberFormatIndex;
        first = false;
      } else if (range.cellStyle.numberFormatIndex != numberFormatIndexStyle) {
        return 0;
      }
    }
    return numberFormatIndexStyle;
  }

  @override
  set numberFormatIndex(int value) {
    final int last = _arrRanges.length;
    for (int index = 0; index < last; index++) {
      final Range range = _arrRanges[index];
      range.cellStyle.numberFormatIndex = value;
    }
  }

  @override
  //Represent numberFormat
  String? get numberFormat {
    String? numberFormatStyle;
    bool first = true;

    final int last = _arrRanges.length;
    for (int index = 0; index < last; index++) {
      final Range range = _arrRanges[index];

      if (first) {
        numberFormatStyle = range.cellStyle.numberFormat;
        first = false;
      } else if (range.cellStyle.numberFormat != numberFormatStyle) {
        return 'General';
      }
    }
    return numberFormatStyle;
  }

  @override
  set numberFormat(String? value) {
    final int last = _arrRanges.length;
    for (int index = 0; index < last; index++) {
      final Range range = _arrRanges[index];
      range.cellStyle.numberFormat = value;
    }
  }

  /// Represents the global style.
  bool get isGlobalStyle {
    bool isGlobalStyleStyle = false;
    bool first = true;

    final int last = _arrRanges.length;
    for (int index = 0; index < last; index++) {
      final Range range = _arrRanges[index];

      if (first) {
        isGlobalStyleStyle = (range.cellStyle as CellStyle).isGlobalStyle;
        first = false;
      } else if ((range.cellStyle as CellStyle).isGlobalStyle !=
          isGlobalStyleStyle) {
        return false;
      }
    }
    return isGlobalStyleStyle;
  }

  set isGlobalStyle(bool value) {
    final int last = _arrRanges.length;
    for (int index = 0; index < last; index++) {
      final Range range = _arrRanges[index];
      (range.cellStyle as CellStyle).isGlobalStyle = value;
    }
  }

  @override

  /// Represents the locked.
  bool get locked {
    bool locked = true;
    bool first = true;

    final int last = _arrRanges.length;
    for (int index = 0; index < last; index++) {
      final Range range = _arrRanges[index];

      if (first) {
        locked = (range.cellStyle as CellStyle).locked;
        first = false;
      } else if ((range.cellStyle as CellStyle).locked != locked) {
        return false;
      }
    }
    return locked;
  }

  @override
  set locked(bool value) {
    final int last = _arrRanges.length;
    for (int index = 0; index < last; index++) {
      final Range range = _arrRanges[index];
      (range.cellStyle as CellStyle).locked = value;
    }
  }

  @override
  Color get backColorRgb {
    Color backColorStyle = const Color.fromARGB(255, 0, 0, 0);
    bool first = true;

    final int last = _arrRanges.length;
    for (int index = 0; index < last; index++) {
      final Range range = _arrRanges[index];

      if (first) {
        backColorStyle = range.cellStyle.backColorRgb;
        first = false;
      } else if (range.cellStyle.backColorRgb != backColorStyle) {
        return const Color.fromARGB(255, 0, 0, 0);
      }
    }
    return backColorStyle;
  }

  @override
  set backColorRgb(Color value) {
    final int last = _arrRanges.length;
    for (int index = 0; index < last; index++) {
      final Range range = _arrRanges[index];
      range.cellStyle.backColorRgb = value;
    }
  }

  @override
  Color get fontColorRgb {
    Color fontColorStyle = const Color.fromARGB(255, 0, 0, 0);
    bool first = true;

    final int last = _arrRanges.length;
    for (int index = 0; index < last; index++) {
      final Range range = _arrRanges[index];

      if (first) {
        fontColorStyle = range.cellStyle.fontColorRgb;
        first = false;
      } else if (range.cellStyle.fontColorRgb != fontColorStyle) {
        return const Color.fromARGB(255, 0, 0, 0);
      }
    }
    return fontColorStyle;
  }

  @override
  set fontColorRgb(Color value) {
    final int last = _arrRanges.length;
    for (int index = 0; index < last; index++) {
      final Range range = _arrRanges[index];
      range.cellStyle.fontColorRgb = value;
    }
  }
}
