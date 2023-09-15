part of xlsio;

/// Represents the class used for autofit columns and rows
class _AutoFitManager {
  /// Intializes the AutoFit Manager.
  _AutoFitManager(
      int row, int column, int lastRow, int lastColumn, Range rangeImpl) {
    _row = row;
    _column = column;
    _lastRow = lastRow;
    _lastColumn = lastColumn;
    _rangeImpl = rangeImpl;
    _worksheet = rangeImpl.worksheet;
    _book = rangeImpl.workbook;
  }

  /// Intializes the AutoFit Manager.
  _AutoFitManager._withSheet(Worksheet worksheet) {
    _worksheet = worksheet;
    _book = worksheet.workbook;
  }

  /// Default size of autofilter font size.
  static const double _defaultAutoFilterFontSize = 1.363;

  late Range _rangeImpl;
  late Worksheet _worksheet;
  late Workbook _book;
  late int _row;
  late int _column;
  late int _lastRow;
  late int _lastColumn;

  /// Measures the character ranges.
  int _measureCharacterRanges(
      Style style, String strText, int num1, Rectangle<num> rectF) {
    Font? font2;
    final _FontStyle regular = _FontStyle._regular;
    double size = 10;
    String familyName = 'Arial';
    final Font font = Font();
    font.name = style.fontName;
    font.size = style.fontSize;

    regular._bold = font.bold;
    regular._italic = font.italic;
    // regular.strikeout = font.strikeout;
    regular._underline = font.underline;
    familyName = font.name;
    size = font.size;

    font2 = _createFont(familyName, size, regular);

    if (style.rotation == 90) {
      return (((_getFontHeight(font2) * 1.1) + 0.5) + 6).toInt();
    }

    final Rectangle<num> bounds = _measureString(strText, font2, rectF, false);
    if (style.rotation == 0 || style.rotation == 0xff) {
      int num2 = (bounds.width + 0.5).toInt() + num1;
      if (num2 > 100) {
        num2++;
      }
      return num2;
    }
    final int num3 = (bounds.width + 0.5).toInt() + num1;
    final int num4 = ((_getFontHeight(font2) * 1.1) + 0.5).toInt();
    final double d = (3.1415926535897931 * style.rotation.abs()) / 180.0;
    font2 = null;
    return (((num3 * cos(d)) + (num4 * sin(d))) + 6.5).toInt();
  }

  /// Measures the character ranges.
  int _measureCharacterRangesStyle(_StyleWithText styleWithText, int paramNum,
      Rectangle<num> rectF, int column) {
    int num = 0;
    final Font font = _createFont(
        styleWithText._fontName, styleWithText._size, styleWithText._style!);

    int defIndentWidthinPixels = 0;
    const int defaultPixel = 9;
    const String defaultChar = '0';
    final double indentLevel1 = _getIndentLevel(column);
    for (int i = 0; i < styleWithText._strValues.length; i++) {
      String text = styleWithText._strValues[i];
      double indentLevel = indentLevel1;
      if (indentLevel > 0) {
        if (indentLevel < 10) {
          defIndentWidthinPixels = (indentLevel * defaultPixel).toInt();
          text += defaultChar;
        } else {
          if (text.length < 255 - text.length) //Max indent level is 255
          {
            indentLevel = indentLevel * 2.55; //2.55 is an assumption value
          } else if (text.length < 255 - indentLevel) {
            indentLevel =
                indentLevel * 2.55 + 9; // one indent is equal to 9 pixels.
          } else {
            indentLevel = (text.length) * 2 - indentLevel - 9;
          }

          for (int idx = 1; idx <= indentLevel; idx++) {
            text = ' $text';
          }
        }
      }

      int num3 =
          (_measureString(text, font, rectF, false).width + 0.05).toInt() +
              paramNum;
      if (defIndentWidthinPixels > 0) {
        num3 += defIndentWidthinPixels - paramNum;
      }
      if (num3 > 100) {
        num3++;
      }
      if (num < num3) {
        num = num3;
      }
    }

    return num;
  }

  Font _createFont(String fontName, double size, _FontStyle fontStyle) {
    final Font font = Font();
    font.name = fontName;
    font.size = size;
    font.bold = fontStyle._bold;
    font.italic = fontStyle._italic;
    return font;
  }

