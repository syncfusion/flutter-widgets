part of pdf;

/// Helper class to write PDF graphic streams easily.
class _PdfStreamWriter implements _IPdfWriter {
  //Constructor
  _PdfStreamWriter(_PdfStream? stream) {
    _stream = stream;
  }

  //Fields
  _PdfStream? _stream;

  //Implementation
  void _saveGraphicsState() {
    _writeOperator(_Operators.saveState);
  }

  void _restoreGraphicsState() {
    _writeOperator(_Operators.restoreState);
  }

  void _writeOperator(String opcode) {
    _stream!._write(opcode);
    _stream!._write(_Operators.newLine);
  }

  void _writeComment(String comment) {
    _writeOperator('% ' + comment);
  }

  void _writePoint(double? x, double y) {
    _write(x);
    _stream!._write(_Operators.whiteSpace);
    _write(-y);
    _stream!._write(_Operators.whiteSpace);
  }

  void _closePath() {
    _writeOperator(_Operators.closePath);
  }

  void _clipPath(bool useEvenOddRule) {
    _stream!._write(_Operators.clipPath);
    if (useEvenOddRule) {
      _stream!._write(_Operators.evenOdd);
    }
    _stream!._write(_Operators.whiteSpace);
    _stream!._write(_Operators.endPath);
    _stream!._write(_Operators.newLine);
  }

  void _appendRectangle(double? x, double y, double? width, double height) {
    _writePoint(x, y);
    _writePoint(width, height);
    _writeOperator(_Operators.appendRectangle);
  }

  void _modifyCurrentMatrix(_PdfTransformationMatrix matrix) {
    _stream!._write(matrix._toString());
    _writeOperator(_Operators.currentMatrix);
  }

  void _modifyTransformationMatrix(_PdfTransformationMatrix matrix) {
    _stream!._write(matrix._toString());
    _writeOperator(_Operators.transformationMatrix);
  }

  void _setLineWidth(double width) {
    _write(width);
    _stream!._write(_Operators.whiteSpace);
    _writeOperator(_Operators.setLineWidth);
  }

  void _setLineCap(PdfLineCap lineCapStyle) {
    _write(lineCapStyle.index);
    _stream!._write(_Operators.whiteSpace);
    _writeOperator(_Operators.setLineCapStyle);
  }

  void _setLineJoin(PdfLineJoin lineJoinStyle) {
    _write(lineJoinStyle.index);
    _stream!._write(_Operators.whiteSpace);
    _writeOperator(_Operators.setLineJoinStyle);
  }

  void _setMiterLimit(double? miterLimit) {
    _write(miterLimit);
    _stream!._write(_Operators.whiteSpace);
    _writeOperator(_Operators.setMiterLimit);
  }

  void _setLineDashPattern(List<double>? pattern, double patternOffset) {
    final _PdfArray patternArray = _PdfArray(pattern);
    patternArray.save(this);
    _stream!._write(_Operators.whiteSpace);
    _write(patternOffset);
    _stream!._write(_Operators.whiteSpace);
    _writeOperator(_Operators.setDashPattern);
  }

  void _setColorAndSpace(
      PdfColor color, PdfColorSpace? colorSpace, bool forStroking) {
    if (!color.isEmpty) {
      _stream!._write(color._toString(colorSpace, forStroking));
      _stream!._write(_Operators.newLine);
    }
  }

  void _setColorSpace(_PdfName name, bool forStroking) {
    _stream!._write(name.toString());
    _stream!._write(_Operators.whiteSpace);
    _stream!._write(forStroking
        ? _Operators.selectColorSpaceForStroking
        : _Operators.selectColorSpaceForNonStroking);
    _stream!._write(_Operators.newLine);
  }

  void _setFont(PdfFont font, _PdfName name, double size) {
    _stream!._write(name.toString());
    _stream!._write(_Operators.whiteSpace);
    _stream!._write(size.toStringAsFixed(2));
    _stream!._write(_Operators.whiteSpace);
    _writeOperator(_Operators.setFont);
  }

  void _setTextRenderingMode(int renderingMode) {
    _write(renderingMode);
    _stream!._write(_Operators.whiteSpace);
    _writeOperator(_Operators.setRenderingMode);
  }

  void _setTextScaling(double? textScaling) {
    _write(textScaling);
    _stream!._write(_Operators.whiteSpace);
    _writeOperator(_Operators.setTextScaling);
  }

  void _setCharacterSpacing(double? charSpacing) {
    _write(charSpacing);
    _stream!._write(_Operators.whiteSpace);
    _stream!._write(_Operators.setCharacterSpace);
    _stream!._write(_Operators.newLine);
  }

  void _setWordSpacing(double? wordSpacing) {
    _write(wordSpacing);
    _stream!._write(_Operators.whiteSpace);
    _writeOperator(_Operators.setWordSpace);
  }

