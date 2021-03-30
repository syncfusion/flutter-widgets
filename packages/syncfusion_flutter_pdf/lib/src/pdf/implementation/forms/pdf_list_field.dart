part of pdf;

/// Represents base class for form's list fields.
abstract class PdfListField extends PdfField {
  //Constructor
  PdfListField._(PdfPage? page, String name, Rect bounds,
      {List<PdfListFieldItem>? items,
      PdfFont? font,
      PdfTextAlignment? alignment,
      PdfColor? borderColor,
      PdfColor? foreColor,
      PdfColor? backColor,
      int? borderWidth,
      PdfHighlightMode? highlightMode,
      PdfBorderStyle? borderStyle,
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
    if (items != null && items.isNotEmpty) {
      items.forEach((element) => this.items.add(element));
    }
  }

  PdfListField._load(_PdfDictionary dictionary, _PdfCrossTable crossTable)
      : super._load(dictionary, crossTable);

  //Fields
  PdfListFieldItemCollection? _items;
  List<int> _selectedIndex = [-1];

  //Properties
  /// Gets the list field items.
  PdfListFieldItemCollection get items {
    if (_items == null) {
      if (!_isLoadedField) {
        _items = PdfListFieldItemCollection._();
        _dictionary.setProperty(_DictionaryProperties.opt, _items);
      } else {
        _items = _getListItemCollection();
      }
    }
    return _items!;
  }

  List<int> get _selectedIndexes =>
      _isLoadedField ? _obtainSelectedIndex() : _selectedIndex;
  set _selectedIndexes(List<int> value) {
    value.forEach((element) {
      if (element < 0 || element >= items.count) {
        throw RangeError('index');
      }
    });
    if (_isLoadedField) {
      _assignSelectedIndex(value);
    } else {
      if (_selectedIndex != value && _selectedIndex.isNotEmpty) {
        _selectedIndex = value;
        _dictionary.setProperty(
            _DictionaryProperties.i, _PdfArray(_selectedIndex));
      }
    }
  }

  List<String> get _selectedValues {
    if (_isLoadedField) {
      return _obtainSelectedValue();
    } else {
      if (_selectedIndex == [-1]) {
        throw ArgumentError('No value is selected.');
      }
      final List<String> values = [];
      _selectedIndex.forEach((element) => values.add(_items![element].value));
      return values;
    }
  }

  set _selectedValues(List<String> value) {
    if (value.isEmpty) {
      throw ArgumentError('selected value can\'t be null/Empty');
    }
    if (_isLoadedField) {
      bool isText = false;
      if (items[0].value.isEmpty) {
        isText = true;
      }
      _assignSelectedValue(value, isText);
    } else {
      for (int i = 0; i < _items!.count; i++) {
        if (value.contains(_items![i].value)) {
          _selectedIndex.add(i);
          if (_selectedIndex.contains(-1)) {
            _selectedIndex.remove(-1);
          }
          break;
        }
      }
      _dictionary.setProperty(
          _DictionaryProperties.i, _PdfArray(_selectedIndex));
    }
  }

  PdfListFieldItemCollection get _selectedItems {
    if (_selectedIndex == [-1]) {
      throw ArgumentError('No item is selected.');
    }
    final PdfListFieldItemCollection item =
        PdfListFieldItemCollection._(_isLoadedField ? this : null);
    for (final index in _selectedIndexes) {
      if (index > -1 && items.count > 0 && items.count > index) {
        item._addItem(items[index]);
      }
    }
    return item;
  }

  /// Gets or sets the font.
  PdfFont? get font => _font;
  set font(PdfFont? value) {
    if (value != null) {
      _font = value;
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

  //Implementations
  @override
  void _initialize() {
    super._initialize();
    _dictionary.setProperty(
        _DictionaryProperties.ft, _PdfName(_DictionaryProperties.ch));
  }

  // Gets the list item.
  PdfListFieldItemCollection _getListItemCollection() {
    final PdfListFieldItemCollection items = PdfListFieldItemCollection._(this);
    final _IPdfPrimitive? array = PdfField._getValue(
        _dictionary, _crossTable, _DictionaryProperties.opt, true);
    if (array != null && array is _PdfArray) {
      for (int i = 0; i < array.count; i++) {
        final _IPdfPrimitive? primitive = _crossTable!._getObject(array[i]);
        PdfListFieldItem item;
        if (primitive is _PdfString) {
          final _PdfString str = primitive;
          item = PdfListFieldItem._load(str.value, null, this, _crossTable);
        } else {
          final _PdfArray arr = primitive as _PdfArray;
          final _PdfString value =
              _crossTable!._getObject(arr[0]) as _PdfString;
          final _PdfString text = _crossTable!._getObject(arr[1]) as _PdfString;
          item = PdfListFieldItem._load(
              text.value, value.value, this, _crossTable);
        }
        items._addItem(item);
      }
    }
    return items;
  }

  List<int> _obtainSelectedIndex() {
    final List<int> selectedIndex = [];
    if (_dictionary.containsKey(_DictionaryProperties.i)) {
      final _IPdfPrimitive? array =
          _crossTable!._getObject(_dictionary[_DictionaryProperties.i]);
      if (array != null && array is _PdfArray) {
        if (array.count > 0) {
          for (int i = 0; i < array.count; i++) {
            final _IPdfPrimitive? number = _crossTable!._getObject(array[i]);
            if (number != null && number is _PdfNumber) {
              selectedIndex.add(number.value!.toInt());
            }
          }
        }
      } else {
        final _IPdfPrimitive? number =
            _crossTable!._getObject(_dictionary[_DictionaryProperties.i]);
        if (number != null && number is _PdfNumber) {
          selectedIndex.add(number.value!.toInt());
        }
      }
    }
    if (selectedIndex.length == 0) {
      selectedIndex.add(-1);
    }
    return selectedIndex;
  }

  //Gets selected value.
  List<String> _obtainSelectedValue() {
    final List<String> value = [];
    if (_dictionary.containsKey(_DictionaryProperties.v)) {
      final _IPdfPrimitive? primitive =
          _crossTable!._getObject(_dictionary[_DictionaryProperties.v]);
      if (primitive is _PdfString) {
        value.add(primitive.value!);
      } else {
        final _PdfArray array = primitive as _PdfArray;
        for (int i = 0; i < array.count; i++) {
          final _PdfString stringValue = array[i] as _PdfString;
          value.add(stringValue.value!);
        }
      }
    } else {
      for (final index in _selectedIndexes) {
        if (index > -1) {
          value.add(items[index].value);
        }
      }
    }
    return value;
  }

  void _assignSelectedIndex(List<int> value) {
    if ((value.length == 0) || (value.length > items.count)) {
      throw RangeError('selectedIndex');
    }
    value.forEach((element) {
      if ((element >= items.count)) {
        throw RangeError('selectedIndex');
      }
    });
    if (readOnly == false) {
      value.sort();
      _dictionary.setProperty(_DictionaryProperties.i, _PdfArray(value));
      List<String> selectedValues = [];
      bool isText = false;
      value.forEach((element) {
        if (element >= 0) {
          selectedValues.add(items[element].value);
        }
      });
      if (items[0].value.isEmpty) {
        selectedValues = [];
        isText = true;
        value.forEach((element) {
          selectedValues.add(items[element].text);
        });
      }
      if (selectedValues.length > 0) {
        _assignSelectedValue(selectedValues, isText);
      }
      _changed = true;
    }
  }

  void _assignSelectedValue(List<String?> values, bool isText) {
    final List<int> selectedIndexes = [];
    final PdfListFieldItemCollection? collection = items;
    if (readOnly == false) {
      values.forEach((element) {
        bool isvaluePresent = false;
        for (int i = 0; i < collection!.count; i++) {
          if ((isText ? collection[i].text : collection[i].value) == element) {
            isvaluePresent = true;
            selectedIndexes.add(i);
          }
        }
        if (!isvaluePresent &&
            (this is PdfComboBoxField) &&
            !(this as PdfComboBoxField).editable) {
          throw new RangeError('index');
        }
      });
      if (this is PdfListBoxField && values.length > 1) {
        final PdfListBoxField listfield = this as PdfListBoxField;
        if (!listfield.multiSelect) {
          selectedIndexes.removeRange(1, selectedIndexes.length - 1);
          values = [collection![selectedIndexes[0]].value];
        }
      }
      if (selectedIndexes.length != 0) {
        selectedIndexes.sort();
        _dictionary.setProperty(
            _DictionaryProperties.i, _PdfArray(selectedIndexes));
      } else
        _dictionary.remove(_DictionaryProperties.i);
    }
    if (_dictionary.containsKey(_DictionaryProperties.v)) {
      final _IPdfPrimitive? primitive =
          _crossTable!._getObject(_dictionary[_DictionaryProperties.v]);
      if ((primitive == null) || (primitive is _PdfString)) {
        if (this is PdfListBoxField) {
          final _PdfArray array = _PdfArray();
          for (final selectedValue in values) {
            array._add(_PdfString(selectedValue!));
          }
          _dictionary.setProperty(_DictionaryProperties.v, array);
        } else {
          _dictionary._setString(_DictionaryProperties.v, values[0]);
        }
      } else {
        final _PdfArray array = primitive as _PdfArray;
        array._clear();
        for (final selectedValue in values) {
          array._add(_PdfString(selectedValue!));
        }
        _dictionary.setProperty(_DictionaryProperties.v, array);
      }
    } else if (this is PdfComboBoxField) {
      _dictionary._setString(_DictionaryProperties.v, values[0]);
    } else {
      final _PdfArray array = _PdfArray();
      for (final selectedValue in values) {
        array._add(_PdfString(selectedValue!));
      }
      _dictionary.setProperty(_DictionaryProperties.v, array);
    }
    _changed = true;
  }
}
