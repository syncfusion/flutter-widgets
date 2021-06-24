part of pdf;

/// Represents field of the PDF document's interactive form.
abstract class PdfField implements _IPdfWrapper {
  //Constructor
  /// Initializes a new instance of the [PdfField] class with the specific page and name.
  PdfField(PdfPage? page, String? name, Rect bounds,
      {PdfFont? font,
      PdfTextAlignment? alignment,
      PdfColor? borderColor,
      PdfColor? foreColor,
      PdfColor? backColor,
      int? borderWidth,
      PdfHighlightMode? highlightMode,
      PdfBorderStyle? borderStyle,
      String? tooltip})
      : super() {
    if (this is PdfSignatureField) {
      if (page != null && page._document != null) {
        _form = page._document!.form;
      }
    }
    _initialize();
    if (page != null) {
      _page = page;
    }
    this.bounds = bounds;
    if (name != null) {
      _name = name;
      _dictionary.setProperty(_DictionaryProperties.t, _PdfString(name));
    }
    if (font != null) {
      _font = font;
    }
    if (alignment != null) {
      _textAlignment = alignment;
    }
    if (borderColor != null) {
      _borderColor = borderColor;
    }
    if (foreColor != null) {
      _foreColor = foreColor;
    }
    if (backColor != null) {
      _backColor = backColor;
    }
    if (borderWidth != null) {
      _borderWidth = borderWidth;
    }
    if (highlightMode != null) {
      _highlightMode = highlightMode;
    }
    if (borderStyle != null) {
      _borderStyle = borderStyle;
    }
    if (tooltip != null) {
      this.tooltip = tooltip;
    }
    if (this is PdfSignatureField) {
      _addAnnotationToPage(page, _widget);
    }
  }

  PdfField._load(_PdfDictionary dictionary, _PdfCrossTable crossTable) {
    _dictionary = dictionary;
    _crossTable = crossTable;
    _widget = _WidgetAnnotation();
    _isLoadedField = true;
  }

  //Fields
  //// ignore: prefer_final_fields
  List<_FieldFlags> _flagCollection = <_FieldFlags>[
    _FieldFlags.defaultFieldFlag
  ];
  String? _name = '';
  PdfPage? _page;
  _PdfDictionary _dictionary = _PdfDictionary();
  PdfForm? _form;
  String? _mappingName = '';
  String? _tooltip = '';
  PdfFont? _internalFont;
  _WidgetAnnotation? _widget;
  PdfStringFormat? _stringFormat;
  PdfPen? _bPen;
  // ignore: prefer_final_fields
  _PdfArray _array = _PdfArray();
  PdfBrush? _bBrush;
  PdfBrush? _fBrush;
  PdfBrush? _sBrush;
  bool _changed = false;
  bool _isLoadedField = false;
  // ignore: prefer_final_fields
  int _defaultIndex = 0;
  _PdfCrossTable? _crossTable;
  _PdfReferenceHolder? _requiredReference;
  int? _flagValues;
  int _tabIndex = 0;
  // ignore: prefer_final_fields
  int _annotationIndex = 0;
  bool _flatten = false;
  bool _readOnly = false;
  // ignore: prefer_final_fields
  bool _isTextChanged = false;
  bool _fieldChanged = false;
  List<PdfField>? _fieldItems;
  bool _export = false;
  // ignore: prefer_final_fields
  bool _exportEmptyField = false;
  int _objectID = 0;

  //Events
  late _BeforeNameChangesEventHandler _beforeNameChanges;

  //Properties
  /// Gets the form of the [PdfField].
  PdfForm? get form => _form;

  /// Gets the page of the field.
  PdfPage? get page {
    if (_isLoadedField && _page == null) {
      _page = _getLoadedPage();
    } else if (_page != null && _page!._isLoadedPage && _changed ||
        (_form != null && _form!._flatten) ||
        _flattenField) {
      _page = _getLoadedPage();
    }
    return _page;
  }

  /// Gets or sets the name of the [PdfField].
  String? get name {
    if (_isLoadedField && (_name == null || _name!.isEmpty)) {
      _name = _getFieldName();
    }
    return _name;
  }

  set name(String? value) => _setName(value);

  /// Gets or sets a value indicating whether this [PdfField] field is read-only.
  ///
  /// The default value is false.
  bool get readOnly {
    if (_isLoadedField) {
      _readOnly = _isFlagPresent(_FieldFlags.readOnly);
      return _readOnly || form!.readOnly;
    }
    return _readOnly;
  }

  set readOnly(bool value) {
    if (_isLoadedField) {
      value || form!.readOnly
          ? _setFlags(<_FieldFlags>[_FieldFlags.readOnly])
          : _removeFlag(_FieldFlags.readOnly);
    }
    _readOnly = value;
  }

  /// Gets or sets the mapping name to be used when exporting interactive form
  /// field data from the document.
  String get mappingName {
    if (_isLoadedField && (_mappingName == null || _mappingName!.isEmpty)) {
      final _IPdfPrimitive? str =
          _getValue(_dictionary, _crossTable, _DictionaryProperties.tm, false);
      if (str != null && str is _PdfString) {
        _mappingName = str.value;
      }
    }
    return _mappingName!;
  }

  set mappingName(String value) {
    if (_mappingName != value) {
      _mappingName = value;
      _dictionary._setString(_DictionaryProperties.tm, _mappingName);
    }
    if (_isLoadedField) {
      _changed = true;
    }
  }

  /// Gets or sets the tool tip.
  String get tooltip {
    if (_isLoadedField && (_tooltip == null || _tooltip!.isEmpty)) {
      final _IPdfPrimitive? str =
          _getValue(_dictionary, _crossTable, _DictionaryProperties.tu, false);
      if (str != null && str is _PdfString) {
        _tooltip = str.value;
      }
    }
    return _tooltip!;
  }

  set tooltip(String value) {
    if (_tooltip != value) {
      _tooltip = value;
      _dictionary._setString(_DictionaryProperties.tu, _tooltip);
    }
    if (_isLoadedField) {
      _changed = true;
    }
  }

  /// Gets or sets a value indicating whether the [PdfField] is exportable or not.
  ///
  /// The default value is true.
  bool get canExport {
    if (_isLoadedField) {
      _export = !(_isFlagPresent(_FieldFlags.noExport) ||
          _flags.contains(_FieldFlags.noExport));
    }
    return _export;
  }

  set canExport(bool value) {
    if (canExport != value) {
      _export = value;
      _export
          ? _isLoadedField
              ? _removeFlag(_FieldFlags.noExport)
              : _flags.remove(_FieldFlags.noExport)
          : _flags.add(_FieldFlags.noExport);
    }
  }

  /// Gets or sets the bounds.
  Rect get bounds {
    if (_isLoadedField) {
      final Rect rect = _getBounds();
      double x = 0;
      double y = 0;
      if (page != null &&
          page!._dictionary.containsKey(_DictionaryProperties.cropBox)) {
        _PdfArray? cropBox;
        if (page!._dictionary[_DictionaryProperties.cropBox] is _PdfArray) {
          cropBox =
              page!._dictionary[_DictionaryProperties.cropBox] as _PdfArray?;
        } else {
          final _PdfReferenceHolder cropBoxHolder =
              page!._dictionary[_DictionaryProperties.cropBox]!
                  as _PdfReferenceHolder;
          cropBox = cropBoxHolder.object as _PdfArray?;
        }
        if ((cropBox![0]! as _PdfNumber).value != 0 ||
            (cropBox[1]! as _PdfNumber).value != 0 ||
            page!.size.width == (cropBox[2]! as _PdfNumber).value ||
            page!.size.height == (cropBox[3]! as _PdfNumber).value) {
          x = rect.left - (cropBox[0]! as _PdfNumber).value!;
          y = (cropBox[3]! as _PdfNumber).value! - (rect.top + rect.height);
        } else {
          y = page!.size.height - (rect.top + rect.height);
        }
      } else if (page != null &&
          page!._dictionary.containsKey(_DictionaryProperties.mediaBox)) {
        _PdfArray? mediaBox;
        if (_PdfCrossTable._dereference(
            page!._dictionary[_DictionaryProperties.mediaBox]) is _PdfArray) {
          mediaBox = _PdfCrossTable._dereference(
              page!._dictionary[_DictionaryProperties.mediaBox]) as _PdfArray?;
        }
        if ((mediaBox![0]! as _PdfNumber).value! > 0 ||
            (mediaBox[1]! as _PdfNumber).value! > 0 ||
            page!.size.width == (mediaBox[2]! as _PdfNumber).value ||
            page!.size.height == (mediaBox[3]! as _PdfNumber).value) {
          x = rect.left - (mediaBox[0]! as _PdfNumber).value!;
          y = (mediaBox[3]! as _PdfNumber).value! - (rect.top + rect.height);
        } else {
          y = page!.size.height - (rect.top + rect.height);
        }
      } else if (page != null) {
        y = page!.size.height - (rect.top + rect.height);
      } else {
        y = rect.top + rect.height;
      }
      return Rect.fromLTWH(x == 0 ? rect.left : x, y == 0 ? rect.top : y,
          rect.width, rect.height);
    } else {
      return _widget!.bounds;
    }
  }

  set bounds(Rect value) {
    if (value.isEmpty && this is! PdfSignatureField) {
      ArgumentError('bounds can\'t be empty.');
    }
    if (_isLoadedField) {
      final Rect rect = value;
      final double height = page!.size.height;
      final List<_PdfNumber> values = <_PdfNumber>[
        _PdfNumber(rect.left),
        _PdfNumber(height - (rect.top + rect.height)),
        _PdfNumber(rect.left + rect.width),
        _PdfNumber(height - rect.top)
      ];
      _PdfDictionary dic = _dictionary;
      if (!dic.containsKey(_DictionaryProperties.rect)) {
        dic = _getWidgetAnnotation(_dictionary, _crossTable);
      }
      dic._setArray(_DictionaryProperties.rect, values);
      _changed = true;
    } else {
      _widget!.bounds = value;
    }
  }

  /// Gets or sets a value indicating whether to flatten this [PdfField].
  bool get _flattenField {
    if (_form != null) {
      _flatten |= _form!._flatten;
    }
    return _flatten;
  }

  set _flattenField(bool value) {
    _flatten = value;
  }

  /// Gets or sets the color of the border.
  PdfColor get _borderColor {
    if (_isLoadedField) {
      final _PdfDictionary widget =
          _getWidgetAnnotation(_dictionary, _crossTable);
      PdfColor bc = PdfColor(0, 0, 0);
      if (widget.containsKey(_DictionaryProperties.mk)) {
        final _IPdfPrimitive? getObject =
            _crossTable!._getObject(widget[_DictionaryProperties.mk]);
        if (getObject != null &&
            getObject is _PdfDictionary &&
            getObject.containsKey(_DictionaryProperties.bc)) {
          final _PdfArray array =
              getObject[_DictionaryProperties.bc]! as _PdfArray;
          bc = _createColor(array);
        }
      }
      return bc;
    } else {
      return _widget!._widgetAppearance!.borderColor;
    }
  }

  set _borderColor(PdfColor value) {
    _widget!._widgetAppearance!.borderColor = value;
    if (_isLoadedField) {
      form!._setAppearanceDictionary = true;
      _assignBorderColor(value);
      if (form!._needAppearances == false) {
        _changed = true;
        _fieldChanged = true;
      }
    }
    _createBorderPen();
  }

  /// Gets or sets the color of the background.
  PdfColor get _backColor =>
      _isLoadedField ? _getBackColor() : _widget!._widgetAppearance!.backColor;

  set _backColor(PdfColor value) {
    if (_isLoadedField) {
      _assignBackColor(value);
      if (form!._needAppearances == false) {
        _changed = true;
        _fieldChanged = true;
      }
    } else {
      _widget!._widgetAppearance!.backColor = value;
      _createBackBrush();
    }
  }

  /// Gets or sets the color of the text.
  PdfColor get _foreColor {
    if (_isLoadedField) {
      final _PdfDictionary widget =
          _getWidgetAnnotation(_dictionary, _crossTable);
      PdfColor color = PdfColor(0, 0, 0);
      if (widget.containsKey(_DictionaryProperties.da)) {
        final _PdfString defaultAppearance = _crossTable!
            ._getObject(widget[_DictionaryProperties.da])! as _PdfString;
        color = _getForeColor(defaultAppearance.value);
      } else {
        final _IPdfPrimitive? defaultAppearance = widget._getValue(
            _DictionaryProperties.da, _DictionaryProperties.parent);
        if (defaultAppearance != null && defaultAppearance is _PdfString) {
          color = _getForeColor(defaultAppearance.value);
        }
      }
      return color;
    } else {
      return _widget!.defaultAppearance.foreColor;
    }
  }

