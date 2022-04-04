import '../../drawing/drawing.dart';
import '../enums.dart';
import 'enums.dart';
import 'pdf_font.dart';
import 'pdf_string_format.dart';
import 'pdf_string_layout_result.dart';
import 'string_tokenizer.dart';

/// Class lay outing the text.
class PdfStringLayouter {
  //Constructor
  /// internal constructor
  PdfStringLayouter() {
    _size = PdfSize.empty;
    _rectangle = PdfRectangle.empty;
  }

  //Fields
  //ignore: unused_field
  String? _text;
  PdfFont? _font;
  PdfStringFormat? _format;
  late PdfSize _size;
  late PdfRectangle _rectangle;
  late double _pageHeight;
  StringTokenizer? _reader;
  int _tabOccuranceCount = 0;
  bool _isTabReplaced = false;

  //Implementation
  /// internal method
  PdfStringLayoutResult layout(
      String text, PdfFont font, PdfStringFormat? format,
      {double? width,
      double? height,
      PdfRectangle? bounds,
      double? pageHeight}) {
    _text = text;
    _font = font;
    _format = format;
    _size = bounds == null ? PdfSize(width!, height!) : bounds.size;
    _rectangle = bounds ?? PdfRectangle(0, 0, width!, height!);
    _pageHeight = pageHeight ?? 0;
    _reader = StringTokenizer(text);
    final PdfStringLayoutResult result = _doLayout();
    _clear();
    return result;
  }

