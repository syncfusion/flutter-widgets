part of pdf;

/// Represents text box field in the PDF form.
class PdfTextBoxField extends PdfField {
  //Constructor
  /// Initializes a new instance of the [PdfTextBoxField] class with the provided page and name.
  PdfTextBoxField(PdfPage page, String name, Rect bounds,
      {PdfFont? font,
      String? text,
      String? defaultValue,
      int maxLength = 0,
      bool spellCheck = false,
      bool insertSpaces = false,
      bool multiline = false,
      bool isPassword = false,
      bool scrollable = false,
      PdfTextAlignment alignment = PdfTextAlignment.left,
      PdfColor? borderColor,
      PdfColor? foreColor,
      PdfColor? backColor,
      int? borderWidth,
      PdfHighlightMode highlightMode = PdfHighlightMode.invert,
      PdfBorderStyle borderStyle = PdfBorderStyle.solid,
      String? tooltip})
      : super(page, name, bounds,
            font: font,
            alignment: alignment,
            borderColor: borderColor,
            foreColor: foreColor,
            backColor: backColor,
            borderWidth: borderWidth,
            highlightMode: highlightMode,
            borderStyle: borderStyle,
            tooltip: tooltip) {
    this.font =
        font != null ? font : PdfStandardFont(PdfFontFamily.helvetica, 8);
    _init(text, defaultValue, maxLength, spellCheck, insertSpaces, multiline,
        isPassword, scrollable);
  }

  /// Initializes a new instance of the [PdfTextBoxField] class.
  PdfTextBoxField._load(_PdfDictionary dictionary, _PdfCrossTable crossTable)
      : super._load(dictionary, crossTable) {
    _items = PdfFieldItemCollection._(this);
    final _PdfArray? kids = _kids;
    if (kids != null) {
      for (int i = 0; i < kids.count; ++i) {
        final _PdfDictionary? itemDictionary =
            crossTable._getObject(kids[i]) as _PdfDictionary?;
        _items!._add(PdfTextBoxItem._(this, i, itemDictionary));
      }
      _array = kids;
    }
  }

  //Fields
  String? _text = '';
  String? _defaultValue = '';
  bool _spellCheck = false;
  bool _insertSpaces = false;
  bool _multiline = false;
  bool _password = false;
  bool _scrollable = true;
  int _maxLength = 0;
  PdfFieldItemCollection? _items;

  //Properties
  /// Gets or sets the text in the text box.
  String get text {
    if (_isLoadedField) {
      _IPdfPrimitive? str;
      final _IPdfPrimitive? referenceHolder =
          _dictionary[_DictionaryProperties.v];
      if (referenceHolder != null && referenceHolder is _PdfReferenceHolder) {
        final _IPdfPrimitive? textObject =
            _PdfCrossTable._dereference(referenceHolder);
        if (textObject is _PdfStream) {
          final _PdfStream stream = referenceHolder.object as _PdfStream;
          stream._decompress();
          final List<int> bytes = stream._dataStream!;
          final String data = utf8.decode(bytes);
          str = _PdfString(data);
        } else if (textObject is _PdfString) {
          str = PdfField._getValue(
              _dictionary, _crossTable, _DictionaryProperties.v, true);
        } else {
          str = _PdfString('');
        }
      } else {
        str = PdfField._getValue(
            _dictionary, _crossTable, _DictionaryProperties.v, true);
      }
      _text = str != null && str is _PdfString ? str.value : '';
      return _text!;
    }
    return _text!;
  }

