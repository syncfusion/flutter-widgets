part of pdf;

/// Represents combo box field in the PDF Form.
class PdfComboBoxField extends PdfListField {
  /// Initializes a new instance of the [PdfComboBoxField] class with
  /// the specific page, name and bounds.
  PdfComboBoxField(PdfPage page, String name, Rect bounds,
      {List<PdfListFieldItem>? items,
      bool editable = false,
      int? selectedIndex,
      String? selectedValue,
      PdfFont? font,
      PdfTextAlignment alignment = PdfTextAlignment.left,
      PdfColor? borderColor,
      PdfColor? foreColor,
      PdfColor? backColor,
      int? borderWidth,
      PdfHighlightMode highlightMode = PdfHighlightMode.invert,
      PdfBorderStyle borderStyle = PdfBorderStyle.solid,
      String? tooltip})
      : super._(page, name, bounds,
            font: font,
            alignment: alignment,
            items: items,
            borderColor: borderColor,
            foreColor: foreColor,
            backColor: backColor,
            borderWidth: borderWidth,
            highlightMode: highlightMode,
            borderStyle: borderStyle,
            tooltip: tooltip) {
    this.editable = editable;
    if (selectedIndex != null) {
      this.selectedIndex = selectedIndex;
    }
    if (selectedValue != null) {
      this.selectedValue = selectedValue;
    }
  }

  /// Initializes a new instance of the [PdfComboBoxField] class.
  PdfComboBoxField._load(_PdfDictionary dictionary, _PdfCrossTable crossTable)
      : super._load(dictionary, crossTable);

  //Fields
  bool _editable = false;

  //Properties
  /// Gets or sets a value indicating whether this [PdfComboBoxField] is editable.
  ///
  /// The default value is false.
  bool get editable {
    if (_isLoadedField) {
      _editable =
          _isFlagPresent(_FieldFlags.edit) || _flags.contains(_FieldFlags.edit);
    }
    return _editable;
  }

  set editable(bool value) {
    if (_editable != value || _isLoadedField) {
      _editable = value;
      _editable
          ? _flags.add(_FieldFlags.edit)
          : _isLoadedField
              ? _removeFlag(_FieldFlags.edit)
              : _flags.remove(_FieldFlags.edit);
    }
  }

  /// Gets or sets the selected index in the list.
  int get selectedIndex => _selectedIndexes[0];
  set selectedIndex(int value) => _selectedIndexes = [value];

  /// Gets or sets the selected value in the list.
  String get selectedValue => _selectedValues[0];
  set selectedValue(String value) => _selectedValues = [value];

  /// Gets the selected item in the list.
  PdfListFieldItem? get selectedItem => _selectedItems[0];

  //Implementations
  @override
  void _initialize() {
    super._initialize();
    _flags.add(_FieldFlags.combo);
  }

  @override
  void _drawAppearance(PdfTemplate template) {
    super._drawAppearance(template);
    final _PaintParams params = _PaintParams(
        bounds: Rect.fromLTWH(0, 0, bounds.width, bounds.height),
        backBrush: _backBrush,
        foreBrush: _foreBrush,
        borderPen: _borderPen,
        style: borderStyle,
        borderWidth: borderWidth,
        shadowBrush: _shadowBrush);
    _FieldPainter().drawRectangularControl(template.graphics!, params);
    if (selectedIndex != -1 &&
        items[selectedIndex].text != '' &&
        page!._document!._conformanceLevel == PdfConformanceLevel.none) {
      final int multiplier = params._style == PdfBorderStyle.beveled ||
              params._style == PdfBorderStyle.inset
          ? 2
          : 1;
      final Rect rectangle = Rect.fromLTWH(
          params._bounds!.left + (2 * multiplier) * params._borderWidth!,
          params._bounds!.top + (2 * multiplier) * params._borderWidth!,
          params._bounds!.width - (4 * multiplier) * params._borderWidth!,
          params._bounds!.height - (4 * multiplier) * params._borderWidth!);
      template.graphics!.drawString(items[selectedIndex].text,
          font ?? PdfStandardFont(PdfFontFamily.timesRoman, 12),
          brush: params._foreBrush, bounds: rectangle, format: _format);
    }
  }

