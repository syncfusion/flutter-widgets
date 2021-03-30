part of pdf;

/// Represents button field in the PDF form.
class PdfButtonField extends PdfField {
  //Constructor
  /// Initializes an instance of the [PdfButtonField] class with the specific
  /// page, name, and bounds.
  PdfButtonField(PdfPage page, String name, Rect bounds,
      {String? text,
      PdfFont? font,
      PdfColor? borderColor,
      PdfColor? backColor,
      PdfColor? foreColor,
      int? borderWidth,
      PdfHighlightMode highlightMode = PdfHighlightMode.invert,
      PdfBorderStyle borderStyle = PdfBorderStyle.solid,
      PdfFieldActions? actions,
      String? tooltip})
      : super(page, name, bounds,
            tooltip: tooltip,
            font: font,
            borderColor: borderColor,
            backColor: backColor,
            foreColor: foreColor,
            borderWidth: borderWidth,
            highlightMode: highlightMode,
            borderStyle: borderStyle) {
    _initValues(text, actions);
  }

  PdfButtonField._loaded(_PdfDictionary dictionary, _PdfCrossTable crossTable)
      : super._load(dictionary, crossTable);

  //Fields
  String _text = '';
  PdfFieldActions? _actions;

  // Properties
  /// Gets or sets the caption text.
  String get text => _isLoadedField ? _obtainText() : _text;
  set text(String value) {
    if (_isLoadedField) {
      final bool readOnly = ((1 & (_flagValues ?? 65536)) != 0);
      if (!readOnly) {
        this.form!._setAppearanceDictionary = true;
        _assignText(value);
      }
    } else {
      if (_text != value) {
        _text = value;
        _widget!._widgetAppearance!.normalCaption = _text;
      }
    }
  }

  /// Gets or sets the font.
  PdfFont get font => _font!;
  set font(PdfFont value) {
    _font = value;
  }

  /// Gets or sets the border style.
  ///
  /// The default style is solid.
  PdfBorderStyle get borderStyle => _borderStyle;
  set borderStyle(PdfBorderStyle value) => _borderStyle = value;

  /// Gets or sets the color of the border.
  ///
  /// The default color is black.
  PdfColor get borderColor => _borderColor;
  set borderColor(PdfColor value) => _borderColor = value;

  /// Gets or sets the color of the background.
  ///
  /// The default color is empty.
  PdfColor get backColor => _backColor;
  set backColor(PdfColor value) => _backColor = value;

  /// Gets or sets the color of the text.
  ///
  /// The default color is black.
  PdfColor get foreColor => _foreColor;
  set foreColor(PdfColor value) => _foreColor = value;

  /// Gets or sets the width of the border.
  ///
  /// The default value is 1.
  int get borderWidth => _borderWidth;
  set borderWidth(int value) => _borderWidth = value;

  /// Gets or sets the highlighting mode.
  ///
  /// The default mode is invert.
  PdfHighlightMode get highlightMode => _highlightMode;
  set highlightMode(PdfHighlightMode value) => _highlightMode = value;

  /// Gets the actions of the field.{Read-Only}
  PdfFieldActions get actions {
    if (_isLoadedField && _actions == null) {
      if (_dictionary.containsKey(_DictionaryProperties.aa)) {
        final _PdfDictionary actionDict =
            _crossTable!._getObject(_dictionary[_DictionaryProperties.aa])
                as _PdfDictionary;
        _actions = PdfFieldActions._loaded(actionDict);
        _widget!.actions = _actions!._annotationActions;
      } else {
        _actions = PdfFieldActions._loaded(_PdfDictionary());
        _dictionary.setProperty(_DictionaryProperties.aa, _actions);
      }
      _changed = true;
    } else {
      if (_actions == null) {
        _actions = PdfFieldActions(_widget!.actions!);
        _dictionary.setProperty(_DictionaryProperties.aa, _actions);
      }
    }
    return _actions!;
  }

  //Implementation
  void _initValues(String? txt, PdfFieldActions? action) {
    _format!.alignment = PdfTextAlignment.center;
    _widget!.textAlignment = PdfTextAlignment.center;
    text = txt != null ? txt : name!;
    if (action != null) {
      _actions = action;
      _widget!.actions = action._annotationActions;
      _dictionary.setProperty(_DictionaryProperties.aa, _actions);
    }
  }

  @override
  void _initialize() {
    super._initialize();
    _dictionary.setProperty(
        _DictionaryProperties.ft, _PdfName(_DictionaryProperties.btn));
    _backColor = PdfColor(211, 211, 211, 255);
    _flags.add(_FieldFlags.pushButton);
  }

  /// Adds Print action to current button field.
  void addPrintAction() {
    _addPrintAction();
  }