  set text(String value) {
    if (_isLoadedField) {
      //check if not readOnly.
      if (!_isFlagPresent(_FieldFlags.readOnly)) {
        _isTextChanged = true;
        if (_dictionary.containsKey(_DictionaryProperties.aa)) {
          final _IPdfPrimitive? dic = _dictionary[_DictionaryProperties.aa];
          if (dic != null && dic is _PdfDictionary) {
            final _IPdfPrimitive? dicRef = dic[_DictionaryProperties.k];
            if (dicRef != null && dicRef is _PdfReferenceHolder) {
              final _IPdfPrimitive? dict = dicRef.object;
              if (dict != null && dict is _PdfDictionary) {
                final _IPdfPrimitive? str =
                    _PdfCrossTable._dereference(dict['JS']);
                if (str != null && str is _PdfString) {
                  _dictionary.setProperty(
                      _DictionaryProperties.v, _PdfString(str.value!));
                }
              }
            }
          }
        }
        _dictionary.setProperty(_DictionaryProperties.v, _PdfString(value));
        _changed = true;
        _form!._setAppearanceDictionary = true;
        if (_form!._isUR3) {
          _dictionary._beginSaveList ??= [];
          _dictionary._beginSaveList!.add(_dictSave);
        }
      } else {
        _changed = false;
      }
    } else {
      if (_text != value) {
        _text = value;
        _dictionary._setString(_DictionaryProperties.v, _text);
      }
    }
  }

  /// Gets or sets the font.
  PdfFont get font => _font!;
  set font(PdfFont value) {
    _font = value;
  }

  /// Gets or sets the default value.
  String get defaultValue {
    if (_isLoadedField) {
      final _IPdfPrimitive? str = PdfField._getValue(
          _dictionary, _crossTable, _DictionaryProperties.dv, true);
      if (str != null && str is _PdfString) {
        _defaultValue = str.value;
      }
    }
    return _defaultValue!;
  }

  set defaultValue(String value) {
    if (defaultValue != value) {
      _defaultValue = value;
      _dictionary._setString(_DictionaryProperties.dv, _defaultValue);
      if (_isLoadedField) {
        _changed = true;
      }
    }
  }

  /// Gets or sets the maximum number of characters that can be entered in the text box.
  ///
  /// The default value is 0.
  int get maxLength {
    if (_isLoadedField) {
      final _IPdfPrimitive? number = PdfField._getValue(
          _dictionary, _crossTable, _DictionaryProperties.maxLen, true);
      if (number != null && number is _PdfNumber) {
        _maxLength = number.value!.toInt();
      }
    }
    return _maxLength;
  }

  set maxLength(int value) {
    if (maxLength != value) {
      _maxLength = value;
      _dictionary._setNumber(_DictionaryProperties.maxLen, _maxLength);
      if (_isLoadedField) {
        _changed = true;
      }
    }
  }

  /// Gets or sets a value indicating whether to check spelling.
  ///
  /// The default value is false.
  bool get spellCheck {
    if (_isLoadedField) {
      _spellCheck = !(_isFlagPresent(_FieldFlags.doNotSpellCheck) ||
          _flags.contains(_FieldFlags.doNotSpellCheck));
    }
    return _spellCheck;
  }

  set spellCheck(bool value) {
    if (spellCheck != value) {
      _spellCheck = value;
      _spellCheck
          ? _isLoadedField
              ? _removeFlag(_FieldFlags.doNotSpellCheck)
              : _flags.remove(_FieldFlags.doNotSpellCheck)
          : _flags.add(_FieldFlags.doNotSpellCheck);
    }
  }

  /// Meaningful only if the maxLength property is set and the multiline, isPassword properties are false.
  ///
  /// If set, the field is automatically divided into as many equally spaced positions, or combs,
  /// as the value of maxLength, and the text is laid out into those combs.
  ///
  /// The default value is false.
  bool get insertSpaces {
    _insertSpaces = _flags.contains(_FieldFlags.comb) &&
        !_flags.contains(_FieldFlags.multiline) &&
        !_flags.contains(_FieldFlags.password) &&
        !_flags.contains(_FieldFlags.fileSelect);
    if (_isLoadedField) {
      _insertSpaces = _insertSpaces ||
          (_isFlagPresent(_FieldFlags.comb) &&
              !_isFlagPresent(_FieldFlags.multiline) &&
              !_isFlagPresent(_FieldFlags.password) &&
              !_isFlagPresent(_FieldFlags.fileSelect));
    }
    return _insertSpaces;
  }

