part of pdf;

/// Represents interactive form of the PDF document.
class PdfForm implements _IPdfWrapper {
  //Constructors
  /// Initializes a new instance of the [PdfForm] class.
  PdfForm() : super() {
    _fields = PdfFormFieldCollection._();
    _fields!._form = this;
    _dictionary.setProperty(_DictionaryProperties.fields, _fields);
    if (!_isLoadedForm) {
      _dictionary._beginSave = _beginSave;
    }
    _setAppearanceDictionary = true;
  }

  PdfForm._internal(_PdfCrossTable? crossTable,
      [_PdfDictionary? formDictionary]) {
    _isLoadedForm = true;
    _crossTable = crossTable;
    _dictionary._setBoolean(
        _DictionaryProperties.needAppearances, _needAppearances);
    _crossTable!._document!._catalog._beginSaveList ??= [];
    _crossTable!._document!._catalog._beginSaveList!.add(_beginSave);
    _crossTable!._document!._catalog.modify();
    if (_crossTable!._document!._catalog
        .containsKey(_DictionaryProperties.perms)) {
      _checkPerms(_crossTable!._document!._catalog);
    }
    if (formDictionary != null) {
      _initialize(formDictionary, crossTable!);
    }
  }

  //Fields
  _PdfDictionary _dictionary = _PdfDictionary();
  PdfFormFieldCollection? _fields;
  bool? _needAppearances = false;
  bool _setAppearanceDictionary = true;
  _PdfResources? _resource;
  final List<String?> _fieldNames = <String?>[];
  _PdfCrossTable? _crossTable;
  List<_PdfDictionary> _terminalFields = [];
  bool _formHasKids = false;
  bool _isLoadedForm = false;
  bool _isDefaultAppearance = true;
  Map<String?, List<_PdfDictionary>>? _widgetDictionary;
  bool _readOnly = false;
  bool _isUR3 = false;
  List<_SignatureFlags> _signatureFlags = [_SignatureFlags.none];

  /// Gets or sets a value indicating whether field auto naming.
  ///
  /// The default value is true.
  bool fieldAutoNaming = true;

  //Properties
  /// Gets the fields collection.
  PdfFormFieldCollection get fields {
    if (_isLoadedForm) {
      _fields ??= PdfFormFieldCollection._(this);
    }
    return _fields!;
  }

  //Gets or sets the resources.
  _PdfResources get _resources {
    if (_resource == null) {
      _resource = _PdfResources();
      _dictionary.setProperty(_DictionaryProperties.dr, _resource);
    }
    return _resource!;
  }

  set _resources(_PdfResources value) {
    _resource = value;
    if (_isLoadedForm) {
      _dictionary.setProperty(_DictionaryProperties.dr, value);
    }
  }

  /// Gets or sets a value indicating whether the form is read only.
  ///
  /// The default value is false.
  bool get readOnly => _readOnly;
  set readOnly(bool value) {
    _readOnly = value;
    if (_isLoadedForm) {
      for (int i = 0; i < fields.count; i++) {
        fields[i].readOnly = value;
      }
    }
  }

  /// Gets or sets a value indicating whether this [PdfForm] is flatten.
  bool _flatten = false;

  //Public methods.
  /// Specifies whether to set the default appearance for the form or not.
  void setDefaultAppearance(bool value) {
    _needAppearances = value;
    _setAppearanceDictionary = true;
    _isDefaultAppearance = true;
  }

  /// Flatten all the fields available in the form.
  ///
  /// The flatten will add at the time of saving the current document.
  void flattenAllFields() {
    _flatten = true;
  }