  /// Get Indent level.
  double _getIndentLevel(int column) {
    if (_rangeImpl.isSingleRange) {
      return _rangeImpl.cellStyle.indent.toDouble();
    } else {
      double indentLevel = _rangeImpl.cellStyle.indent.toDouble();

      final int firstRow = _rangeImpl.row;
      final int lastRow = _rangeImpl.lastRow;
      for (int iRow = firstRow; iRow <= lastRow; iRow++) {
        final Range range = _worksheet.getRangeByIndex(iRow, column);
        if (indentLevel < range.cellStyle.indent.toDouble()) {
          indentLevel = range.cellStyle.indent.toDouble();
        }
      }
      return indentLevel;
    }
  }

  double _getFontHeight(Font font) {
    return _book._getTextSizeFromFont('a', font)._height;
  }

  Rectangle<num> _measureString(
      String text, Font font, Rectangle<num> rectF, bool isAutoFitRow) {
    return _book._getMeasuredRectangle(text, font, rectF);
  }

  /// Sorts the text to fit.
  static void _sortTextToFit(List<Object>? list, Font fontImpl, String strText,
      bool autoFilter, HAlignType alignment) {
    final _FontStyle regular = _FontStyle._regular;
    double size = 10;
    String name = 'Arial';
    final Font font = fontImpl;
    regular._bold = font.bold;
    regular._italic = font.italic;
    // regular.strikeout = font.strikeout;
    regular._underline = font.underline;
    name = font.name;
    size = font.size;

    if (list != null) {
      for (int i = 0; i < list.length; i++) {
        final _StyleWithText styleWithText = list[i] as _StyleWithText;
        if (((styleWithText._fontName == name) &&
                styleWithText._size == size) &&
            (styleWithText._style!._equals(regular))) {
          for (int j = 0; j < styleWithText._strValues.length; j++) {
            final String str = styleWithText._strValues[j];
            if (str.length < strText.length) {
              styleWithText._strValues.insert(j, strText);
              if (styleWithText._strValues.length > 5) {
                styleWithText._strValues.removeAt(5);
              }
              return;
            }
          }
          if (styleWithText._strValues.length < 5) {
            styleWithText._strValues.add(strText);
          }
          return;
        }
      }
      final _StyleWithText swText = _StyleWithText();
      swText._fontName = name;
      if (autoFilter &&
          (alignment != HAlignType.left && alignment != HAlignType.center)) {
        swText._size = size + _defaultAutoFilterFontSize;
        // swText._fontSizeIncreased = true;
      } else {
        swText._size = size;
      }
      swText._style = regular;
      swText._strValues.add(strText);
      list.add(swText);
    }
  }