  void _addPrintAction() {
    final _PdfDictionary actionDictionary = _PdfDictionary();
    actionDictionary.setProperty(
        _DictionaryProperties.n, _PdfName(_DictionaryProperties.print));
    actionDictionary.setProperty(_DictionaryProperties.s, _PdfName('Named'));
    if (_isLoadedField) {
      final _PdfArray? kidsArray = _crossTable!
          ._getObject(_dictionary[_DictionaryProperties.kids]) as _PdfArray?;
      if (kidsArray != null) {
        final _PdfReferenceHolder buttonObject =
            kidsArray[0] as _PdfReferenceHolder;
        final _PdfDictionary buttonDictionary =
            buttonObject._object as _PdfDictionary;
        buttonDictionary.setProperty(_DictionaryProperties.a, actionDictionary);
      } else {
        _dictionary.setProperty(_DictionaryProperties.a, actionDictionary);
      }
    } else {
      final _PdfArray kidsArray =
          _dictionary[_DictionaryProperties.kids] as _PdfArray;
      final _PdfReferenceHolder buttonObject =
          kidsArray[0] as _PdfReferenceHolder;
      final _PdfDictionary buttonDictionary =
          buttonObject._object as _PdfDictionary;
      buttonDictionary.setProperty(_DictionaryProperties.a, actionDictionary);
    }
  }

  @override
  void _save() {
    super._save();
    if (page != null &&
        page!.formFieldsTabOrder == PdfFormFieldsTabOrder.manual &&
        !(page!._isLoadedPage)) {
      final PdfPage? page = this.page;
      final PdfField textField = this;
      if (textField._widget != null) {
        page!.annotations.remove(textField._widget!);
        page.annotations._annotations
            ._insert(this.tabIndex, _PdfReferenceHolder(textField._widget));
        page.annotations._list.insert(this.tabIndex, textField._widget!);
      }
    }
    if (form != null && !form!._needAppearances!) {
      if (_widget!._pdfAppearance == null) {
        _drawAppearance(_widget!.appearance.normal);
      }
    }
    if (form != null && !form!._needAppearances!) {
      if (_widget!.appearance._templatePressed == null) {
        _drawPressedAppearance(_widget!.appearance.pressed);
      }
    }
  }

  @override
  void _drawAppearance(PdfTemplate template) {
    super._drawAppearance(template);
    if (text.isEmpty) {
      text = name!;
    }
    final _PaintParams paintParams = _PaintParams(
        bounds: Rect.fromLTWH(
            0, 0, _widget!.bounds.size.width, _widget!.bounds.size.height),
        backBrush: PdfSolidBrush(_backColor),
        foreBrush: PdfSolidBrush(_foreColor),
        borderPen: _borderPen,
        style: _borderStyle,
        borderWidth: _borderWidth,
        shadowBrush: PdfSolidBrush(_backColor),
        rotationAngle: 0);
    _FieldPainter().drawButton(
        template.graphics!,
        paintParams,
        text,
        (_font == null) ? PdfStandardFont(PdfFontFamily.helvetica, 8) : _font!,
        _format);
  }

  void _drawPressedAppearance(PdfTemplate template) {
    if (text.isEmpty) {
      text = name!;
    }
    final _PaintParams paintParams = _PaintParams(
        bounds: Rect.fromLTWH(
            0, 0, _widget!.bounds.size.width, _widget!.bounds.size.height),
        backBrush: PdfSolidBrush(_backColor),
        foreBrush: PdfSolidBrush(_foreColor),
        borderPen: _borderPen,
        style: _borderStyle,
        borderWidth: _borderWidth,
        shadowBrush: PdfSolidBrush(_backColor),
        rotationAngle: 0);
    _FieldPainter().drawPressedButton(
        template.graphics!,
        paintParams,
        text,
        (_font == null) ? PdfStandardFont(PdfFontFamily.helvetica, 8) : _font!,
        _format);
  }

  String _obtainText() {
    final _PdfDictionary widget =
        _getWidgetAnnotation(_dictionary, _crossTable);
    String? str;
    if (widget.containsKey(_DictionaryProperties.mk)) {
      final _PdfDictionary appearance = _crossTable!
          ._getObject(widget[_DictionaryProperties.mk]) as _PdfDictionary;
      if (appearance.containsKey(_DictionaryProperties.ca)) {
        final _PdfString text = _crossTable!
            ._getObject(appearance[_DictionaryProperties.ca]) as _PdfString;
        str = text.value;
      }
    }
    if (str == null) {
      _PdfString? val = _crossTable!
          ._getObject(_dictionary[_DictionaryProperties.v]) as _PdfString?;
      if (val == null) {
        val = PdfField._getValue(
                _dictionary, _crossTable, _DictionaryProperties.v, true)
            as _PdfString?;
      }
      if (val != null) {
        str = val.value;
      } else {
        str = '';
      }
    }
    return str!;
  }

