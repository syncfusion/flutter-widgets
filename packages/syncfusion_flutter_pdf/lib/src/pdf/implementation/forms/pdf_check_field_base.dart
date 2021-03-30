part of pdf;

/// Represents base class for field which can be checked and unchecked states.
class PdfCheckFieldBase extends PdfField {
  //Contructor
  /// Initializes a instance of the [PdfCheckFieldBase] class with
  /// the specific page, name and bounds.
  PdfCheckFieldBase(PdfPage? page, String? name, Rect bounds,
      {PdfCheckBoxStyle? style,
      PdfColor? borderColor,
      PdfColor? backColor,
      PdfColor? foreColor,
      int? borderWidth,
      PdfHighlightMode? highlightMode,
      PdfBorderStyle? borderStyle,
      String? tooltip})
      : super(page, name, bounds,
            borderColor: borderColor,
            backColor: backColor,
            foreColor: foreColor,
            borderWidth: borderWidth,
            highlightMode: highlightMode,
            borderStyle: borderStyle,
            tooltip: tooltip) {
    _initValues(style);
  }

  PdfCheckFieldBase._loaded(
      _PdfDictionary dictionary, _PdfCrossTable crossTable)
      : super._load(dictionary, crossTable);

  //Fields
  PdfCheckBoxStyle _style = PdfCheckBoxStyle.check;
  PdfTemplate? _checkedTemplate;
  PdfTemplate? _uncheckedTemplate;
  PdfTemplate? _pressedCheckedTemplate;
  PdfTemplate? _pressedUncheckedTemplate;

  //Properties
  /// Gets or sets the style.
  ///
  /// The default style is check.
  PdfCheckBoxStyle get style => _isLoadedField ? _obtainStyle() : _style;
  set style(PdfCheckBoxStyle value) {
    if (_isLoadedField) {
      _assignStyle(value);
      if (this is PdfCheckBoxField &&
          (this as PdfCheckBoxField).items != null) {
        final PdfFieldItemCollection items = (this as PdfCheckBoxField).items!;
        for (int i = 0; i < items.count; i++) {
          (items[i] as PdfCheckBoxItem)._setStyle(value);
        }
      }
      if (form!._needAppearances == false) {
        _changed = true;
        _fieldChanged = true;
      }
    } else {
      if (_style != value) {
        _style = value;
        _widget!._widgetAppearance!.normalCaption = _styleToString(_style);
      }
    }
  }

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

  //Implementation
  String _styleToString(PdfCheckBoxStyle style) {
    switch (style) {
      case PdfCheckBoxStyle.circle:
        return 'l';
      case PdfCheckBoxStyle.cross:
        return '8';
      case PdfCheckBoxStyle.diamond:
        return 'u';
      case PdfCheckBoxStyle.square:
        return 'n';
      case PdfCheckBoxStyle.star:
        return 'H';
      case PdfCheckBoxStyle.check:
      default:
        return '4';
    }
  }

  @override
  void _initialize() {
    super._initialize();
    _dictionary.setProperty(
        _DictionaryProperties.ft, _PdfName(_DictionaryProperties.btn));
  }

  void _initValues(PdfCheckBoxStyle? boxStyle) {
    if (boxStyle != null) {
      style = boxStyle;
    }
  }

  @override
  void _save() {
    super._save();
    if (form != null) {
      final Map<String, PdfTemplate> checkValue =
          _createTemplate(_checkedTemplate);
      _checkedTemplate = checkValue['template'];
      final Map<String, PdfTemplate> unCheckValue =
          _createTemplate(_uncheckedTemplate);
      _uncheckedTemplate = unCheckValue['template'];
      final Map<String, PdfTemplate> pressedValue =
          _createTemplate(_pressedCheckedTemplate);
      _pressedCheckedTemplate = pressedValue['template'];
      final Map<String, PdfTemplate> unPressedValue =
          _createTemplate(_pressedUncheckedTemplate);
      _pressedUncheckedTemplate = unPressedValue['template'];

      _widget!.extendedAppearance!.normal.activate = _checkedTemplate;
      _widget!.extendedAppearance!.normal.off = _uncheckedTemplate;
      _widget!.extendedAppearance!.pressed.activate = _pressedCheckedTemplate;
      _widget!.extendedAppearance!.pressed.off = _pressedUncheckedTemplate;
      _drawCheckAppearance();
    } else {
      _releaseTemplate(_checkedTemplate);
      _releaseTemplate(_uncheckedTemplate);
      _releaseTemplate(_pressedCheckedTemplate);
      _releaseTemplate(_pressedUncheckedTemplate);
    }
  }

