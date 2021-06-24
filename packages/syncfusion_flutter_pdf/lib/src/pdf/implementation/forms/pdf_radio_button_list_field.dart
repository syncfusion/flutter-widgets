part of pdf;

/// Represents radio button field in the PDF form.
class PdfRadioButtonListField extends PdfField {
  //Constructor
  /// Initializes a new instance of the [PdfRadioButtonListField] class with
  /// the specific page, name and bounds.
  PdfRadioButtonListField(PdfPage page, String name,
      {List<PdfRadioButtonListItem>? items,
      int? selectedIndex,
      String? selectedValue})
      : super(page, name, Rect.zero) {
    _initValues(items, selectedIndex, selectedValue);
    _flags.add(_FieldFlags.radio);
    _dictionary.setProperty(
        _DictionaryProperties.ft, _PdfName(_DictionaryProperties.btn));
  }

  PdfRadioButtonListField._loaded(
      _PdfDictionary dictionary, _PdfCrossTable crossTable)
      : super._load(dictionary, crossTable) {
    _retrieveOptionValue();
  }

  //Fields
  PdfRadioButtonItemCollection? _items;
  int _selectedIndex = -1;

  //Properties
  /// Gets the items of the radio button field.{Read-Only}
  PdfRadioButtonItemCollection get items {
    if (_isLoadedField) {
      _items ??= _getRadioButtonListItems(PdfRadioButtonItemCollection._(this));
      return _items!;
    } else {
      if (_items == null) {
        _items = PdfRadioButtonItemCollection._(this);
        _dictionary.setProperty(_DictionaryProperties.kids, _items);
      }
      return _items!;
    }
  }

  /// Gets or sets the first selected item in the list.
  int get selectedIndex {
    if (_isLoadedField && _selectedIndex == -1) {
      _selectedIndex = _obtainSelectedIndex();
    }
    if (_selectedIndex == -1) {
      ArgumentError.value('None of the item to be selected in the list');
    }
    return _selectedIndex;
  }

  set selectedIndex(int value) {
    RangeError.range(value, 0, items.count, 'SelectedIndex');
    if (selectedIndex != value) {
      if (_isLoadedField) {
        _assignSelectedIndex(value);
        _changed = true;
      }
      _selectedIndex = value;
      final PdfRadioButtonListItem item = _items![_selectedIndex];
      _dictionary._setName(_PdfName(_DictionaryProperties.v), item.value);
      _dictionary._setName(_PdfName(_DictionaryProperties.dv), item.value);
    }
  }

  /// Gets the first selected item in the list.{Read-Only}
  PdfRadioButtonListItem? get selectedItem {
    PdfRadioButtonListItem? item;
    if (selectedIndex != -1) {
      item = items[_selectedIndex];
    }
    return item;
  }

  /// Gets or sets the value of the first selected item in the list.
  String get selectedValue {
    if (_isLoadedField) {
      if (selectedIndex == -1) {
        _selectedIndex = _obtainSelectedIndex();
      }
      if (_selectedIndex != -1) {
        return _items![_selectedIndex].value;
      } else {
        ArgumentError('None of the item to be selected in the list');
      }
      return _items![_selectedIndex].value;
    } else {
      if (_selectedIndex == -1) {
        ArgumentError('None of the item to be selected in the list');
      }
      return _items![_selectedIndex].value;
    }
  }

  set selectedValue(String value) {
    if (_isLoadedField) {
      _assignSelectedValue(value);
      _changed = true;
    } else {
      for (final Object? item in items._list) {
        if (item is PdfRadioButtonListItem && item.value == value) {
          _selectedIndex = items.indexOf(item);
          _dictionary._setName(_PdfName(_DictionaryProperties.v), item.value);
          _dictionary._setName(_PdfName(_DictionaryProperties.dv), item.value);
          break;
        }
      }
    }
  }

  //Implementation
  void _initValues(
      List<PdfRadioButtonListItem>? radioItems, int? index, String? value) {
    if (radioItems != null) {
      radioItems
          .toList()
          .forEach((PdfRadioButtonListItem item) => items.add(item));
    }
    if (index != null) {
      selectedIndex = index;
    }
    if (value != null) {
      selectedValue = value;
    }
  }

  PdfRadioButtonItemCollection _getRadioButtonListItems(
      PdfRadioButtonItemCollection listItems) {
    final _PdfArray fieldKids = _obtainKids()!;
    for (int i = 0; i < fieldKids.count; i++) {
      final _IPdfPrimitive? kidsDict =
          _PdfCrossTable._dereference(fieldKids[i]);
      if (kidsDict != null && kidsDict is _PdfDictionary) {
        final PdfRadioButtonListItem item =
            PdfRadioButtonListItem._loaded(kidsDict, _crossTable!, this);
        listItems._doAdd(item, true);
      }
    }
    return listItems;
  }