  set _foreColor(PdfColor value) {
    if (_isLoadedField) {
      final _PdfDictionary widget =
          _getWidgetAnnotation(_dictionary, _crossTable);
      double? height = 0;
      String? name;
      if (widget.containsKey(_DictionaryProperties.da)) {
        final _PdfString str = widget[_DictionaryProperties.da]! as _PdfString;
        final dynamic fontName = _fontName(str.value!);
        name = fontName['name'] as String?;
        height = fontName['height'] as double?;
      } else if (_dictionary.containsKey(_DictionaryProperties.da)) {
        final _PdfString str =
            _dictionary[_DictionaryProperties.da]! as _PdfString;
        final dynamic fontName = _fontName(str.value!);
        name = fontName['name'] as String?;
        height = fontName['height'] as double?;
      }
      if (name != null) {
        final _PdfDefaultAppearance defaultAppearance = _PdfDefaultAppearance();
        defaultAppearance.fontName = name;
        defaultAppearance.fontSize = height;
        defaultAppearance.foreColor = value;
        widget[_DictionaryProperties.da] =
            _PdfString(defaultAppearance._toString());
      } else if (_font != null) {
        final _PdfDefaultAppearance defaultAppearance = _PdfDefaultAppearance();
        defaultAppearance.fontName = _font!.name;
        defaultAppearance.fontSize = _font!.size;
        defaultAppearance.foreColor = value;
        widget[_DictionaryProperties.da] =
            _PdfString(defaultAppearance._toString());
      }
      form!._setAppearanceDictionary = true;
    } else {
      _widget!._defaultAppearance!.foreColor = value;
      _foreBrush = PdfSolidBrush(value);
    }
  }

  /// Gets or sets the width of the border.
  int get _borderWidth => _isLoadedField
      ? _obtainBorderWidth()
      : _widget!._widgetBorder!.width.toInt();
  set _borderWidth(int value) {
    if (_widget!._widgetBorder!.width != value) {
      _widget!._widgetBorder!.width = value.toDouble();
      if (_isLoadedField) {
        _assignBorderWidth(value);
      } else {
        value == 0
            ? _widget!._widgetAppearance!.borderColor = PdfColor(255, 255, 255)
            : _createBorderPen();
      }
    }
  }

  /// Gets or sets the highlighting mode.
  PdfHighlightMode get _highlightMode =>
      _isLoadedField ? _obtainHighlightMode() : _widget!.highlightMode!;
  set _highlightMode(PdfHighlightMode value) => _isLoadedField
      ? _assignHighlightMode(value)
      : _widget!.highlightMode = value;

  /// Gets or sets the border style.
  PdfBorderStyle get _borderStyle => _isLoadedField
      ? _obtainBorderStyle()
      : _widget!._widgetBorder!.borderStyle;
  set _borderStyle(PdfBorderStyle value) {
    if (_isLoadedField) {
      _assignBorderStyle(value);
      if (form!._needAppearances == false) {
        _changed = true;
        _fieldChanged = true;
      }
    } else {
      _widget!._widgetBorder!.borderStyle = value;
    }
    _createBorderPen();
  }

  /// Gets or sets the tab index for form fields.
  ///
  /// The default value is 0.
  int get tabIndex {
    if (_isLoadedField) {
      if (page != null) {
        final _PdfDictionary annotDic =
            _getWidgetAnnotation(_dictionary, _crossTable);
        final _PdfReference reference =
            page!._crossTable!._getReference(annotDic);
        _tabIndex = page!._annotsReference._indexOf(reference);
      }
    }
    return _tabIndex;
  }

  set tabIndex(int value) {
    _tabIndex = value;
    if (_isLoadedField &&
        page != null &&
        page!.formFieldsTabOrder == PdfFormFieldsTabOrder.manual) {
      final PdfAnnotation annotationReference =
          _WidgetAnnotation._(_dictionary, _crossTable!);
      final _PdfReference reference =
          page!._crossTable!._getReference(annotationReference._element);
      int index = page!._annotsReference._indexOf(reference);
      if (index < 0) {
        index = _annotationIndex;
      }
      final _PdfArray? annots =
          page!.annotations._rearrange(reference, _tabIndex, index);
      page!._dictionary.setProperty(_DictionaryProperties.annots, annots);
    }
  }

  //Gets or sets the font.
  PdfFont? get _font {
    if (_isLoadedField) {
      if (_internalFont != null &&
          !_dictionary.containsKey(_DictionaryProperties.kids)) {
        return _internalFont!;
      }
      bool? isCorrectFont = false;
      PdfFont font = PdfStandardFont(PdfFontFamily.helvetica, 8);
      final _PdfDictionary widget =
          _getWidgetAnnotation(_dictionary, _crossTable);
      if (widget.containsKey(_DictionaryProperties.da) ||
          _dictionary.containsKey(_DictionaryProperties.da)) {
        _IPdfPrimitive? defaultAppearance =
            _crossTable!._getObject(widget[_DictionaryProperties.da]);
        defaultAppearance ??=
            _crossTable!._getObject(_dictionary[_DictionaryProperties.da]);
        String? fontName;
        if (defaultAppearance != null && defaultAppearance is _PdfString) {
          final Map<String, dynamic> value = _getFont(defaultAppearance.value!);
          font = value['font'] as PdfFont;
          isCorrectFont = value['isCorrectFont'] as bool?;
          fontName = value['fontName'] as String?;
          if (!isCorrectFont! && fontName != null) {
            widget.setProperty(
                _DictionaryProperties.da,
                _PdfString(
                    defaultAppearance.value!.replaceAll(fontName, '/Helv')));
          }
        }
      }
      return font;
    }
    return _internalFont;
  }

  set _font(PdfFont? value) {
    if (value != null && _internalFont != value) {
      _internalFont = value;
      if (_isLoadedField) {
        if (_form != null) {
          _form!._setAppearanceDictionary = true;
        }
        final _PdfDefaultAppearance defaultAppearance = _PdfDefaultAppearance();
        defaultAppearance.fontName = _internalFont!.name.replaceAll(' ', '');
        defaultAppearance.fontSize = _internalFont!.size;
        defaultAppearance.foreColor = _foreColor;
        final _IPdfPrimitive? fontDictionary = _PdfCrossTable._dereference(
            _form!._resources[_DictionaryProperties.font]);
        if (fontDictionary != null &&
            fontDictionary is _PdfDictionary &&
            !fontDictionary.containsKey(defaultAppearance.fontName)) {
          final _IPdfWrapper fontWrapper = _internalFont!;
          final _PdfDictionary? fontElement =
              fontWrapper._element as _PdfDictionary?;
          fontDictionary._items![_PdfName(defaultAppearance.fontName)] =
              _PdfReferenceHolder(fontElement);
        }
        final _PdfDictionary widget =
            _getWidgetAnnotation(_dictionary, _crossTable);
        widget[_DictionaryProperties.da] =
            _PdfString(defaultAppearance._toString());
      } else {
        _defineDefaultAppearance();
      }
    }
  }

  //Gets or sets the text alignment.
  PdfTextAlignment get _textAlignment =>
      _isLoadedField ? _format!.alignment : _widget!.textAlignment!;
  set _textAlignment(PdfTextAlignment value) {
    if (_isLoadedField) {
      final _PdfDictionary widget =
          _getWidgetAnnotation(_dictionary, _crossTable);
      widget.setProperty(_DictionaryProperties.q, _PdfNumber(value.index));
      _changed = true;
    } else if (_widget!.textAlignment != value) {
      _widget!.textAlignment = value;
      _format = PdfStringFormat(
          alignment: value, lineAlignment: PdfVerticalAlignment.middle);
    }
  }

  //Gets the flags.
  List<_FieldFlags> get _flags => _flagCollection;

  int get _flagValue => _flagValues ??= _getFlagValue();

  bool _isFlagPresent(_FieldFlags flag) {
    return _getFieldFlagsValue(flag) & _flagValue != 0;
  }

  PdfStringFormat? get _format =>
      _isLoadedField ? _assignStringFormat() : _stringFormat;
  set _format(PdfStringFormat? value) => _stringFormat = value;

  PdfBrush? get _backBrush {
    if (_isLoadedField) {
      final _PdfDictionary widget =
          _getWidgetAnnotation(_dictionary, _crossTable);
      PdfColor c = PdfColor.empty;
      if (widget.containsKey(_DictionaryProperties.mk)) {
        final _IPdfPrimitive? bs =
            _crossTable!._getObject(widget[_DictionaryProperties.mk]);
        if (bs is _PdfDictionary) {
          _IPdfPrimitive? array;
          if (bs.containsKey(_DictionaryProperties.bg)) {
            array = bs[_DictionaryProperties.bg];
          } else if (bs.containsKey(_DictionaryProperties.bs)) {
            array = bs[_DictionaryProperties.bs];
          }
          if (array != null && array is _PdfArray) {
            c = _createColor(array);
          }
        }
      }
      return c.isEmpty ? null : PdfSolidBrush(c);
    } else {
      return _bBrush;
    }
  }

  set _backBrush(PdfBrush? value) {
    if (_isLoadedField && value is PdfSolidBrush) {
      _assignBackColor(value.color);
    } else {
      _bBrush = value;
    }
  }

  PdfBrush? get _foreBrush =>
      _isLoadedField ? PdfSolidBrush(_foreColor) : _fBrush;
  set _foreBrush(PdfBrush? value) => _fBrush = value;

  PdfBrush? get _shadowBrush => _isLoadedField ? _obtainShadowBrush() : _sBrush;
  set _shadowBrush(PdfBrush? value) => _sBrush = value;

  PdfPen? get _borderPen => _isLoadedField ? _obtainBorderPen() : _bPen;
  set _borderPen(PdfPen? value) => _bPen = value;

  _PdfArray? get _kids => _obtainKids();

  //Public methods
  /// Flattens the field.
  void flatten() {
    _flattenField = true;
  }

  //Implementations
  /// Sets the name of the field.
  void _setName(String? name) {
    if (name == null || name.isEmpty) {
      throw ArgumentError('Field name cannot be null/empty.');
    }
    if (_isLoadedField) {
      if (this.name != null && this.name != name) {
        final List<String> nameParts = this.name!.split('.');
        if (nameParts[nameParts.length - 1] == name) {
          return;
        } else {
          if (_form != null) {
            _beforeNameChanges(name);
          }
          _name = name;
          _changed = true;
        }
      }
    } else {
      _name = name;
    }
    _dictionary.setProperty(_DictionaryProperties.t, _PdfString(name));
  }

  void _initialize() {
    _dictionary._beginSave =
        this is PdfSignatureField ? _dictionaryBeginSave : _dictBeginSave;
    _widget = _WidgetAnnotation();
    if (this is PdfSignatureField && form!.fieldAutoNaming) {
      _createBorderPen();
      _createBackBrush();
      _dictionary = _widget!._dictionary;
    } else {
      _widget!.parent = this;
      if (this is! PdfSignatureField) {
        _format = PdfStringFormat(
            alignment: _widget!._alignment!,
            lineAlignment: PdfVerticalAlignment.middle);
        _createBorderPen();
        _createBackBrush();
      }
      final _PdfArray array = _PdfArray();
      array._add(_PdfReferenceHolder(_widget));
      _dictionary.setProperty(_DictionaryProperties.kids, _PdfArray(array));
    }
    _widget!.defaultAppearance.fontName = 'TiRo';
  }

  void _dictionaryBeginSave(Object sender, _SavePdfPrimitiveArgs? ars) {
    if (_dictionary.containsKey(_DictionaryProperties.kids) &&
        _dictionary.containsKey(_DictionaryProperties.tu)) {
      final _IPdfPrimitive? kids = _dictionary[_DictionaryProperties.kids];
      if (kids != null && kids is _PdfArray) {
        for (int i = 0; i < kids.count; i++) {
          final _IPdfPrimitive? kidsReferenceHolder = kids._elements[i];
          if (kidsReferenceHolder != null &&
              kidsReferenceHolder is _PdfReferenceHolder) {
            final _IPdfPrimitive? widgetAnnot = kidsReferenceHolder._object;
            if (widgetAnnot != null &&
                widgetAnnot is _PdfDictionary &&
                !widgetAnnot.containsKey(_DictionaryProperties.tu)) {
              final _IPdfPrimitive? toolTip =
                  _dictionary[_DictionaryProperties.tu];
              if (toolTip != null && toolTip is _PdfString) {
                widgetAnnot._setString(_DictionaryProperties.tu, toolTip.value);
              }
            }
          }
        }
      }
    }
  }

  void _save() {
    if (readOnly || (_form != null && _form!.readOnly)) {
      _flags.add(_FieldFlags.readOnly);
    }
    _setFlags(_flags);
    if (page != null &&
        page!.formFieldsTabOrder == PdfFormFieldsTabOrder.manual) {
      page!.annotations.remove(_widget!);
      page!.annotations._annotations
          ._insert(tabIndex, _PdfReferenceHolder(_widget));
      page!.annotations._list.insert(tabIndex, _widget!);
    }
    if (form != null &&
        !form!._needAppearances! &&
        _widget!._pdfAppearance == null) {
      _widget!.setAppearance = true;
      _drawAppearance(_widget!.appearance.normal);
    }
  }

  void _dictBeginSave(Object sender, _SavePdfPrimitiveArgs? ars) {
    _save();
  }