  PdfStringLayoutResult _doLayout() {
    final PdfStringLayoutResult result = PdfStringLayoutResult();
    PdfStringLayoutResult lineResult = PdfStringLayoutResult();
    final List<LineInfo> lines = <LineInfo>[];
    String? line = _reader!.peekLine();
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
        _reader!.read(numSymbolsInserted);
        break;
      }
      _reader!.readLine();
      line = _reader!.peekLine();
      lineIndent = _getLineIndent(false);
    }
    _finalizeResult(result, lines);
    return result;
  }

  void _finalizeResult(PdfStringLayoutResult result, List<LineInfo> lines) {
    result.lines = lines.toList();
    result.lineHeight = _getLineHeight();
    if (!_reader!.isEndOfFile) {
      result.remainder = _reader!.readToEnd();
    }
    lines.length = 0;
  }

  double? _getLineIndent(bool firstLine) {
    double? lineIndent = 0;
    if (_format != null) {
      lineIndent = firstLine
          ? PdfStringFormatHelper.getHelper(_format!).firstLineIndent
          : _format!.paragraphIndent;
      lineIndent = (_size.width > 0)
          ? (_size.width <= lineIndent ? _size.width : lineIndent)
          : lineIndent;
    }
    return lineIndent;
  }

  PdfStringLayoutResult _layoutLine(String line, double lineIndent) {
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
    final PdfStringLayoutResult lineResult = PdfStringLayoutResult();
    lineResult.lineHeight = _getLineHeight();
    final List<LineInfo> lines = <LineInfo>[];
    final double maxWidth = _size.width;
    double lineWidth = _getLineWidth(line) + lineIndent;
    LineType lineType = LineType.firstParagraphLine;
    bool readWord = true;
    if (maxWidth <= 0 ||
        lineWidth.roundToDouble() <= maxWidth.roundToDouble()) {
      _addToLineResult(
          lineResult,
          lines,
          line,
          lineWidth,
          getLineTypeValue(LineType.newLineBreak)! |
              getLineTypeValue(lineType)!);
    } else {
      String builder = '';
      String curLine = '';
      lineWidth = lineIndent;
      double curIndent = lineIndent;
      final StringTokenizer reader = StringTokenizer(line);
      String? word = reader.peekWord();
      if (word!.length != reader.length) {
        if (word == ' ') {
          curLine = curLine + word;
          builder = builder + word;
          reader.position = reader.position! + 1;
          word = reader.peekWord();
        }
      }
      while (word != null) {
        curLine += word;
        double curLineWidth = _getLineWidth(curLine) + curIndent;
        if (curLine == ' ') {
          curLine = '';
          curLineWidth = 0;
        }
        if (curLineWidth > maxWidth) {
          if (_getWrapType() == PdfWordWrapType.none) {
            break;
          }
          if (curLine.length == word.length) {
            if (_getWrapType() == PdfWordWrapType.wordOnly) {
              lineResult.remainder = line.substring(reader.position!);
              break;
            } else if (curLine.length == 1) {
              builder += word;
              break;
            } else {
              readWord = false;
              curLine = '';
              word = reader.peek();
              continue;
            }
          } else {
            if (_getWrapType() != PdfWordWrapType.character || !readWord) {
              final String ln = builder;
              if (ln != ' ') {
                _addToLineResult(
                    lineResult,
                    lines,
                    ln,
                    lineWidth,
                    getLineTypeValue(LineType.layoutBreak)! |
                        getLineTypeValue(lineType)!);
              }
              curLine = '';
              builder = '';
              lineWidth = 0;
              curIndent = 0;
              curLineWidth = 0;
              lineType = LineType.none;
              word = readWord ? word : reader.peekWord()!;
              readWord = true;
            } else {
              readWord = false;
              curLine = builder;
              word = reader.peek();
            }
            continue;
          }
        }
        builder += word;
        lineWidth = curLineWidth;
        if (readWord) {
          reader.readWord();
          word = reader.peekWord();
        } else {
          reader.read();
          word = reader.peek();
        }
      }
      if (builder.isNotEmpty) {
        final String ln = builder;
        _addToLineResult(
            lineResult,
            lines,
            ln,
            lineWidth,
            getLineTypeValue(LineType.newLineBreak)! |
                getLineTypeValue(LineType.lastParagraphLine)!);
      }
      reader.close();
    }
    lineResult.lines = lines.toList();
    lines.length = 0;
    return lineResult;
  }

  void _addToLineResult(PdfStringLayoutResult lineResult, List<LineInfo> lines,
      String line, double lineWidth, int breakType) {
    final LineInfo info = LineInfo();
    info.text = line;
    info.width = lineWidth;
    info.lineType = breakType;
    info.lineTypeList = _getLineType(breakType);
    lines.add(info);
    final PdfSize size = lineResult.size;
    size.height += _getLineHeight();
    size.width = size.width >= lineWidth ? size.width : lineWidth;
    lineResult.size = size;
  }

  List<LineType> _getLineType(int breakType) {
    final List<LineType> result = <LineType>[];
    if ((breakType & getLineTypeValue(LineType.none)!) > 0) {
      result.add(LineType.none);
    }
    if ((breakType & getLineTypeValue(LineType.newLineBreak)!) > 0) {
      result.add(LineType.newLineBreak);
    }
    if ((breakType & getLineTypeValue(LineType.layoutBreak)!) > 0) {
      result.add(LineType.layoutBreak);
    }
    if (breakType & getLineTypeValue(LineType.firstParagraphLine)! > 0) {
      result.add(LineType.firstParagraphLine);
    }
    if (breakType & getLineTypeValue(LineType.lastParagraphLine)! > 0) {
      result.add(LineType.lastParagraphLine);
    }
    return result;
  }

  double _getLineHeight() {
    return (_format != null && _format!.lineSpacing != 0)
        ? _format!.lineSpacing + _font!.height
        : _font!.height;
  }

  double _getLineWidth(String line) {
    return PdfFontHelper.getLineWidth(_font!, line, _format);
  }

  PdfWordWrapType? _getWrapType() {
    return _format != null ? _format!.wordWrap : PdfWordWrapType.word;
  }

  dynamic _copyToResult(
      PdfStringLayoutResult result,
      PdfStringLayoutResult lineResult,
      List<LineInfo> lines,
      int? numInserted) {
    bool success = true;
    final bool allowPartialLines = _format != null && !_format!.lineLimit;
    double? height = result.size.height;
    double? maxHeight = _size.height;
    if ((_pageHeight > 0) && (maxHeight + _rectangle.y > _pageHeight)) {
      maxHeight = _rectangle.y - _pageHeight;
      maxHeight = maxHeight >= -maxHeight ? maxHeight : -maxHeight;
    }
    numInserted = 0;
    if (lineResult.lines != null) {
      for (int i = 0; i < lineResult.lines!.length; i++) {
        final double expHeight = height! + lineResult.lineHeight;
        if (expHeight <= maxHeight ||
            maxHeight <= 0 ||
            allowPartialLines ||
            (expHeight - maxHeight).abs() < 0.001) {
          LineInfo info = lineResult.lines![i];
          if (!_isTabReplaced) {
            numInserted = numInserted! + info.text!.length;
          } else {
            numInserted =
                numInserted! + info.text!.length - (_tabOccuranceCount * 3);
            _isTabReplaced = false;
          }
          info = _trimLine(info, lines.isEmpty);
          lines.add(info);
          final PdfSize size = result.size;
          size.width = (size.width >= info.width!) ? size.width : info.width!;
          result.size = size;
          height = expHeight;
        } else {
          success = false;
          break;
        }
      }
    }
    if (height != result.size.height) {
      final PdfSize size = result.size;
      size.height = height!;
      result.size = size;
    }
    return <String, dynamic>{'success': success, 'numInserted': numInserted};
  }

  LineInfo _trimLine(LineInfo info, bool firstLine) {
    String line = info.text.toString();
    double? lineWidth = info.width;
    final bool start = _format == null ||
        _format!.textDirection != PdfTextDirection.rightToLeft;
    if (!info.lineTypeList.contains(LineType.firstParagraphLine)) {
      line = start ? line.trimLeft() : line.trimRight();
    }
    if (_format == null || !_format!.measureTrailingSpaces) {
      line = start ? line.trimRight() : line.trimLeft();
    }
    if (line.length != info.text!.length) {
      lineWidth = _getLineWidth(line);
      if (info.lineType & getLineTypeValue(LineType.firstParagraphLine)! > 0) {
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
    _reader!.close();
    _reader = null;
    _text = null;
  }

  /// internal method
  static int? getLineTypeValue(LineType type) {
    int? value;
    switch (type) {
      case LineType.none:
        value = 0;
        break;
      case LineType.newLineBreak:
        value = 0x0001;
        break;
      case LineType.layoutBreak:
        value = 0x0002;
        break;
      case LineType.firstParagraphLine:
        value = 0x0004;
        break;
      case LineType.lastParagraphLine:
        value = 0x0008;
        break;
    }
    return value;
  }
}

/// Provides a line information
class LineInfo {
  /// internal field
  String? text;

  /// internal field
  double? width;

  /// internal field
  List<LineType> lineTypeList = <LineType>[];

  /// internal field
  late int lineType;
}
