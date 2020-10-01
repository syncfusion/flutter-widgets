part of pdf;

/// Represents the schema of a cell in a [PdfGrid].
class PdfGridCell {
  /// Initializes a new instance of the [PdfGridCell] class.
  PdfGridCell(
      {PdfGridCellStyle style,
      PdfStringFormat format,
      PdfGridRow row,
      int rowSpan,
      int columnSpan}) {
    _initialize(style, format, row, rowSpan, columnSpan);
  }

  //Fields
  double _width;
  double _height;
  double _outerCellWidth;
  int _rowSpan;
  int _columnSpan;
  PdfGridRow _row;
  dynamic _value;
  PdfStringFormat _format;
  bool _finished;
  String _remainingString;
  bool _present = false;
  PdfGridCell _parent;
  double _rowSpanRemainingHeight;
  double _tempRowSpanRemainingHeight;
  int _pageCount;
  PdfGridImagePosition _imagePosition;
  _PdfGridStretchOption _pdfGridStretchOption;
  PdfGridCellStyle _style;
  bool _isCellMergeContinue;
  bool _isRowMergeContinue;
  double _maxValue;

  //Properties
  /// Gets the width of the PdfGrid cell.
  double get width {
    if (_width == -1 || _row._grid._isComplete) {
      _width = _measureWidth();
    }
    return double.parse(_width.toStringAsFixed(4));
  }

  /// Gets the height of the PdfGrid cell.
  double get height {
    if (_height == -1) {
      _height = _measureHeight();
    }
    return _height;
  }

  /// Gets a value that indicates the total number of rows that cell spans
  /// within a PdfGrid.
  int get rowSpan => _rowSpan;

  /// Sets a value that indicates the total number of rows that cell spans
  /// within a PdfGrid.
  set rowSpan(int value) {
    if (value < 1) {
      throw ArgumentError.value('value', 'row span',
          'Invalid span specified, must be greater than or equal to 1');
    }
    if (value > 1) {
      _rowSpan = value;
      _row._rowSpanExists = true;
      _row._grid._hasRowSpan = true;
    }
  }

  /// Gets a value that indicates the total number of columns that cell spans
  /// within a PdfGrid.
  int get columnSpan => _columnSpan;

  /// Sets a value that indicates the total number of columns that cell spans
  /// within a PdfGrid.
  set columnSpan(int value) {
    if (value < 1) {
      throw ArgumentError.value('value', 'column span',
          'Invalid span specified, must be greater than or equal to 1');
    }
    if (value > 1) {
      _columnSpan = value;
      _row._grid._hasColumnSpan = true;
    }
  }

  /// Gets the cell style.
  PdfGridCellStyle get style {
    _style ??= PdfGridCellStyle();
    return _style;
  }

  /// Sets the cell style.
  set style(PdfGridCellStyle value) {
    _style = value;
  }

  /// Gets the value of the cell.
  dynamic get value => _value;

  /// Sets the value of the cell.
  set value(dynamic value) {
    _value = value;
    _setValue(value);
  }

  /// Gets the string format.
  PdfStringFormat get stringFormat {
    _format ??= PdfStringFormat();
    return _format;
  }

  /// Sets the string format.
  set stringFormat(PdfStringFormat value) {
    _format = value;
  }

  //Implementation
  void _initialize(PdfGridCellStyle style, PdfStringFormat format,
      PdfGridRow row, int rowSpan, int columnSpan) {
    if (row != null) {
      _row = row;
    }
    if (style != null) {
      _style = style;
    }
    if (format != null) {
      stringFormat = format;
    }
    if (rowSpan != null && rowSpan > 1) {
      this.rowSpan = rowSpan;
    } else {
      _rowSpan = 1;
    }
    if (columnSpan != null && columnSpan > 1) {
      this.columnSpan = columnSpan;
    } else {
      _columnSpan = 1;
    }
    _width = -1;
    _height = -1;
    _finished = true;
    _pageCount = 0;
    _present = false;
    _outerCellWidth = -1;
    _rowSpanRemainingHeight = 0;
    _imagePosition = PdfGridImagePosition.stretch;
    _pdfGridStretchOption = _PdfGridStretchOption.none;
    _isCellMergeContinue = false;
    _isRowMergeContinue = false;
    _tempRowSpanRemainingHeight = 0;
    _maxValue = 3.40282347E+38;
  }

  void _setValue(dynamic value) {
    if (value == null) {
      throw ArgumentError.value(value, 'value', 'value cannot be null');
    }
    if (_value is PdfGrid) {
      _row._grid._isSingleGrid = false;
      _value._parentCell = this;
      _value._isChildGrid = true;
      for (int i = 0; i < _value.rows.count; i++) {
        final PdfGridRow row = _value.rows[i];
        for (int j = 0; j < row.cells.count; j++) {
          final PdfGridCell cell = row.cells[j];
          cell._parent = this;
        }
      }
    }
  }

  PdfFont _getTextFont() {
    return style.font ??
        _row.style.font ??
        _row._grid.style.font ??
        _row._grid._defaultFont;
  }