  //Implementation
  //Raises before stream saves.
  void _beginSave(Object sender, _SavePdfPrimitiveArgs? ars) {
    if (!_isLoadedForm) {
      if (_signatureFlags.length > 1 ||
          (_signatureFlags.isNotEmpty &&
              !_signatureFlags.contains(_SignatureFlags.none))) {
        _setSignatureFlags(_signatureFlags);
        _needAppearances = false;
      }
      _checkFlatten();
      if (fields.count > 0 && _setAppearanceDictionary) {
        _dictionary._setBoolean(
            _DictionaryProperties.needAppearances, _needAppearances);
      }
    } else {
      int i = 0;
      if (_signatureFlags.length > 1 ||
          (_signatureFlags.isNotEmpty &&
              !_signatureFlags.contains(_SignatureFlags.none))) {
        _setSignatureFlags(_signatureFlags);
        _dictionary.changed = true;
        if (!_isDefaultAppearance) {
          _needAppearances = false;
        }
        if (_dictionary.containsKey(_DictionaryProperties.needAppearances))
          _dictionary._setBoolean(
              _DictionaryProperties.needAppearances, _needAppearances);
      }
      while (i < fields.count) {
        final PdfField? field = fields[i];
        if (field != null) {
          if (field._isLoadedField) {
            final _PdfDictionary dic = field._dictionary;
            bool isNeedAppearance = false;
            if (!dic.containsKey(_DictionaryProperties.ap) &&
                _isDefaultAppearance &&
                !_needAppearances! &&
                !field._changed) {
              isNeedAppearance = true;
            }
            if (field._flags.length > 1) {
              field._changed = true;
              field._setFlags(field._flags);
            }
            int fieldFlag = 0;
            if (dic.containsKey(_DictionaryProperties.f)) {
              final _IPdfPrimitive? flag =
                  _PdfCrossTable._dereference(dic[_DictionaryProperties.f]);
              if (flag != null && flag is _PdfNumber) {
                fieldFlag = flag.value!.toInt();
              }
            }
            _PdfArray? kids;
            if (field._dictionary.containsKey(_DictionaryProperties.kids)) {
              kids = _PdfCrossTable._dereference(
                  field._dictionary[_DictionaryProperties.kids]) as _PdfArray?;
            }
            if (field._flattenField && fieldFlag != 6) {
              if (field.page != null || kids != null) {
                field._draw();
              }
              fields.remove(field);
              final int? index =
                  _crossTable!._items!._lookFor(field._dictionary);
              if (index != -1) {
                _crossTable!._items!._objectCollection!.removeAt(index!);
              }
              --i;
            } else if (field._changed || isNeedAppearance) {
              field._beginSave();
            }
          } else {
            if (field._flattenField) {
              fields.remove(field);
              field._draw();
              --i;
            } else {
              field._save();
            }
          }
        }
        ++i;
      }
      if (_setAppearanceDictionary) {
        _dictionary._setBoolean(
            _DictionaryProperties.needAppearances, _needAppearances);
      }
    }
  }

  void _setSignatureFlags(List<_SignatureFlags> value) {
    int n = 0;
    value.forEach((element) => n |= element.index);
    _dictionary._setNumber(_DictionaryProperties.sigFlags, n);
  }

  String? _getCorrectName(String? name) {
    String? correctName = name;
    if (_fieldNames.contains(name)) {
      final int firstIndex = _fieldNames.indexOf(name);
      final int lastIndex = _fieldNames.lastIndexOf(name);
      if (firstIndex != lastIndex) {
        correctName = name! + '_' + _PdfResources._globallyUniqueIdentifier;
        _fieldNames.removeAt(lastIndex);
        _fieldNames.add(correctName);
      }
    }
    return correctName;
  }

