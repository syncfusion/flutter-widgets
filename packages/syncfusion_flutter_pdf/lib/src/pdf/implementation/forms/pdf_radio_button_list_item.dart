part of pdf;

/// Represents an item of a radio button list.
class PdfRadioButtonListItem extends PdfCheckFieldBase {
  //Constructor
  /// Initializes a instance of the [PdfRadioButtonListItem] class with
  /// the specific value and bounds.
  PdfRadioButtonListItem(String value, Rect bounds,
      {PdfCheckBoxStyle style = PdfCheckBoxStyle.circle,
      PdfColor? borderColor,
      PdfColor? backColor,
      PdfColor? foreColor,
      int? borderWidth,
      PdfHighlightMode highlightMode = PdfHighlightMode.invert,
      PdfBorderStyle borderStyle = PdfBorderStyle.solid,
      String? tooltip})
      : super(null, null, bounds,
            style: style,
            borderColor: borderColor,
            backColor: backColor,
            foreColor: foreColor,
            borderWidth: borderWidth,
            highlightMode: highlightMode,
            borderStyle: borderStyle,
            tooltip: tooltip) {
    this.value = value;
    _dictionary._beginSave = _dictionaryBeginSave;
  }

  PdfRadioButtonListItem._loaded(_PdfDictionary dictionary,
      _PdfCrossTable crossTable, PdfRadioButtonListField field)
      : super._loaded(dictionary, crossTable) {
    _field = field;
  }

  //Fields
  String? _value = '';
  PdfRadioButtonListField? _field;
  String? _optionValue;

  //Properties
  ///Gets or sets the value.
  String get value {
    if (_isLoadedField) {
      _value = _getItemValue(_dictionary, _crossTable);
    }
    return _value!;
  }

  set value(String value) {
    if (value.isEmpty) {
      ArgumentError.value('value should not be empty');
    }
    if (_isLoadedField) {
      _setItemValue(value);
    }
    _value = value;
  }

  /// Gets the form of the field.{Read-Only}
  @override
  PdfForm? get form => (_field != null) ? _field!.form : null;

  @override
  set style(PdfCheckBoxStyle value) {
    if (_isLoadedField) {
      _assignStyle(value);
      if (form!._needAppearances == false) {
        _field!._changed = true;
        _field!._fieldChanged = true;
      }
    } else {
      if (_style != value) {
        _style = value;
        _widget!._widgetAppearance!.normalCaption = _styleToString(_style);
      }
    }
  }

  //Implementation
  @override
  void _initialize() {
    super._initialize();
    _widget!._beginSave = _widgetSave;
    style = PdfCheckBoxStyle.circle;
  }

  void _widgetSave(Object sender, _SavePdfPrimitiveArgs? e) {
    _save();
  }

  @override
  void _save() {
    super._save();
    if (form != null) {
      final String value = _obtainValue();
      _widget!.extendedAppearance!.normal._onMappingName = value;
      _widget!.extendedAppearance!.pressed._onMappingName = value;
      if (_field!.selectedItem == this) {
        _widget!._appearanceState = _obtainValue();
      } else {
        _widget!._appearanceState = _DictionaryProperties.off;
      }
    }
  }

  String _obtainValue() {
    String? returnValue;
    if (_value!.isEmpty) {
      final int index = _field!.items.indexOf(this);
      returnValue = index.toString();
    } else {
      returnValue = _value;
    }
    return returnValue!.replaceAll(RegExp(r'\s+'), '#20');
  }

  void _setField(PdfRadioButtonListField? field, [bool? isItem]) {
    _widget!.parent = field;
    final PdfPage page = (field != null) ? field.page! : _field!.page!;
    if (!page._isLoadedPage) {
      if (field == null) {
        page.annotations.remove(_widget!);
      } else {
        page.annotations.add(_widget!);
      }
    } else if (page._isLoadedPage && !isItem!) {
      final _PdfDictionary pageDic = page._dictionary;
      _PdfArray? annots;
      if (pageDic.containsKey(_DictionaryProperties.annots)) {
        annots = page._crossTable!
            ._getObject(pageDic[_DictionaryProperties.annots]) as _PdfArray?;
      } else {
        annots = _PdfArray();
      }
      final _PdfReferenceHolder reference = _PdfReferenceHolder(_widget);
      if (field == null) {
        final int index = annots!._indexOf(reference);
        if (index >= 0) {
          annots._removeAt(index);
        }
      } else {
        annots!._add(reference);
        if (!field.page!.annotations.contains(_widget!)) {
          field.page!.annotations.add(_widget!);
        }
        field.page!._dictionary
            .setProperty(_DictionaryProperties.annots, annots);
      }
    }
    if (field != null) {
      _field = field;
    }
  }