  PdfBrush _getTextBrush() {
    return style.textBrush ??
        _row.style.textBrush ??
        _row._grid.style.textBrush ??
        PdfBrushes.black;
  }

  PdfPen _getTextPen() {
    return style.textPen ?? _row.style.textPen ?? _row._grid.style.textPen;
  }

  PdfBrush _getBackgroundBrush() {
    return style.backgroundBrush ??
        _row.style.backgroundBrush ??
        _row._grid.style.backgroundBrush;
  }

  double _measureHeight() {
    final double width = _calculateWidth() -
        (style.cellPadding == null
            ? (_row._grid.style.cellPadding.right +
                _row._grid.style.cellPadding.left)
            : (style.cellPadding.right +
                style.cellPadding.left +
                style.borders.left.width +
                style.borders.right.width));
    _outerCellWidth = width;
    double height = 0;
    final _PdfStringLayouter layouter = _PdfStringLayouter();
    if (value is PdfTextElement) {
      final PdfTextElement element = value as PdfTextElement;
      String temp = element.text;
      if (!_finished) {
        temp = (_remainingString != null && _remainingString.isNotEmpty)
            ? _remainingString
            : value;
      }
      final _PdfStringLayoutResult result = layouter._layout(temp,
          element.font ?? _getTextFont(), element.stringFormat ?? stringFormat,
          width: width, height: _maxValue);
      height += result._size.height +
          ((style.borders.top.width + style.borders.bottom.width) * 2);
    } else if (value is String || _remainingString is String) {
      String currentValue = value;
      if (!_finished) {
        currentValue = (_remainingString != null && _remainingString.isNotEmpty)
            ? _remainingString
            : value;
      }
      final _PdfStringLayoutResult result = layouter._layout(
          currentValue, _getTextFont(), stringFormat,
          width: width, height: _maxValue);
      height += result._size.height +
          ((style.borders.top.width + style.borders.bottom.width) * 2);
    } else if (value is PdfGrid) {
      height = value._size.height;
    } else if (value is PdfImage) {
      final PdfImage img = _value as PdfImage;
      height = img.height / (96 / 72);
    }
    height += style.cellPadding == null
        ? (_row._grid.style.cellPadding.top +
            _row._grid.style.cellPadding.bottom)
        : (style.cellPadding.top + style.cellPadding.bottom);
    height += _row._grid.style.cellSpacing;
    return height;
  }

  double _calculateWidth() {
    final int cellIndex = _row.cells.indexOf(this);
    final int columnSpan = this.columnSpan;
    double width = 0;
    for (int i = 0; i < columnSpan; i++) {
      width += _row._grid.columns[cellIndex + i].width;
    }
    if (_parent != null &&
        _parent._row._getWidth() > 0 &&
        (_row._grid._isChildGrid) &&
        (_row._getWidth() > _parent._row._getWidth())) {
      width = 0;
      for (int j = 0; j < _parent.columnSpan; j++) {
        width += _parent._row._grid.columns[j].width;
      }
      width = width / _row.cells.count;
    } else if (_parent != null && _row._grid._isChildGrid && width == -1) {
      width = _findGridColumnWidth(_parent);
      width = width / _row.cells.count;
    }
    return width;
  }

  double _findGridColumnWidth(PdfGridCell pdfGridCell) {
    double width = -1;
    if (pdfGridCell._parent != null && pdfGridCell._outerCellWidth == -1) {
      width = _findGridColumnWidth(pdfGridCell._parent);
      width = width / pdfGridCell._row.cells.count;
    } else if (pdfGridCell._parent == null && pdfGridCell._outerCellWidth > 0) {
      width = pdfGridCell._outerCellWidth;
    }
    return width;
  }

  double _measureWidth() {
    double width = 0;
    final _PdfStringLayouter layouter = _PdfStringLayouter();
    if (value is String) {
      double defaultWidth = _maxValue;
      if (_parent != null) {
        defaultWidth = _getColumnWidth();
      }
      final _PdfStringLayoutResult result = layouter._layout(
          value, _getTextFont(), stringFormat,
          width: defaultWidth, height: _maxValue);
      width += result._size.width;
      if (style.borders != null &&
          style.borders.left != null &&
          style.borders.right != null) {
        width += (style.borders.left.width + style.borders.right.width) * 2;
      }
    } else if (value is PdfGrid) {
      width = (value as PdfGrid)._gridSize.width;
    } else if (value is PdfTextElement) {
      double defaultWidth = _maxValue;
      if (_parent != null) {
        defaultWidth = _getColumnWidth();
      }
      final PdfTextElement element = value as PdfTextElement;
      String temp = element.text;
      if (!_finished) {
        temp = (_remainingString != null && _remainingString.isNotEmpty)
            ? _remainingString
            : value;
      }
      final _PdfStringLayoutResult result = layouter._layout(temp,
          element.font ?? _getTextFont(), element.stringFormat ?? stringFormat,
          width: defaultWidth, height: _maxValue);
      width += result._size.width;
      width += (style.borders.left.width + style.borders.right.width) * 2;
    }
    return width +
        _row._grid.style.cellSpacing +
        (style.cellPadding != null
            ? (style.cellPadding.left + style.cellPadding.right)
            : (_row._grid.style.cellPadding.left +
                _row._grid.style.cellPadding.right));
  }