  void _deleteFromPages(PdfField field) {
    final _PdfDictionary dic = field._dictionary;
    final _PdfName kidsName = _PdfName(_DictionaryProperties.kids);
    final _PdfName annotsName = _PdfName(_DictionaryProperties.annots);
    final _PdfName pName = _PdfName(_DictionaryProperties.p);
    final bool isLoaded = field._isLoadedField;
    if (dic._items != null) {
      if (dic.containsKey(kidsName)) {
        final _PdfArray array = (dic[kidsName]) as _PdfArray;
        for (int i = 0; i < array.count; ++i) {
          final _PdfReferenceHolder holder = array[i] as _PdfReferenceHolder;
          final _PdfDictionary? widget = holder.object as _PdfDictionary?;
          _PdfDictionary? page;
          if (!isLoaded) {
            final _PdfReferenceHolder pageRef =
                (widget![pName]) as _PdfReferenceHolder;
            page = (pageRef.object) as _PdfDictionary?;
          } else {
            _PdfReference? pageRef;
            if (widget!.containsKey(pName) &&
                !(widget[_DictionaryProperties.p] is _PdfNull)) {
              pageRef = _crossTable!._getReference(widget[pName]);
            } else if (dic.containsKey(pName) &&
                !(dic[_DictionaryProperties.p] is _PdfNull)) {
              pageRef = _crossTable!._getReference(dic[pName]);
            } else if (field.page != null) {
              pageRef = _crossTable!._getReference(field.page!._dictionary);
            }
            page = _crossTable!._getObject(pageRef) as _PdfDictionary?;
          }
          if (page != null && page.containsKey(annotsName)) {
            _PdfArray? annots;
            if (isLoaded) {
              annots = _crossTable!._getObject(page[annotsName]) as _PdfArray?;
              for (int i = 0; i < annots!.count; i++) {
                final _IPdfPrimitive? obj = annots._elements[i];
                if (obj != null &&
                    obj is _PdfReferenceHolder &&
                    obj.object is _PdfDictionary &&
                    obj.object == holder.object) {
                  annots._remove(obj);
                  break;
                }
              }
              annots.changed = true;
              page.setProperty(annotsName, annots);
            } else {
              if (page[_DictionaryProperties.annots] is _PdfReferenceHolder) {
                final _PdfReferenceHolder annotReference =
                    (page[_DictionaryProperties.annots]) as _PdfReferenceHolder;
                annots = (annotReference.object) as _PdfArray?;
                for (int i = 0; i < annots!.count; i++) {
                  final _IPdfPrimitive? obj = annots._elements[i];
                  if (obj != null &&
                      obj is _PdfReferenceHolder &&
                      obj.object is _PdfDictionary &&
                      obj.object == holder.object) {
                    annots._remove(obj);
                    break;
                  }
                }
                annots.changed = true;
                page.setProperty(_DictionaryProperties.annots, annots);
              } else if (page[_DictionaryProperties.annots] is _PdfArray) {
                if (field._page != null) {
                  final PdfAnnotationCollection? annotCollection =
                      field._page!.annotations;
                  if (annotCollection != null && annotCollection.count > 0) {
                    final int index =
                        annotCollection._annotations._indexOf(holder);
                    if (index >= 0 && index < annotCollection.count) {
                      annotCollection.remove(annotCollection[index]);
                    }
                  }
                }
                if (annots != null && annots._contains(holder)) {
                  annots._remove(holder);
                  annots.changed = true;
                  page.setProperty(_DictionaryProperties.annots, annots);
                }
              }
            }
          } else if (isLoaded) {
            field._requiredReference = holder;
            if (field.page != null &&
                field.page!._dictionary.containsKey(annotsName)) {
              final _PdfArray annots = _crossTable!
                  ._getObject(field.page!._dictionary[annotsName]) as _PdfArray;
              for (int i = 0; i < annots.count; i++) {
                final _IPdfPrimitive? obj = annots._elements[i];
                if (obj != null &&
                    obj is _PdfReferenceHolder &&
                    obj.object is _PdfDictionary &&
                    obj.object == widget) {
                  annots._remove(obj);
                  break;
                }
              }
              annots.changed = true;
            }
            if (_crossTable!._items != null &&
                _crossTable!._items!.contains(widget)) {
              _crossTable!._items!._objectCollection!
                  .remove(_crossTable!._items!._lookFor(widget));
            }
            field._requiredReference = null;
          }
        }
      } else {
        _PdfDictionary? page;
        if (!isLoaded) {
          final _PdfReferenceHolder pageRef = dic.containsKey(pName)
              ? (dic[pName] as _PdfReferenceHolder?)!
              : _PdfReferenceHolder(field._page!._dictionary);
          page = pageRef.object as _PdfDictionary?;
        } else {
          _PdfReference? pageRef;
          if (dic.containsKey(pName) &&
              !(dic[_DictionaryProperties.p] is _PdfNull)) {
            pageRef = _crossTable!._getReference(dic[pName]);
          } else if (field.page != null) {
            pageRef = _crossTable!._getReference(field.page!._dictionary);
          }
          page = _crossTable!._getObject(pageRef) as _PdfDictionary?;
        }
        if (page != null && page.containsKey(_DictionaryProperties.annots)) {
          final _IPdfPrimitive? annots = isLoaded
              ? _crossTable!._getObject(page[annotsName])
              : page[_DictionaryProperties.annots];
          if (annots != null && annots is _PdfArray) {
            for (int i = 0; i < annots.count; i++) {
              final _IPdfPrimitive? obj = annots._elements[i];
              if (obj != null &&
                  obj is _PdfReferenceHolder &&
                  obj.object is _PdfDictionary &&
                  obj.object == dic) {
                annots._remove(obj);
                break;
              }
            }
            annots.changed = true;
            page.setProperty(_DictionaryProperties.annots, annots);
          }
        } else if (isLoaded &&
            field.page != null &&
            field.page!._dictionary.containsKey(annotsName)) {
          final _PdfArray annots = _crossTable!
              ._getObject(field.page!._dictionary[annotsName]) as _PdfArray;
          for (int i = 0; i < annots.count; i++) {
            final _IPdfPrimitive? obj = annots._elements[i];
            if (obj != null &&
                obj is _PdfReferenceHolder &&
                obj.object is _PdfDictionary &&
                obj.object == dic) {
              annots._remove(obj);
              break;
            }
          }
          annots.changed = true;
        }
      }
    }
  }