  set insertSpaces(bool value) {
    if (insertSpaces != value) {
      _insertSpaces = value;
      _insertSpaces
          ? _flags.add(_FieldFlags.comb)
          : _isLoadedField
              ? _removeFlag(_FieldFlags.comb)
              : _flags.remove(_FieldFlags.comb);
    }
  }

  /// Gets or sets a value indicating whether this [PdfTextBoxField] is multiline.
  ///
  /// The default value is false.
  bool get multiline {
    if (_isLoadedField) {
      _multiline = _isFlagPresent(_FieldFlags.multiline) ||
          _flags.contains(_FieldFlags.multiline);
    }
    return _multiline;
  }

  set multiline(bool value) {
    if (multiline != value) {
      _multiline = value;
      if (_multiline) {
        _flags.add(_FieldFlags.multiline);
        _format!.lineAlignment = PdfVerticalAlignment.top;
      } else {
        _isLoadedField
            ? _removeFlag(_FieldFlags.multiline)
            : _flags.remove(_FieldFlags.multiline);
        _format!.lineAlignment = PdfVerticalAlignment.middle;
      }
    }
  }

  /// Gets or sets a value indicating whether this [PdfTextBoxField] is password field.
  ///
  /// The default value is false.
  bool get isPassword {
    if (_isLoadedField) {
      _password = _isFlagPresent(_FieldFlags.password) ||
          _flags.contains(_FieldFlags.password);
    }
    return _password;
  }

  set isPassword(bool value) {
    if (isPassword != value) {
      _password = value;
      _password
          ? _flags.add(_FieldFlags.password)
          : _isLoadedField
              ? _removeFlag(_FieldFlags.password)
              : _flags.remove(_FieldFlags.password);
    }
  }

  /// Gets or sets a value indicating whether this [PdfTextBoxField] is scrollable.
  ///
  /// The default value is true.
  bool get scrollable {
    if (_isLoadedField) {
      _scrollable = !(_isFlagPresent(_FieldFlags.doNotScroll) ||
          _flags.contains(_FieldFlags.doNotScroll));
    }
    return _scrollable;
  }

  set scrollable(bool value) {
    if (scrollable != value) {
      _scrollable = value;
      _spellCheck
          ? _isLoadedField
              ? _removeFlag(_FieldFlags.doNotScroll)
              : _flags.remove(_FieldFlags.doNotScroll)
          : _flags.add(_FieldFlags.doNotScroll);
    }
  }

  /// Gets or sets the text alignment.
  ///
  /// The default alignment is left.
  PdfTextAlignment get textAlignment => _textAlignment;
  set textAlignment(PdfTextAlignment value) => _textAlignment = value;

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

  /// Gets or sets the border style.
  ///
  /// The default style is solid.
  PdfBorderStyle get borderStyle => _borderStyle;
  set borderStyle(PdfBorderStyle value) => _borderStyle = value;

  /// Gets the collection of text box field items.
  PdfFieldItemCollection? get items => _items;

  //Implementations
  @override
  void _initialize() {
    super._initialize();
    _flags.add(_FieldFlags.doNotSpellCheck);
    _dictionary.setProperty(
        _DictionaryProperties.ft, _PdfName(_DictionaryProperties.tx));
  }

  @override
  void _save() {
    super._save();
    if (_fieldItems != null && _fieldItems!.length > 1) {
      for (int i = 1; i < _fieldItems!.length; i++) {
        final PdfTextBoxField field = _fieldItems![i] as PdfTextBoxField;
        field.text = text;
        field._save();
      }
    }
  }

  void _dictSave(Object sender, _SavePdfPrimitiveArgs? ars) {
    _beginSave();
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
    template._writeTransformation = false;
    final PdfGraphics graphics = template.graphics!;
    _beginMarkupSequence(graphics._streamWriter!._stream!);
    graphics._initializeCoordinates();
    if (params._borderWidth == 0 && params._borderPen != null) {
      params._borderWidth = 1;
      params._borderPen!.width = 1;
    }
    _drawTextBox(graphics, params: params);
    _endMarkupSequence(graphics._streamWriter!._stream!);
  }