  double _getColumnWidth() {
    double defaultWidth = _parent._calculateWidth() / _row._grid.columns.count;
    if (defaultWidth <= 0) {
      defaultWidth = _maxValue;
    }
    return defaultWidth;
  }

  PdfGraphics _drawCellBorders(PdfGraphics graphics, _Rectangle bounds) {
    final PdfBorders borders = style.borders;
    if (_row._grid.style.borderOverlapStyle == PdfBorderOverlapStyle.inside) {
      bounds.x += borders.left.width;
      bounds.y += borders.top.width;
      bounds.width -= borders.right.width;
      bounds.height -= borders.bottom.width;
    }
    PdfPen pen = style.borders.left;
    if (style.borders._isAll) {
      _setTransparency(graphics, pen);
      graphics.drawRectangle(pen: pen, bounds: bounds.rect);
    } else {
      Offset p1 = Offset(bounds.x, bounds.y + bounds.height);
      Offset p2 = Offset(bounds.x, bounds.y);
      if (_style.borders.left.dashStyle == PdfDashStyle.solid &&
          !pen._immutable) {
        pen.lineCap = PdfLineCap.square;
      }
      _setTransparency(graphics, pen);
      graphics.drawLine(pen, p1, p2);
      graphics.restore();

      p1 = Offset(bounds.x + bounds.width, bounds.y);
      p2 = Offset(bounds.x + bounds.width, bounds.y + bounds.height);
      pen = _style.borders.right;
      if (bounds.x + bounds.width > graphics.clientSize.width - pen.width / 2) {
        p1 = Offset(graphics.clientSize.width - pen.width / 2, bounds.y);
        p2 = Offset(graphics.clientSize.width - pen.width / 2,
            bounds.y + bounds.height);
      }
      if (_style.borders.right.dashStyle == PdfDashStyle.solid &&
          !pen._immutable) {
        pen.lineCap = PdfLineCap.square;
      }
      _setTransparency(graphics, pen);
      graphics.drawLine(pen, p1, p2);
      graphics.restore();
      p1 = Offset(bounds.x, bounds.y);
      p2 = Offset(bounds.x + bounds.width, bounds.y);
      pen = _style.borders.top;
      if (_style.borders.top.dashStyle == PdfDashStyle.solid &&
          !pen._immutable) {
        pen.lineCap = PdfLineCap.square;
      }
      _setTransparency(graphics, pen);
      graphics.drawLine(pen, p1, p2);
      graphics.restore();
      p1 = Offset(bounds.x + bounds.width, bounds.y + bounds.height);
      p2 = Offset(bounds.x, bounds.y + bounds.height);
      pen = _style.borders.bottom;
      if (bounds.y + bounds.height >
          graphics.clientSize.height - pen.width / 2) {
        p1 = Offset(bounds.x + bounds.width,
            graphics.clientSize.height - pen.width / 2);
        p2 = Offset(bounds.x, graphics.clientSize.height - pen.width / 2);
      }
      if (_style.borders.bottom.dashStyle == PdfDashStyle.solid &&
          !pen._immutable) {
        pen.lineCap = PdfLineCap.square;
      }
      _setTransparency(graphics, pen);
      graphics.drawLine(pen, p1, p2);
    }
    graphics.restore();
    return graphics;
  }

  void _setTransparency(PdfGraphics graphics, PdfPen pen) {
    graphics.save();
    graphics.setTransparency(pen.color._alpha / 255);
  }