  /// Measures to fit column.
  void _measureToFitColumn() {
    const int num1 = 14;
    final int firstRow = _row;
    final int lastRow = _lastRow;
    final int firstColumn = _column;
    final int lastColumn = _lastColumn;
    final Map<int, List<Object>> measurable = <int, List<Object>>{};
    final Map<int, int> columnsWidth = <int, int>{};
    const Rectangle<num> ef = Rectangle<num>(0, 0, 1800, 100);

    for (int row = firstRow; row <= lastRow; row++) {
      for (int column = firstColumn; column <= lastColumn; column++) {
        Range migrantRange = _worksheet.getRangeByIndex(row, column);
        final Style style = migrantRange.cellStyle;
        final Font fontImpl = Font();
        fontImpl.name = style.fontName;
        fontImpl.size = style.fontSize;

        int num4 = 0;

        final bool autofit = migrantRange._bAutofitText;
        final List<dynamic> result =
            Range._isMergedCell(migrantRange, false, num4);
        num4 = result[0] as int;
        final bool isMerged = result[1] as bool;

        if (!isMerged || num4 != 0) {
          if (!autofit) {
            migrantRange._bAutofitText = true;
          }

          if (!columnsWidth.containsKey(column)) {
            columnsWidth[column] = 0;
          }
          String text = migrantRange.displayText;
          if (text == '') {
            continue;
          }

          migrantRange = _worksheet.getRangeByIndex(row, column);
          final bool hasWrapText = style.wrapText;
          if (!hasWrapText) {
            text = text.replaceAll('\n', '');
          }
          if ((style.rotation == 0 || style.rotation == 0xff) && !hasWrapText) {
            List<Object>? arrList =
                (measurable.containsKey(column)) ? measurable[column] : null;
            if (arrList == null) {
              arrList = <Object>[];
              measurable[column] = arrList;
            }
            final HAlignType horizontalAlignment = style.hAlign;
            if (horizontalAlignment == HAlignType.center) {
              final Range cellRange =
                  _rangeImpl.worksheet.getRangeByIndex(row, column++);
              if (column != cellRange.column + 1) {
                continue;
              }
            }
            _sortTextToFit(arrList, fontImpl, text, false, horizontalAlignment);
          } else if (hasWrapText) {
            final int columnWidth = _worksheet._getColumnWidthInPixels(column);
            final double textHeight =
                _calculateWrappedCell(style, text, columnWidth);
            final double fitRowHeight = _book._convertFromPixel(textHeight, 6);

            final double rowHeight = migrantRange.rowHeight;
            List<String> words;
            final List<String> wordsN = text.split('\n');
            final List<String> wordNSplit =
                wordsN[wordsN.length - 1].split(' ');
            words =
                List<String>.filled(wordsN.length - 1 + wordNSplit.length, '');
            for (int i = 0; i < wordsN.length - 1; i++) {
              words[i] = '${wordsN[i]}\n';
            }
            int j = wordsN.length - 1;
            for (int i = 0; i < wordNSplit.length; i++) {
              words[j] = wordNSplit[i];
              j++;
            }
            String autoFitText;
            int biggestLength = 0;
            for (int index = 0; index < words.length; index++) {
              autoFitText = words[index];
              if (autoFitText.isNotEmpty) {
                final int length =
                    _measureCharacterRanges(style, autoFitText, num1, ef);
                final CellType cellType = migrantRange.type;
                final bool isNumberCellType = cellType == CellType.number;
                if (length < columnWidth || isNumberCellType) {
                  for (int temp = index + 1;
                      temp < words.length || temp == 1;
                      temp++) {
                    index = temp;
                    if (words.length != 1) {
                      if (!autoFitText.endsWith('\n')) {
                        autoFitText = '$autoFitText ${words[temp]}';
                      } else {
                        index--;
                      }
                    }
                    final int currentLength =
                        _measureCharacterRanges(style, autoFitText, num1, ef);
                    if (wordsN.length == 1 &&
                        (currentLength > biggestLength) &&
                        rowHeight >= _worksheet._standardHeight &&
                        rowHeight <= fitRowHeight) {
                      biggestLength = currentLength;
                    } else if (currentLength < columnWidth ||
                        isNumberCellType) {
                      if (currentLength > biggestLength) {
                        biggestLength = currentLength;
                        temp = words.length;
                      }
                    } else {
                      index = temp - 1;
                      biggestLength = columnWidth;
                      temp = words.length;
                    }
                  }
                } else if (style.rotation == 0 || style.rotation == 0xff) {
                  if (wordsN.length == 1 &&
                      length > biggestLength &&
                      rowHeight >= _worksheet._standardHeight &&
                      rowHeight <= fitRowHeight) {
                    biggestLength = length;
                  } else {
                    biggestLength = columnWidth;
                  }
                  index = words.length;
                } else if (length > biggestLength) {
                  biggestLength = length;
                }
              }
              if (biggestLength > columnsWidth[column]!) {
                columnsWidth[column] = biggestLength;
              }
            }
          } else {
            final int num5 = _measureCharacterRanges(style, text, num1, ef);
            final int num6 =
                (columnsWidth.containsKey(column)) ? columnsWidth[column]! : 0;
            if (num6 < num5) {
              columnsWidth[column] = num5;
            }
          }
        }
      }
    }
    for (final int key in measurable.keys) {
      final List<Object> list3 = measurable[key]!;
      int num8 = 0;
      for (int k = 0; k < list3.length; k++) {
        final _StyleWithText styleWithText = list3[k] as _StyleWithText;
        final int num10 =
            _measureCharacterRangesStyle(styleWithText, num1, ef, key);
        if (num8 < num10) {
          num8 = num10;
        }
      }
      final int num11 =
          (columnsWidth.containsKey(key)) ? columnsWidth[key]! : 0;
      if (num8 > num11) {
        columnsWidth[key] = num8;
      }
    }

    for (final int key in columnsWidth.keys) {
      final int num12 = columnsWidth[key]!;
      if (num12 != 0) {
        _worksheet.setColumnWidthInPixels(key, num12);
      }
    }
  }