  void _init(String? text, String? defaultValue, int maxLength, bool spellCheck,
      bool insertSpaces, bool multiline, bool password, bool scrollable) {
    if (text != null) {
      this.text = text;
    }
    if (defaultValue != null) {
      this.defaultValue = defaultValue;
    }
    this.maxLength = maxLength;
    this.spellCheck = spellCheck;
    this.insertSpaces = insertSpaces;
    this.multiline = multiline;
    this.isPassword = password;
    this.scrollable = scrollable;
  }

  void _drawTextBox(PdfGraphics? graphics,
      {_PaintParams? params, PdfFieldItem? item}) {
    if (params != null) {
      String newText = text;
      if (isPassword && text.isNotEmpty) {
        newText = '';
        for (int i = 0; i < text.length; ++i) {
          newText += '*';
        }
      }
      graphics!.save();
      if (insertSpaces) {
        double width = 0;
        final List<String> ch = text.split('');
        if (maxLength > 0) {
          width = params._bounds!.width / maxLength;
        }
        graphics.drawRectangle(bounds: params._bounds!, pen: _borderPen);
        for (int i = 0; i < maxLength; i++) {
          if (_format!.alignment != PdfTextAlignment.right) {
            if (_format!.alignment == PdfTextAlignment.center &&
                ch.length < maxLength) {
              final int startLocation =
                  (maxLength / 2 - (ch.length / 2).ceil()).toInt();
              newText = i >= startLocation && i < startLocation + ch.length
                  ? ch[i - startLocation]
                  : '';
            } else {
              newText = ch.length > i ? ch[i] : '';
            }
          } else {
            newText = maxLength - ch.length <= i
                ? ch[i - (maxLength - ch.length)]
                : '';
          }
          params._bounds = Rect.fromLTWH(params._bounds!.left,
              params._bounds!.top, width, params._bounds!.height);
          final PdfStringFormat format = PdfStringFormat(
              alignment: PdfTextAlignment.center,
              lineAlignment: _format!.lineAlignment);
          _FieldPainter().drawTextBox(
              graphics, params, newText, font, format, insertSpaces, multiline);
          params._bounds = Rect.fromLTWH(params._bounds!.left + width,
              params._bounds!.top, width, params._bounds!.height);
          if (params._borderWidth != 0) {
            graphics.drawLine(
                params._borderPen!,
                Offset(params._bounds!.left, params._bounds!.top),
                Offset(params._bounds!.left,
                    params._bounds!.top + params._bounds!.height));
          }
        }
      } else {
        _FieldPainter().drawTextBox(
            graphics, params, newText, font, _format!, insertSpaces, multiline);
      }
      graphics.restore();
    } else {
      final _GraphicsProperties gp = item != null
          ? _GraphicsProperties.fromFieldItem(item)
          : _GraphicsProperties(this);
      if (gp._borderWidth == 0 && gp._borderPen != null) {
        gp._borderWidth = 1;
        gp._borderPen!.width = 1;
      }
      if (graphics!._layer == null) {
        gp._bounds = Rect.fromLTWH(gp._bounds!.left, gp._bounds!.top,
            graphics.size.width, graphics.size.height);
      }
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
          shadowBrush: gp._shadowBrush);
      _drawTextBox(graphics, params: prms);
    }
  }

  @override
  void _beginSave() {
    super._beginSave();
    final _PdfArray? kids = _kids;
    if ((kids != null)) {
      for (int i = 0; i < kids.count; ++i) {
        final _PdfDictionary? widget =
            _crossTable!._getObject(kids[i]) as _PdfDictionary?;
        _applyAppearance(widget, items![i]);
      }
    } else {
      _applyAppearance(_getWidgetAnnotation(_dictionary, _crossTable));
    }
  }

  void _applyAppearance(_PdfDictionary? widget, [PdfFieldItem? item]) {
    if (_form!._setAppearanceDictionary) {
      if (widget != null && !_form!._needAppearances!) {
        final _PdfDictionary appearance = _PdfDictionary();
        final Rect bounds = item == null ? this.bounds : item.bounds;
        PdfTemplate? template;
        if (widget.containsKey(_DictionaryProperties.mk)) {
          final _IPdfPrimitive? mkDic = widget[_DictionaryProperties.mk];
          if (mkDic != null &&
              mkDic is _PdfDictionary &&
              mkDic.containsKey(_DictionaryProperties.r)) {
            final _IPdfPrimitive? angle = mkDic[_DictionaryProperties.r];
            if (angle != null && angle is _PdfNumber) {
              if (angle.value == 90) {
                template = PdfTemplate(bounds.size.height, bounds.size.width);
                template._content[_DictionaryProperties.matrix] =
                    _PdfArray([0, 1, -1, 0, bounds.size.width, 0]);
              } else if (angle.value == 180) {
                template = PdfTemplate(bounds.size.width, bounds.size.height);
                template._content[_DictionaryProperties.matrix] = _PdfArray(
                    [-1, 0, 0, -1, bounds.size.width, bounds.size.height]);
              } else if (angle.value == 270) {
                template = PdfTemplate(bounds.size.height, bounds.size.width);
                template._content[_DictionaryProperties.matrix] =
                    _PdfArray([0, -1, 1, 0, 0, bounds.size.height]);
              }
              if (template != null) {
                template._writeTransformation = false;
              }
            }
          }
        }
        if (template == null) {
          template = PdfTemplate(bounds.size.width, bounds.size.height);
          template._writeTransformation = false;
          template._content[_DictionaryProperties.matrix] =
              _PdfArray([1, 0, 0, 1, 0, 0]);
        }
        if (item != null) {
          _beginMarkupSequence(template.graphics!._streamWriter!._stream!);
          template.graphics!._initializeCoordinates();
          _drawTextBox(template.graphics, item: item);
          _endMarkupSequence(template.graphics!._streamWriter!._stream!);
        } else {
          _drawAppearance(template);
        }
        appearance.setProperty(
            _DictionaryProperties.n, _PdfReferenceHolder(template));
        widget.setProperty(_DictionaryProperties.ap, appearance);
      } else {
        _form!._needAppearances = true;
      }
    }
  }

  double _getFontHeight(PdfFontFamily family) {
    double s = 12;
    if (!multiline) {
      final PdfStandardFont font = PdfStandardFont(family, 12);
      final Size fontSize = font.measureString(text);
      s = (8 * (bounds.size.width - 4 * borderWidth)) / fontSize.width;
      s = (s > 8) ? 8 : s;
    } else {
      s = 12.5;
    }
    return s;
  }

  void _draw() {
    super._draw();
    if (!_isLoadedField && _widget!._pdfAppearance != null) {
      page!.graphics.drawPdfTemplate(
          _widget!._pdfAppearance!.normal, Offset(bounds.width, bounds.height));
      if (_fieldItems != null && _fieldItems!.length > 1) {
        for (int i = 1; i < _fieldItems!.length; i++) {
          final PdfTextBoxField field = _fieldItems![i] as PdfTextBoxField;
          field.text = text;
          field.page!.graphics.drawPdfTemplate(
              field._widget!._pdfAppearance!.normal,
              Offset(field.bounds.width, field.bounds.height));
        }
      }
    } else {
      if (_isLoadedField) {
        final _PdfArray? kids = _kids;
        if (kids != null) {
          for (int i = 0; i < kids.count; ++i) {
            final PdfFieldItem item = items![i];
            if (item.page != null && item.page!._isLoadedPage) {
              _drawTextBox(item.page!.graphics, item: item);
            }
          }
        } else {
          _drawTextBox(page!.graphics);
        }
      } else {
        _drawTextBox(page!.graphics);
        if (_fieldItems != null && _fieldItems!.length > 1) {
          for (int i = 1; i < _fieldItems!.length; i++) {
            final PdfTextBoxField field = _fieldItems![i] as PdfTextBoxField;
            field.text = text;
            field._drawTextBox(field.page!.graphics);
          }
        }
      }
    }
  }
}

/// Represents an item in a text box field collection.
class PdfTextBoxItem extends PdfFieldItem {
  PdfTextBoxItem._(PdfField field, int index, _PdfDictionary? dictionary)
      : super._(field, index, dictionary);
}