  void _showNextLineText(dynamic value) {
    if (value == null) {
      throw ArgumentError.value(value, 'value', 'value cannot be null');
    }
    _writeText(value);
    _writeOperator(_Operators.setTextOnNewLine);
  }

  void _startNextLine([double? x, double? y]) {
    if (x == null && y == null) {
      _writeOperator(_Operators.goToNextLine);
    } else {
      _writePoint(x, y!);
      _writeOperator(_Operators.setCoords);
    }
  }

  void _showText(_PdfString pdfString) {
    _writeText(pdfString);
    _writeOperator(_Operators.setText);
  }

  void _endText() {
    _writeOperator(_Operators.endText);
  }

  void _writeText(dynamic value) {
    if (value is _PdfString) {
      _stream!._write(value._pdfEncode(null));
    } else if (value is List<int>) {
      _stream!._write(_PdfString.stringMark[0]);
      _stream!._write(value);
      _stream!._write(_PdfString.stringMark[1]);
    }
  }

  void _setGraphicsState(_PdfName name) {
    if (name._name!.isEmpty) {
      throw ArgumentError.value(
          name, 'name', 'dictionary name cannot be empty');
    }
    _stream!._write(name.toString());
    _stream!._write(_Operators.whiteSpace);
    _writeOperator(_Operators.setGraphicsState);
  }

  void _beginPath(double x, double y) {
    _writePoint(x, y);
    _writeOperator(_Operators.beginPath);
  }

  void _appendLineSegment(double x, double y) {
    _writePoint(x, y);
    _writeOperator(_Operators.appendLineSegment);
  }

  void _strokePath() {
    _writeOperator(_Operators.stroke);
  }

  void _closeFillStrokePath(bool useEvenOddRule) {
    _stream!._write(_Operators.closeFillStrokePath);
    if (useEvenOddRule) {
      _stream!._write(_Operators.evenOdd);
    }
    _stream!._write(_Operators.newLine);
  }

  void _fillStrokePath(bool useEvenOddRule) {
    _stream!._write(_Operators.fillStroke);
    if (useEvenOddRule) {
      _stream!._write(_Operators.evenOdd);
    }
    _stream!._write(_Operators.newLine);
  }

  void _fillPath(bool useEvenOddRule) {
    _stream!._write(_Operators.fill);
    if (useEvenOddRule) {
      _stream!._write(_Operators.evenOdd);
    }
    _stream!._write(_Operators.newLine);
  }

  void _closeFillPath(bool useEvenOddRule) {
    _writeOperator(_Operators.closePath);
    _stream!._write(_Operators.fill);
    if (useEvenOddRule) {
      _stream!._write(_Operators.evenOdd);
    }
    _stream!._write(_Operators.newLine);
  }

  void _closeStrokePath() {
    _writeOperator(_Operators.closeStrokePath);
  }

  void _endPath() {
    _writeOperator(_Operators.n);
  }

  void _executeObject(_PdfName pdfName) {
    _stream!._write(pdfName.toString());
    _stream!._write(_Operators.whiteSpace);
    _writeOperator(_Operators.paintXObject);
  }

  void _appendBezierSegment(
      double x1, double y1, double x2, double y2, double x3, double y3) {
    _writePoint(x1, y1);
    _writePoint(x2, y2);
    _writePoint(x3, y3);
    _writeOperator(_Operators.appendBezierCurve);
  }

  void _clear() {
    _stream!._clearStream();
  }

  //_IPdfWriter members
  @override
  PdfDocument? get _document => null;

  @override
  //ignore:unused_element
  set _document(PdfDocument? value) {
    throw ArgumentError.value(
        value, 'The method or operation is not implemented');
  }

  @override
  //ignore:unused_element
  int get _length => _stream!._dataStream!.length;

  @override
  //ignore:unused_element
  set _length(int? value) {
    throw ArgumentError.value(
        value, 'The method or operation is not implemented');
  }

  @override
  //ignore:unused_element
  int? get _position => _stream!.position;
  @override
  //ignore:unused_element
  set _position(int? value) {
    throw ArgumentError.value(
        value, 'The method or operation is not implemented');
  }

  @override
  void _write(dynamic pdfObject) {
    if (pdfObject is _IPdfPrimitive) {
      pdfObject.save(this);
    } else if (pdfObject is int) {
      _stream!._write(pdfObject.toString());
    } else if (pdfObject is double) {
      pdfObject = pdfObject.toStringAsFixed(2);
      if ((pdfObject as String).endsWith('.00')) {
        if (pdfObject.length == 3) {
          pdfObject = '0';
        } else {
          pdfObject = pdfObject.substring(0, pdfObject.length - 3);
        }
      }
      _stream!._write(pdfObject);
    } else if (pdfObject is String) {
      _stream!._write(pdfObject);
    } else if (pdfObject is List<int>) {
      _stream!._write(pdfObject);
    } else {
      throw ArgumentError.value(
          pdfObject, 'The method or operation is not implemented');
    }
  }
}