  _PdfStringLayoutResult _draw(
      PdfGraphics graphics, _Rectangle bounds, bool cancelSubsequentSpans) {
    bool isrowbreak = false;
    if (!_row._grid._isSingleGrid) {
      if ((_remainingString != null) ||
          (_PdfGridLayouter._repeatRowIndex != -1)) {
        _drawParentCells(graphics, bounds, true);
      } else if (_row._grid.rows.count > 1) {
        for (int i = 0; i < _row._grid.rows.count; i++) {
          if (_row == _row._grid.rows[i]) {
            if (_row._grid.rows[i]._rowBreakHeight > 0) {
              isrowbreak = true;
            }
            if ((i > 0) && isrowbreak) {
              _drawParentCells(graphics, bounds, false);
            }
          }
        }
      }
    }
    _PdfStringLayoutResult result;
    if (cancelSubsequentSpans) {
      final int currentCellIndex = _row.cells.indexOf(this);
      for (int i = currentCellIndex + 1;
          i <= currentCellIndex + _columnSpan;
          i++) {
        _row.cells[i]._isCellMergeContinue = false;
        _row.cells[i]._isRowMergeContinue = false;
      }
      _columnSpan = 1;
    }
    if (_isCellMergeContinue || _isRowMergeContinue) {
      if (_isCellMergeContinue && _row._grid.style.allowHorizontalOverflow) {
        if ((_row._rowOverflowIndex > 0 &&
                (_row.cells.indexOf(this) != _row._rowOverflowIndex + 1)) ||
            (_row._rowOverflowIndex == 0 && _isCellMergeContinue)) {
          return result;
        }
      } else {
        return result;
      }
    }
    bounds = _adjustOuterLayoutArea(bounds, graphics);
    graphics = _drawCellBackground(graphics, bounds);
    final PdfPen textPen = _getTextPen();
    final PdfBrush textBrush = _getTextBrush();
    final PdfFont font = _getTextFont();
    final PdfStringFormat strFormat = style.stringFormat ?? stringFormat;
    _Rectangle innerLayoutArea = bounds._clone();
    if (innerLayoutArea.height >= graphics.clientSize.height) {
      if (_row._grid.allowRowBreakingAcrossPages) {
        innerLayoutArea.height -= innerLayoutArea.y;
        bounds.height -= bounds.y;
        if (_row._grid._isChildGrid) {
          innerLayoutArea.height -=
              _row._grid._parentCell._row._grid.style.cellPadding.bottom;
        }
      } else {
        innerLayoutArea.height = graphics.clientSize.height;
        bounds.height = graphics.clientSize.height;
      }
    }
    innerLayoutArea = _adjustContentLayoutArea(innerLayoutArea);
    if (value is PdfGrid) {
      graphics.save();
      graphics.setClip(bounds: innerLayoutArea.rect, mode: PdfFillMode.winding);
      final PdfGrid childGrid = value as PdfGrid;
      childGrid._isChildGrid = true;
      childGrid._parentCell = this;
      childGrid._listOfNavigatePages = <int>[];
      _PdfGridLayouter layouter = _PdfGridLayouter(childGrid);
      PdfLayoutFormat format = PdfLayoutFormat();
      if (_row._grid._layoutFormat != null) {
        format = _row._grid._layoutFormat;
      } else {
        format.layoutType = PdfLayoutType.paginate;
      }
      if (graphics._layer != null) {
        final _PdfLayoutParams param = _PdfLayoutParams();
        param.page = graphics._page;
        param.bounds = innerLayoutArea;
        param.format = format;
        childGrid._setSpan();
        final PdfLayoutResult childGridResult = layouter._layout(param);
        value = childGrid;
        if (param.page != childGridResult.page) {
          _row._gridResult = childGridResult;
          bounds.height = graphics.clientSize.height - bounds.y;
        }
      } else {
        childGrid._setSpan();
        layouter = _PdfGridLayouter(value as PdfGrid);
        layouter.layout(graphics, innerLayoutArea);
      }
      graphics.restore();
    } else if (value is PdfTextElement) {
      final PdfTextElement textelement = value as PdfTextElement;
      final PdfPage page = graphics._page;
      textelement._isPdfTextElement = true;
      final String textElementString = textelement.text;
      PdfTextLayoutResult textlayoutresult;
      if (_finished) {
        textlayoutresult = textelement.draw(
            page: page, bounds: innerLayoutArea.rect) as PdfTextLayoutResult;
      } else {
        textelement.text = _remainingString;
        textlayoutresult = textelement.draw(
            page: page, bounds: innerLayoutArea.rect) as PdfTextLayoutResult;
      }
      if (textlayoutresult._remainder != null &&
          textlayoutresult._remainder.isNotEmpty) {
        _remainingString = textlayoutresult._remainder;
        _finished = false;
      } else {
        _remainingString = null;
        _finished = true;
      }
      textelement.text = textElementString;
    } else if (value is String || _remainingString is String) {
      String temp;
      _Rectangle layoutRectangle;
      if (innerLayoutArea.height < font.height) {
        layoutRectangle = _Rectangle(innerLayoutArea.x, innerLayoutArea.y,
            innerLayoutArea.width, font.height);
      } else {
        layoutRectangle = innerLayoutArea;
      }
      if (innerLayoutArea.height < font.height &&
          _row._grid._isChildGrid &&
          _row._grid._parentCell != null) {
        final double height = layoutRectangle.height -
            _row._grid._parentCell._row._grid.style.cellPadding.bottom -
            _row._grid.style.cellPadding.bottom;
        if (height > 0 && height < font.height) {
          layoutRectangle.height = height;
        } else if (height + _row._grid.style.cellPadding.bottom > 0 &&
            height + _row._grid.style.cellPadding.bottom < font.height) {
          layoutRectangle.height = height + _row._grid.style.cellPadding.bottom;
        } else if (bounds.height < font.height) {
          layoutRectangle.height = bounds.height;
        } else if (bounds.height -
                _row._grid._parentCell._row._grid.style.cellPadding.bottom <
            font.height) {
          layoutRectangle.height = bounds.height -
              _row._grid._parentCell._row._grid.style.cellPadding.bottom;
        }
      }
      if (style.cellPadding != null &&
          style.cellPadding.bottom == 0 &&
          style.cellPadding.left == 0 &&
          style.cellPadding.right == 0 &&
          style.cellPadding.top == 0) {
        layoutRectangle.width -=
            style.borders.left.width + style.borders.right.width;
      }
      if (_finished) {
        temp = _remainingString != null && _remainingString.isEmpty
            ? _remainingString
            : value;
        graphics.drawString(temp, font,
            pen: textPen,
            brush: textBrush,
            bounds: layoutRectangle.rect,
            format: strFormat);
      } else {
        graphics.drawString(_remainingString, font,
            pen: textPen,
            brush: textBrush,
            bounds: layoutRectangle.rect,
            format: strFormat);
      }
      result = graphics._stringLayoutResult;
      if (_row._grid._isChildGrid &&
          _row._rowBreakHeight > 0 &&
          result != null) {
        bounds.height -=
            _row._grid._parentCell._row._grid.style.cellPadding.bottom;
      }
    } else if (_value is PdfImage) {
      if (_imagePosition == PdfGridImagePosition.stretch) {
        if (style.cellPadding != null && style.cellPadding != PdfPaddings()) {
          final PdfPaddings padding = style.cellPadding;
          bounds = _Rectangle(
              bounds.x + padding.left,
              bounds.y + padding.top,
              bounds.width - (padding.left + padding.right),
              bounds.height - (padding.top + padding.bottom));
        } else if (_row._grid.style.cellPadding != null &&
            _row._grid.style.cellPadding != PdfPaddings()) {
          final PdfPaddings padding = _row._grid.style.cellPadding;
          bounds = _Rectangle(
              bounds.x + padding.left,
              bounds.y + padding.top,
              bounds.width - (padding.left + padding.right),
              bounds.height - (padding.top + padding.bottom));
        }
        final PdfImage img = value as PdfImage;
        double imgWidth = img.width.toDouble();
        double imgHeight = img.height.toDouble();
        double spaceX = 0;
        double spaceY = 0;
        if (_pdfGridStretchOption == _PdfGridStretchOption.uniform ||
            _pdfGridStretchOption == _PdfGridStretchOption.uniformToFill) {
          double ratio = 1;
          if (imgWidth > bounds.width) {
            ratio = imgWidth / bounds.width;
            imgWidth = bounds.width;
            imgHeight = imgHeight / ratio;
          }
          if (imgHeight > bounds.height) {
            ratio = imgHeight / bounds.height;
            imgHeight = bounds.height;
            imgWidth = imgWidth / ratio;
          }
          if (imgWidth < bounds.width && imgHeight < bounds.height) {
            spaceX = bounds.width - imgWidth;
            spaceY = bounds.height - imgHeight;
            if (spaceX < spaceY) {
              ratio = imgWidth / bounds.width;
              imgWidth = bounds.width;
              imgHeight = imgHeight / ratio;
            } else {
              ratio = imgHeight / bounds.height;
              imgHeight = bounds.height;
              imgWidth = imgWidth / ratio;
            }
          }
        }
        if (_pdfGridStretchOption == _PdfGridStretchOption.fill ||
            _pdfGridStretchOption == _PdfGridStretchOption.none) {
          imgWidth = bounds.width;
          imgHeight = bounds.height;
        }
        if (_pdfGridStretchOption == _PdfGridStretchOption.uniformToFill) {
          double ratio = 1;
          if (imgWidth == bounds.width && imgHeight < bounds.height) {
            ratio = imgHeight / bounds.height;
            imgHeight = bounds.height;
            imgWidth = imgWidth / ratio;
          }
          if (imgHeight == bounds.height && imgWidth < bounds.width) {
            ratio = imgWidth / bounds.width;
            imgWidth = bounds.width;
            imgHeight = imgHeight / ratio;
          }
          final PdfPage graphicsPage = graphics._page;
          final PdfGraphicsState st = graphicsPage.graphics.save();
          graphicsPage.graphics
              .setClip(bounds: bounds.rect, mode: PdfFillMode.winding);
          graphicsPage.graphics.drawImage(
              img, Rect.fromLTWH(bounds.x, bounds.y, imgWidth, imgHeight));
          graphicsPage.graphics.restore(st);
        } else {
          graphics.drawImage(
              img, Rect.fromLTWH(bounds.x, bounds.y, imgWidth, imgHeight));
        }
      }
      graphics.save();
    }
    if (style.borders != null && style.borders.left != null) {
      graphics = _drawCellBorders(graphics, bounds);
    }
    return result;
  }