  void _beginSave() {
    if (_backBrush != null &&
        _backBrush is PdfSolidBrush &&
        (_backBrush! as PdfSolidBrush).color.isEmpty) {
      final _PdfDictionary widget =
          _getWidgetAnnotation(_dictionary, _crossTable);
      final _PdfDictionary mk = _PdfDictionary();
      final _PdfArray arr = _PdfArray(<int>[1, 1, 1]);
      mk.setProperty(_DictionaryProperties.bg, arr);
      widget.setProperty(_DictionaryProperties.mk, mk);
    }
  }

  int _getFieldFlagsValue(_FieldFlags value) {
    switch (value) {
      case _FieldFlags.readOnly:
        return 1;
      case _FieldFlags.requiredFieldFlag:
        return 1 << 1;
      case _FieldFlags.noExport:
        return 1 << 2;
      case _FieldFlags.multiline:
        return 1 << 12;
      case _FieldFlags.password:
        return 1 << 13;
      case _FieldFlags.fileSelect:
        return 1 << 20;
      case _FieldFlags.doNotSpellCheck:
        return 1 << 22;
      case _FieldFlags.doNotScroll:
        return 1 << 23;
      case _FieldFlags.comb:
        return 1 << 24;
      case _FieldFlags.richText:
        return 1 << 25;
      case _FieldFlags.noToggleToOff:
        return 1 << 14;
      case _FieldFlags.radio:
        return 1 << 15;
      case _FieldFlags.pushButton:
        return 1 << 16;
      case _FieldFlags.radiosInUnison:
        return 1 << 25;
      case _FieldFlags.combo:
        return 1 << 17;
      case _FieldFlags.edit:
        return 1 << 18;
      case _FieldFlags.sort:
        return 1 << 19;
      case _FieldFlags.multiSelect:
        return 1 << 21;
      case _FieldFlags.commitOnSelChange:
        return 1 << 26;
      default:
        return 0;
    }
  }

  void _setForm(PdfForm? form) {
    _form = form;
    _defineDefaultAppearance();
  }

  void _setFlags(List<_FieldFlags> value) {
    int flagValue = _isLoadedField ? _flagValue : 0;
    // ignore: avoid_function_literals_in_foreach_calls
    value.forEach(
        (_FieldFlags element) => flagValue |= _getFieldFlagsValue(element));
    _flagValues = flagValue;
    _dictionary._setNumber(_DictionaryProperties.fieldFlags, _flagValues);
  }

  void _removeFlag(_FieldFlags flag) {
    _flagValues = _flagValue & ~_getFieldFlagsValue(flag);
  }

  int _getFlagValue() {
    final _IPdfPrimitive? number = _getValue(
        _dictionary, _crossTable, _DictionaryProperties.fieldFlags, true);
    return number != null && number is _PdfNumber ? number.value!.toInt() : 0;
  }

  void _defineDefaultAppearance() {
    if (form != null && _internalFont != null) {
      if (_isLoadedField) {
        final _PdfDictionary widget =
            _getWidgetAnnotation(_dictionary, _crossTable);
        final _PdfName name = _form!._resources._getName(_font!);
        _form!._resources._add(_internalFont, name);
        _form!._needAppearances = true;
        final _PdfDefaultAppearance defaultAppearance = _PdfDefaultAppearance();
        defaultAppearance.fontName = name._name;
        defaultAppearance.fontSize = _internalFont!.size;
        defaultAppearance.foreColor = _foreColor;
        widget[_DictionaryProperties.da] =
            _PdfString(defaultAppearance._toString());
        if (this is PdfRadioButtonListField) {
          final PdfRadioButtonListField radioButtonListField =
              this as PdfRadioButtonListField;
          for (int i = 0; i < radioButtonListField.items.count; i++) {
            final PdfRadioButtonListItem item = radioButtonListField.items[i];
            if (item._font != null)
              form!._resources._add(radioButtonListField.items[i]._font,
                  _PdfName(item._widget!._defaultAppearance!.fontName));
          }
        }
      } else {
        final _PdfName name = form!._resources._getName(_internalFont!);
        _widget!.defaultAppearance.fontName = name._name;
        _widget!.defaultAppearance.fontSize = _internalFont!.size;
      }
    } else if (!_isLoadedField && _internalFont != null) {
      _widget!.defaultAppearance.fontName = _internalFont!.name;
      _widget!.defaultAppearance.fontSize = _internalFont!.size;
    }
  }

  void _applyName(String? name) {
    if (_isLoadedField) {
      _setName(name);
    } else {
      _name = name;
      _dictionary.setProperty(_DictionaryProperties.t, _PdfString(name!));
    }
  }

  //Creates the border pen.
  void _createBorderPen() {
    final double width = _widget!._widgetBorder!.width.toDouble();
    _borderPen = PdfPen(_widget!._widgetAppearance!.borderColor, width: width);
    if (_widget!._widgetBorder!.borderStyle == PdfBorderStyle.dashed ||
        _widget!._widgetBorder!.borderStyle == PdfBorderStyle.dot) {
      _borderPen!.dashStyle = PdfDashStyle.custom;
      _borderPen!.dashPattern = <double>[3 / width];
    }
  }

  //Creates the back brush.
  void _createBackBrush() {
    final PdfColor bc = _widget!._widgetAppearance!._backColor;
    _backBrush = PdfSolidBrush(bc);
    final PdfColor color = PdfColor(bc.r, bc.g, bc.b);
    color.r = (color.r - 64 >= 0 ? color.r - 64 : 0).toUnsigned(8);
    color.g = (color.g - 64 >= 0 ? color.g - 64 : 0).toUnsigned(8);
    color.b = (color.b - 64 >= 0 ? color.b - 64 : 0).toUnsigned(8);
    _shadowBrush = PdfSolidBrush(color);
  }

  void _drawAppearance(PdfTemplate template) {
    if (_font != null) {
      if ((_font is PdfStandardFont || _font is PdfCjkStandardFont) &&
          page != null &&
          _page!._document != null &&
          _page!._document!._conformanceLevel != PdfConformanceLevel.none) {
        throw ArgumentError(
            'All the fonts must be embedded in ${_page!._document!._conformanceLevel.toString()} document.');
      } else if (_font is PdfTrueTypeFont &&
          _page!._document != null &&
          _page!._document!._conformanceLevel == PdfConformanceLevel.a1b) {
        (_font! as PdfTrueTypeFont)._fontInternal._initializeCidSet();
      }
    }
  }

  //Gets the widget annotation.
  _PdfDictionary _getWidgetAnnotation(
      _PdfDictionary dictionary, _PdfCrossTable? crossTable) {
    _PdfDictionary? dic;
    if (dictionary.containsKey(_DictionaryProperties.kids)) {
      final _IPdfPrimitive? array =
          crossTable!._getObject(dictionary[_DictionaryProperties.kids]);
      if (array is _PdfArray && array.count > 0) {
        final _IPdfPrimitive reference =
            crossTable._getReference(array[_defaultIndex]);
        if (reference is _PdfReference) {
          dic = crossTable._getObject(reference) as _PdfDictionary?;
        }
      }
    }
    return dic ?? dictionary;
  }

  // Gets the value.
  static _IPdfPrimitive? _getValue(_PdfDictionary dictionary,
      _PdfCrossTable? crossTable, String value, bool inheritable) {
    _IPdfPrimitive? primitive;
    if (dictionary.containsKey(value)) {
      primitive = crossTable!._getObject(dictionary[value]);
    } else if (inheritable) {
      primitive = _searchInParents(dictionary, crossTable, value);
    }
    return primitive;
  }

  // Searches the in parents.
  static _IPdfPrimitive? _searchInParents(
      _PdfDictionary dictionary, _PdfCrossTable? crossTable, String value) {
    _IPdfPrimitive? primitive;
    _PdfDictionary? dic = dictionary;
    while (primitive == null && dic != null) {
      if (dic.containsKey(value)) {
        primitive = crossTable!._getObject(dic[value]);
      } else {
        dic = dic.containsKey(_DictionaryProperties.parent)
            ? (crossTable!._getObject(dic[_DictionaryProperties.parent])
                as _PdfDictionary?)!
            : null;
      }
    }
    return primitive;
  }

  String? _getFieldName() {
    String? name;
    _PdfString? str;
    if (!_dictionary.containsKey(_DictionaryProperties.parent)) {
      str = _getValue(_dictionary, _crossTable, _DictionaryProperties.t, false)
          as _PdfString?;
    } else {
      _IPdfPrimitive? dic =
          _crossTable!._getObject(_dictionary[_DictionaryProperties.parent]);
      while (dic != null &&
          dic is _PdfDictionary &&
          dic.containsKey(_DictionaryProperties.parent)) {
        if (dic.containsKey(_DictionaryProperties.t)) {
          name = name == null
              ? (_getValue(dic, _crossTable, _DictionaryProperties.t, false)!
                      as _PdfString)
                  .value
              : (_getValue(dic, _crossTable, _DictionaryProperties.t, false)!
                          as _PdfString)
                      .value! +
                  '.' +
                  name;
        }
        dic = _crossTable!._getObject(dic[_DictionaryProperties.parent])
            as _PdfDictionary?;
      }
      if (dic != null &&
          dic is _PdfDictionary &&
          dic.containsKey(_DictionaryProperties.t)) {
        name = name == null
            ? (_getValue(dic, _crossTable, _DictionaryProperties.t, false)!
                    as _PdfString)
                .value
            : (_getValue(dic, _crossTable, _DictionaryProperties.t, false)!
                        as _PdfString)
                    .value! +
                '.' +
                name;
        final _IPdfPrimitive? strName =
            _getValue(_dictionary, _crossTable, _DictionaryProperties.t, false);
        if (strName != null && strName is _PdfString) {
          name = name! + '.' + strName.value!;
        }
      } else if (_dictionary.containsKey(_DictionaryProperties.t)) {
        str =
            _getValue(_dictionary, _crossTable, _DictionaryProperties.t, false)
                as _PdfString?;
      }
    }
    if (str != null && str is _PdfString) {
      name = str.value;
    }
    return name;
  }

  PdfPage? _getLoadedPage() {
    PdfPage? page = _page;
    if (page == null || (page._isLoadedPage) && _crossTable != null) {
      final PdfDocument? doc = _crossTable!._document;
      final _PdfDictionary widget =
          _getWidgetAnnotation(_dictionary, _crossTable);
      if (widget.containsKey(_DictionaryProperties.p) &&
          _PdfCrossTable._dereference(widget[_DictionaryProperties.p])
              is! _PdfNull) {
        final _IPdfPrimitive? pageRef =
            _crossTable!._getObject(widget[_DictionaryProperties.p]);
        if (pageRef != null && pageRef is _PdfDictionary) {
          page = doc!.pages._getPage(pageRef);
        }
      } else {
        final _PdfReference widgetReference =
            _crossTable!._getReference(widget);
        for (int j = 0; j < doc!.pages.count; j++) {
          final PdfPage loadedPage = doc.pages[j];
          final _PdfArray? lAnnots = loadedPage._obtainAnnotations();
          if (lAnnots != null) {
            for (int i = 0; i < lAnnots.count; i++) {
              final _PdfReferenceHolder holder =
                  lAnnots[i]! as _PdfReferenceHolder;
              if (holder.reference!._objNum == widgetReference._objNum &&
                  holder.reference!._genNum == widgetReference._genNum) {
                page = loadedPage;
                return page;
              } else if (_requiredReference != null &&
                  _requiredReference!.reference!._objNum ==
                      holder.reference!._objNum &&
                  _requiredReference!.reference!._genNum ==
                      holder.reference!._genNum) {
                page = loadedPage;
                return page;
              }
            }
          }
        }
      }
    }
    if (page!._dictionary.containsKey(_DictionaryProperties.tabs)) {
      final _PdfName tabName =
          page._dictionary[_DictionaryProperties.tabs]! as _PdfName;
      if (tabName._name == '') {
        page._dictionary[_DictionaryProperties.tabs] = _PdfName(' ');
      }
    }
    return page;
  }

  void _draw() {
    _removeAnnotationFromPage();
  }

  void _removeAnnotationFromPage([PdfPage? page]) {
    page ??= this.page;
    if (page != null) {
      if (!page._isLoadedPage) {
        page.annotations.remove(_widget!);
      } else {
        final _PdfDictionary pageDic = page._dictionary;
        final _PdfArray annots = pageDic
                .containsKey(_DictionaryProperties.annots)
            ? page._crossTable!
                ._getObject(pageDic[_DictionaryProperties.annots])! as _PdfArray
            : _PdfArray();
        _widget!._dictionary
            .setProperty(_DictionaryProperties.p, _PdfReferenceHolder(page));
        for (int i = 0; i < annots.count; i++) {
          final _IPdfPrimitive? obj = annots[i];
          if (obj != null &&
              obj is _PdfReferenceHolder &&
              obj.object is _PdfDictionary &&
              obj.object == _widget!._dictionary) {
            annots._remove(obj);
            break;
          }
        }
        page._dictionary.setProperty(_DictionaryProperties.annots, annots);
      }
    }
  }