  double _calculateWrappedCell(
      Style format, String stringValue, int columnWidth) {
    final Font font = Font();
    font.name = format.fontName;
    font.size = format.fontSize;
    double num9 = 0;
    double num6 = 0;
    const int number = 19;

    if (stringValue.isEmpty) {
      return 0;
    } else {
      final double calculatedValue = (stringValue.length / 406) * (font.size) +
          (2 * ((font.bold || font.italic) ? 1 : 0));
      num9 = (calculatedValue < columnWidth)
          ? columnWidth.toDouble()
          : calculatedValue;
      num6 = _measureCell(format, stringValue, num9, number, true);
      return num6;
    }
  }

  double _measureCell(Style format, String stringValue, double columnWidth,
      int number, bool isString) {
    final Font font = Font();
    font.name = format.fontName;
    font.size = format.fontSize;
    double size = font.size;
    final _FontStyle regular = _FontStyle._regular;

    if (stringValue[stringValue.length - 1] == '\n') {
      stringValue = '${stringValue}a';
    }

    regular._bold = font.bold;
    regular._italic = font.italic;
    // regular.strikeout = font.strikeout;
    regular._underline = font.underline;
    size = font.size;

    if (isString && (font.name == 'Times New Roman')) {
      stringValue = _modifySepicalChar(stringValue);
    }

    final Font font2 = _createFont(font.name, size, regular);
    const double num2 = 0;
    const double num3 = 0;
    const double num4 = 600;
    if (!format.wrapText) {
      columnWidth = 600;
    } else if (columnWidth < 100) {
      if (format.hAlign == HAlignType.left ||
          format.hAlign == HAlignType.right) {
        columnWidth = columnWidth - 1;
      }
    } else {
      columnWidth = columnWidth - 2;
    }

    final Rectangle<num> ef = Rectangle<num>(num2, num3, columnWidth, num4);
    final Rectangle<num> bounds = _measureString(stringValue, font2, ef, true);
    double num5;

    num5 = (bounds.height).ceilToDouble();

    if ((font.size >= 20) || (num5 > 100)) {
      num5 = num5 + 1;
    }
    if (format.wrapText) {
      if (size >= 10) {
        return num5;
      }
      final int num6 = _calculateFontHeight(font);
      double num7 = bounds.height as double;
      if (num7 > 100) {
        num7 = num7 + 1;
      }
      int num8 = ((num7 * 1.0) / num6).ceil();
      if (num7 > 100) {
        num8 = (((num7 * 1.0) / num6) + 1).toInt();
      }
      if (num8 == 1) {
        return _calculateFontHeightFromGraphics(font);
      }
      final StringBuffer buffer = StringBuffer();
      for (int i = 0; i < num8; i = i + 1) {
        buffer.write('0');
        if (i + 1 < num8) {
          buffer.write('\n');
        }
      }
      return _measureFontSize(format, buffer.toString(), columnWidth);
    }
    final int num10 = format.rotation.abs();
    if (num10 == 90) {
      return (bounds.width + 0.5) + number;
    }
    final int num11 = ((bounds.width + 0.5) + number).toInt();
    final int num12 = ((_getFontHeight(font2) * 1.1) + 0.5).toInt();
    return (num11 * sin((3.1415926535897931 * num10) / 180.0)) +
        (num12 * cos((3.1415926535897931 * num10) / 180.0)) +
        6.5;
  }

  double _calculateFontHeightFromGraphics(Font font) {
    final double size = font.size;
    final _FontStyle regular = _FontStyle._regular;
    regular._bold = font.bold;
    regular._italic = font.italic;
    // regular.strikeout = font.strikeout;
    regular._underline = font.underline;
    final Font font2 = _createFont(font.name, size, regular);

    double num3 = _getFontHeight(font2).ceilToDouble();
    if (((font.size >= 20) || (num3 > 100)) ||
        ((font.size == 12) && font.bold)) {
      num3 = num3 + 1;
    }
    if (font.size == 8) {
      num3 = num3 + 2;
    } else if (font.size < 10) {
      num3 = num3 + 1;
    }
    return num3;
  }

  int _calculateFontHeight(Font font) {
    final double size = font.size;
    final _FontStyle regular = _FontStyle._regular;
    regular._bold = font.bold;
    regular._italic = font.italic;
    // regular.strikeout = font.strikeout;
    regular._underline = font.underline;

    final Font font2 = _createFont(font.name, size, regular);
    return _getFontHeight(font2).ceil();
  }