  void _drawParentCells(PdfGraphics graphics, _Rectangle bounds, bool b) {
    final _Point location = _Point(_row._grid._defaultBorder.right.width / 2,
        _row._grid._defaultBorder.top.width / 2);
    if ((bounds.height < graphics.clientSize.height) && (b == true)) {
      bounds.height += bounds.y - location.y;
    }
    final _Rectangle rect =
        _Rectangle(location.x, location.y, bounds.width, bounds.height);
    if (b == false) {
      rect.y = bounds.y;
      rect.height = bounds.height;
    }
    PdfGridCell c = this;
    if (_parent != null) {
      if ((c._row._grid.rows.count == 1) &&
          (c._row._grid.rows[0].cells.count == 1)) {
        c._row._grid.rows[0].cells[0]._present = true;
      } else {
        for (int rowIndex = 0; rowIndex < c._row._grid.rows.count; rowIndex++) {
          final PdfGridRow r = c._row._grid.rows[rowIndex];
          if (r == c._row) {
            for (int cellIndex = 0; cellIndex < _row.cells.count; cellIndex++) {
              final PdfGridCell cell = _row.cells[cellIndex];
              if (cell == c) {
                cell._present = true;
                break;
              }
            }
          }
        }
      }
      while (c._parent != null) {
        c = c._parent;
        c._present = true;
        rect.x += c._row._grid.style.cellPadding.left;
      }
    }
    if (bounds.x >= rect.x) {
      rect.x -= bounds.x;
      if (rect.x < 0) {
        rect.x = bounds.x;
      }
    }
    PdfGrid pdfGrid = c._row._grid;
    for (int i = 0; i < pdfGrid.rows.count; i++) {
      for (int j = 0; j < pdfGrid.rows[i].cells.count; j++) {
        if (pdfGrid.rows[i].cells[j]._present == true) {
          int cellcount = 0;
          if (pdfGrid.rows[i].style.backgroundBrush != null) {
            style.backgroundBrush = pdfGrid.rows[i].style.backgroundBrush;
            double cellwidth = 0;
            if (j > 0) {
              for (int n = 0; n < j; n++) {
                cellwidth += pdfGrid.columns[n].width;
              }
            }
            rect.width = pdfGrid.rows[i]._getWidth() - cellwidth;
            final PdfGrid grid = pdfGrid.rows[i].cells[j].value as PdfGrid;
            if (grid != null) {
              for (int l = 0; l < grid.rows.count; l++) {
                for (int m = 0; m < grid.rows[l].cells.count; m++) {
                  if ((grid.rows[l].cells[m]._present) && m > 0) {
                    rect.width = grid.rows[l].cells[m].width;
                    cellcount = m;
                  }
                }
              }
            }
            graphics = _drawCellBackground(graphics, rect);
          }
          pdfGrid.rows[i].cells[j]._present = false;
          if (pdfGrid.rows[i].cells[j].style.backgroundBrush != null) {
            style.backgroundBrush =
                pdfGrid.rows[i].cells[j].style.backgroundBrush;
            if (cellcount == 0) {
              rect.width = pdfGrid.columns[j].width;
            }
            graphics = _drawCellBackground(graphics, rect);
          }
          if (pdfGrid.rows[i].cells[j].value is PdfGrid) {
            if ((pdfGrid.style != null) && (!pdfGrid.rows[i]._isrowFinish)) {
              if (cellcount == 0) {
                rect.x += pdfGrid.style.cellPadding.left;
              }
            }
            pdfGrid = pdfGrid.rows[i].cells[j].value as PdfGrid;
            if (pdfGrid.style.backgroundBrush != null) {
              style.backgroundBrush = pdfGrid.style.backgroundBrush;
              if (cellcount == 0) {
                if (j < pdfGrid.columns.count) {
                  rect.width = pdfGrid.columns[j].width;
                }
              }
              graphics = _drawCellBackground(graphics, rect);
            }
            i = -1;
            break;
          }
        }
      }
    }
    if (bounds.height < graphics.clientSize.height) {
      bounds.height -= bounds.y - location.y;
    }
  }

