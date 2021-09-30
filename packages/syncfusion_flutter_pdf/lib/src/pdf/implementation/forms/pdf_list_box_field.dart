part of pdf;

/// Represents list box field of the PDF form.
class PdfListBoxField extends PdfListField {
  //Constructor
  /// Initializes a new instance of the [PdfListBoxField] class with the specific page and name.
  PdfListBoxField(PdfPage page, String name, Rect bounds,
      {List<PdfListFieldItem>? items,
      bool multiSelect = false,
      List<int>? selectedIndexes,
      List<String>? selectedValues,
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
    this.multiSelect = multiSelect;
    if (selectedIndexes != null) {
      this.selectedIndexes = selectedIndexes;
    }
    if (selectedValues != null) {
      this.selectedValues = selectedValues;
    }
  }

  /// Initializes a new instance of the [PdfListBoxField] class.
  PdfListBoxField._load(_PdfDictionary dictionary, _PdfCrossTable crossTable)
      : super._load(dictionary, crossTable);

  //Fields
  bool _multiSelect = false;

  //Properties
  /// Gets or sets a value indicating whether the field is multi-selectable.
  ///
  /// The default value is false.
  bool get multiSelect {
    if (_isLoadedField) {
      _multiSelect = _isFlagPresent(_FieldFlags.multiSelect) ||
          _flags.contains(_FieldFlags.multiSelect);
    }
    return _multiSelect;
  }

  set multiSelect(bool value) {
    if (_multiSelect != value || _isLoadedField) {
      _multiSelect = value;
      _multiSelect
          ? _flags.add(_FieldFlags.multiSelect)
          : _isLoadedField
              ? _removeFlag(_FieldFlags.multiSelect)
              : _flags.remove(_FieldFlags.multiSelect);
    }
  }

  /// Gets or sets selected indexes in the list.
  ///
  /// Multiple indexes will be selected only when multiSelect property is enabled,
  /// Otherwise only the first index in the collection will be selected.
  List<int> get selectedIndexes => _selectedIndexes;
  set selectedIndexes(List<int> value) {
    if (value.isNotEmpty) {
      _selectedIndexes = multiSelect ? value : <int>[value[0]];
    }
  }

  /// Gets or sets the selected values in the list.
  ///
  /// Multiple values will be selected only when multiSelect property is enabled,
  /// Otherwise only the first value in the collection will be selected.
  List<String> get selectedValues => _selectedValues;
  set selectedValues(List<String> value) {
    if (value.isNotEmpty) {
      _selectedValues = multiSelect ? value : <String>[value[0]];
    }
  }

  /// Gets the selected items in the list.
  PdfListFieldItemCollection get selectedItems => _selectedItems;

  //Implementation.
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
    PdfFont font;
    if (this.font == null) {
      if (_page!._document != null &&
          _page!._document!._conformanceLevel != PdfConformanceLevel.none) {
        throw ArgumentError(
            'Font data is not embedded to the conformance PDF.');
      }
      font = PdfStandardFont(
          PdfFontFamily.timesRoman, _getFontHeight(PdfFontFamily.timesRoman));
    } else {
      font = this.font!;
    }
    _FieldPainter().drawListBox(
        template.graphics!, params, items, _selectedIndexes, font, _format);
  }

  @override
  void _draw() {
    super._draw();
    if (!_isLoadedField) {
      if (_widget!._pdfAppearance != null) {
        page!.graphics
            .drawPdfTemplate(_widget!.appearance.normal, bounds.topLeft);
      } else {
        final Rect rect = Rect.fromLTWH(0, 0, bounds.width, bounds.height);
        final PdfFont font = this.font ??
            PdfStandardFont(PdfFontFamily.helvetica,
                _getFontHeight(PdfFontFamily.helvetica));
        final _PaintParams parameters = _PaintParams(
            bounds: rect,
            backBrush: _backBrush,
            foreBrush: _foreBrush,
            borderPen: _borderPen,
            style: borderStyle,
            borderWidth: borderWidth,
            shadowBrush: _shadowBrush);
        final PdfTemplate template = PdfTemplate(rect.width, rect.height);
        _FieldPainter().drawListBox(template.graphics!, parameters, items,
            selectedIndexes, font, _format);
        page!.graphics.drawPdfTemplate(template, bounds.topLeft, rect.size);
      }
    } else {
      final PdfTemplate template = PdfTemplate(bounds.width, bounds.height);
      _drawListBox(template.graphics!);
      page!.graphics.drawPdfTemplate(template, bounds.topLeft);
    }
  }

  @override
  void _beginSave() {
    super._beginSave();
    _applyAppearance(_getWidgetAnnotation(_dictionary, _crossTable));
  }

  void _applyAppearance(_PdfDictionary widget) {
    if (widget.containsKey(_DictionaryProperties.ap) &&
        !_form!._needAppearances!) {
      final _IPdfPrimitive? appearance =
          _crossTable!._getObject(widget[_DictionaryProperties.ap]);
      if (appearance != null &&
          appearance is _PdfDictionary &&
          appearance.containsKey(_DictionaryProperties.n)) {
        final PdfTemplate template = PdfTemplate(bounds.width, bounds.height);
        template._writeTransformation = false;
        _beginMarkupSequence(template.graphics!._streamWriter!._stream!);
        template.graphics!._initializeCoordinates();
        _drawListBox(template.graphics!);
        _endMarkupSequence(template.graphics!._streamWriter!._stream!);
        appearance.remove(_DictionaryProperties.n);
        appearance.setProperty(
            _DictionaryProperties.n, _PdfReferenceHolder(template));
        widget.setProperty(_DictionaryProperties.ap, appearance);
      }
    } else if (_form!._setAppearanceDictionary && !_form!._needAppearances!) {
      final _PdfDictionary dic = _PdfDictionary();
      final PdfTemplate template = PdfTemplate(bounds.width, bounds.height);
      _drawAppearance(template);
      dic.setProperty(_DictionaryProperties.n, _PdfReferenceHolder(template));
      widget.setProperty(_DictionaryProperties.ap, dic);
    }
  }

  void _drawListBox(PdfGraphics graphics) {
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
    if (!_form!._setAppearanceDictionary && !_form!._flatten) {
      prms._backBrush = null;
    }
    _FieldPainter().drawListBox(
        graphics, prms, items, _selectedIndexes, gp._font!, gp._stringFormat);
  }

  @override
  double _getFontHeight(PdfFontFamily family) {
    double s = 0;
    if (items.count > 0) {
      final PdfFont font = PdfStandardFont(family, 12);
      double max = font.measureString(items[0].text).width;
      for (int i = 1; i < items.count; ++i) {
        final double temp = font.measureString(items[i].text).width;
        max = (max > temp) ? max : temp;
      }
      s = (12 * (bounds.size.width - 4 * borderWidth)) / max;
      s = (s > 12) ? 12 : s;
    }
    return s;
  }
}