  void _assignText(String value) {
    final String text = value;
    final _PdfDictionary widget =
        _getWidgetAnnotation(_dictionary, _crossTable);
    if (widget.containsKey(_DictionaryProperties.mk)) {
      final _PdfDictionary appearance = _crossTable!
          ._getObject(widget[_DictionaryProperties.mk]) as _PdfDictionary;
      appearance._setString(_DictionaryProperties.ca, text);
      widget.setProperty(
          _DictionaryProperties.mk, _PdfReferenceHolder(appearance));
    } else {
      final _PdfDictionary appearance = _PdfDictionary();
      appearance._setString(_DictionaryProperties.ca, text);
      widget.setProperty(
          _DictionaryProperties.mk, _PdfReferenceHolder(appearance));
    }
    if (widget.containsKey(_DictionaryProperties.ap)) {
      _applyAppearance(widget, null);
    }
    _changed = true;
  }

  @override
  void _beginSave() {
    super._beginSave();
    final _PdfArray? kids = _obtainKids();
    if ((kids != null)) {
      for (int i = 0; i < kids.count; ++i) {
        final _PdfDictionary? widget =
            _crossTable!._getObject(kids[i]) as _PdfDictionary?;
        _applyAppearance(widget, this);
      }
    }
  }

  void _draw() {
    super._draw();
    if (_isLoadedField) {
      final _PdfArray? kids = _obtainKids();
      if ((kids != null) && (kids.count > 1)) {
        for (int i = 0; i < kids.count; ++i) {
          if (this.page != null) {
            final _PdfDictionary? widget =
                _crossTable!._getObject(kids[i]) as _PdfDictionary?;
            _drawButton(this.page!.graphics, this, widget);
          }
        }
      } else {
        _drawButton(page!.graphics, null);
      }
    } else {
      if (_widget!._pdfAppearance != null) {
        page!.graphics.drawPdfTemplate(_widget!._pdfAppearance!.normal,
            Offset(_widget!.bounds.left, _widget!.bounds.top));
      } else {
        Rect rect = bounds;
        rect = Rect.fromLTWH(0, 0, bounds.width, bounds.height);
        PdfFont? font = _font;
        if (font == null) {
          font = PdfStandardFont(PdfFontFamily.helvetica, 8);
        }
        final _PaintParams params = _PaintParams(
            bounds: rect,
            backBrush: _backBrush,
            foreBrush: _foreBrush,
            borderPen: _borderPen,
            style: borderStyle,
            borderWidth: borderWidth,
            shadowBrush: _shadowBrush,
            rotationAngle: 0);
        final PdfTemplate template = PdfTemplate(rect.width, rect.height);
        _FieldPainter()
            .drawButton(template.graphics!, params, text, font, _stringFormat);
        page!.graphics.drawPdfTemplate(
            template, Offset(bounds.left, bounds.top), rect.size);
        page!.graphics.drawString((text.isEmpty) ? name! : text, font,
            brush: params._foreBrush, bounds: bounds, format: _stringFormat);
      }
    }
  }

  _PdfArray? _obtainKids() {
    _PdfArray? kids;
    if (_dictionary.containsKey(_DictionaryProperties.kids)) {
      kids = _crossTable!._getObject(_dictionary[_DictionaryProperties.kids])
          as _PdfArray?;
    }
    return kids;
  }