  PdfGraphics _drawCellBackground(PdfGraphics graphics, _Rectangle bounds) {
    final PdfBrush backgroundBrush = _getBackgroundBrush();
    if (backgroundBrush != null) {
      graphics.save();
      graphics.drawRectangle(brush: backgroundBrush, bounds: bounds.rect);
      graphics.restore();
    }
    if (style.backgroundImage != null) {
      final PdfImage image = style.backgroundImage;
      if (style.cellPadding != null && style.cellPadding != PdfPaddings()) {
        final PdfPaddings padding = style.cellPadding;
        bounds = _Rectangle(
            bounds.x + padding.left,
            bounds.y + padding.top,
            bounds.width - (padding.left + padding.right),
            bounds.height - (padding.top + padding.bottom));
      } else if (_row._grid.style.cellPadding != null &&
          _row._grid.style.cellPadding != PdfPaddings()) {
        final PdfPaddings padding = _row._grid.style.cellPadding;
        bounds = _Rectangle(
            bounds.x + padding.left,
            bounds.y + padding.top,
            bounds.width - (padding.left + padding.right),
            bounds.height - (padding.top + padding.bottom));
      }
      if (_imagePosition == PdfGridImagePosition.stretch) {
        graphics.drawImage(image, bounds.rect);
      } else if (_imagePosition == PdfGridImagePosition.center) {
        double gridCentreX;
        double gridCentreY;
        gridCentreX = bounds.x + (bounds.width / 4);
        gridCentreY = bounds.y + (bounds.height / 4);
        graphics.drawImage(
            image,
            Rect.fromLTWH(
                gridCentreX, gridCentreY, bounds.width / 2, bounds.height / 2));
      } else if (_imagePosition == PdfGridImagePosition.fit) {
        final double imageWidth = image.physicalDimension.width;
        final double imageHeight = image.physicalDimension.height;
        double x;
        double y;
        if (imageHeight > imageWidth) {
          y = bounds.y;
          x = bounds.x + bounds.width / 4;
          graphics.drawImage(
              image, Rect.fromLTWH(x, y, bounds.width / 2, bounds.height));
        } else {
          x = bounds.x;

          y = bounds.y + (bounds.height / 4);
          graphics.drawImage(
              image, Rect.fromLTWH(x, y, bounds.width, bounds.height / 2));
        }
      } else if (_imagePosition == PdfGridImagePosition.tile) {
        final double cellLeft = bounds.x;
        final double cellTop = bounds.y;
        double x = cellLeft;
        double y = cellTop;
        for (; y < bounds.bottom;) {
          for (x = cellLeft; x < bounds.right;) {
            if (x + image.physicalDimension.width < bounds.right &&
                y + image.physicalDimension.height < bounds.bottom) {
              graphics.drawImage(image, Rect.fromLTWH(x, y, 0, 0));
            }
            x += image.physicalDimension.width;
          }
          y += image.physicalDimension.height;
        }
      }
    }
    return graphics;
  }