  void _beginSave() {
    super._beginSave();
    _applyAppearance(_getWidgetAnnotation(_dictionary, _crossTable));
  }

  void _applyAppearance(_PdfDictionary widget) {
    if (widget.containsKey(_DictionaryProperties.ap) &&
        !_form!._needAppearances!) {
      final _IPdfPrimitive? appearance =
          _crossTable!._getObject(widget[_DictionaryProperties.ap]);
      if ((appearance != null) &&
          appearance is _PdfDictionary &&
          (appearance.containsKey(_DictionaryProperties.n))) {
        final PdfTemplate template = PdfTemplate(bounds.width, bounds.height);
        _drawComboBox(template.graphics);
        appearance.remove(_DictionaryProperties.n);
        appearance.setProperty(
            _DictionaryProperties.n, _PdfReferenceHolder(template));
        widget.setProperty(_DictionaryProperties.ap, appearance);
      }
    } else if (_form!.readOnly == true || readOnly == true) {
      _form!._setAppearanceDictionary = true;
    } else if (_form!._setAppearanceDictionary && !_form!._needAppearances!) {
      final _PdfDictionary dic = _PdfDictionary();
      final PdfTemplate template = PdfTemplate(bounds.width, bounds.height);
      _drawAppearance(template);
      dic.setProperty(_DictionaryProperties.n, _PdfReferenceHolder(template));
      widget.setProperty(_DictionaryProperties.ap, dic);
    }
  }

  void _draw() {
    super._draw();
    if (!_isLoadedField && _widget!._pdfAppearance != null) {
      page!.graphics
          .drawPdfTemplate(_widget!.appearance.normal, bounds.topLeft);
    } else {
      final Rect rect = Rect.fromLTWH(0, 0, bounds.width, bounds.height);
      final PdfFont font = this.font ??
          PdfStandardFont(
              PdfFontFamily.helvetica, _getFontHeight(PdfFontFamily.helvetica));
      final _PaintParams parameters = _PaintParams(
          bounds: rect,
          backBrush: _backBrush,
          foreBrush: _foreBrush,
          borderPen: _borderPen,
          style: borderStyle,
          borderWidth: this.borderWidth,
          shadowBrush: _shadowBrush);
      final PdfTemplate template = PdfTemplate(rect.width, rect.height);
      String? text = '';
      if (selectedIndex != -1) {
        text = selectedItem!.text;
      } else if (_isLoadedField) {
        if (selectedIndex == -1 &&
            _dictionary.containsKey(_DictionaryProperties.v) &&
            _dictionary.containsKey(_DictionaryProperties.ap) &&
            !_dictionary.containsKey(_DictionaryProperties.parent)) {
          final _IPdfPrimitive? value =
              _PdfCrossTable._dereference(_dictionary[_DictionaryProperties.v]);
          if (value != null && value is _PdfString) {
            text = value.value;
          }
        } else if (_dictionary.containsKey(_DictionaryProperties.dv)) {
          if (_dictionary[_DictionaryProperties.dv] is _PdfString) {
            text = (_dictionary[_DictionaryProperties.dv] as _PdfString).value;
          } else {
            final _IPdfPrimitive? str = _PdfCrossTable._dereference(
                _dictionary[_DictionaryProperties.dv]);
            if (str != null && str is _PdfString) {
              text = str.value;
            }
          }
        }
      }
      if (!_isLoadedField) {
        _FieldPainter().drawRectangularControl(template.graphics!, parameters);
        final double borderWidth = parameters._borderWidth!.toDouble();
        final double doubleBorderWidth = 2 * borderWidth;
        final bool padding = (parameters._style == PdfBorderStyle.inset ||
            parameters._style == PdfBorderStyle.beveled);
        final Offset point = padding
            ? Offset(2 * doubleBorderWidth, 2 * borderWidth)
            : Offset(doubleBorderWidth, borderWidth);
        final double width = parameters._bounds!.width - doubleBorderWidth;
        final Rect itemTextBound = Rect.fromLTWH(
            point.dx,
            point.dy,
            width - point.dx,
            parameters._bounds!.height -
                (padding ? doubleBorderWidth : borderWidth));
        template.graphics!.drawString(text!, font,
            brush: _foreBrush, bounds: itemTextBound, format: _format);
        page!.graphics.drawPdfTemplate(template, bounds.topLeft, rect.size);
      } else {
        final _GraphicsProperties gp = _GraphicsProperties(this);
        final _PaintParams prms = _PaintParams(
            bounds: gp._bounds,
            backBrush: gp._backBrush,
            foreBrush: gp._foreBrush,
            borderPen: gp._borderPen,
            style: gp._style,
            borderWidth: gp._borderWidth,
            shadowBrush: gp._shadowBrush);
        if (gp._font!.height > bounds.height) {
          _setFittingFontSize(gp, prms, text!);
        }
        _FieldPainter().drawComboBox(
            page!.graphics, prms, text, gp._font, gp._stringFormat);
      }
    }
  }

