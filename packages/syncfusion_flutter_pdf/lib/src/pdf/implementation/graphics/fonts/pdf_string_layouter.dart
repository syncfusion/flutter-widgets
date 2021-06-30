part of pdf;

/// Class lay outing the text.
class _PdfStringLayouter {
  //Constructor
  _PdfStringLayouter() {
    _size = _Size.empty;
    _rectangle = _Rectangle.empty;
  }

  //Fields
  //ignore: unused_field
  String? _text;
  PdfFont? _font;
  PdfStringFormat? _format;
  late _Size _size;
  late _Rectangle _rectangle;
  late double _pageHeight;
  _StringTokenizer? _reader;
  int _tabOccuranceCount = 0;
  bool _isTabReplaced = false;

  //Implementation
  _PdfStringLayoutResult _layout(
      String text, PdfFont font, PdfStringFormat? format,
      {double? width, double? height, _Rectangle? bounds, double? pageHeight}) {
    _text = text;
    _font = font;
    _format = format;
    _size = bounds == null ? _Size(width!, height!) : bounds.size;
    _rectangle = bounds ?? _Rectangle(0, 0, width!, height!);
    _pageHeight = pageHeight ?? 0;
    _reader = _StringTokenizer(text);
    final _PdfStringLayoutResult result = _doLayout();
    _clear();
    return result;
  }

  _PdfStringLayoutResult _doLayout() {
    final _PdfStringLayoutResult result = _PdfStringLayoutResult();
    _PdfStringLayoutResult lineResult = _PdfStringLayoutResult();
    final List<_LineInfo> lines = <_LineInfo>[];
    String? line = _reader!._peekLine();
    double? lineIndent = _getLineIndent(true);
    while (line != null) {
      lineResult = _layoutLine(line, lineIndent!);
      int? numSymbolsInserted = 0;
      final Map<String, dynamic> returnedValue =
          _copyToResult(result, lineResult, lines, numSymbolsInserted)
              as Map<String, dynamic>;
      final bool success = returnedValue['success'] as bool;
      numSymbolsInserted = returnedValue['numInserted'] as int?;
      if (!success) {
        _reader!._read(numSymbolsInserted);
        break;
      }
      _reader!._readLine();
      line = _reader!._peekLine();
      lineIndent = _getLineIndent(false);
    }
    _finalizeResult(result, lines);
    return result;
  }

  void _finalizeResult(_PdfStringLayoutResult result, List<_LineInfo> lines) {
    result._lines = lines.toList();
    result._lineHeight = _getLineHeight();
    if (!_reader!._isEndOfFile) {
      result._remainder = _reader!._readToEnd();
    }
    lines.length = 0;
  }

  double? _getLineIndent(bool firstLine) {
    double? lineIndent = 0;
    if (_format != null) {
      lineIndent =
          firstLine ? _format!._firstLineIndent : _format!.paragraphIndent;
      lineIndent = (_size.width > 0)
          ? (_size.width <= lineIndent ? _size.width : lineIndent)
          : lineIndent;
    }
    return lineIndent;
  }