  _Rectangle _adjustContentLayoutArea(_Rectangle bounds) {
    PdfPaddings padding = style.cellPadding;
    if (value is PdfGrid) {
      final _Size size = (value as PdfGrid)._gridSize;
      if (padding == null) {
        padding = _row._grid.style.cellPadding;
        bounds.width -= padding.right + padding.left;
        bounds.height -= padding.bottom + padding.top;
        if (stringFormat.alignment == PdfTextAlignment.center) {
          bounds.x += padding.left + (bounds.width - size.width) / 2;
          bounds.y += padding.top + (bounds.height - size.height) / 2;
        } else if (stringFormat.alignment == PdfTextAlignment.left) {
          bounds.x += padding.left;
          bounds.y += padding.top;
        } else if (stringFormat.alignment == PdfTextAlignment.right) {
          bounds.x += padding.left + (bounds.width - size.width);
          bounds.y += padding.top;
          bounds.width = size.width;
        }
      } else {
        bounds.width -= padding.right + padding.left;
        bounds.height -= padding.bottom + padding.top;

        if (stringFormat.alignment == PdfTextAlignment.center) {
          bounds.x += padding.left + (bounds.width - size.width) / 2;
          bounds.y += padding.top + (bounds.height - size.height) / 2;
        } else if (stringFormat.alignment == PdfTextAlignment.left) {
          bounds.x += padding.left;
          bounds.y += padding.top;
        } else if (stringFormat.alignment == PdfTextAlignment.right) {
          bounds.x += padding.left + (bounds.width - size.width);
          bounds.y += padding.top;
          bounds.width = size.width;
        }
      }
    } else {
      if (padding == null) {
        padding = _row._grid.style.cellPadding;
        bounds.x += padding.left;
        bounds.y += padding.top;
        bounds.width -= padding.right + padding.left;
        bounds.height -= padding.bottom + padding.top;
      } else {
        bounds.x += padding.left;
        bounds.y += padding.top;
        bounds.width -= padding.right + padding.left;
        bounds.height -= padding.bottom + padding.top;
      }
    }

    return bounds;
  }