  int _obtainSelectedIndex() {
    int index = -1;
    for (int i = 0; i < items.count; ++i) {
      final PdfRadioButtonListItem item = items[i];
      final _PdfDictionary dic = item._dictionary;
      final _IPdfPrimitive? checkNamePrimitive =
          PdfField._searchInParents(dic, _crossTable, _DictionaryProperties.v);
      if (dic.containsKey(_DictionaryProperties.usageApplication) &&
          (checkNamePrimitive is _PdfName ||
              checkNamePrimitive is _PdfString)) {
        final _IPdfPrimitive? name = _crossTable!
            ._getObject(dic[_DictionaryProperties.usageApplication]);
        if (name is _PdfName && name._name!.toLowerCase() != 'off') {
          if (checkNamePrimitive is _PdfName &&
              checkNamePrimitive._name!.toLowerCase() != 'off') {
            if (name._name == checkNamePrimitive._name) {
              index = i;
            }
            break;
          } else if (checkNamePrimitive is _PdfString &&
              checkNamePrimitive.value!.toLowerCase() != 'off') {
            if (name._name == checkNamePrimitive.value) {
              index = i;
            }
            break;
          }
        }
      }
    }
    return index;
  }

  @override
  void _beginSave() {
    super._beginSave();
    final _PdfArray? kids = _obtainKids();
    int i = 0;
    if (kids != null) {
      for (i = 0; i < kids.count; ++i) {
        final _PdfDictionary? widget =
            _crossTable!._getObject(kids[i]) as _PdfDictionary?;
        final PdfRadioButtonListItem item = items[i];
        item._applyAppearance(widget, item);
      }
    }
    while (i < items.count) {
      final PdfRadioButtonListItem item = items[i];
      item._save();
      i++;
    }
  }

  void _assignSelectedIndex(int value) {
    final int index = _selectedIndex;
    if (index != value) {
      _PdfName? name;
      if (_dictionary.containsKey(_DictionaryProperties.v)) {
        name = _dictionary[_DictionaryProperties.v] as _PdfName?;
        _dictionary.remove(_DictionaryProperties.v);
        _dictionary.remove(_DictionaryProperties.dv);
      }
      if (name != null) {
        for (int i = 0; i < items.count; i++) {
          final PdfRadioButtonListItem item = items[i];
          if (item.value == name._name) {
            item._dictionary._setName(
                _PdfName(_DictionaryProperties.usageApplication),
                _DictionaryProperties.off);
          }
        }
      }
      items[value]._dictionary._setName(
          _PdfName(_DictionaryProperties.usageApplication), items[value].value);
    }
  }

  void _assignSelectedValue(String value) {
    _PdfName? name;
    if (_dictionary.containsKey(_DictionaryProperties.v)) {
      name = _dictionary[_DictionaryProperties.v] as _PdfName?;
      _dictionary.remove(_DictionaryProperties.v);
      _dictionary.remove(_DictionaryProperties.dv);
    }
    if (name != null) {
      for (int i = 0; i < items.count; i++) {
        final PdfRadioButtonListItem item = items[i];
        if (item.value == name._name) {
          item._dictionary._setName(
              _PdfName(_DictionaryProperties.usageApplication),
              _DictionaryProperties.off);
        }
      }
    }
    for (final Object? item in items._list) {
      if (item is PdfRadioButtonListItem &&
          (item.value == value || item._optionValue == value)) {
        _selectedIndex = items.indexOf(item);
        _dictionary._setName(_PdfName(_DictionaryProperties.v), item.value);
        _dictionary._setName(_PdfName(_DictionaryProperties.dv), item.value);
        item._dictionary._setName(
            _PdfName(_DictionaryProperties.usageApplication), item.value);
        item._dictionary
            ._setName(_PdfName(_DictionaryProperties.v), item.value);
        break;
      }
    }
  }

  @override
  void _draw() {
    if (_isLoadedField) {
      final _PdfArray? kids = _obtainKids();
      if (kids != null) {
        for (int i = 0; i < kids.count; ++i) {
          final PdfRadioButtonListItem item = items[i];
          _PdfCheckFieldState state = _PdfCheckFieldState.unchecked;
          if ((selectedIndex >= 0) && (selectedValue == item.value)) {
            state = _PdfCheckFieldState.checked;
          }
          if (item.page != null) {
            _drawStateItem(item.page!.graphics, state, item);
          }
        }
      }
    } else {
      for (int i = 0; i < items.count; ++i) {
        items[i]._draw();
      }
    }
  }

  void _retrieveOptionValue() {
    if (_dictionary.containsKey(_DictionaryProperties.opt)) {
      final _IPdfPrimitive optionArray =
          _dictionary[_DictionaryProperties.opt]!;
      final _IPdfPrimitive? options =
          optionArray is _PdfReferenceHolder ? optionArray.object : optionArray;
      if (options != null && options is _PdfArray) {
        final int count =
            (options.count <= items.count) ? options.count : items.count;
        for (int i = 0; i < count; i++) {
          final _IPdfPrimitive? option = options[i] is _PdfReferenceHolder
              ? (options[i]! as _PdfReferenceHolder).object
              : options[i];
          if (option != null && option is _PdfString) {
            items[i]._optionValue = option.value;
          }
        }
      }
    }
  }
}