  _PdfStringLayoutResult _layoutLine(String line, double lineIndent) {
    if (line.contains('\t')) {
      _tabOccuranceCount = 0;
      int i = 0;
      const String tab = '\t';
      while ((i = line.indexOf(tab, i)) != -1) {
        i += tab.length;
        _tabOccuranceCount++;
      }
      line = line.replaceAll('\t', '    ');
      _isTabReplaced = true;
    }
    final _PdfStringLayoutResult lineResult = _PdfStringLayoutResult();
    lineResult._lineHeight = _getLineHeight();
    final List<_LineInfo> lines = <_LineInfo>[];
    final double maxWidth = _size.width;
    double lineWidth = _getLineWidth(line) + lineIndent;
    _LineType lineType = _LineType.firstParagraphLine;
    bool readWord = true;
    if (maxWidth <= 0 ||
        lineWidth.roundToDouble() <= maxWidth.roundToDouble()) {
      _addToLineResult(
          lineResult,
          lines,
          line,
          lineWidth,
          _getLineTypeValue(_LineType.newLineBreak)! |
              _getLineTypeValue(lineType)!);
    } else {
      String builder = '';
      String curLine = '';
      lineWidth = lineIndent;
      double curIndent = lineIndent;
      final _StringTokenizer reader = _StringTokenizer(line);
      String? word = reader._peekWord();
      if (word!.length != reader._length) {
        if (word == ' ') {
          curLine = curLine + word;
          builder = builder + word;
          reader._position = reader._position! + 1;
          word = reader._peekWord()!;
        }
      }
      while (word != null) {
        curLine += word;
        double curLineWidth = _getLineWidth(curLine.toString()) + curIndent;
        if (curLine.toString() == ' ') {
          curLine = '';
          curLineWidth = 0;
        }
        if (curLineWidth > maxWidth) {
          if (_getWrapType() == PdfWordWrapType.none) {
            break;
          }
          if (curLine.length == word.length) {
            if (_getWrapType() == PdfWordWrapType.wordOnly) {
              lineResult._remainder = line.substring(reader._position!);
              break;
            } else if (curLine.length == 1) {
              builder += word;
              break;
            } else {
              readWord = false;
              curLine = '';
              word = reader._peek().toString();
              continue;
            }
          } else {
            if (_getWrapType() != PdfWordWrapType.character || !readWord) {
              final String ln = builder.toString();
              if (ln != ' ') {
                _addToLineResult(
                    lineResult,
                    lines,
                    ln,
                    lineWidth,
                    _getLineTypeValue(_LineType.layoutBreak)! |
                        _getLineTypeValue(lineType)!);
              }
              curLine = '';
              builder = '';
              lineWidth = 0;
              curIndent = 0;
              curLineWidth = 0;
              lineType = _LineType.none;
              word = readWord ? word : reader._peekWord()!;
              readWord = true;
            } else {
              readWord = false;
              curLine = builder.toString();
              word = reader._peek();
            }
            continue;
          }
        }
        builder += word;
        lineWidth = curLineWidth;
        if (readWord) {
          reader._readWord();
          word = reader._peekWord();
        } else {
          reader._read();
          word = reader._peek().toString();
        }
      }
      if (builder.isNotEmpty) {
        final String ln = builder.toString();
        _addToLineResult(
            lineResult,
            lines,
            ln,
            lineWidth,
            _getLineTypeValue(_LineType.newLineBreak)! |
                _getLineTypeValue(_LineType.lastParagraphLine)!);
      }
      reader._close();
    }
    lineResult._lines = lines.toList();
    lines.length = 0;
    return lineResult;
  }

  void _addToLineResult(_PdfStringLayoutResult lineResult,
      List<_LineInfo> lines, String line, double lineWidth, int breakType) {
    final _LineInfo info = _LineInfo();
    info.text = line;
    info.width = lineWidth;
    info._lineType = breakType;
    info.lineType = _getLineType(breakType);
    lines.add(info);
    final _Size size = lineResult._size;
    size.height += _getLineHeight();
    size.width = size.width >= lineWidth ? size.width : lineWidth;
    lineResult._size = size;
  }

  List<_LineType> _getLineType(int breakType) {
    final List<_LineType> result = <_LineType>[];
    if ((breakType & _getLineTypeValue(_LineType.none)!) > 0) {
      result.add(_LineType.none);
    }
    if ((breakType & _getLineTypeValue(_LineType.newLineBreak)!) > 0) {
      result.add(_LineType.newLineBreak);
    }
    if ((breakType & _getLineTypeValue(_LineType.layoutBreak)!) > 0) {
      result.add(_LineType.layoutBreak);
    }
    if (breakType & _getLineTypeValue(_LineType.firstParagraphLine)! > 0) {
      result.add(_LineType.firstParagraphLine);
    }
    if (breakType & _getLineTypeValue(_LineType.lastParagraphLine)! > 0) {
      result.add(_LineType.lastParagraphLine);
    }
    return result;
  }