  void _deleteAnnotation(PdfField field) {
    final _PdfDictionary dic = field._dictionary;
    if (dic._items != null) {
      if (dic.containsKey(_DictionaryProperties.kids)) {
        _PdfArray? array;
        array = !field._isLoadedField
            ? dic[_DictionaryProperties.kids] as _PdfArray?
            : _crossTable!._getObject(dic[_DictionaryProperties.kids])
                as _PdfArray?;
        array!._clear();
        dic.setProperty(_DictionaryProperties.kids, array);
      }
    }
  }

  void _initialize(_PdfDictionary formDictionary, _PdfCrossTable crossTable) {
    _dictionary = formDictionary;
    //Get terminal fields.
    _createFields();
    //Gets NeedAppearance
    if (_dictionary.containsKey(_DictionaryProperties.needAppearances)) {
      final _PdfBoolean needAppearance = _crossTable!
              ._getObject(_dictionary[_DictionaryProperties.needAppearances])
          as _PdfBoolean;
      _needAppearances = needAppearance.value;
      _setAppearanceDictionary = true;
    } else {
      _setAppearanceDictionary = false;
    }
    //Gets resource dictionary
    if (_dictionary.containsKey(_DictionaryProperties.dr)) {
      final _IPdfPrimitive? resources =
          _PdfCrossTable._dereference(_dictionary[_DictionaryProperties.dr]);
      if (resources != null && resources is _PdfDictionary) {
        _resources = _PdfResources(resources);
      }
    }
  }