  Map<String, PdfTemplate> _createTemplate(PdfTemplate? template) {
    if (template == null) {
      template =
          PdfTemplate(_widget!.bounds.size.width, _widget!.bounds.size.height);
    } else {
      template.reset(_widget!.bounds.size.width, _widget!.bounds.size.height);
    }
    return <String, PdfTemplate>{'template': template};
  }

  void _releaseTemplate(PdfTemplate? template) {
    if (template != null) {
      template.reset();
      _widget!._extendedAppearance = null;
    }
  }

  void _drawCheckAppearance() {}

  void _applyAppearance(_PdfDictionary? widget, PdfCheckFieldBase? item,
      [PdfFieldItem? fieldItem]) {
    if (widget != null && item != null) {
      if (item._dictionary.containsKey(_DictionaryProperties.v) &&
          !(item is PdfRadioButtonListItem)) {
        widget._setName(
            _PdfName(_DictionaryProperties.v), _DictionaryProperties.yes);
        widget._setName(_PdfName(_DictionaryProperties.usageApplication),
            _DictionaryProperties.yes);
      } else if (!item._dictionary.containsKey(_DictionaryProperties.v) &&
          !(item is PdfRadioButtonListItem)) {
        widget.remove(_DictionaryProperties.v);
        widget._setName(_PdfName(_DictionaryProperties.usageApplication),
            _DictionaryProperties.off);
      }
    } else if (widget != null && fieldItem != null) {
      widget = fieldItem._dictionary;
    } else {
      widget = item!._dictionary;
    }
    if ((widget != null) && (widget.containsKey(_DictionaryProperties.ap))) {
      final _PdfDictionary? appearance = _crossTable!
          ._getObject(widget[_DictionaryProperties.ap]) as _PdfDictionary?;
      if ((appearance != null) &&
          (appearance.containsKey(_DictionaryProperties.n))) {
        String? value = '';
        Rect rect;
        if (item != null) {
          value = _getItemValue(widget, item._crossTable);
          rect = item.bounds;
        } else if (fieldItem != null) {
          value = _getItemValue(widget, fieldItem._field._crossTable);
          rect = fieldItem.bounds;
        } else {
          value = _getItemValue(widget, _crossTable);
          rect = bounds;
        }
        _IPdfPrimitive? holder =
            _PdfCrossTable._dereference(appearance[_DictionaryProperties.n]);
        _PdfDictionary? normal = holder as _PdfDictionary?;
        if (this._fieldChanged == true && normal != null) {
          normal = _PdfDictionary();
          final PdfTemplate checkedTemplate =
              PdfTemplate(rect.width, rect.height);
          final PdfTemplate unchekedTemplate =
              PdfTemplate(rect.width, rect.height);
          _drawStateItem(checkedTemplate.graphics!, _PdfCheckFieldState.checked,
              item, fieldItem);
          _drawStateItem(unchekedTemplate.graphics!,
              _PdfCheckFieldState.unchecked, item, fieldItem);
          normal.setProperty(value, _PdfReferenceHolder(checkedTemplate));
          normal.setProperty(
              _DictionaryProperties.off, _PdfReferenceHolder(unchekedTemplate));
          appearance.remove(_DictionaryProperties.n);
          appearance[_DictionaryProperties.n] = _PdfReferenceHolder(normal);
        }
        holder =
            _PdfCrossTable._dereference(appearance[_DictionaryProperties.d]);
        _PdfDictionary? pressed = holder as _PdfDictionary?;
        if (this._fieldChanged == true && pressed != null) {
          pressed = _PdfDictionary();
          final PdfTemplate checkedTemplate =
              PdfTemplate(rect.width, rect.height);
          final PdfTemplate unchekedTemplate =
              PdfTemplate(rect.width, rect.height);
          _drawStateItem(checkedTemplate.graphics!,
              _PdfCheckFieldState.pressedChecked, item, fieldItem);
          _drawStateItem(unchekedTemplate.graphics!,
              _PdfCheckFieldState.pressedUnchecked, item, fieldItem);
          pressed.setProperty(
              _DictionaryProperties.off, _PdfReferenceHolder(unchekedTemplate));
          pressed.setProperty(value, _PdfReferenceHolder(checkedTemplate));
          appearance.remove(_DictionaryProperties.d);
          appearance[_DictionaryProperties.d] = _PdfReferenceHolder(pressed);
        }
      }
      widget.setProperty(_DictionaryProperties.ap, appearance);
    } else if ((this).form!._setAppearanceDictionary) {
      (this).form!._needAppearances = true;
    } else if ((this)._form!._setAppearanceDictionary &&
        !_form!._needAppearances!) {
      final _PdfDictionary dic = _PdfDictionary();
      final PdfTemplate template = PdfTemplate(bounds.width, bounds.height);
      _drawAppearance(template);
      dic.setProperty(_DictionaryProperties.n, _PdfReferenceHolder(template));
      widget!.setProperty(_DictionaryProperties.ap, dic);
    }
  }