  Map<String, dynamic> _getFont(String fontString) {
    bool isCorrectFont = true;
    final Map<String, dynamic> fontNameDic = _fontName(fontString);
    final String? name = fontNameDic['name'] as String?;
    double height = fontNameDic['height'] as double;
    PdfFont font = PdfStandardFont(PdfFontFamily.helvetica, height);
    _IPdfPrimitive? fontDictionary =
        _crossTable!._getObject(form!._resources[_DictionaryProperties.font]);
    if (fontDictionary != null &&
        name != null &&
        fontDictionary is _PdfDictionary &&
        fontDictionary.containsKey(name)) {
      fontDictionary = _crossTable!._getObject(fontDictionary[name]);
      if (fontDictionary != null &&
          fontDictionary is _PdfDictionary &&
          fontDictionary.containsKey(_DictionaryProperties.subtype)) {
        final _PdfName fontSubtype = _crossTable!
                ._getObject(fontDictionary[_DictionaryProperties.subtype])!
            as _PdfName;
        if (fontSubtype._name == _DictionaryProperties.type1) {
          final _PdfName baseFont = _crossTable!
                  ._getObject(fontDictionary[_DictionaryProperties.baseFont])!
              as _PdfName;
          final List<PdfFontStyle> fontStyle = _getFontStyle(baseFont._name!);
          final dynamic fontFamilyDic = _getFontFamily(baseFont._name!);
          final PdfFontFamily? fontFamily =
              fontFamilyDic['fontFamily'] as PdfFontFamily?;
          final String? standardName = fontFamilyDic['standardName'] as String?;
          if (standardName == null) {
            font = PdfStandardFont(fontFamily!, height, multiStyle: fontStyle);
            if (!_isTextChanged) {
              font = _updateFontEncoding(font, fontDictionary);
            }
          } else {
            if (height == 0 && standardName != _getEnumName(fontFamily)) {
              _PdfDictionary? appearanceDictionary = _PdfDictionary();
              if (_dictionary.containsKey(_DictionaryProperties.ap)) {
                appearanceDictionary =
                    _dictionary[_DictionaryProperties.ap] as _PdfDictionary?;
              } else {
                if (_dictionary.containsKey(_DictionaryProperties.kids) &&
                    _dictionary[_DictionaryProperties.kids] is _PdfArray) {
                  final _PdfArray kidsArray =
                      _dictionary[_DictionaryProperties.kids]! as _PdfArray;
                  for (int i = 0; i < kidsArray.count; i++) {
                    if (kidsArray[i] is _PdfReferenceHolder) {
                      final _PdfReferenceHolder kids =
                          kidsArray[i]! as _PdfReferenceHolder;
                      final _IPdfPrimitive? dictionary = kids.object;
                      appearanceDictionary = dictionary != null &&
                              dictionary is _PdfDictionary &&
                              dictionary
                                  .containsKey(_DictionaryProperties.ap) &&
                              dictionary[_DictionaryProperties.ap]
                                  is _PdfDictionary
                          ? dictionary[_DictionaryProperties.ap]
                              as _PdfDictionary?
                          : null;
                      break;
                    }
                  }
                }
              }
              if (appearanceDictionary != null &&
                  appearanceDictionary is _PdfDictionary &&
                  appearanceDictionary.containsKey(_DictionaryProperties.n)) {
                final _IPdfPrimitive? dic = _PdfCrossTable._dereference(
                    appearanceDictionary[_DictionaryProperties.n]);
                if (dic != null && dic is _PdfStream) {
                  final _PdfStream stream = dic;
                  stream._decompress();
                  final dynamic fontNameDict =
                      _fontName(utf8.decode(stream._dataStream!.toList()));
                  height = fontNameDict['height'] as double;
                }
              }
            }
            if (height == 0 && standardName != _getEnumName(fontFamily)) {
              final PdfStandardFont stdf = font as PdfStandardFont;
              height = _getFontHeight(stdf.fontFamily);
              font = PdfStandardFont.prototype(stdf, height);
            }
            if (fontStyle != <PdfFontStyle>[PdfFontStyle.regular]) {
              font = PdfStandardFont(PdfFontFamily.helvetica, height,
                  multiStyle: fontStyle);
            }
            if (standardName != _getEnumName(fontFamily)) {
              font = _updateFontEncoding(font, fontDictionary);
            }
            font._metrics = _createFont(fontDictionary, height, baseFont);
            font._fontInternals = fontDictionary;
          }
        } else if (fontSubtype._name == 'TrueType') {
          final _PdfName baseFont = _crossTable!
                  ._getObject(fontDictionary[_DictionaryProperties.baseFont])!
              as _PdfName;
          final List<PdfFontStyle> fontStyle = _getFontStyle(baseFont._name!);
          font = PdfStandardFont.prototype(
              PdfStandardFont(PdfFontFamily.helvetica, 8), height,
              multiStyle: fontStyle);
          final _IPdfPrimitive? tempName =
              fontDictionary[_DictionaryProperties.name];
          if (tempName != null && tempName is _PdfName) {
            if (font.name != tempName._name) {
              font._metrics = _createFont(fontDictionary, height, baseFont);
            }
          }
        } else if (fontSubtype._name == _DictionaryProperties.type0) {
          final _IPdfPrimitive? baseFont = _crossTable!
              ._getObject(fontDictionary[_DictionaryProperties.baseFont]);
          if (baseFont != null &&
              baseFont is _PdfName &&
              _isCjkFont(baseFont._name)) {
            font = PdfCjkStandardFont(
                _getCjkFontFamily(baseFont._name)!, height,
                multiStyle: _getFontStyle(baseFont._name!));
          } else {
            _IPdfPrimitive? descendantFontsArray;
            _IPdfPrimitive? descendantFontsDic;
            _IPdfPrimitive? fontDescriptor;
            _IPdfPrimitive? fontDescriptorDic;
            _IPdfPrimitive? fontName;
            descendantFontsArray = _crossTable!._getObject(
                fontDictionary[_DictionaryProperties.descendantFonts]);
            if (descendantFontsArray != null &&
                descendantFontsArray is _PdfArray &&
                descendantFontsArray.count > 0) {
              descendantFontsDic = descendantFontsArray[0] is _PdfDictionary
                  ? descendantFontsArray[0]
                  : (descendantFontsArray[0]! as _PdfReferenceHolder).object;
            }
            if (descendantFontsDic != null &&
                descendantFontsDic is _PdfDictionary) {
              fontDescriptor =
                  descendantFontsDic[_DictionaryProperties.fontDescriptor];
            }
            if (fontDescriptor != null &&
                fontDescriptor is _PdfReferenceHolder) {
              fontDescriptorDic = fontDescriptor.object;
            }
            if (fontDescriptorDic != null &&
                fontDescriptorDic is _PdfDictionary)
              fontName = fontDescriptorDic[_DictionaryProperties.fontName];
            if (fontName != null && fontName is _PdfName) {
              String fontNameStr =
                  fontName._name!.substring(fontName._name!.indexOf('+') + 1);
              final _PdfFontMetrics fontMetrics = _createFont(
                  descendantFontsDic! as _PdfDictionary,
                  height,
                  _PdfName(fontNameStr));
              if (fontNameStr.contains('PSMT')) {
                fontNameStr = fontNameStr.replaceAll('PSMT', '');
              }
              if (fontNameStr.contains('PS')) {
                fontNameStr = fontNameStr.replaceAll('PS', '');
              }
              if (fontNameStr.contains('-')) {
                fontNameStr = fontNameStr.replaceAll('-', '');
              }
              if (font.name != fontNameStr) {
                final _WidthTable? widthTable = font._metrics!._widthTable;
                font._metrics = fontMetrics;
                font._metrics!._widthTable = widthTable;
              }
            }
          }
        }
      }
    } else {
      final PdfFont? usedFont = _getFontByName(name, height);
      usedFont != null ? font = usedFont : isCorrectFont = false;
    }
    if (height == 0) {
      if (font is PdfStandardFont) {
        height = _getFontHeight(font.fontFamily);
        if (height == 0) {
          height = 12;
        }
        font._setSize(height);
      }
    }
    return <String, dynamic>{
      'font': font,
      'isCorrectFont': isCorrectFont,
      'FontName': name
    };
  }

  bool _isCjkFont(String? fontName) {
    final List<String> fontString = <String>[
      'STSong-Light',
      'HeiseiMin-W3',
      'HeiseiKakuGo-W5',
      'HYSMyeongJo-Medium',
      'MSung-Light',
      'MHei-Medium',
      'HYGoThic-Medium'
    ];
    for (int i = 0; i < 7; i++) {
      if (fontName!.contains(fontString[i])) {
        return true;
      }
    }
    return false;
  }

  PdfCjkFontFamily? _getCjkFontFamily(String? fontName) {
    final List<String> fontString = <String>[
      'STSong-Light',
      'HeiseiMin-W3',
      'HeiseiKakuGo-W5',
      'HYSMyeongJo-Medium',
      'MSung-Light',
      'MHei-Medium',
      'HYGoThic-Medium'
    ];
    String? value;
    for (int i = 0; i < 7; i++) {
      if (fontName!.contains(fontString[i])) {
        value = fontString[i];
        break;
      }
    }
    switch (value) {
      case 'STSong-Light':
        return PdfCjkFontFamily.sinoTypeSongLight;
      case 'HeiseiMin-W3':
        return PdfCjkFontFamily.heiseiMinchoW3;
      case 'HeiseiKakuGo-W5':
        return PdfCjkFontFamily.heiseiKakuGothicW5;
      case 'HYSMyeongJo-Medium':
        return PdfCjkFontFamily.hanyangSystemsShinMyeongJoMedium;
      case 'MSung-Light':
        return PdfCjkFontFamily.monotypeSungLight;
      case 'MHei-Medium':
        return PdfCjkFontFamily.monotypeHeiMedium;
      case 'HYGoThic-Medium':
        return PdfCjkFontFamily.hanyangSystemsGothicMedium;
    }
    return null;
  }

  Map<String, dynamic> _fontName(String fontString) {
    if (fontString.contains('#2C')) {
      fontString = fontString.replaceAll('#2C', ',');
    }
    final _PdfReader reader = _PdfReader(utf8.encode(fontString));
    reader.position = 0;
    String? prevToken = reader._getNextToken();
    String? token = reader._getNextToken();
    String? name;
    double height = 0;
    while (token != null && token.isNotEmpty) {
      name = prevToken;
      prevToken = token;
      token = reader._getNextToken();
      if (token == _Operators.setFont) {
        try {
          height = double.parse(prevToken);
        } catch (e) {
          height = 0;
        }
        break;
      }
    }
    return <String, dynamic>{'name': name, 'height': height};
  }

  //Gets the font style
  List<PdfFontStyle> _getFontStyle(String fontFamilyString) {
    String standardName = fontFamilyString;
    int position = standardName.indexOf('-');
    if (position >= 0) {
      standardName = standardName.substring(position + 1, standardName.length);
    }
    position = standardName.indexOf(',');
    if (position >= 0) {
      standardName = standardName.substring(position + 1, standardName.length);
    }
    List<PdfFontStyle> style = <PdfFontStyle>[PdfFontStyle.regular];
    if (position >= 0) {
      switch (standardName) {
        case 'Italic':
        case 'Oblique':
        case 'ItalicMT':
        case 'It':
          style = <PdfFontStyle>[PdfFontStyle.italic];
          break;
        case 'Bold':
        case 'BoldMT':
          style = <PdfFontStyle>[PdfFontStyle.bold];
          break;
        case 'BoldItalic':
        case 'BoldOblique':
        case 'BoldItalicMT':
          style = <PdfFontStyle>[PdfFontStyle.italic, PdfFontStyle.bold];
          break;
      }
    }
    return style;
  }

  Map<String, dynamic> _getFontFamily(String fontFamilyString) {
    String? standardName;
    final int position = fontFamilyString.indexOf('-');
    PdfFontFamily fontFamily = PdfFontFamily.helvetica;
    standardName = fontFamilyString;
    if (position >= 0) {
      standardName = fontFamilyString.substring(0, position);
    }
    if (standardName == 'Times') {
      fontFamily = PdfFontFamily.timesRoman;
      standardName = null;
    }
    final List<String> fontFamilyList = <String>[
      'Helvetica',
      'Courier',
      'TimesRoman',
      'Symbol',
      'ZapfDingbats'
    ];
    if (standardName != null && fontFamilyList.contains(standardName)) {
      fontFamily = PdfFontFamily.values[fontFamilyList.indexOf(standardName)];
      standardName = null;
    }
    return <String, dynamic>{
      'fontFamily': fontFamily,
      'standardName': standardName
    };
  }