  //Retrieves the terminal fields.
  void _createFields() {
    _PdfArray? fields;
    if (_dictionary.containsKey(_DictionaryProperties.fields)) {
      final _IPdfPrimitive? obj =
          _crossTable!._getObject(_dictionary[_DictionaryProperties.fields]);
      if (obj != null) {
        fields = obj as _PdfArray;
      }
    }
    int count = 0;
    final Queue<_NodeInfo> nodes = Queue();
    while (true && fields != null) {
      for (; count < fields!.count; ++count) {
        final _IPdfPrimitive? fieldDictionary =
            _crossTable!._getObject(fields[count]);
        _PdfArray? fieldKids;
        if (fieldDictionary != null &&
            fieldDictionary is _PdfDictionary &&
            fieldDictionary.containsKey(_DictionaryProperties.kids)) {
          final _IPdfPrimitive? fieldKid = _crossTable!
              ._getObject(fieldDictionary[_DictionaryProperties.kids]);
          if (fieldKid != null && fieldKid is _PdfArray) {
            fieldKids = fieldKid;
            for (int i = 0; i < fieldKids.count; i++) {
              final _IPdfPrimitive? kidsDict =
                  _PdfCrossTable._dereference(fieldKids[i]);
              if (kidsDict != null &&
                  kidsDict is _PdfDictionary &&
                  !kidsDict.containsKey(_DictionaryProperties.parent)) {
                kidsDict[_DictionaryProperties.parent] =
                    _PdfReferenceHolder(fieldDictionary);
              }
            }
          }
        }
        if (fieldKids == null) {
          if (fieldDictionary != null) {
            if (!_terminalFields.contains(fieldDictionary)) {
              _terminalFields.add(fieldDictionary as _PdfDictionary);
            }
          }
        } else {
          if (!(fieldDictionary as _PdfDictionary)
                  .containsKey(_DictionaryProperties.ft) ||
              _isNode(fieldKids)) {
            nodes.addFirst(_NodeInfo(fields, count));
            _formHasKids = true;
            count = -1;
            fields = fieldKids;
          } else {
            _terminalFields.add(fieldDictionary);
          }
        }
      }
      if (nodes.isEmpty) {
        break;
      }
      final _NodeInfo nInfo = nodes.elementAt(0);
      nodes.removeFirst();
      fields = nInfo._fields;
      count = nInfo._count + 1;
    }
  }

  //Determines whether the specified kids is node.
  bool _isNode(_PdfArray kids) {
    bool isNode = false;
    if (kids.count >= 1) {
      final _PdfDictionary dictionary =
          _crossTable!._getObject(kids[0]) as _PdfDictionary;
      if (dictionary.containsKey(_DictionaryProperties.subtype)) {
        final _PdfName name = _crossTable!
            ._getObject(dictionary[_DictionaryProperties.subtype]) as _PdfName;
        if (name._name != _DictionaryProperties.widget) {
          isNode = true;
        }
      }
    }
    return isNode;
  }

  //Removes field and kids annotation from dictionaries.
  void _removeFromDictionaries(PdfField field) {
    if (_fields != null && _fields!.count > 0) {
      final _PdfName fieldsDict = _PdfName(_DictionaryProperties.fields);
      final _PdfArray fields =
          _crossTable!._getObject(_dictionary[fieldsDict]) as _PdfArray;
      late _PdfReferenceHolder holder;
      for (int i = 0; i < fields._elements.length; i++) {
        final _IPdfPrimitive? obj = fields._elements[i];
        if (obj != null &&
            obj is _PdfReferenceHolder &&
            obj.object is _PdfDictionary &&
            obj.object == field._dictionary) {
          holder = obj;
          break;
        }
      }
      fields._remove(holder);
      fields.changed = true;
      if (!_formHasKids ||
          !(field._dictionary._items!
              .containsKey(_PdfName(_DictionaryProperties.parent)))) {
        for (int i = 0; i < fields.count; i++) {
          final _IPdfPrimitive? fieldDictionary =
              _PdfCrossTable._dereference(_crossTable!._getObject(fields[i]));
          final _PdfName kidsName = _PdfName(_DictionaryProperties.kids);
          if (fieldDictionary != null &&
              fieldDictionary is _PdfDictionary &&
              fieldDictionary.containsKey(kidsName)) {
            final _PdfArray kids =
                _crossTable!._getObject(fieldDictionary[kidsName]) as _PdfArray;
            for (int i = 0; i < kids.count; i++) {
              final _IPdfPrimitive? obj = kids[i];
              if (obj != null &&
                  obj is _PdfReferenceHolder &&
                  obj.object == holder.object) kids._remove(obj);
            }
          }
        }
      } else {
        if (field._dictionary._items!
            .containsKey(_PdfName(_DictionaryProperties.parent))) {
          final _PdfDictionary dic =
              (field._dictionary[_DictionaryProperties.parent]
                      as _PdfReferenceHolder)
                  .object as _PdfDictionary;
          final _PdfArray kids =
              dic._items![_PdfName(_DictionaryProperties.kids)] as _PdfArray;
          for (int k = 0; k < kids.count; k++) {
            final _PdfReferenceHolder kidsReference =
                kids[k] as _PdfReferenceHolder;
            if (kidsReference.object == holder.object) {
              kids._remove(kidsReference);
            }
          }
        }
      }
      _dictionary.setProperty(fieldsDict, fields);
    }
    if (field._isLoadedField) {
      _deleteFromPages(field);
      _deleteAnnotation(field);
    }
  }

