part of pdf;

/// Represents a collection of form fields.
class PdfFormFieldCollection extends PdfObjectCollection
    implements _IPdfWrapper {
  //Constructor
  /// Initializes a new instance of the [PdfFormFieldCollection] class.
  PdfFormFieldCollection._([PdfForm? form]) : super() {
    if (form != null) {
      _form = form;
      for (int i = 0; i < _form!._terminalFields.length; ++i) {
        final PdfField? field = _getField(index: i);
        if (field != null) {
          _doAdd(field);
        }
      }
    }
  }

  //Fields
  PdfForm? _form;
  final _PdfArray _array = _PdfArray();
  // ignore: prefer_final_fields
  bool _isAction = false;
  final List<String?> _addedFieldNames = <String?>[];

  //Properties
  /// Gets the [PdfField] at the specified index.
  PdfField operator [](int index) {
    if ((count < 0) || (index >= count)) {
      throw RangeError('index');
    }
    return _list[index] as PdfField;
  }

  //Public methods
  /// Adds the specified field to the collection.
  int add(PdfField field) {
    return _doAdd(field);
  }

  /// Adds a list of fields to the collection.
  void addAll(List<PdfField> fields) {
    if (fields.isEmpty) {
      throw ArgumentError('fields can\'t be empty');
    }
    // ignore: avoid_function_literals_in_foreach_calls
    fields.forEach((PdfField element) => add(element));
  }

  /// Removes the specified field in the collection.
  void remove(PdfField field) {
    _doRemove(field);
  }

  /// Removes field at the specified position.
  void removeAt(int index) {
    _doRemoveAt(index);
  }

  /// Gets the index of the specific field.
  int indexOf(PdfField field) {
    return _list.indexOf(field);
  }

  /// Determines whether field is contained within the collection.
  bool contains(PdfField field) {
    return _list.contains(field);
  }

  /// Clears the form field collection.
  void clear() {
    _doClear();
  }

  //Implementations
  int _doAdd(PdfField field) {
    final bool isLoaded = _form != null && _form!._isLoadedForm;
    if (!_isAction) {
      field._setForm(_form);
      String? name = field.name;
      _PdfArray? array;
      bool skipField = false;
      if (isLoaded) {
        array = _form!._dictionary.containsKey(_DictionaryProperties.fields)
            ? _form!._crossTable!._getObject(
                _form!._dictionary[_DictionaryProperties.fields]) as _PdfArray?
            : _PdfArray();
        if (field._dictionary._items!
            .containsKey(_PdfName(_DictionaryProperties.parent))) {
          skipField = true;
        }
      } else {
        if (name == null || name.isEmpty) {
          name = _PdfResources._globallyUniqueIdentifier;
        }
        _form!._fieldNames.add(name);
      }
      if (!isLoaded || !field._isLoadedField) {
        if (_form!.fieldAutoNaming && !skipField) {
          if (!isLoaded) {
            field._applyName(_form!._getCorrectName(name));
          } else {
            field._applyName(_getCorrectName(name));
            array!._add(_PdfReferenceHolder(field));
            _form!._dictionary.setProperty(_DictionaryProperties.fields, array);
          }
        } else if (isLoaded && !_addedFieldNames.contains(name) && !skipField) {
          array!._add(_PdfReferenceHolder(field));
          _form!._dictionary.setProperty(_DictionaryProperties.fields, array);
        } else if (isLoaded &&
                (!_addedFieldNames.contains(name) && skipField) ||
            (_form!.fieldAutoNaming && skipField)) {
          _addedFieldNames.add(field.name);
        } else if (count > 0 && !isLoaded) {
          for (int i = 0; i < count; i++) {
            if (_list[i] is PdfField) {
              final PdfField oldField = _list[i] as PdfField;
              if (oldField._name == field._name) {
                if ((field is PdfTextBoxField && oldField is PdfTextBoxField) ||
                    (field is PdfCheckBoxField &&
                        oldField is PdfCheckBoxField)) {
                  final _PdfDictionary dic = field._widget!._dictionary;
                  dic.remove(_DictionaryProperties.parent);
                  field._widget!.parent = oldField;
                  if (field._page != null) {
                    field._page!.annotations.add(field._widget!);
                  }
                  bool isPresent = false;
                  for (int i = 0; i < oldField._array.count; i++) {
                    final _IPdfPrimitive? obj = oldField._array._elements[i];
                    if (obj != null &&
                        obj is _PdfReferenceHolder &&
                        obj.object != null &&
                        obj.object is _PdfDictionary &&
                        obj.object == oldField._widget!._dictionary) {
                      isPresent = true;
                      break;
                    }
                  }
                  if (!isPresent) {
                    oldField._array._add(_PdfReferenceHolder(oldField._widget));
                    oldField._fieldItems ??= <PdfField>[];
                    oldField._fieldItems!.add(oldField);
                  }
                  oldField._array._add(_PdfReferenceHolder(field._widget));
                  oldField._fieldItems ??= <PdfField>[];
                  oldField._fieldItems!.add(field);
                  oldField._dictionary
                      .setProperty(_DictionaryProperties.kids, oldField._array);
                  return count - 1;
                } else if (field is PdfSignatureField) {
                  final PdfSignatureField currentField = field;
                  final _PdfDictionary dictionary =
                      currentField._widget!._dictionary;
                  if (dictionary.containsKey(_DictionaryProperties.parent)) {
                    dictionary.remove(_DictionaryProperties.parent);
                  }
                  currentField._widget!.parent = oldField;
                  _IPdfPrimitive? oldKids;
                  _IPdfPrimitive? newKids;
                  if (oldField._dictionary
                      .containsKey(_DictionaryProperties.kids)) {
                    oldKids = oldField._dictionary
                        ._items![_PdfName(_DictionaryProperties.kids)];
                  }
                  if (field._dictionary
                      .containsKey(_DictionaryProperties.kids)) {
                    newKids = field._dictionary
                        ._items![_PdfName(_DictionaryProperties.kids)];
                  }
                  if (newKids != null && newKids is _PdfArray) {
                    if (oldKids == null || oldKids is! _PdfArray) {
                      oldKids = _PdfArray();
                    }
                    for (int i = 0; i < newKids.count; i++) {
                      final _IPdfPrimitive? kidsReference = newKids[i];
                      if (kidsReference != null &&
                          kidsReference is _PdfReferenceHolder) {
                        oldKids._add(kidsReference);
                      }
                    }
                  }
                  oldField._dictionary
                      .setProperty(_DictionaryProperties.kids, oldKids);
                  currentField._skipKidsCertificate = true;
                  if (!field.page!.annotations
                      .contains(currentField._widget!)) {
                    field.page!.annotations.add(currentField._widget!);
                  }
                  return count - 1;
                }
              }
            }
          }
        }
      }
    }
    if (isLoaded && !_addedFieldNames.contains(field.name)) {
      _addedFieldNames.add(field.name);
    }
    if (field is! PdfRadioButtonListField && field._page != null) {
      field._page!.annotations.add(field._widget!);
    }
    _array._add(_PdfReferenceHolder(field));
    _list.add(field);
    field._annotationIndex = _list.length - 1;
    return _list.length - 1;
  }

  void _doRemove(PdfField field) {
    if (field._isLoadedField ||
        (field._form != null && field._form!._isLoadedForm)) {
      _removeFromDictionary(field);
    }
    field._setForm(null);
    final int index = _list.indexOf(field);
    _array._removeAt(index);
    _list.removeAt(index);
  }

  void _doRemoveAt(int index) {
    if (_list[index] is PdfField && (_list[index] as PdfField)._isLoadedField) {
      _removeFromDictionary(_list[index] as PdfField);
    }
    _array._removeAt(index);
    _list.removeAt(index);
  }

  void _doClear() {
    if (count > 0) {
      for (int i = 0; i < count; i++) {
        if (_list[i] is PdfField) {
          final PdfField field = _list[i] as PdfField;
          if (field._isLoadedField) {
            _removeFromDictionary(field);
          } else {
            _form!._deleteFromPages(field);
            _form!._deleteAnnotation(field);
            field._page = null;
            if (field._dictionary._items != null) {
              field._dictionary.clear();
            }
            field._setForm(null);
          }
        }
      }
    }
    _addedFieldNames.clear();
    _form!._terminalFields.clear();
    _array._clear();
    _list.clear();
  }

  void _createFormFieldsFromWidgets(int startFormFieldIndex) {
    for (int i = startFormFieldIndex; i < _form!._terminalFields.length; ++i) {
      final PdfField? field = _getField(index: i);
      if (field != null) {
        _doAdd(field);
      }
    }
    if (_form!._widgetDictionary != null &&
        _form!._widgetDictionary!.isNotEmpty) {
      for (final List<_PdfDictionary> dictValue
          in _form!._widgetDictionary!.values) {
        if (dictValue.isNotEmpty) {
          final PdfField? field = _getField(dictionary: dictValue[0]);
          if (field != null) {
            _form!._terminalFields.add(field._dictionary);
            _doAdd(field);
          }
        }
      }
    }
  }

  // Gets the field.
  PdfField? _getField({int? index, _PdfDictionary? dictionary}) {
    index != null
        ? dictionary = _form!._terminalFields[index]
        : ArgumentError.checkNotNull(
            dictionary, 'method cannot be initialized without parameters');
    final _PdfCrossTable? crossTable = _form!._crossTable;
    PdfField? field;
    final _PdfName? name = PdfField._getValue(
        dictionary!, crossTable, _DictionaryProperties.ft, true) as _PdfName?;
    _PdfFieldTypes type = _PdfFieldTypes.none;
    if (name != null) {
      type = _getFieldType(name, dictionary, crossTable);
    }
    switch (type) {
      case _PdfFieldTypes.comboBox:
        field = _createComboBox(dictionary, crossTable!);
        break;
      case _PdfFieldTypes.listBox:
        field = _createListBox(dictionary, crossTable!);
        break;
      case _PdfFieldTypes.textField:
        field = _createTextField(dictionary, crossTable!);
        break;
      case _PdfFieldTypes.checkBox:
        field = _createCheckBox(dictionary, crossTable!);
        break;
      case _PdfFieldTypes.radioButton:
        field = _createRadioButton(dictionary, crossTable!);
        break;
      case _PdfFieldTypes.pushButton:
        field = _createPushButton(dictionary, crossTable!);
        break;
      case _PdfFieldTypes.signatureField:
        field = _createSignatureField(dictionary, crossTable!);
        break;
      default:
        break;
    }
    if (field != null) {
      field._setForm(_form);
      field._beforeNameChanges = (String name) {
        if (_addedFieldNames.contains(name)) {
          throw ArgumentError('Field with the same name already exist');
        }
      };
    }
    return field;
  }

  //Gets the type of the field.
  _PdfFieldTypes _getFieldType(
      _PdfName name, _PdfDictionary dictionary, _PdfCrossTable? crossTable) {
    final String str = name._name!;
    _PdfFieldTypes type = _PdfFieldTypes.none;
    final _PdfNumber? number = PdfField._getValue(
            dictionary, crossTable, _DictionaryProperties.fieldFlags, true)
        as _PdfNumber?;
    int fieldFlags = 0;
    if (number != null) {
      fieldFlags = number.value!.toInt();
    }
    switch (str.toLowerCase()) {
      case 'ch':
        //check with _FieldFlags.combo value.
        if ((fieldFlags & 1 << 17) != 0) {
          type = _PdfFieldTypes.comboBox;
        } else {
          type = _PdfFieldTypes.listBox;
        }
        break;
      case 'tx':
        type = _PdfFieldTypes.textField;
        break;
      case 'btn':
        if ((fieldFlags & 1 << 15) != 0) {
          type = _PdfFieldTypes.radioButton;
        } else if ((fieldFlags & 1 << 16) != 0) {
          type = _PdfFieldTypes.pushButton;
        } else {
          type = _PdfFieldTypes.checkBox;
        }
        break;
      case 'sig':
        type = _PdfFieldTypes.signatureField;
        break;
    }
    return type;
  }

  //Creates the combo box.
  PdfField _createComboBox(
      _PdfDictionary dictionary, _PdfCrossTable crossTable) {
    final PdfField field = PdfComboBoxField._load(dictionary, crossTable);
    field._setForm(_form);
    return field;
  }

  //Creates the list box.
  PdfField _createListBox(
      _PdfDictionary dictionary, _PdfCrossTable crossTable) {
    final PdfField field = PdfListBoxField._load(dictionary, crossTable);
    field._setForm(_form);
    return field;
  }

  //Creates the text field.
  PdfField _createTextField(
      _PdfDictionary dictionary, _PdfCrossTable crossTable) {
    final PdfField field = PdfTextBoxField._load(dictionary, crossTable);
    field._setForm(_form);
    return field;
  }

  PdfField _createCheckBox(
      _PdfDictionary dictionary, _PdfCrossTable crossTable) {
    final PdfField field = PdfCheckBoxField._loaded(dictionary, crossTable);
    field._setForm(_form);
    return field;
  }

  PdfField _createRadioButton(
      _PdfDictionary dictionary, _PdfCrossTable crossTable) {
    final PdfField field =
        PdfRadioButtonListField._loaded(dictionary, crossTable);
    field._setForm(_form);
    return field;
  }

  PdfField _createPushButton(
      _PdfDictionary dictionary, _PdfCrossTable crossTable) {
    final PdfField field = PdfButtonField._loaded(dictionary, crossTable);
    field._setForm(_form);
    return field;
  }

  PdfField _createSignatureField(
      _PdfDictionary dictionary, _PdfCrossTable crossTable) {
    final PdfField field = PdfSignatureField._(dictionary, crossTable);
    field._setForm(_form);
    return field;
  }

  /// Gets the new name of the field.
  String? _getCorrectName(String? name) {
    final List<String?> list = <String?>[];
    for (int i = 0; i < count; i++) {
      if (_list[i] is PdfField) {
        list.add((_list[i] as PdfField).name);
      }
    }
    String? correctName = name;
    int index = 0;
    while (list.contains(correctName)) {
      correctName = name! + index.toString();
      ++index;
    }
    list.clear();
    return correctName;
  }

  void _removeFromDictionary(PdfField field) {
    if (field._isLoadedField) {
      _form!._removeFromDictionaries(field);
    }
    _addedFieldNames.remove(field.name);
  }

  int _getFieldIndex(String name) {
    int i = -1;
    final List<String> _fieldNames = <String>[];
    final List<String> _indexedFieldNames = <String>[];
    for (int j = 0; j < count; j++) {
      if (_list[j] is PdfField) {
        final PdfField field = _list[j] as PdfField;
        _fieldNames.add(field.name!);
        if (field.name != null) {
          _indexedFieldNames.add(field.name!.split('[')[0]);
        }
      }
    }
    if (_fieldNames.contains(name)) {
      i = _fieldNames.indexOf(name);
    } else if (_indexedFieldNames.contains(name)) {
      i = _indexedFieldNames.indexOf(name);
    }
    return i;
  }

  //Overrides
  @override
  _IPdfPrimitive get _element => _array;

  @override
  // ignore: unused_element
  set _element(_IPdfPrimitive? value) {
    throw ArgumentError('Primitive element can\'t be set');
  }
}