  double _measureFontSize(
      Style extendedFromat, String stringValue, double columnWidth) {
    if (stringValue.isEmpty) {
      return 0;
    }
    final double size = extendedFromat.fontSize;
    final Font font =
        _createFont(extendedFromat.fontName, size, _FontStyle._regular);

    const double num2 = 0;
    const double num3 = 0;
    const double num4 = 600;
    if (!extendedFromat.wrapText) {
      columnWidth = 600;
    }
    final Rectangle<num> ef = Rectangle<num>(num2, num3, columnWidth, num4);
    return (_measureString(stringValue, font, ef, true).height * 1.1) + 0.5;
  }

  String _modifySepicalChar(String stringValue) {
    final StringBuffer buffer = StringBuffer();
    // ignore: dead_code
    for (int i = 0; i < stringValue.length; i++) {
      switch (stringValue[i]) {
        case ' ':
          if (i != 0) {
            switch (stringValue[i - 1]) {
              case '%':
              case '&':
                buffer.write(stringValue[i]);
                break;
            }
          }
          buffer.write(stringValue[i]);
          continue;

        case '/':
          {
            buffer.write('W');
            continue;
          }
        default:
          {
            buffer.write(stringValue[i]);
            continue;
          }
      }
    }
    return buffer.toString();
  }
}

/// Collection of DisplayText with matching fonts. This class used to improve the AutoFitToColumn method Performance.
class _StyleWithText {
  /// Creates an new instances of the Workbook.
  _StyleWithText() {
    _strValues = <String>[];
  }
  String _fontName = '';
  double _size = 0;
  _FontStyle? _style;
  late List<String> _strValues;
  // bool _fontSizeIncreased;
}

/// Represents Font style class.
class _FontStyle {
  // ignore: prefer_final_fields
  static _FontStyle _regular = _FontStyle();
  bool _bold = false;
  bool _italic = false;
  // bool _strikeout;
  bool _underline = false;

  bool _equals(_FontStyle style) {
    return _bold == style._bold &&
        _italic == style._italic &&
        _underline == style._underline;
  }
}

/// Metrics of the font.
class _FontMetrics {
  /// Initialize the font Metrics class with the parameters.
  _FontMetrics(double ascent, double descent, int linegap, double height,
      double superscriptfactor, double subscriptfactor) {
    _ascent = ascent;
    _descent = descent;
    _lineGap = linegap;
    _height = height;
    _superscriptSizeFactor = superscriptfactor;
    _subScriptSizeFactor = subscriptfactor;
  }

  /// Gets ascent of the font.
  late double _ascent;

  /// Gets descent of the font.
  late double _descent;

  /// Line gap.
  late int _lineGap;

  /// Gets height of the font.
  // ignore: unused_field
  late double _height;

  /// Subscript size factor.
  // ignore: unused_field
  late double _subScriptSizeFactor;

  /// Superscript size factor.
  // ignore: unused_field
  late double _superscriptSizeFactor;

  /// Multiplier of the symbol width.
  static const double _chartSizeMultiplier = 0.001;

  /// Returns ascent taking into consideration font's size.
  double _getAscent(Font format) {
    return _ascent * _chartSizeMultiplier * _getSize(format);
  }

  /// Returns descent taking into consideration font's size.
  double _getDescent(Font format) {
    return _descent * _chartSizeMultiplier * _getSize(format);
  }

  /// Returns Line gap taking into consideration font's size.
  double _getLineGap(Font format) {
    return _lineGap * _chartSizeMultiplier * _getSize(format);
  }

  /// Returns height taking into consideration font's size.
  double _getHeight(Font format) {
    double height;
    if (_getDescent(format) < 0) {
      height = _getAscent(format) - _getDescent(format) + _getLineGap(format);
    } else {
      height = _getAscent(format) + _getDescent(format) + _getLineGap(format);
    }

    return height;
  }

  /// Calculates size of the font depending on the subscript/superscript value.
  double _getSize(Font format) {
    final double size = format.size;
    return size;
  }
}

class _SizeF {
  _SizeF(double width, double height) {
    _width = width;
    _height = height;
  }
  static final _SizeF _empty = _SizeF(0, 0);
  late double _width;
  late double _height;

  // ignore: unused_element
  bool get _isEmpty {
    return (_width == 0) && (_height == 0);
  }
}