  PdfCheckBoxStyle _obtainStyle() {
    final _PdfDictionary widget =
        _getWidgetAnnotation(_dictionary, _crossTable);
    PdfCheckBoxStyle style = PdfCheckBoxStyle.check;
    if (widget.containsKey(_DictionaryProperties.mk)) {
      final _PdfDictionary bs = _crossTable!
          ._getObject(widget[_DictionaryProperties.mk]) as _PdfDictionary;
      style = _createStyle(bs);
    }
    return style;
  }

  PdfCheckBoxStyle _createStyle(_PdfDictionary bs) {
    PdfCheckBoxStyle style = PdfCheckBoxStyle.check;
    if (bs.containsKey(_DictionaryProperties.ca)) {
      final _PdfString? name =
          _crossTable!._getObject(bs[_DictionaryProperties.ca]) as _PdfString?;
      if (name != null) {
        final String ch = name.value!.toLowerCase();
        switch (ch) {
          case '4':
            style = PdfCheckBoxStyle.check;
            break;
          case 'l':
            style = PdfCheckBoxStyle.circle;
            break;
          case '8':
            style = PdfCheckBoxStyle.cross;
            break;
          case 'u':
            style = PdfCheckBoxStyle.diamond;
            break;
          case 'n':
            style = PdfCheckBoxStyle.square;
            break;
          case 'h':
            style = PdfCheckBoxStyle.star;
            break;
        }
      }
    }
    return style;
  }

  void _assignStyle(PdfCheckBoxStyle checkStyle) {
    String style = '';
    final _PdfDictionary widget =
        _getWidgetAnnotation(_dictionary, _crossTable);
    if (widget.containsKey(_DictionaryProperties.mk)) {
      switch (checkStyle) {
        case PdfCheckBoxStyle.check:
          style = "4";
          break;
        case PdfCheckBoxStyle.circle:
          style = "l";
          break;
        case PdfCheckBoxStyle.cross:
          style = "8";
          break;
        case PdfCheckBoxStyle.diamond:
          style = "u";
          break;
        case PdfCheckBoxStyle.square:
          style = "n";
          break;
        case PdfCheckBoxStyle.star:
          style = "H";
          break;
      }
      if (widget[_DictionaryProperties.mk] is _PdfReferenceHolder) {
        final _PdfDictionary widgetDict = _crossTable!
            ._getObject(widget[_DictionaryProperties.mk]) as _PdfDictionary;
        if (widgetDict.containsKey(_DictionaryProperties.ca)) {
          widgetDict[_DictionaryProperties.ca] = _PdfString(style);
        } else {
          widgetDict.setProperty(_DictionaryProperties.ca, _PdfString(style));
        }
      } else {
        (widget[_DictionaryProperties.mk]
            as _PdfDictionary)[_DictionaryProperties.ca] = _PdfString(style);
      }
      _widget!._widgetAppearance!.normalCaption = style;
    }
  }
}