  void _applyAppearance(_PdfDictionary? widget, PdfButtonField? item) {
    if ((_actions != null) && _actions!._isChanged) {
      widget!.setProperty(_DictionaryProperties.aa, _actions);
    }
    if ((widget != null) && (widget.containsKey(_DictionaryProperties.ap))) {
      final _PdfDictionary? appearance = _crossTable!
          ._getObject(widget[_DictionaryProperties.ap]) as _PdfDictionary?;
      if ((appearance != null) &&
          (appearance.containsKey(_DictionaryProperties.n))) {
        final Rect bounds = (item == null) ? super.bounds : item.bounds;
        PdfTemplate template = PdfTemplate(bounds.width, bounds.height);
        final PdfTemplate pressedTemplate =
            PdfTemplate(bounds.width, bounds.height);
        if (widget.containsKey(_DictionaryProperties.mk)) {
          _PdfDictionary? mkDic;
          if (widget[_DictionaryProperties.mk] is _PdfReferenceHolder) {
            mkDic = _crossTable!._getObject(widget[_DictionaryProperties.mk])
                as _PdfDictionary?;
          } else {
            mkDic = widget[_DictionaryProperties.mk] as _PdfDictionary?;
          }
          if (mkDic != null && mkDic.containsKey(_DictionaryProperties.r)) {
            final _PdfNumber? angle =
                mkDic[_DictionaryProperties.r] as _PdfNumber?;
            if (angle != null) {
              if (angle.value == 90) {
                template = PdfTemplate(bounds.size.height, bounds.size.width);
                template._writeTransformation = false;
                template._content[_DictionaryProperties.matrix] =
                    _PdfArray(<double>[0, 1, -1, 0, bounds.size.width, 0]);
              } else if (angle.value == 180) {
                template = PdfTemplate(bounds.size.width, bounds.size.height);
                template._writeTransformation = false;
                template._content[_DictionaryProperties.matrix] =
                    _PdfArray(<double>[
                  -1,
                  0,
                  0,
                  -1,
                  bounds.size.width,
                  bounds.size.height
                ]);
              } else if (angle.value == 270) {
                template = PdfTemplate(bounds.size.height, bounds.size.width);
                template._writeTransformation = false;
                template._content[_DictionaryProperties.matrix] =
                    _PdfArray(<double>[0, -1, 1, 0, 0, bounds.size.height]);
              }
            }
          }
        }
        _drawButton(template.graphics!, item, widget);
        _drawButton(pressedTemplate.graphics!, item, widget);
        appearance.setProperty(
            _DictionaryProperties.n, _PdfReferenceHolder(template));
        appearance.setProperty(
            _DictionaryProperties.d, _PdfReferenceHolder(pressedTemplate));
        widget.setProperty(_DictionaryProperties.ap, appearance);
      }
    } else if (super.form!._setAppearanceDictionary) {
      super.form!._needAppearances = true;
    }
  }

  void _drawButton(PdfGraphics? graphics, PdfButtonField? item,
      [_PdfDictionary? widget]) {
    final _GraphicsProperties gp = _GraphicsProperties(this);
    if (!_flattenField) {
      gp._bounds = Rect.fromLTWH(0, 0, gp._bounds!.width, gp._bounds!.height);
    }
    final _PaintParams prms = _PaintParams(
        bounds: gp._bounds,
        backBrush: gp._backBrush,
        foreBrush: gp._foreBrush,
        borderPen: gp._borderPen,
        style: gp._style,
        borderWidth: gp._borderWidth,
        shadowBrush: gp._shadowBrush,
        rotationAngle: 0);
    if (this._dictionary.containsKey(_DictionaryProperties.ap) &&
        !(graphics!._layer != null &&
            graphics._page!._rotation != PdfPageRotateAngle.rotateAngle0)) {
      _IPdfPrimitive? buttonAppearance =
          this._dictionary[_DictionaryProperties.ap];
      if (buttonAppearance == null) {
        buttonAppearance = widget![_DictionaryProperties.ap];
      }
      _PdfDictionary? buttonResource =
          _PdfCrossTable._dereference(buttonAppearance) as _PdfDictionary?;
      if (buttonResource != null) {
        buttonAppearance = buttonResource[_DictionaryProperties.n];
        buttonResource =
            _PdfCrossTable._dereference(buttonAppearance) as _PdfDictionary?;
        if (buttonResource != null) {
          final _PdfStream? stream = buttonResource as _PdfStream?;
          if (stream != null) {
            final PdfTemplate buttonShape = PdfTemplate._fromPdfStream(stream);
            page!.graphics
                .drawPdfTemplate(buttonShape, Offset(bounds.left, bounds.top));
          }
        }
      }
    } else if (this._dictionary.containsKey(_DictionaryProperties.kids) &&
        item != null &&
        !(graphics!._layer != null &&
            graphics._page!._rotation != PdfPageRotateAngle.rotateAngle0)) {
      _IPdfPrimitive? buttonAppearance =
          item._dictionary[_DictionaryProperties.ap];
      if (buttonAppearance == null) {
        buttonAppearance = widget![_DictionaryProperties.ap];
      }
      _PdfDictionary? buttonResource =
          _PdfCrossTable._dereference(buttonAppearance) as _PdfDictionary?;
      if (buttonResource != null) {
        buttonAppearance = buttonResource[_DictionaryProperties.n];
        buttonResource =
            _PdfCrossTable._dereference(buttonAppearance) as _PdfDictionary?;
        if (buttonResource != null) {
          final _PdfStream? stream = buttonResource as _PdfStream?;
          if (stream != null) {
            final PdfTemplate buttonShape = PdfTemplate._fromPdfStream(stream);
            page!.graphics
                .drawPdfTemplate(buttonShape, Offset(bounds.left, bounds.top));
          }
        }
      }
    } else {
      _FieldPainter()
          .drawButton(graphics!, prms, text, gp._font!, gp._stringFormat);
    }
  }
}
