part of pdf;

/// Represents check box field in the PDF form.
class PdfCheckBoxField extends PdfCheckFieldBase {
  //Constructor
  /// Initializes a new instance of the [PdfCheckBoxField] class with
  /// the specific page, name and bounds.
  PdfCheckBoxField(PdfPage page, String name, Rect bounds,
      {bool isChecked = false,
      PdfCheckBoxStyle style = PdfCheckBoxStyle.check,
      PdfColor? borderColor,
      PdfColor? backColor,
      PdfColor? foreColor,
      int? borderWidth,
      PdfHighlightMode highlightMode = PdfHighlightMode.invert,
      PdfBorderStyle borderStyle = PdfBorderStyle.solid,
      String? tooltip})
      : super(page, name, bounds,
            style: style,
            borderColor: borderColor,
            backColor: backColor,
            foreColor: foreColor,
            borderWidth: borderWidth,
            highlightMode: highlightMode,
            borderStyle: borderStyle,
            tooltip: tooltip) {
    _setCheckBoxValue(isChecked);
  }

  PdfCheckBoxField._loaded(_PdfDictionary dictionary, _PdfCrossTable crossTable)
      : super._loaded(dictionary, crossTable) {
    _items = PdfFieldItemCollection._(this);
    final _PdfArray? kids = _kids;
    if (kids != null) {
      for (int i = 0; i < kids.count; ++i) {
        final _PdfDictionary? itemDictionary =
            crossTable._getObject(kids[i]) as _PdfDictionary?;
        _items!._add(PdfCheckBoxItem._(this, i, itemDictionary));
      }
      _array = kids;
    }
  }

  //Fields
  bool _checked = false;
  PdfFieldItemCollection? _items;

  //Properties
  /// Gets or sets a value indicating whether this [PdfCheckBoxField] is checked.
  ///
  /// The default value is false.
  bool get isChecked {
    if (_isLoadedField) {
      if (items != null && items!.count > 0) {
        final _IPdfPrimitive? state = _PdfCrossTable._dereference(
            items![_defaultIndex]
                ._dictionary![_DictionaryProperties.usageApplication]);
        if (state == null) {
          final _IPdfPrimitive? name = PdfField._getValue(
              _dictionary, _crossTable, _DictionaryProperties.v, false);
          if (name != null && name is _PdfName) {
            _checked = name._name ==
                _getItemValue(items![_defaultIndex]._dictionary!, _crossTable);
          }
        } else if (state is _PdfName) {
          _checked = state._name != _DictionaryProperties.off;
        }
        return _checked;
      }
      if (_dictionary.containsKey(_DictionaryProperties.v)) {
        final _PdfName chk = _dictionary[_DictionaryProperties.v]! as _PdfName;
        _checked = chk._name != 'Off';
      }
    }
    return _checked;
  }

  set isChecked(bool value) {
    if (_isLoadedField) {
      if (_dictionary.containsKey(_DictionaryProperties.v)) {
        final _PdfName chk = _dictionary[_DictionaryProperties.v]! as _PdfName;
        if (chk._name!.isNotEmpty) {
          _checked = chk._name != 'Off';
        } else {
          _dictionary.remove(_DictionaryProperties.v);
        }
      }
      form!._setAppearanceDictionary = true;
      if (_form!._needAppearances == false) {
        _changed = true;
      }
    }
    if (_checked != value) {
      _checked = value;
      String? val;
      if (_isLoadedField) {
        val = _enableCheckBox(value);
        _enableItems(value, val);
      }
      if (_checked) {
        _dictionary._setName(_PdfName(_DictionaryProperties.v),
            val ?? _DictionaryProperties.yes);
      } else {
        _dictionary.remove(_DictionaryProperties.v);
        if (_dictionary.containsKey(_DictionaryProperties.usageApplication)) {
          _dictionary._setName(_PdfName(_DictionaryProperties.usageApplication),
              _DictionaryProperties.off);
        }
      }
    }
  }

  /// Gets the collection of check box field items.
  PdfFieldItemCollection? get items => _items;

  //Implementation
  @override
  void _save() {
    super._save();
    if (form != null) {
      if (!isChecked) {
        _widget!._appearanceState = _DictionaryProperties.off;
      } else {
        _widget!._appearanceState = _DictionaryProperties.yes;
      }
    }
    if (_fieldItems != null && _fieldItems!.length > 1) {
      for (int i = 1; i < _fieldItems!.length; i++) {
        final PdfCheckBoxField field = _fieldItems![i] as PdfCheckBoxField;
        field.isChecked = isChecked;
        field._save();
      }
    }
  }

  String? _enableCheckBox(bool value) {
    bool isChecked = false;
    String? val;
    if (_dictionary.containsKey(_DictionaryProperties.usageApplication)) {
      final _PdfName? state = _PdfCrossTable._dereference(
          _dictionary[_DictionaryProperties.usageApplication]) as _PdfName?;
      if (state != null) {
        isChecked = state._name != _DictionaryProperties.off;
      }
    }
    if (value != isChecked) {
      val = _getItemValue(_dictionary, _crossTable);
      if (value) {
        if (val == null || val == '') {
          val = _DictionaryProperties.yes;
        }
        _dictionary.setProperty(
            _DictionaryProperties.usageApplication, _PdfName(val));
        _changed = true;
      }
    }
    return val;
  }