  PdfFont _updateFontEncoding(PdfFont font, _PdfDictionary fontDictionary) {
    final _PdfDictionary? fontInternalDictionary =
        font._fontInternals as _PdfDictionary?;
    if (fontDictionary._items!
        .containsKey(_PdfName(_DictionaryProperties.encoding))) {
      final _PdfName encodingName = _PdfName(_DictionaryProperties.encoding);
      final _IPdfPrimitive? encodingReferenceHolder =
          fontDictionary._items![_PdfName(_DictionaryProperties.encoding)];
      if (encodingReferenceHolder != null &&
          encodingReferenceHolder is _PdfReferenceHolder) {
        final _IPdfPrimitive? dictionary = encodingReferenceHolder.object;
        if (dictionary != null && dictionary is _PdfDictionary) {
          if (fontInternalDictionary!._items!
              .containsKey(_PdfName(_DictionaryProperties.encoding))) {
            fontInternalDictionary._items!
                .remove(_PdfName(_DictionaryProperties.encoding));
          }
          fontInternalDictionary._items![encodingName] = dictionary;
        }
      } else {
        final _IPdfPrimitive? encodingDictionary =
            fontDictionary._items![_PdfName(_DictionaryProperties.encoding)];
        if (encodingDictionary != null &&
            encodingDictionary is _PdfDictionary) {
          if (fontInternalDictionary!._items!
              .containsKey(_PdfName(_DictionaryProperties.encoding))) {
            fontInternalDictionary._items!
                .remove(_PdfName(_DictionaryProperties.encoding));
          }
          fontInternalDictionary._items![encodingName] = encodingDictionary;
        }
      }
    }
    return font;
  }

  String _getEnumName(dynamic annotText) {
    final int index = annotText.toString().indexOf('.');
    final String name = annotText.toString().substring(index + 1);
    return name[0].toUpperCase() + name.substring(1);
  }

  _PdfFontMetrics _createFont(
      _PdfDictionary fontDictionary, double? height, _PdfName baseFont) {
    final _PdfFontMetrics fontMetrics = _PdfFontMetrics();
    if (fontDictionary.containsKey(_DictionaryProperties.fontDescriptor)) {
      _IPdfPrimitive? createFontDictionary;
      final _IPdfPrimitive? fontReferenceHolder =
          fontDictionary[_DictionaryProperties.fontDescriptor];
      if (fontReferenceHolder != null &&
          fontReferenceHolder is _PdfReferenceHolder) {
        createFontDictionary = fontReferenceHolder.object;
      } else {
        createFontDictionary =
            fontDictionary[_DictionaryProperties.fontDescriptor];
      }
      if (createFontDictionary != null &&
          createFontDictionary is _PdfDictionary) {
        fontMetrics.ascent =
            (createFontDictionary[_DictionaryProperties.ascent]! as _PdfNumber)
                .value! as double;
        fontMetrics.descent =
            (createFontDictionary[_DictionaryProperties.descent]! as _PdfNumber)
                .value! as double;
        fontMetrics.size = height!;
        fontMetrics.height = fontMetrics.ascent - fontMetrics.descent;
        fontMetrics.postScriptName = baseFont._name;
      }
    }
    _PdfArray? array;
    if (fontDictionary.containsKey(_DictionaryProperties.widths)) {
      if (fontDictionary[_DictionaryProperties.widths] is _PdfReferenceHolder) {
        final _PdfReferenceHolder tableReference =
            _PdfReferenceHolder(fontDictionary[_DictionaryProperties.widths]);
        final _PdfReferenceHolder tableArray =
            tableReference.object! as _PdfReferenceHolder;
        array = tableArray.object as _PdfArray?;
        final List<int> widthTable = <int>[];
        for (int i = 0; i < array!.count; i++) {
          widthTable.add((array[i]! as _PdfNumber).value! as int);
        }
        fontMetrics._widthTable = _StandardWidthTable(widthTable);
      } else {
        array = fontDictionary[_DictionaryProperties.widths] as _PdfArray?;
        final List<int> widthTable = <int>[];
        for (int i = 0; i < array!.count; i++) {
          widthTable.add((array[i]! as _PdfNumber).value!.toInt());
        }
        fontMetrics._widthTable = _StandardWidthTable(widthTable);
      }
    }
    fontMetrics.name = baseFont._name!;
    return fontMetrics;
  }

  PdfFont? _getFontByName(String? name, double height) {
    PdfFont? font;
    switch (name) {
      case 'CoBO': //"Courier-BoldOblique"
        font = PdfStandardFont(PdfFontFamily.courier, height,
            multiStyle: <PdfFontStyle>[PdfFontStyle.bold, PdfFontStyle.italic]);
        break;
      case 'CoBo': //"Courier-Bold"
        font = PdfStandardFont(PdfFontFamily.courier, height,
            style: PdfFontStyle.bold);
        break;
      case 'CoOb': //"Courier-Oblique"
        font = PdfStandardFont(PdfFontFamily.courier, height,
            style: PdfFontStyle.italic);
        break;
      case 'Courier':
      case 'Cour': //"Courier"
        font = PdfStandardFont(PdfFontFamily.courier, height,
            style: PdfFontStyle.regular);
        break;
      case 'HeBO': //"Helvetica-BoldOblique"
        font = PdfStandardFont(PdfFontFamily.helvetica, height,
            multiStyle: <PdfFontStyle>[PdfFontStyle.bold, PdfFontStyle.italic]);
        break;
      case 'HeBo': //"Helvetica-Bold"
        font = PdfStandardFont(PdfFontFamily.helvetica, height,
            style: PdfFontStyle.bold);
        break;
      case 'HeOb': //"Helvetica-Oblique"
        font = PdfStandardFont(PdfFontFamily.helvetica, height,
            style: PdfFontStyle.italic);
        break;
      case 'Helv': //"Helvetica"
        font = PdfStandardFont(PdfFontFamily.helvetica, height,
            style: PdfFontStyle.regular);
        break;
      case 'Symb': // "Symbol"
        font = PdfStandardFont(PdfFontFamily.symbol, height);
        break;
      case 'TiBI': // "Times-BoldItalic"
        font = PdfStandardFont(PdfFontFamily.timesRoman, height,
            multiStyle: <PdfFontStyle>[PdfFontStyle.bold, PdfFontStyle.italic]);
        break;
      case 'TiBo': // "Times-Bold"
        font = PdfStandardFont(PdfFontFamily.timesRoman, height,
            style: PdfFontStyle.bold);
        break;
      case 'TiIt': // "Times-Italic"
        font = PdfStandardFont(PdfFontFamily.timesRoman, height,
            style: PdfFontStyle.italic);
        break;
      case 'TiRo': // "Times-Roman"
        font = PdfStandardFont(PdfFontFamily.timesRoman, height,
            style: PdfFontStyle.regular);
        break;
      case 'ZaDb': // "ZapfDingbats"
        font = PdfStandardFont(PdfFontFamily.zapfDingbats, height);
        break;
    }
    return font;
  }

  //Gets the font color.
  PdfColor _getForeColor(String? defaultAppearance) {
    PdfColor colour = PdfColor(0, 0, 0);
    if (defaultAppearance == null || defaultAppearance.isEmpty) {
      colour = PdfColor(0, 0, 0);
    } else {
      final _PdfReader reader = _PdfReader(utf8.encode(defaultAppearance));
      reader.position = 0;
      bool symbol = false;
      final List<String?> operands = <String?>[];
      String? token = reader._getNextToken();
      if (token == '/') {
        symbol = true;
      }
      while (token != null && token.isNotEmpty) {
        if (symbol == true) {
          token = reader._getNextToken();
        }
        symbol = true;
        if (token == 'g') {
          colour = PdfColor._fromGray(_parseFloatColour(operands.last!));
        } else if (token == 'rg') {
          colour = PdfColor(
              (_parseFloatColour(operands.elementAt(operands.length - 3)!) *
                      255)
                  .toInt()
                  .toUnsigned(8),
              (_parseFloatColour(operands.elementAt(operands.length - 2)!) *
                      255)
                  .toInt()
                  .toUnsigned(8),
              (_parseFloatColour(operands.last!) * 255).toInt().toUnsigned(8));
          operands.clear();
        } else if (token == 'k') {
          colour = PdfColor.fromCMYK(
              _parseFloatColour(operands.elementAt(operands.length - 4)!),
              _parseFloatColour(operands.elementAt(operands.length - 3)!),
              _parseFloatColour(operands.elementAt(operands.length - 2)!),
              _parseFloatColour(operands.last!));
          operands.clear();
        } else {
          operands.add(token);
        }
      }
    }
    return colour;
  }

  double _parseFloatColour(String text) {
    double number;
    try {
      number = double.parse(text);
    } catch (e) {
      number = 0;
    }
    return number;
  }

  PdfColor _getBackColor([bool isBrush = false]) {
    final _PdfDictionary widget =
        _getWidgetAnnotation(_dictionary, _crossTable);
    PdfColor c = isBrush ? PdfColor(255, 255, 255, 255) : PdfColor(0, 0, 0);
    if (widget.containsKey(_DictionaryProperties.mk)) {
      final _IPdfPrimitive? bs =
          _crossTable!._getObject(widget[_DictionaryProperties.mk]);
      if (bs is _PdfDictionary) {
        _IPdfPrimitive? array;
        if (bs.containsKey(_DictionaryProperties.bg)) {
          array = bs[_DictionaryProperties.bg];
        } else if (bs.containsKey(_DictionaryProperties.bs)) {
          array = bs[_DictionaryProperties.bs];
        }
        if (array != null && array is _PdfArray) {
          c = _createColor(array);
        }
      }
    }
    return c;
  }

  PdfColor _createColor(_PdfArray array) {
    final int dim = array.count;
    PdfColor color = PdfColor.empty;
    final List<double> colors = <double>[];
    for (int i = 0; i < array.count; ++i) {
      final _PdfNumber number =
          _crossTable!._getObject(array[i])! as _PdfNumber;
      colors.add(number.value!.toDouble());
    }
    switch (dim) {
      case 1:
        color = (colors[0] > 0.0) && (colors[0] <= 1.0)
            ? PdfColor._fromGray(colors[0])
            : PdfColor._fromGray(colors[0].toInt().toUnsigned(8).toDouble());
        break;
      case 3:
        color = ((colors[0] > 0.0) && (colors[0] <= 1.0)) ||
                ((colors[1] > 0.0) && (colors[1] <= 1.0)) ||
                ((colors[2] > 0.0) && (colors[2] <= 1.0))
            ? PdfColor(
                (colors[0] * 255).toInt().toUnsigned(8),
                (colors[1] * 255).toInt().toUnsigned(8),
                (colors[2] * 255).toInt().toUnsigned(8))
            : PdfColor(
                colors[0].toInt().toUnsigned(8),
                colors[1].toInt().toUnsigned(8),
                colors[2].toInt().toUnsigned(8));
        break;
      case 4:
        color = ((colors[0] > 0.0) && (colors[0] <= 1.0)) ||
                ((colors[1] > 0.0) && (colors[1] <= 1.0)) ||
                ((colors[2] > 0.0) && (colors[2] <= 1.0)) ||
                ((colors[3] > 0.0) && (colors[3] <= 1.0))
            ? PdfColor.fromCMYK(colors[0], colors[1], colors[2], colors[3])
            : PdfColor.fromCMYK(
                colors[0].toInt().toUnsigned(8).toDouble(),
                colors[1].toInt().toUnsigned(8).toDouble(),
                colors[2].toInt().toUnsigned(8).toDouble(),
                colors[3].toInt().toUnsigned(8).toDouble());
        break;
    }
    return color;
  }

  void _assignBackColor(PdfColor? value) {
    final _PdfDictionary widget =
        _getWidgetAnnotation(_dictionary, _crossTable);
    if (widget.containsKey(_DictionaryProperties.mk)) {
      final _PdfDictionary mk = _crossTable!
          ._getObject(widget[_DictionaryProperties.mk])! as _PdfDictionary;
      final _PdfArray array = value!._toArray();
      mk[_DictionaryProperties.bg] = array;
    } else {
      final _PdfDictionary mk = _PdfDictionary();
      final _PdfArray array = value!._toArray();
      mk[_DictionaryProperties.bg] = array;
      widget[_DictionaryProperties.mk] = mk;
    }
    form!._setAppearanceDictionary = true;
  }