  double _getLineHeight() {
    return (_format != null && _format!.lineSpacing != 0)
        ? _format!.lineSpacing + _font!.height
        : _font!.height;
  }

  double _getLineWidth(String line) {
    return _font!._getLineWidth(line, _format);
  }

  PdfWordWrapType? _getWrapType() {
    return _format != null ? _format!.wordWrap : PdfWordWrapType.word;
  }

  dynamic _copyToResult(
      _PdfStringLayoutResult result,
      _PdfStringLayoutResult lineResult,
      List<_LineInfo> lines,
      int? numInserted) {
    bool success = true;
    final bool allowPartialLines = _format != null && !_format!.lineLimit;
    double? height = result._size.height;
    double? maxHeight = _size.height;
    if ((_pageHeight > 0) && (maxHeight + _rectangle.y > _pageHeight)) {
      maxHeight = _rectangle.y - _pageHeight;
      maxHeight = maxHeight >= -maxHeight ? maxHeight : -maxHeight;
    }
    numInserted = 0;
    if (lineResult._lines != null) {
      for (int i = 0; i < lineResult._lines!.length; i++) {
        final double expHeight = height! + lineResult._lineHeight;
        if (expHeight <= maxHeight || maxHeight <= 0 || allowPartialLines) {
          _LineInfo info = lineResult._lines![i];
          if (!_isTabReplaced) {
            numInserted = numInserted! + info.text!.length;
          } else {
            numInserted =
                numInserted! + info.text!.length - (_tabOccuranceCount * 3);
            _isTabReplaced = false;
          }
          info = _trimLine(info, lines.isEmpty);
          lines.add(info);
          final _Size size = result._size;
          size.width = (size.width >= info.width!) ? size.width : info.width!;
          result._size = size;
          height = expHeight;
        } else {
          success = false;
          break;
        }
      }
    }
    if (height != result._size.height) {
      final _Size size = result._size;
      size.height = height!;
      result._size = size;
    }
    return <String, dynamic>{'success': success, 'numInserted': numInserted};
  }

  _LineInfo _trimLine(_LineInfo info, bool firstLine) {
    String line = info.text.toString();
    double? lineWidth = info.width;
    final bool start = _format == null ||
        _format!.textDirection != PdfTextDirection.rightToLeft;
    if (!info.lineType.contains(_LineType.firstParagraphLine)) {
      line = start ? line.trimLeft() : line.trimRight();
    }
    if (_format == null || !_format!.measureTrailingSpaces) {
      line = start ? line.trimRight() : line.trimLeft();
    }
    if (line.length != info.text!.length) {
      lineWidth = _getLineWidth(line);
      if (info._lineType & _getLineTypeValue(_LineType.firstParagraphLine)! >
          0) {
        lineWidth += _getLineIndent(firstLine)!;
      }
    }
    info.text = line;
    info.width = lineWidth;
    return info;
  }

  void _clear() {
    _font = null;
    _format = null;
    _reader!._close();
    _reader = null;
    _text = null;
  }

  static int? _getLineTypeValue(_LineType type) {
    int? value;
    switch (type) {
      case _LineType.none:
        value = 0;
        break;
      case _LineType.newLineBreak:
        value = 0x0001;
        break;
      case _LineType.layoutBreak:
        value = 0x0002;
        break;
      case _LineType.firstParagraphLine:
        value = 0x0004;
        break;
      case _LineType.lastParagraphLine:
        value = 0x0008;
        break;
    }
    return value;
  }
}

/// Provides a line information
class _LineInfo {
  String? text;
  double? width;
  List<_LineType> lineType = <_LineType>[];
  late int _lineType;
}