  void _enableItems(bool check, String? value) {
    if (items != null && items!.count > 0) {
      final _PdfDictionary? dic = items![_defaultIndex]._dictionary;
      if (dic != null) {
        if (value == null || value.isEmpty) {
          value = _getItemValue(dic, _crossTable);
        }
        if (value == null || value.isEmpty) {
          value = _DictionaryProperties.yes;
        }
        if (check) {
          dic.setProperty(
              _DictionaryProperties.usageApplication, _PdfName(value));
          dic.setProperty(_DictionaryProperties.v, _PdfName(value));
        } else {
          dic._setName(_PdfName(_DictionaryProperties.usageApplication),
              _DictionaryProperties.off);
        }
      }
    }
  }

  @override
  void _drawCheckAppearance() {
    super._drawCheckAppearance();
    final _PaintParams paintParams = _PaintParams(
        bounds: Rect.fromLTWH(
            0, 0, _widget!.bounds.size.width, _widget!.bounds.size.height),
        backBrush: _backBrush,
        foreBrush: _foreBrush,
        borderPen: _borderPen,
        style: _borderStyle,
        borderWidth: _borderWidth,
        shadowBrush: _shadowBrush);

    PdfTemplate template = _widget!.extendedAppearance!.normal.activate!;
    _FieldPainter()._drawCheckBox(template.graphics!, paintParams,
        _styleToString(style), _PdfCheckFieldState.checked, _font);
    template = _widget!.extendedAppearance!.normal.off!;
    _FieldPainter()._drawCheckBox(template.graphics!, paintParams,
        _styleToString(style), _PdfCheckFieldState.unchecked, _font);

    template = _widget!.extendedAppearance!.pressed.activate!;
    _FieldPainter()._drawCheckBox(template.graphics!, paintParams,
        _styleToString(style), _PdfCheckFieldState.pressedChecked, _font);
    template = _widget!.extendedAppearance!.pressed.off!;
    _FieldPainter()._drawCheckBox(template.graphics!, paintParams,
        _styleToString(style), _PdfCheckFieldState.pressedUnchecked, _font);
  }

  void _setCheckBoxValue(bool isChecked) {
    this.isChecked = isChecked;
  }

  @override
  void _beginSave() {
    final _PdfArray? kids = _obtainKids();
    if (kids != null) {
      for (int i = 0; i < kids.count; ++i) {
        final _PdfDictionary? widget =
            _crossTable!._getObject(kids[i]) as _PdfDictionary?;
        _applyAppearance(widget, null, _items![i]);
      }
    } else {
      _applyAppearance(null, this);
    }
  }

  @override
  void _draw() {
    super._draw();
    final _PdfCheckFieldState state =
        isChecked ? _PdfCheckFieldState.checked : _PdfCheckFieldState.unchecked;
    if (!_isLoadedField) {
      final _PaintParams params = _PaintParams(
          bounds: bounds,
          backBrush: _backBrush,
          foreBrush: _foreBrush,
          borderPen: _borderPen,
          style: borderStyle,
          borderWidth: borderWidth,
          shadowBrush: _shadowBrush);
      if (_fieldItems != null && _fieldItems!.isNotEmpty) {
        for (int i = 0; i < _array.count; i++) {
          final PdfCheckBoxField item = _fieldItems![i] as PdfCheckBoxField;
          params._bounds = item.bounds;
          params._backBrush = item._backBrush;
          params._foreBrush = item._foreBrush;
          params._borderPen = item._borderPen;
          params._style = item._borderStyle;
          params._borderWidth = item._borderWidth;
          params._shadowBrush = item._shadowBrush;
          _FieldPainter()._drawCheckBox(
              item.page!.graphics, params, _styleToString(item.style), state);
        }
      } else {
        _FieldPainter()._drawCheckBox(
            page!.graphics, params, _styleToString(style), state);
      }
    } else {
      final _PdfArray? kids = _kids;
      if (kids != null) {
        for (int i = 0; i < kids.count; ++i) {
          final PdfCheckBoxItem item = _items![i] as PdfCheckBoxItem;
          if (item.page != null) {
            _drawStateItem(item.page!.graphics, state, null, item);
          }
        }
      } else {
        _drawStateItem(page!.graphics, state, this);
      }
    }
  }
}

/// Represents loaded check box item.
class PdfCheckBoxItem extends PdfFieldItem {
  PdfCheckBoxItem._(PdfField field, int index, _PdfDictionary? dictionary)
      : super._(field, index, dictionary);

  //Implementation
  void _setStyle(PdfCheckBoxStyle value) {
    String style = '';
    if (_dictionary!.containsKey(_DictionaryProperties.mk)) {
      switch (value) {
        case PdfCheckBoxStyle.check:
          style = '4';
          break;
        case PdfCheckBoxStyle.circle:
          style = 'l';
          break;
        case PdfCheckBoxStyle.cross:
          style = '8';
          break;
        case PdfCheckBoxStyle.diamond:
          style = 'u';
          break;
        case PdfCheckBoxStyle.square:
          style = 'n';
          break;
        case PdfCheckBoxStyle.star:
          style = 'H';
          break;
      }
      final _IPdfPrimitive? mk = _dictionary![_DictionaryProperties.mk];
      if (mk is _PdfReferenceHolder) {
        final _IPdfPrimitive? widgetDict = mk.object;
        if (widgetDict is _PdfDictionary) {
          if (widgetDict.containsKey(_DictionaryProperties.ca)) {
            widgetDict[_DictionaryProperties.ca] = _PdfString(style);
          } else {
            widgetDict.setProperty(_DictionaryProperties.ca, _PdfString(style));
          }
        }
      } else if (mk is _PdfDictionary) {
        mk[_DictionaryProperties.ca] = _PdfString(style);
      }
    }
  }
}