  void _checkFlatten() {
    int i = 0;
    while (i < _fields!.count) {
      final PdfField field = _fields![i];
      if (field._flattenField) {
        int? fieldFlag = 0;
        final _PdfDictionary fieldDictionary = field._dictionary;
        if (fieldDictionary.containsKey(_DictionaryProperties.f)) {
          fieldFlag = (fieldDictionary[_DictionaryProperties.f] as _PdfNumber)
              .value as int?;
        }
        if (fieldFlag != 6) {
          _addFieldResourcesToPage(field);
          field._draw();
          _fields!.remove(field);
          _deleteFromPages(field);
          _deleteAnnotation(field);
          --i;
        }
      } else if (field._isLoadedField) {
        field._beginSave();
      } else {
        field._save();
      }
      ++i;
    }
  }

  void _addFieldResourcesToPage(PdfField field) {
    final _PdfResources formResources = field._form!._resources;
    if (formResources.containsKey(_DictionaryProperties.font)) {
      _IPdfPrimitive? fieldFontResource =
          formResources[_DictionaryProperties.font];
      if (fieldFontResource is _PdfReferenceHolder) {
        fieldFontResource = fieldFontResource.object as _PdfDictionary?;
      }
      if (fieldFontResource != null && fieldFontResource is _PdfDictionary) {
        fieldFontResource._items!.keys.forEach((key) {
          final _PdfResources pageResources = field.page!._getResources()!;
          _IPdfPrimitive? pageFontResource =
              pageResources[_DictionaryProperties.font];
          if (pageFontResource is _PdfDictionary) {
          } else if (pageFontResource is _PdfReferenceHolder) {
            pageFontResource = pageFontResource.object as _PdfDictionary?;
          }
          if (pageFontResource == null ||
              (pageFontResource is _PdfDictionary &&
                  !pageFontResource.containsKey(key))) {
            final _PdfReferenceHolder? fieldFontReference = (fieldFontResource
                as _PdfDictionary)[key] as _PdfReferenceHolder?;
            if (pageFontResource == null) {
              final _PdfDictionary fontDictionary = _PdfDictionary();
              fontDictionary._items![key] = fieldFontReference;
              pageResources[_DictionaryProperties.font] = fontDictionary;
            } else {
              (pageFontResource as _PdfDictionary)._items![key] =
                  fieldFontReference;
            }
          }
        });
      }
    }
  }

  void _checkPerms(_PdfCatalog catalog) {
    _IPdfPrimitive? permission = catalog[_DictionaryProperties.perms];
    if (permission is _PdfReferenceHolder) {
      permission =
          (catalog[_DictionaryProperties.perms] as _PdfReferenceHolder).object;
    }
    if (permission != null &&
        permission is _PdfDictionary &&
        permission.containsKey('UR3')) {
      _isUR3 = true;
    }
  }

  //Overrides
  @override
  _IPdfPrimitive get _element => _dictionary;

  @override
  // ignore: unused_element
  set _element(_IPdfPrimitive? value) {
    throw ArgumentError('Primitive element can\'t be set');
  }
}

class _NodeInfo {
  //Constructor
  _NodeInfo(_PdfArray? fields, int count) {
    _fields = fields;
    _count = count;
  }

  //Fields
  _PdfArray? _fields;
  late int _count;
}