  void _drawComboBox(PdfGraphics? graphics) {
    final _GraphicsProperties gp = _GraphicsProperties(this);
    gp._bounds = Rect.fromLTWH(0, 0, bounds.width, bounds.height);
    final _PaintParams prms = _PaintParams(
        bounds: gp._bounds,
        backBrush: gp._backBrush,
        foreBrush: gp._foreBrush,
        borderPen: gp._borderPen,
        style: gp._style,
        borderWidth: gp._borderWidth,
        shadowBrush: gp._shadowBrush);
    String? text;
    if (_selectedItems.count > 0 && selectedIndex != -1 && !_flattenField) {
      text = _selectedItems[0].text;
    } else if (_dictionary.containsKey(_DictionaryProperties.dv) &&
        !_flattenField) {
      final _IPdfPrimitive? defaultValue =
          _PdfCrossTable._dereference(_dictionary[_DictionaryProperties.dv]);
      if (defaultValue != null && defaultValue is _PdfString) {
        text = defaultValue.value;
      }
    }
    if (_selectedItems.count == 0) {
      _FieldPainter().drawComboBox(
          graphics!, prms, selectedValue, gp._font, gp._stringFormat);
    } else if (text != null && !_flattenField) {
      _FieldPainter()
          .drawComboBox(graphics!, prms, text, gp._font, gp._stringFormat);
    } else {
      _FieldPainter().drawRectangularControl(graphics!, prms);
    }
  }

  double _getFontHeight(PdfFontFamily family) {
    double fontSize = 0;
    final List<double> widths = [];
    if (selectedIndex != -1) {
      final PdfFont itemFont = PdfStandardFont(family, 12);
      widths.add(itemFont.measureString(selectedItem!.text).width);
    } else {
      final PdfFont sfont = PdfStandardFont(family, 12);
      double max = sfont.measureString(items[0].text).width;
      for (int i = 1; i < items.count; ++i) {
        final double value = sfont.measureString(items[i].text).width;
        max = (max > value) ? max : value;
        widths.add(max);
      }
    }
    widths.sort();
    double s = widths.length > 0
        ? ((12 * (bounds.size.width - 4 * borderWidth)) /
            widths[widths.length - 1])
        : 12;
    if (selectedIndex != -1) {
      final PdfFont font = PdfStandardFont(family, s);
      final String text = selectedValue;
      final Size textSize = font.measureString(text);
      if (textSize.width > bounds.width || textSize.height > bounds.height) {
        final double width = bounds.width - 4 * borderWidth;
        final double h = bounds.height - 4 * borderWidth;
        final double minimumFontSize = 0.248;
        for (double i = 1; i <= bounds.height; i++) {
          font._setSize(i);
          Size textSize = font.measureString(text);
          if (textSize.width > bounds.width || textSize.height > h) {
            fontSize = i;
            do {
              fontSize = fontSize - 0.001;
              font._setSize(fontSize);
              final double textWidth = font._getLineWidth(text, _format);
              if (fontSize < minimumFontSize) {
                font._setSize(minimumFontSize);
                break;
              }
              textSize = font.measureString(text, format: _format);
              if (textWidth < width && textSize.height < h) {
                font._setSize(fontSize);
                break;
              }
            } while (fontSize > minimumFontSize);
            s = fontSize;
            break;
          }
        }
      }
    } else if (s > 12) {
      s = 12;
    }
    return s;
  }
}