  _Rectangle _adjustOuterLayoutArea(_Rectangle bounds, PdfGraphics g) {
    bool isHeader = false;
    final double cellSpacing = _row._grid.style.cellSpacing;
    if (cellSpacing > 0) {
      bounds = _Rectangle(bounds.x + cellSpacing, bounds.y + cellSpacing,
          bounds.width - cellSpacing, bounds.height - cellSpacing);
    }
    final int currentColIndex = _row.cells.indexOf(this);
    if (columnSpan > 1 ||
        (_row._rowOverflowIndex > 0 &&
            (currentColIndex == _row._rowOverflowIndex + 1) &&
            _isCellMergeContinue)) {
      int span = columnSpan;
      if (span == 1 && _isCellMergeContinue) {
        for (int j = currentColIndex + 1; j < _row._grid.columns.count; j++) {
          if (_row.cells[j]._isCellMergeContinue) {
            span++;
          } else {
            break;
          }
        }
      }
      double totalWidth = 0;
      for (int i = currentColIndex; i < currentColIndex + span; i++) {
        if (_row._grid.style.allowHorizontalOverflow) {
          double width;
          final double compWidth =
              _row._grid._gridSize.width < g.clientSize.width
                  ? _row._grid._gridSize.width
                  : g.clientSize.width;
          if (_row._grid._gridSize.width > g.clientSize.width) {
            width = bounds.x + totalWidth + _row._grid.columns[i].width;
          } else {
            width = totalWidth + _row._grid.columns[i].width;
          }
          if (width > compWidth) {
            break;
          }
        }
        totalWidth += _row._grid.columns[i].width;
      }
      totalWidth -= _row._grid.style.cellSpacing;
      bounds.width = totalWidth;
    }
    if (rowSpan > 1 || _row._rowSpanExists) {
      int span = rowSpan;
      int currentRowIndex = _row._grid.rows._indexOf(_row);
      if (currentRowIndex == -1) {
        currentRowIndex = _row._grid.headers._indexOf(_row);
        if (currentRowIndex != -1) {
          isHeader = true;
        }
      }
      if (span == 1 && _isCellMergeContinue) {
        for (int j = currentRowIndex + 1; j < _row._grid.rows.count; j++) {
          if (isHeader
              ? _row
                  ._grid.headers[j].cells[currentColIndex]._isCellMergeContinue
              : _row
                  ._grid.rows[j].cells[currentColIndex]._isCellMergeContinue) {
            span++;
          } else {
            break;
          }
        }
      }
      double totalHeight = 0;
      double max = 0;
      if (isHeader) {
        for (int i = currentRowIndex; i < currentRowIndex + span; i++) {
          totalHeight += _row._grid.headers[i].height;
        }
        totalHeight -= _row._grid.style.cellSpacing;
        bounds.height = totalHeight;
      } else {
        for (int i = currentRowIndex; i < currentRowIndex + span; i++) {
          if (!_row._grid.rows[i]._isRowSpanRowHeightSet) {
            _row._grid.rows[i]._isRowHeightSet = false;
          }
          totalHeight += isHeader
              ? _row._grid.headers[i].height
              : _row._grid.rows[i].height;
          final PdfGridRow row = _row._grid.rows[i];
          final int rowIndex = _row._grid.rows._indexOf(row);
          if (rowSpan > 1) {
            for (int cellIndex = 0; cellIndex < row.cells.count; cellIndex++) {
              final PdfGridCell cell = row.cells[cellIndex];
              if (cell.rowSpan > 1) {
                double tempHeight = 0;
                for (int j = i; j < i + cell.rowSpan; j++) {
                  if (!_row._grid.rows[j]._isRowSpanRowHeightSet) {
                    _row._grid.rows[j]._isRowHeightSet = false;
                  }
                  tempHeight += _row._grid.rows[j].height;
                  if (!_row._grid.rows[j]._isRowSpanRowHeightSet) {
                    _row._grid.rows[j]._isRowHeightSet = true;
                  }
                }
                if (cell.height > tempHeight) {
                  if (max < (cell.height - tempHeight)) {
                    max = cell.height - tempHeight;
                    if (_tempRowSpanRemainingHeight != 0 &&
                        max > _tempRowSpanRemainingHeight) {
                      max += _tempRowSpanRemainingHeight;
                    }
                    final int index = row.cells.indexOf(cell);
                    _row._grid.rows[(rowIndex + cell.rowSpan) - 1].cells[index]
                        ._rowSpanRemainingHeight = max;
                    _tempRowSpanRemainingHeight = _row
                        ._grid
                        .rows[(rowIndex + cell.rowSpan) - 1]
                        .cells[index]
                        ._rowSpanRemainingHeight;
                  }
                }
              }
            }
          }
          if (!_row._grid.rows[i]._isRowSpanRowHeightSet) {
            _row._grid.rows[i]._isRowHeightSet = true;
          }
        }
        final int cellIndex = _row.cells.indexOf(this);
        totalHeight -= _row._grid.style.cellSpacing;
        if (_row.cells[cellIndex].height > totalHeight &&
            (!_row._grid.rows[(currentRowIndex + span) - 1]._isRowHeightSet)) {
          _row._grid.rows[(currentRowIndex + span) - 1].cells[cellIndex]
                  ._rowSpanRemainingHeight =
              _row.cells[cellIndex].height - totalHeight;
          totalHeight = _row.cells[cellIndex].height;
          bounds.height = totalHeight;
        } else {
          bounds.height = totalHeight;
        }
        if (!_row._rowMergeComplete) {
          bounds.height = totalHeight;
        }
      }
    }
    return bounds;
  }
}

/// Provides access to an ordered, strongly typed collection of
/// [PdfGridCell] objects.
class PdfGridCellCollection {
  //Constructors
  /// Initializes a new instance of the [PdfGridCellCollection] class
  /// with the row.
  PdfGridCellCollection._(PdfGridRow row) {
    _row = row;
    _cells = <PdfGridCell>[];
  }

  //Fields
  PdfGridRow _row;
  List<PdfGridCell> _cells;

  //Properties
  /// Gets the cells count.
  int get count => _cells.length;

  /// Gets the [PdfGridCell] at the specified index.
  PdfGridCell operator [](int index) => _returnValue(index);

  //Public methods
  /// Returns the index of a particular cell in the collection.
  int indexOf(PdfGridCell cell) {
    return _cells.indexOf(cell);
  }

  //Implementation
  PdfGridCell _returnValue(int index) {
    if (index < 0 || index >= _cells.length) {
      throw IndexError(index, _cells);
    }
    return _cells[index];
  }

  void _add(PdfGridCell cell) {
    cell.style ??= _row.style as PdfGridCellStyle;
    cell._row = _row;
    _cells.add(cell);
  }
}