  void _assignBorderColor(PdfColor borderColor) {
    if (_dictionary.containsKey(_DictionaryProperties.kids)) {
      final _IPdfPrimitive? kids =
          _crossTable!._getObject(_dictionary[_DictionaryProperties.kids]);
      if (kids != null && kids is _PdfArray) {
        for (int i = 0; i < kids.count; i++) {
          final _IPdfPrimitive? widget = _PdfCrossTable._dereference(kids[i]);
          if (widget != null && widget is _PdfDictionary) {
            if (widget.containsKey(_DictionaryProperties.mk)) {
              final _IPdfPrimitive? mk =
                  _crossTable!._getObject(widget[_DictionaryProperties.mk]);
              if (mk != null && mk is _PdfDictionary) {
                final _PdfArray array = borderColor._toArray();
                if (borderColor._alpha == 0) {
                  mk[_DictionaryProperties.bc] = _PdfArray(<int>[]);
                } else {
                  mk[_DictionaryProperties.bc] = array;
                }
              }
            } else {
              final _PdfDictionary mk = _PdfDictionary();
              final _PdfArray array = borderColor._toArray();
              if (borderColor._alpha == 0) {
                mk[_DictionaryProperties.bc] = _PdfArray(<int>[]);
              } else {
                mk[_DictionaryProperties.bc] = array;
              }
              widget[_DictionaryProperties.mk] = mk;
            }
          }
        }
      }
    } else {
      final _PdfDictionary widget =
          _getWidgetAnnotation(_dictionary, _crossTable);
      if (widget.containsKey(_DictionaryProperties.mk)) {
        final _IPdfPrimitive? mk =
            _crossTable!._getObject(widget[_DictionaryProperties.mk]);
        if (mk != null && mk is _PdfDictionary) {
          final _PdfArray array = borderColor._toArray();
          if (borderColor._alpha == 0) {
            mk[_DictionaryProperties.bc] = _PdfArray(<int>[]);
          } else {
            mk[_DictionaryProperties.bc] = array;
          }
        }
      } else {
        final _PdfDictionary mk = _PdfDictionary();
        final _PdfArray array = borderColor._toArray();
        if (borderColor._alpha == 0) {
          mk[_DictionaryProperties.bc] = _PdfArray(<int>[]);
        } else {
          mk[_DictionaryProperties.bc] = array;
        }
        widget[_DictionaryProperties.mk] = mk;
      }
    }
  }

  int _obtainBorderWidth() {
    final _PdfDictionary widget =
        _getWidgetAnnotation(_dictionary, _crossTable);
    int width = 0;
    final _IPdfPrimitive? name =
        _crossTable!._getObject(widget[_DictionaryProperties.ft]);
    if (widget.containsKey(_DictionaryProperties.bs)) {
      width = 1;
      final _PdfDictionary bs = _crossTable!
          ._getObject(widget[_DictionaryProperties.bs])! as _PdfDictionary;
      final _IPdfPrimitive? number =
          _crossTable!._getObject(bs[_DictionaryProperties.w]);
      if (number != null && number is _PdfNumber) {
        width = number.value!.toInt();
      }
    } else if (name != null && name is _PdfName && name._name == 'Btn') {
      width = 1;
    }
    return width;
  }

  void _assignBorderWidth(int width) {
    final _PdfDictionary widget =
        _getWidgetAnnotation(_dictionary, _crossTable);
    if (widget.containsKey(_DictionaryProperties.bs)) {
      if (widget[_DictionaryProperties.bs] is _PdfReferenceHolder) {
        final _PdfDictionary widgetDict = _crossTable!
            ._getObject(widget[_DictionaryProperties.bs])! as _PdfDictionary;
        if (widgetDict.containsKey(_DictionaryProperties.w)) {
          widgetDict[_DictionaryProperties.w] = _PdfNumber(width);
        } else {
          widgetDict.setProperty(_DictionaryProperties.w, _PdfNumber(width));
        }
      } else {
        (widget[_DictionaryProperties.bs]!
            as _PdfDictionary)[_DictionaryProperties.w] = _PdfNumber(width);
      }
      _createBorderPen();
    } else {
      if (!widget.containsKey(_DictionaryProperties.bs)) {
        widget.setProperty(
            _DictionaryProperties.bs, _widget!._widgetBorder!._dictionary);
        (widget[_DictionaryProperties.bs]! as _PdfDictionary)
            .setProperty(_DictionaryProperties.w, _PdfNumber(width));
        _createBorderPen();
      }
    }
  }

  PdfStringFormat _assignStringFormat() {
    final _PdfDictionary widget =
        _getWidgetAnnotation(_dictionary, _crossTable);
    final PdfStringFormat stringFormat = PdfStringFormat();
    stringFormat.lineAlignment = PdfVerticalAlignment.middle;
    stringFormat.lineAlignment =
        ((_flagValue & _getFieldFlagsValue(_FieldFlags.multiline)) > 0)
            ? PdfVerticalAlignment.top
            : PdfVerticalAlignment.middle;
    _IPdfPrimitive? number;
    if (widget.containsKey(_DictionaryProperties.q)) {
      number = _crossTable!._getObject(widget[_DictionaryProperties.q]);
    } else if (_dictionary.containsKey(_DictionaryProperties.q)) {
      number = _crossTable!._getObject(_dictionary[_DictionaryProperties.q]);
    }
    if (number != null && number is _PdfNumber) {
      stringFormat.alignment = PdfTextAlignment.values[number.value!.toInt()];
    }
    return stringFormat;
  }

  PdfBrush? _obtainShadowBrush() {
    PdfBrush? brush = PdfBrushes.white;
    final _PdfDictionary widget =
        _getWidgetAnnotation(_dictionary, _crossTable);
    if (widget.containsKey(_DictionaryProperties.da)) {
      PdfColor? color = PdfColor(255, 255, 255);
      if (_backBrush is PdfSolidBrush) {
        color = (_backBrush! as PdfSolidBrush).color;
      }
      color.r = (color.r - 64 >= 0 ? color.r - 64 : 0).toUnsigned(8);
      color.g = (color.g - 64 >= 0 ? color.g - 64 : 0).toUnsigned(8);
      color.b = (color.b - 64 >= 0 ? color.b - 64 : 0).toUnsigned(8);
      brush = PdfSolidBrush(color);
    }
    return brush;
  }

  PdfBorderStyle _obtainBorderStyle() {
    final _PdfDictionary widget =
        _getWidgetAnnotation(_dictionary, _crossTable);
    PdfBorderStyle style = PdfBorderStyle.solid;
    if (widget.containsKey(_DictionaryProperties.bs)) {
      final _PdfDictionary bs = _crossTable!
          ._getObject(widget[_DictionaryProperties.bs])! as _PdfDictionary;
      style = _createBorderStyle(bs);
    }
    return style;
  }

  PdfBorderStyle _createBorderStyle(_PdfDictionary bs) {
    PdfBorderStyle style = PdfBorderStyle.solid;
    if (bs.containsKey(_DictionaryProperties.s)) {
      final _IPdfPrimitive? name =
          _crossTable!._getObject(bs[_DictionaryProperties.s]);
      if (name != null && name is _PdfName) {
        switch (name._name!.toLowerCase()) {
          case 'd':
            style = PdfBorderStyle.dashed;
            break;
          case 'b':
            style = PdfBorderStyle.beveled;
            break;
          case 'i':
            style = PdfBorderStyle.inset;
            break;
          case 'u':
            style = PdfBorderStyle.underline;
            break;
        }
      }
    }
    return style;
  }

  void _assignBorderStyle(PdfBorderStyle? borderStyle) {
    String style = '';
    final _PdfDictionary widget =
        _getWidgetAnnotation(_dictionary, _crossTable);
    if (widget.containsKey(_DictionaryProperties.bs)) {
      switch (borderStyle) {
        case PdfBorderStyle.dashed:
        case PdfBorderStyle.dot:
          style = 'D';
          break;
        case PdfBorderStyle.beveled:
          style = 'B';
          break;
        case PdfBorderStyle.inset:
          style = 'I';
          break;
        case PdfBorderStyle.underline:
          style = 'U';
          break;
        default:
          style = 'S';
          break;
      }
      if (widget[_DictionaryProperties.bs] is _PdfReferenceHolder) {
        final _PdfDictionary widgetDict = _crossTable!
            ._getObject(widget[_DictionaryProperties.bs])! as _PdfDictionary;
        if (widgetDict.containsKey(_DictionaryProperties.s)) {
          widgetDict[_DictionaryProperties.s] = _PdfName(style);
        } else {
          widgetDict.setProperty(_DictionaryProperties.s, _PdfName(style));
        }
      } else {
        final _PdfDictionary bsDict =
            widget[_DictionaryProperties.bs]! as _PdfDictionary;
        if (bsDict.containsKey(_DictionaryProperties.s)) {
          bsDict[_DictionaryProperties.s] = _PdfName(style);
        } else {
          bsDict.setProperty(_DictionaryProperties.s, _PdfName(style));
        }
      }
      _widget!._widgetBorder!.borderStyle = borderStyle!;
    } else {
      if (!widget.containsKey(_DictionaryProperties.bs)) {
        _widget!._widgetBorder!.borderStyle = borderStyle!;
        widget.setProperty(
            _DictionaryProperties.bs, _widget!._widgetBorder!._dictionary);
      }
    }
    if (widget.containsKey(_DictionaryProperties.mk) &&
        widget[_DictionaryProperties.mk] is _PdfDictionary) {
      final _PdfDictionary mkDict =
          widget[_DictionaryProperties.mk]! as _PdfDictionary;
      if (!mkDict.containsKey(_DictionaryProperties.bc) &&
          !mkDict.containsKey(_DictionaryProperties.bg)) {
        _widget!._widgetAppearance!._dictionary._items!
            .forEach((_PdfName? key, _IPdfPrimitive? value) {
          mkDict.setProperty(key, value);
        });
      }
    } else {
      widget.setProperty(_DictionaryProperties.mk, _widget!._widgetAppearance);
    }
  }

  PdfHighlightMode _obtainHighlightMode() {
    final _PdfDictionary widget =
        _getWidgetAnnotation(_dictionary, _crossTable);
    PdfHighlightMode mode = PdfHighlightMode.noHighlighting;
    if (widget.containsKey(_DictionaryProperties.h)) {
      final _PdfName name = widget[_DictionaryProperties.h]! as _PdfName;
      switch (name._name) {
        case 'I':
          mode = PdfHighlightMode.invert;
          break;
        case 'N':
          mode = PdfHighlightMode.noHighlighting;
          break;
        case 'O':
          mode = PdfHighlightMode.outline;
          break;
        case 'P':
          mode = PdfHighlightMode.push;
          break;
      }
    }
    return mode;
  }

  void _assignHighlightMode(PdfHighlightMode? highlightMode) {
    final _PdfDictionary widget =
        _getWidgetAnnotation(_dictionary, _crossTable);
    widget._setName(_PdfName(_DictionaryProperties.h),
        _widget!._highlightModeToString(highlightMode));
    _changed = true;
  }