  @override
  void _drawCheckAppearance() {
    super._drawCheckAppearance();
    final _PaintParams paintParams = _PaintParams(
        bounds: Rect.fromLTWH(
            0, 0, _widget!.bounds.size.width, _widget!.bounds.size.height),
        backBrush: PdfSolidBrush(_backColor),
        foreBrush: PdfSolidBrush(_foreColor),
        borderPen: _borderPen,
        style: _borderStyle,
        borderWidth: _borderWidth,
        shadowBrush: PdfSolidBrush(_backColor));

    PdfTemplate template = _widget!.extendedAppearance!.normal.activate!;
    _FieldPainter().drawRadioButton(template.graphics, paintParams,
        _styleToString(style), _PdfCheckFieldState.checked);

    template = _widget!.extendedAppearance!.normal.off!;
    _FieldPainter().drawRadioButton(template.graphics, paintParams,
        _styleToString(style), _PdfCheckFieldState.unchecked);

    template = _widget!.extendedAppearance!.pressed.activate!;
    _FieldPainter().drawRadioButton(template.graphics, paintParams,
        _styleToString(style), _PdfCheckFieldState.pressedChecked);

    template = _widget!.extendedAppearance!.pressed.off!;
    _FieldPainter().drawRadioButton(template.graphics, paintParams,
        _styleToString(style), _PdfCheckFieldState.pressedUnchecked);
  }

  void _setItemValue(String value) {
    final String str = value;
    if (_dictionary.containsKey(_DictionaryProperties.ap)) {
      _PdfDictionary dic = _crossTable!
          ._getObject(_dictionary[_DictionaryProperties.ap])! as _PdfDictionary;
      if (dic.containsKey(_DictionaryProperties.n)) {
        final _PdfReference normal =
            _crossTable!._getReference(dic[_DictionaryProperties.n]);
        dic = _crossTable!._getObject(normal)! as _PdfDictionary;
        final String? dicValue = _getItemValue(_dictionary, _crossTable);
        if (dic.containsKey(dicValue)) {
          final _PdfReference valRef =
              _crossTable!._getReference(dic[dicValue]);
          dic.remove(this.value);
          dic.setProperty(
              str, _PdfReferenceHolder.fromReference(valRef, _crossTable));
        }
      }
    }
    if (str == _field!.selectedValue) {
      _dictionary._setName(
          _PdfName(_DictionaryProperties.usageApplication), str);
    } else {
      _dictionary._setName(_PdfName(_DictionaryProperties.usageApplication),
          _DictionaryProperties.off);
    }
  }

  @override
  void _draw() {
    _removeAnnotationFromPage(_field!.page);
    final _PaintParams params = _PaintParams(
        bounds: bounds,
        backBrush: _backBrush,
        foreBrush: _foreBrush,
        borderPen: _borderPen,
        style: borderStyle,
        borderWidth: borderWidth,
        shadowBrush: _shadowBrush);
    if (params._borderPen != null && params._borderWidth == 0) {
      params._borderWidth = 1;
    }
    _PdfCheckFieldState state = _PdfCheckFieldState.unchecked;
    if ((_field!.selectedIndex >= 0) && (_field!.selectedValue == value)) {
      state = _PdfCheckFieldState.checked;
    }
    _FieldPainter().drawRadioButton(
        _field!.page!.graphics, params, _styleToString(style), state);
  }

  @override
  Rect _getBounds() {
    _IPdfPrimitive? array;
    if (array == null && _dictionary.containsKey(_DictionaryProperties.rect)) {
      array = _crossTable!._getObject(_dictionary[_DictionaryProperties.rect]);
    }
    Rect bounds;
    if (array != null && array is _PdfArray) {
      bounds = array.toRectangle().rect;
      double? y = 0;
      if ((_PdfCrossTable._dereference(array[1])! as _PdfNumber).value! < 0) {
        y = (_PdfCrossTable._dereference(array[1])! as _PdfNumber).value
            as double?;
        if ((_PdfCrossTable._dereference(array[1])! as _PdfNumber).value! >
            (_PdfCrossTable._dereference(array[3])! as _PdfNumber).value!) {
          y = y! - bounds.height;
        }
      }
      bounds = Rect.fromLTWH(
          bounds.left, y! <= 0 ? bounds.top : y, bounds.width, bounds.height);
    } else {
      bounds = const Rect.fromLTWH(0, 0, 0, 0);
    }
    return bounds;
  }

  @override
  _IPdfPrimitive? get _element => _widget!._element;
}