  Rect _getBounds() {
    _IPdfPrimitive? array;
    if (_dictionary.containsKey(_DictionaryProperties.kids)) {
      final _PdfDictionary widget =
          _getWidgetAnnotation(_dictionary, _crossTable);
      if (widget.containsKey(_DictionaryProperties.rect)) {
        array = _crossTable!._getObject(widget[_DictionaryProperties.rect]);
      }
    } else {
      if (_dictionary.containsKey(_DictionaryProperties.parent)) {
        final _IPdfPrimitive? parentDictionary =
            (_dictionary[_DictionaryProperties.parent]! as _PdfReferenceHolder)
                .object;
        if (parentDictionary != null &&
            parentDictionary is _PdfDictionary &&
            parentDictionary.containsKey(_DictionaryProperties.kids)) {
          if (parentDictionary.containsKey(_DictionaryProperties.ft) &&
              (parentDictionary[_DictionaryProperties.ft]! as _PdfName)._name ==
                  _DictionaryProperties.btn) {
            final _PdfDictionary widget =
                _getWidgetAnnotation(parentDictionary, _crossTable);
            if (widget.containsKey(_DictionaryProperties.rect)) {
              array =
                  _crossTable!._getObject(widget[_DictionaryProperties.rect]);
            }
          }
        }
      }
      if (array == null &&
          _dictionary.containsKey(_DictionaryProperties.rect)) {
        array =
            _crossTable!._getObject(_dictionary[_DictionaryProperties.rect]);
      }
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

  PdfPen? _obtainBorderPen() {
    final _PdfDictionary widget =
        _getWidgetAnnotation(_dictionary, _crossTable);
    PdfPen? pen;
    if (widget.containsKey(_DictionaryProperties.mk)) {
      final _IPdfPrimitive? mk =
          _crossTable!._getObject(widget[_DictionaryProperties.mk]);
      if (mk is _PdfDictionary && mk.containsKey(_DictionaryProperties.bc)) {
        final _PdfArray array =
            _crossTable!._getObject(mk[_DictionaryProperties.bc])! as _PdfArray;
        pen = PdfPen(_createColor(array));
      }
    }
    if (pen != null) {
      pen.width = _borderWidth.toDouble();
      if (_borderStyle == PdfBorderStyle.dashed) {
        final List<double>? dashPatern = _obtainDashPatern();
        pen.dashStyle = PdfDashStyle.custom;
        if (dashPatern != null) {
          pen.dashPattern = dashPatern;
        } else if (_borderWidth > 0) {
          pen.dashPattern = <double>[3 / _borderWidth];
        }
      }
    }
    return (pen == null) ? _bPen : pen;
  }

  List<double>? _obtainDashPatern() {
    List<double>? array;
    if (_borderStyle == PdfBorderStyle.dashed) {
      final _PdfDictionary widget =
          _getWidgetAnnotation(_dictionary, _crossTable);
      if (widget.containsKey(_DictionaryProperties.d)) {
        final _IPdfPrimitive? dashes =
            _crossTable!._getObject(widget[_DictionaryProperties.d]);
        if (dashes != null && dashes is _PdfArray) {
          if (dashes.count == 2) {
            array = <double>[0, 0];
            _IPdfPrimitive? number = dashes[0];
            if (number != null && number is _PdfNumber) {
              array[0] = number.value!.toDouble();
            }
            number = dashes[1];
            if (number != null && number is _PdfNumber) {
              array[1] = number.value!.toDouble();
            }
          } else {
            array = <double>[0];
            final _IPdfPrimitive? number = dashes[0];
            if (number != null && number is _PdfNumber) {
              array[0] = number.value!.toDouble();
            }
          }
        }
      }
    }
    return array;
  }

  void _setFittingFontSize(
      _GraphicsProperties gp, _PaintParams prms, String text) {
    double fontSize = 0;
    final double width = prms._style == PdfBorderStyle.beveled ||
            prms._style == PdfBorderStyle.inset
        ? gp._bounds!.width - 8 * prms._borderWidth!
        : gp._bounds!.width - 4 * prms._borderWidth!;
    final double height = gp._bounds!.height - 2 * gp._borderWidth!;
    const double minimumFontSize = 0.248;
    if (text.endsWith(' ')) {
      gp._stringFormat!.measureTrailingSpaces = true;
    }
    for (double i = 0; i <= gp._bounds!.height; i++) {
      gp._font!._setSize(i);
      Size textSize = gp._font!.measureString(text, format: gp._stringFormat);
      if (textSize.width > gp._bounds!.width || textSize.height > height) {
        fontSize = i;
        do {
          fontSize = fontSize - 0.001;
          gp._font!._setSize(fontSize);
          final double textWidth =
              gp._font!._getLineWidth(text, gp._stringFormat);
          if (fontSize < minimumFontSize) {
            gp._font!._setSize(minimumFontSize);
            break;
          }
          textSize = gp._font!.measureString(text, format: gp._stringFormat);
          if (textWidth < width && textSize.height < height) {
            gp._font!._setSize(fontSize);
            break;
          }
        } while (fontSize > minimumFontSize);
        break;
      }
    }
  }

  double _getFontHeight(PdfFontFamily family) {
    return 0;
  }

  void _addAnnotationToPage(PdfPage? page, PdfAnnotation? widget) {
    if (page != null && !page._isLoadedPage) {
      widget!._dictionary
          .setProperty(_DictionaryProperties.t, _PdfString(_name!));
    } else {
      final _PdfDictionary pageDic = page!._dictionary;
      _PdfArray? annots;
      if (pageDic.containsKey(_DictionaryProperties.annots)) {
        final _IPdfPrimitive? obj =
            page._crossTable!._getObject(pageDic[_DictionaryProperties.annots]);
        if (obj != null && obj is _PdfArray) {
          annots = obj;
        }
      }
      annots ??= _PdfArray();
      widget!._dictionary
          .setProperty(_DictionaryProperties.p, _PdfReferenceHolder(page));
      form!.fieldAutoNaming
          ? widget._dictionary
              .setProperty(_DictionaryProperties.t, _PdfString(_name!))
          : _dictionary.setProperty(
              _DictionaryProperties.t, _PdfString(_name!));
      annots._add(_PdfReferenceHolder(widget));
      page._dictionary.setProperty(_DictionaryProperties.annots, annots);
    }
  }

  void _beginMarkupSequence(_PdfStream stream) {
    stream._write('/');
    stream._write('Tx');
    stream._write(' ');
    stream._write('BMC');
    stream._write('\r\n');
  }

  void _endMarkupSequence(_PdfStream stream) {
    stream._write('EMC');
    stream._write('\r\n');
  }

  void _drawStateItem(
      PdfGraphics graphics, _PdfCheckFieldState state, PdfCheckFieldBase? item,
      [PdfFieldItem? fieldItem]) {
    final _GraphicsProperties gp = item != null
        ? _GraphicsProperties(item)
        : _GraphicsProperties.fromFieldItem(fieldItem!);
    if (!_flattenField) {
      gp._bounds = Rect.fromLTWH(0, 0, gp._bounds!.width, gp._bounds!.height);
    }
    if (gp._borderPen != null && gp._borderWidth == 0) {
      gp._borderWidth = 1;
    }
    graphics.save();
    final _PaintParams prms = _PaintParams(
        bounds: gp._bounds,
        backBrush: gp._backBrush,
        foreBrush: gp._foreBrush,
        borderPen: gp._borderPen,
        style: gp._style,
        borderWidth: gp._borderWidth,
        shadowBrush: gp._shadowBrush);
    if (_fieldChanged == true) {
      _drawFields(graphics, gp, prms, state);
    } else {
      graphics._streamWriter!._setTextRenderingMode(0);
      final PdfTemplate? stateTemplate = _getStateTemplate(
          state, item != null ? item._dictionary : fieldItem!._dictionary);
      if (stateTemplate != null) {
        final Rect bounds = item == null && fieldItem == null
            ? this.bounds
            : item != null
                ? item.bounds
                : fieldItem!.bounds;
        bool encryptedContent = false;
        if (_crossTable != null &&
            _crossTable!._document != null &&
            _crossTable!._document!._isLoadedDocument) {
          final PdfDocument? loadedDocument = _crossTable!._document;
          if (loadedDocument != null && loadedDocument._isEncrypted) {
            if (loadedDocument.security._encryptor._encrypt! &&
                loadedDocument.security.encryptionOptions ==
                    PdfEncryptionOptions.encryptAllContents)
              encryptedContent = true;
          }
        }
        final _PdfStream pdfStream = stateTemplate._content;
        if (encryptedContent &&
            pdfStream.encrypt! &&
            !pdfStream.decrypted! &&
            this is PdfCheckBoxField) {
          gp._font = null;
          _FieldPainter()._drawCheckBox(
              graphics,
              prms,
              (this as PdfCheckBoxField)
                  ._styleToString((this as PdfCheckBoxField).style),
              state,
              gp._font);
        } else {
          graphics.drawPdfTemplate(stateTemplate, bounds.topLeft, bounds.size);
        }
      } else {
        _drawFields(graphics, gp, prms, state);
      }
    }
    graphics.restore();
  }

  void _drawFields(PdfGraphics graphics, _GraphicsProperties gp,
      _PaintParams params, _PdfCheckFieldState state) {
    if (gp._font!.size >= 0) {
      gp._font = null;
    }
    if (this is PdfCheckBoxField) {
      _FieldPainter()._drawCheckBox(
          graphics,
          params,
          (this as PdfCheckBoxField)
              ._styleToString((this as PdfCheckBoxField).style),
          state,
          gp._font);
    } else if (this is PdfRadioButtonListItem) {
      _FieldPainter().drawRadioButton(
          graphics,
          params,
          (this as PdfRadioButtonListItem)
              ._styleToString((this as PdfRadioButtonListItem).style),
          state);
    }
  }

  PdfTemplate? _getStateTemplate(
      _PdfCheckFieldState state, _PdfDictionary? itemDictionary) {
    final _PdfDictionary dic = itemDictionary ?? _dictionary;
    final String? value = state == _PdfCheckFieldState.checked
        ? _getItemValue(dic, _crossTable)
        : _DictionaryProperties.off;
    PdfTemplate? template;
    if (dic.containsKey(_DictionaryProperties.ap)) {
      final _IPdfPrimitive? appearance =
          _PdfCrossTable._dereference(dic[_DictionaryProperties.ap]);
      if (appearance != null && appearance is _PdfDictionary) {
        final _IPdfPrimitive? norm =
            _PdfCrossTable._dereference(appearance[_DictionaryProperties.n]);
        if (value != null &&
            value.isNotEmpty &&
            norm != null &&
            norm is _PdfDictionary) {
          final _IPdfPrimitive? xObject =
              _PdfCrossTable._dereference(norm[value]);
          if (xObject != null && xObject is _PdfStream) {
            template = PdfTemplate._fromPdfStream(xObject);
            if (value == _DictionaryProperties.off &&
                xObject.encrypt! &&
                xObject.decrypted!) {
              //AP stream undecrypted might cause document corruption
              template = null;
            }
          }
        }
      }
    }
    return template;
  }

  _PdfArray? _obtainKids() {
    _IPdfPrimitive? kids;
    if (_dictionary.containsKey(_DictionaryProperties.kids)) {
      kids = _crossTable!._getObject(_dictionary[_DictionaryProperties.kids]);
    }
    return kids != null && kids is _PdfArray ? kids : null;
  }

  String? _getItemValue(_PdfDictionary dictionary, _PdfCrossTable? crossTable) {
    String? value = '';
    _PdfName? name;
    if (dictionary.containsKey(_DictionaryProperties.usageApplication)) {
      name = crossTable!
              ._getObject(dictionary[_DictionaryProperties.usageApplication])
          as _PdfName?;
      if (name != null && name._name != _DictionaryProperties.off) {
        value = name._name;
      }
    }
    if (value!.isEmpty) {
      if (dictionary.containsKey(_DictionaryProperties.ap)) {
        final _PdfDictionary dic =
            crossTable!._getObject(dictionary[_DictionaryProperties.ap])!
                as _PdfDictionary;
        if (dic.containsKey(_DictionaryProperties.n)) {
          final _PdfReference reference =
              crossTable._getReference(dic[_DictionaryProperties.n]);
          final _PdfDictionary normalAppearance =
              crossTable._getObject(reference)! as _PdfDictionary;
          final List<Object?> list = <Object?>[];
          normalAppearance._items!
              .forEach((_PdfName? key, _IPdfPrimitive? value) {
            list.add(key);
          });
          for (int i = 0; i < list.length; ++i) {
            name = list[i] as _PdfName?;
            if (name!._name != _DictionaryProperties.off) {
              value = name._name;
              break;
            }
          }
        }
      }
    }
    return value;
  }

  void _importFieldValue(Object fieldValue) {
    final _IPdfPrimitive? primitive =
        _getValue(_dictionary, _crossTable, _DictionaryProperties.ft, true);
    String? value;
    if (fieldValue is String) {
      value = fieldValue.toString();
    }
    List<String>? valueArray;
    if (value == null) {
      valueArray = fieldValue as List<String>;
      if (valueArray is List<String> && valueArray.isNotEmpty) {
        value = fieldValue[0];
      }
    }
    if (value != null && primitive != null && primitive is _PdfName) {
      switch (primitive._name) {
        case 'Tx':
          (this as PdfTextBoxField).text = value;
          break;
        case 'Ch':
          if (this is PdfListBoxField) {
            (this as PdfListBoxField).selectedValues =
                valueArray ?? <String>[value];
          } else if (this is PdfComboBoxField) {
            (this as PdfComboBoxField).selectedValue = value;
          }
          break;
        case 'Btn':
          if (this is PdfCheckBoxField) {
            final PdfCheckBoxField field1 = this as PdfCheckBoxField;
            if (value.toUpperCase() == 'OFF' || value.toUpperCase() == 'NO') {
              field1.isChecked = false;
            } else if (_containsExportValue(value, field1._dictionary)) {
              field1.isChecked = true;
            } else
              field1.isChecked = false;
          } else if (this is PdfRadioButtonListField) {
            (this as PdfRadioButtonListField).selectedValue = value;
          }
          break;
      }
    }
  }

  Map<String, dynamic> _exportField(List<int> bytes, int objectID) {
    bool flag = false;
    _IPdfPrimitive? kids;
    if (_dictionary.containsKey(_DictionaryProperties.kids)) {
      kids = _crossTable!._getObject(_dictionary[_DictionaryProperties.kids]);
      if (kids != null && kids is _PdfArray) {
        for (int i = 0; i < kids.count; i++) {
          flag = flag ||
              (kids[i] is PdfField && (kids[i]! as PdfField)._isLoadedField);
        }
      }
    }
    final _IPdfPrimitive? name =
        _getValue(_dictionary, _crossTable, _DictionaryProperties.ft, true);
    String? strValue = '';
    if (name != null && name is _PdfName) {
      switch (name._name) {
        case 'Tx':
          final _IPdfPrimitive? tempName = _getValue(
              _dictionary, _crossTable, _DictionaryProperties.v, true);
          if (tempName != null && tempName is _PdfString) {
            strValue = tempName.value;
          }
          break;
        case 'Ch':
          final _IPdfPrimitive? checkBoxPrimitive = _getValue(
              _dictionary, _crossTable, _DictionaryProperties.v, true);
          if (checkBoxPrimitive != null) {
            final String? value = _getExportValue(this, checkBoxPrimitive);
            if (value != null && value.isNotEmpty) {
              strValue = value;
            }
          }
          break;
        case 'Btn':
          final _IPdfPrimitive? buttonFieldPrimitive = _getValue(
              _dictionary, _crossTable, _DictionaryProperties.v, true);
          if (buttonFieldPrimitive != null) {
            final String? value = _getExportValue(this, buttonFieldPrimitive);
            if (value != null && value.isNotEmpty) {
              strValue = value;
            } else if (this is PdfRadioButtonListField ||
                this is PdfCheckBoxField) {
              if (!_exportEmptyField) {
                strValue = _DictionaryProperties.off;
              }
            }
          } else {
            if (this is PdfRadioButtonListField) {
              strValue = _getAppearanceStateValue(this);
            } else {
              final _PdfDictionary holder =
                  _getWidgetAnnotation(_dictionary, _crossTable);
              final _IPdfPrimitive? holderName =
                  holder[_DictionaryProperties.usageApplication];
              if (holderName != null && holderName is _PdfName) {
                strValue = holderName._name;
              }
            }
          }
          break;
      }
      if ((strValue != null && strValue.isNotEmpty) ||
          _exportEmptyField ||
          flag) {
        if (flag && kids != null && kids is _PdfArray) {
          for (int i = 0; i < kids.count; i++) {
            final _IPdfPrimitive? field = kids[i];
            if (field != null &&
                field is PdfField &&
                (field as PdfField)._isLoadedField &&
                (field as PdfField).canExport) {
              final Map<String, dynamic> out =
                  (field as PdfField)._exportField(bytes, objectID);
              bytes = out['bytes'] as List<int>;
              objectID = out['objectID'] as int;
            }
          }
          _objectID = objectID;
          objectID++;
          final _PdfString stringValue = _PdfString(strValue!)
            ..encode = _ForceEncoding.ascii;
          final StringBuffer buffer = StringBuffer();
          buffer.write(
              '$_objectID 0 obj<</T <${_PdfString._bytesToHex(stringValue.value!.codeUnits)}> /Kids [');
          if (kids is _PdfArray) {
            for (int i = 0; i < kids.count; i++) {
              final PdfField field = kids[i]! as PdfField;
              if (field._isLoadedField &&
                  field.canExport &&
                  field._objectID != 0) {
                buffer.write('${field._objectID} 0 R ');
              }
            }
          }
          buffer.write(']>>endobj\n');
          final _PdfString builderString = _PdfString(buffer.toString())
            ..encode = _ForceEncoding.ascii;
          bytes.addAll(builderString.value!.codeUnits);
        } else {
          _objectID = objectID;
          objectID++;
          if (this is PdfCheckBoxField || this is PdfRadioButtonListField) {
            strValue = '/' + strValue!;
          } else {
            final _PdfString stringFieldValue = _PdfString(strValue!)
              ..encode = _ForceEncoding.ascii;
            strValue = '<' +
                _PdfString._bytesToHex(stringFieldValue.value!.codeUnits) +
                '>';
          }
          final _PdfString stringFieldName = _PdfString(this.name!)
            ..encode = _ForceEncoding.ascii;
          final _PdfString buildString = _PdfString(
              '$_objectID 0 obj<</T <${_PdfString._bytesToHex(stringFieldName.value!.codeUnits)}> /V $strValue >>endobj\n')
            ..encode = _ForceEncoding.ascii;
          bytes.addAll(buildString.value!.codeUnits);
        }
      }
    }
    return <String, dynamic>{'bytes': bytes, 'objectID': objectID};
  }

  bool _containsExportValue(String value, _PdfDictionary dictionary) {
    bool result = false;
    final _PdfDictionary widgetDictionary =
        _getWidgetAnnotation(dictionary, _crossTable);
    if (widgetDictionary.containsKey(_DictionaryProperties.ap)) {
      final _IPdfPrimitive? appearance =
          _crossTable!._getObject(widgetDictionary[_DictionaryProperties.ap]);
      if (appearance != null &&
          appearance is _PdfDictionary &&
          appearance.containsKey(_DictionaryProperties.n)) {
        final _IPdfPrimitive? normalTemplate =
            _PdfCrossTable._dereference(appearance[_DictionaryProperties.n]);
        if (normalTemplate != null &&
            normalTemplate is _PdfDictionary &&
            normalTemplate.containsKey(value)) {
          result = true;
        }
      }
    }
    return result;
  }

  String? _getExportValue(PdfField field, _IPdfPrimitive buttonFieldPrimitive) {
    String? value;
    if (buttonFieldPrimitive is _PdfName) {
      value = buttonFieldPrimitive._name;
    } else if (buttonFieldPrimitive is _PdfString) {
      value = buttonFieldPrimitive.value;
    } else if (buttonFieldPrimitive is _PdfArray &&
        buttonFieldPrimitive.count > 0) {
      for (int i = 0; i < buttonFieldPrimitive.count; i++) {
        final _IPdfPrimitive? primitive = buttonFieldPrimitive[i];
        if (primitive is _PdfName) {
          value = primitive._name;
          break;
        } else if (primitive is _PdfString) {
          value = primitive.value;
          break;
        }
      }
    }
    if (value != null) {
      if (field is PdfRadioButtonListField) {
        final PdfRadioButtonListItem? item = field.selectedItem;
        if (item != null &&
            (item.value == value || item._optionValue == value)) {
          if (item._optionValue != null && item._optionValue!.isNotEmpty) {
            value = item._optionValue;
          }
        }
      }
    }
    return value;
  }

  String _getAppearanceStateValue(PdfField field) {
    final List<_PdfDictionary> holders =
        field._getWidgetAnnotations(field._dictionary, field._crossTable!);
    String? value;
    for (int i = 0; i < holders.length; i++) {
      final _IPdfPrimitive? pdfName =
          holders[i][_DictionaryProperties.usageApplication];
      if (pdfName != null &&
          pdfName is _PdfName &&
          pdfName._name != _DictionaryProperties.off) {
        value = pdfName._name;
      }
    }
    if (value == null && _exportEmptyField) {
      value = '';
    }
    return value ?? _DictionaryProperties.off;
  }

  List<_PdfDictionary> _getWidgetAnnotations(
      _PdfDictionary dictionary, _PdfCrossTable crossTable) {
    final List<_PdfDictionary> widgetAnnotationCollection = <_PdfDictionary>[];
    if (dictionary.containsKey(_DictionaryProperties.kids)) {
      final _IPdfPrimitive? array =
          crossTable._getObject(dictionary[_DictionaryProperties.kids]);
      if (array != null && array is _PdfArray && array.count > 0) {
        for (int i = 0; i < array.count; i++) {
          final _IPdfPrimitive item = array[i]!;
          final _PdfReference reference = crossTable._getReference(item);
          final _IPdfPrimitive? widgetDic = crossTable._getObject(reference);
          if (widgetDic != null && widgetDic is _PdfDictionary) {
            widgetAnnotationCollection.add(widgetDic);
          }
        }
      }
    } else if (dictionary.containsKey(_DictionaryProperties.subtype)) {
      final _IPdfPrimitive? type =
          _crossTable!._getObject(dictionary[_DictionaryProperties.subtype]);
      if (type != null &&
          type is _PdfName &&
          type._name == _DictionaryProperties.widget) {
        widgetAnnotationCollection.add(dictionary);
      }
    }
    if (widgetAnnotationCollection.isEmpty) {
      widgetAnnotationCollection.add(dictionary);
    }
    return widgetAnnotationCollection;
  }

  XmlElement? _exportFieldForXml() {
    final _IPdfPrimitive? name =
        _getValue(_dictionary, _crossTable, _DictionaryProperties.ft, true);
    String fieldName = this.name!.replaceAll(' ', '_x0020_');
    fieldName = fieldName
        .replaceAll(r'\', '_x005C_')
        .replaceAll(']', '_x005D_')
        .replaceAll('[', '_x005B_')
        .replaceAll(',', '_x002C_')
        .replaceAll('"', '_x0022_')
        .replaceAll(':', '_x003A_')
        .replaceAll('{', '_x007B_')
        .replaceAll('}', '_x007D_')
        .replaceAll('#', '_x0023_')
        .replaceAll(r'$', '_x0024_');
    XmlElement? element;
    if (name != null && name is _PdfName) {
      switch (name._name) {
        case 'Tx':
          final _IPdfPrimitive? str = _getValue(
              _dictionary, _crossTable, _DictionaryProperties.v, true);
          if ((str != null && str is _PdfString) || _exportEmptyField) {
            element = XmlElement(XmlName(fieldName));
            if (str != null && str is _PdfString) {
              element.innerText = str.value!;
            } else if (_exportEmptyField) {
              element.innerText = '';
            }
          }
          break;
        case 'Ch':
          final _IPdfPrimitive? str = _getValue(
              _dictionary, _crossTable, _DictionaryProperties.v, true);
          if (str != null && str is _PdfName) {
            final XmlElement element = XmlElement(XmlName(fieldName));
            element.innerText = str._name!;
          } else if ((str != null && str is _PdfString) || _exportEmptyField) {
            element = XmlElement(XmlName(fieldName));
            if (str != null && str is _PdfString) {
              element.innerText = str.value!;
            } else if (_exportEmptyField) {
              element.innerText = '';
            }
          }
          break;
        case 'Btn':
          final _IPdfPrimitive? buttonFieldPrimitive = _getValue(
              _dictionary, _crossTable, _DictionaryProperties.v, true);
          if (buttonFieldPrimitive != null) {
            final String? value = _getExportValue(this, buttonFieldPrimitive);
            if ((value != null && value.isNotEmpty) || _exportEmptyField) {
              element = XmlElement(XmlName(fieldName));
              if (value != null) {
                element.innerText = value;
              } else if (_exportEmptyField) {
                element.innerText = '';
              }
            } else if (this is PdfRadioButtonListField ||
                this is PdfCheckBoxField) {
              element = XmlElement(XmlName(fieldName));
              if (_exportEmptyField) {
                element.innerText = '';
              } else {
                element.innerText = _DictionaryProperties.off;
              }
            }
          } else {
            if (this is PdfRadioButtonListField) {
              element = XmlElement(XmlName(fieldName));
              element.innerText = _getAppearanceStateValue(this);
            } else {
              final _PdfDictionary holder =
                  _getWidgetAnnotation(_dictionary, _crossTable);
              if ((holder[_DictionaryProperties.usageApplication]
                      is _PdfName) ||
                  _exportEmptyField) {
                final _IPdfPrimitive? holderName =
                    holder[_DictionaryProperties.usageApplication];
                element = XmlElement(XmlName(fieldName));
                if (holderName != null && holderName is _PdfName) {
                  element.innerText = holderName._name!;
                } else if (_exportEmptyField) {
                  element.innerText = '';
                }
              }
            }
          }
          break;
      }
    }
    return element;
  }

  //Overrides
  @override
  _IPdfPrimitive? get _element => _dictionary;

  @override
  // ignore: unused_element
  set _element(_IPdfPrimitive? value) {
    throw ArgumentError('Primitive element can\'t be set');
  }
}

/// Represents the graphic properties of field.
class _GraphicsProperties {
  //Constructor
  _GraphicsProperties(PdfField field) {
    _bounds = field.bounds;
    _borderPen = field._borderPen;
    _style = field._borderStyle;
    _borderWidth = field._borderWidth;
    _backBrush = field._backBrush;
    _foreBrush = field._foreBrush;
    _shadowBrush = field._shadowBrush;
    _font = field._font;
    _stringFormat = field._format;
    if (field.page != null &&
        field.page!._rotation != PdfPageRotateAngle.rotateAngle0) {
      _bounds =
          _rotateTextbox(field.bounds, field.page!.size, field.page!._rotation);
    }
  }

  _GraphicsProperties.fromFieldItem(PdfFieldItem item) {
    _bounds = item.bounds;
    _borderPen = item._borderPen;
    _style = item._borderStyle;
    _borderWidth = item._borderWidth;
    _backBrush = item._backBrush;
    _foreBrush = item._foreBrush;
    _shadowBrush = item._shadowBrush;
    _font = item._font;
    _stringFormat = item._format;
    if (item.page != null &&
        item.page!._rotation != PdfPageRotateAngle.rotateAngle0) {
      _bounds =
          _rotateTextbox(item.bounds, item.page!.size, item.page!._rotation);
    }
  }

  //Fields
  Rect? _bounds;
  PdfBrush? _foreBrush;
  PdfBrush? _backBrush;
  PdfBrush? _shadowBrush;
  int? _borderWidth;
  PdfBorderStyle? _style;
  PdfPen? _borderPen;
  PdfFont? _font;
  PdfStringFormat? _stringFormat;

  //Implementation
  Rect _rotateTextbox(Rect rect, Size? size, PdfPageRotateAngle angle) {
    Rect rectangle = rect;
    if (angle == PdfPageRotateAngle.rotateAngle180) {
      rectangle = Rect.fromLTWH(size!.width - rect.left - rect.width,
          size.height - rect.top - rect.height, rect.width, rect.height);
    }
    if (angle == PdfPageRotateAngle.rotateAngle270) {
      rectangle = Rect.fromLTWH(rect.top, size!.width - rect.left - rect.width,
          rect.height, rect.width);
    }
    if (angle == PdfPageRotateAngle.rotateAngle90) {
      rectangle = Rect.fromLTWH(size!.height - rect.top - rect.height,
          rect.left, rect.height, rect.width);
    }
    return rectangle;
  }
}

//typedef for NameChanged event handler.
typedef _BeforeNameChangesEventHandler = void Function(String name);
