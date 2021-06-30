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
    _crossTable!._document!._catalog._beginSaveList ??=
        <_SavePdfPrimitiveCallback>[];
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
  final List<_PdfDictionary> _terminalFields = <_PdfDictionary>[];
  bool _formHasKids = false;
  bool _isLoadedForm = false;
  bool _isDefaultAppearance = true;
  Map<String?, List<_PdfDictionary>>? _widgetDictionary;
  bool _readOnly = false;
  bool _isUR3 = false;
  // ignore: prefer_final_fields
  List<_SignatureFlags> _signatureFlags = <_SignatureFlags>[
    _SignatureFlags.none
  ];

  /// Gets or sets a value indicating whether field auto naming.
  ///
  /// The default value is true.
  bool fieldAutoNaming = true;

  /// Gets or sets the ExportEmptyFields property, enabling this will export
  /// the empty acroform fields.
  ///
  /// The default value is false.
  bool exportEmptyFields = false;

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

  /// Imports form value from base 64 string to the file with the specific [DataFormat].
  void importDataFromBase64String(String base64String, DataFormat dataFormat,
      [bool continueImportOnError = false]) {
    importData(base64.decode(base64String).toList(), dataFormat,
        continueImportOnError);
  }

  /// Imports form value to the file with the specific [DataFormat].
  void importData(List<int> inputBytes, DataFormat dataFormat,
      [bool continueImportOnError = false]) {
    if (dataFormat == DataFormat.fdf) {
      _importDataFDF(inputBytes, continueImportOnError);
    } else if (dataFormat == DataFormat.json) {
      _importDataJSON(inputBytes, continueImportOnError);
    } else if (dataFormat == DataFormat.xfdf) {
      _importDataXFDF(inputBytes);
    } else if (dataFormat == DataFormat.xml) {
      _importDataXml(inputBytes, continueImportOnError);
    }
  }

  /// Export the form data to a file with the specific [DataFormat] and form name.
  List<int> exportData(DataFormat dataFormat, [String formName = '']) {
    List<int>? data;
    if (dataFormat == DataFormat.fdf) {
      data = _exportDataFDF(formName);
    } else if (dataFormat == DataFormat.xfdf) {
      data = _exportDataXFDF(formName);
    } else if (dataFormat == DataFormat.json) {
      data = _exportDataJSON();
    } else if (dataFormat == DataFormat.xml) {
      data = _exportDataXML();
    }
    return data!;
  }

  /// Imports XFDF Data from the given data.
  void _importDataXFDF(List<int> bytes) {
    final String data = String.fromCharCodes(bytes);
    final XmlDocument xmlDoc = XmlDocument.parse(data);
    PdfField formField;
    for (final XmlNode node in xmlDoc.rootElement.firstElementChild!.children) {
      if (node is XmlElement) {
        final String fieldName = node.attributes.first.value;
        final int index = fields._getFieldIndex(fieldName);
        formField = fields[index];
        final String fieldInnerValue = node.firstElementChild!.innerText;
        formField._importFieldValue(fieldInnerValue);
      }
    }
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
        final PdfField field = fields[i];
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
            final int? index = _crossTable!._items!._lookFor(field._dictionary);
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
        ++i;
      }
      if (_setAppearanceDictionary) {
        _dictionary._setBoolean(
            _DictionaryProperties.needAppearances, _needAppearances);
      }
      _dictionary.remove('XFA');
    }
  }

  void _setSignatureFlags(List<_SignatureFlags> value) {
    int n = 0;
    for (final _SignatureFlags element in value) {
      n |= element.index;
    }
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
        final _PdfArray array = dic[kidsName]! as _PdfArray;
        for (int i = 0; i < array.count; ++i) {
          final _PdfReferenceHolder holder = array[i]! as _PdfReferenceHolder;
          final _PdfDictionary? widget = holder.object as _PdfDictionary?;
          _PdfDictionary? page;
          if (!isLoaded) {
            final _PdfReferenceHolder pageRef =
                widget![pName]! as _PdfReferenceHolder;
            page = pageRef.object as _PdfDictionary?;
          } else {
            _PdfReference? pageRef;
            if (widget!.containsKey(pName) &&
                widget[_DictionaryProperties.p] is! _PdfNull) {
              pageRef = _crossTable!._getReference(widget[pName]);
            } else if (dic.containsKey(pName) &&
                dic[_DictionaryProperties.p] is! _PdfNull) {
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
                    page[_DictionaryProperties.annots]! as _PdfReferenceHolder;
                annots = annotReference.object as _PdfArray?;
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
                  final PdfAnnotationCollection annotCollection =
                      field._page!.annotations;
                  if (annotCollection.count > 0) {
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
              final _PdfArray annots =
                  _crossTable!._getObject(field.page!._dictionary[annotsName])!
                      as _PdfArray;
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
                  .removeAt(_crossTable!._items!._lookFor(widget)!);
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
              dic[_DictionaryProperties.p] is! _PdfNull) {
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
              ._getObject(field.page!._dictionary[annotsName])! as _PdfArray;
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
              ._getObject(_dictionary[_DictionaryProperties.needAppearances])!
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
    final Queue<_NodeInfo> nodes = Queue<_NodeInfo>();
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
          if (!(fieldDictionary! as _PdfDictionary)
                  .containsKey(_DictionaryProperties.ft) ||
              _isNode(fieldKids)) {
            nodes.addFirst(_NodeInfo(fields, count));
            _formHasKids = true;
            count = -1;
            fields = fieldKids;
          } else {
            _terminalFields.add(fieldDictionary as _PdfDictionary);
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
          _crossTable!._getObject(kids[0])! as _PdfDictionary;
      if (dictionary.containsKey(_DictionaryProperties.subtype)) {
        final _PdfName name = _crossTable!
            ._getObject(dictionary[_DictionaryProperties.subtype])! as _PdfName;
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
          _crossTable!._getObject(_dictionary[fieldsDict])! as _PdfArray;
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
          !field._dictionary._items!
              .containsKey(_PdfName(_DictionaryProperties.parent))) {
        for (int i = 0; i < fields.count; i++) {
          final _IPdfPrimitive? fieldDictionary =
              _PdfCrossTable._dereference(_crossTable!._getObject(fields[i]));
          final _PdfName kidsName = _PdfName(_DictionaryProperties.kids);
          if (fieldDictionary != null &&
              fieldDictionary is _PdfDictionary &&
              fieldDictionary.containsKey(kidsName)) {
            final _PdfArray kids = _crossTable!
                ._getObject(fieldDictionary[kidsName])! as _PdfArray;
            for (int i = 0; i < kids.count; i++) {
              final _IPdfPrimitive? obj = kids[i];
              if (obj != null &&
                  obj is _PdfReferenceHolder &&
                  obj.object == holder.object) {
                kids._remove(obj);
              }
            }
          }
        }
      } else {
        if (field._dictionary._items!
            .containsKey(_PdfName(_DictionaryProperties.parent))) {
          final _PdfDictionary dic =
              (field._dictionary[_DictionaryProperties.parent]!
                      as _PdfReferenceHolder)
                  .object! as _PdfDictionary;
          final _PdfArray kids =
              dic._items![_PdfName(_DictionaryProperties.kids)]! as _PdfArray;
          for (int k = 0; k < kids.count; k++) {
            final _PdfReferenceHolder kidsReference =
                kids[k]! as _PdfReferenceHolder;
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
          fieldFlag = (fieldDictionary[_DictionaryProperties.f]! as _PdfNumber)
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
        // ignore: avoid_function_literals_in_foreach_calls
        fieldFontResource._items!.keys.forEach((_PdfName? key) {
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
            final _PdfReferenceHolder? fieldFontReference = (fieldFontResource!
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
          (catalog[_DictionaryProperties.perms]! as _PdfReferenceHolder).object;
    }
    if (permission != null &&
        permission is _PdfDictionary &&
        permission.containsKey('UR3')) {
      _isUR3 = true;
    }
  }

  /// Imports form value from FDF file.
  void _importDataFDF(List<int> inputBytes, bool continueImportOnError) {
    final _PdfReader reader = _PdfReader(inputBytes);
    reader.position = 0;
    String? token = reader._getNextToken();
    if (token != null && token.startsWith('%')) {
      token = reader._getNextToken();
      if (token != null && !token.startsWith('FDF-')) {
        throw ArgumentError(
            'The source is not a valid FDF file because it does not start with"%FDF-"');
      }
    }
    final Map<String, List<String>> table = <String, List<String>>{};
    String? fieldName = '';
    token = reader._getNextToken();
    while (token != null && token.isNotEmpty) {
      if (token.toUpperCase() == 'T') {
        final List<String?> out = _getFieldName(reader, token);
        fieldName = out[0];
        token = out[1];
      }
      if (token != null && token.toUpperCase() == 'V') {
        _getFieldValue(reader, token, fieldName!, table);
      }
      token = reader._getNextToken();
    }
    PdfField? field;
    table.forEach((String k, List<String> v) {
      try {
        final int index = fields._getFieldIndex(k.toString());
        if (index == -1) {
          throw ArgumentError('Incorrect field name.');
        }
        field = fields[index];
        if (field != null) {
          field!._importFieldValue(v);
        }
      } catch (e) {
        if (!continueImportOnError) {
          rethrow;
        }
      }
    });
  }

  /// Export the form data in FDF file format.
  List<int> _exportDataFDF(String formName) {
    List<int> bytes = <int>[];
    final _PdfString headerString = _PdfString('%FDF-1.2\n')
      ..encode = _ForceEncoding.ascii;
    bytes.addAll(headerString.value!.codeUnits);
    int count = 1;
    for (int i = 0; i < fields.count; i++) {
      final PdfField field = fields[i];
      field._exportEmptyField = exportEmptyFields;
      if (field.canExport && field._isLoadedField) {
        final Map<String, dynamic> out = field._exportField(bytes, count);
        bytes = out['bytes'] as List<int>;
        count = out['objectID'] as int;
      }
    }
    final _PdfString formNameEncodedString = _PdfString(formName)
      ..encode = _ForceEncoding.ascii;
    final StringBuffer buffer = StringBuffer();
    buffer.write(
        '$count 0 obj<</F <${_PdfString._bytesToHex(formNameEncodedString.value!.codeUnits)}>  /Fields [');
    for (int i = 0; i < fields.count; i++) {
      final PdfField field = fields[i];
      if (field._isLoadedField && field.canExport && field._objectID != 0) {
        buffer.write('${field._objectID} 0 R ');
      }
    }
    buffer.write(']>>endobj\n');
    buffer.write('${count + 1} 0 obj<</Version /1.4 /FDF $count 0 R>>endobj\n');
    buffer.write('trailer\n<</Root ${count + 1} 0 R>>\n');
    final _PdfString fdfString = _PdfString(buffer.toString())
      ..encode = _ForceEncoding.ascii;
    bytes.addAll(fdfString.value!.codeUnits);
    return bytes;
  }

  List<String?> _getFieldName(_PdfReader reader, String? token) {
    String? fieldname = '';
    token = reader._getNextToken();
    if (token != null && token.isNotEmpty) {
      if (token == '<') {
        token = reader._getNextToken();
        if (token != null && token.isNotEmpty && token != '>') {
          final _PdfString str = _PdfString('');
          final List<int> buffer = str._hexToBytes(token);
          token = _PdfString._byteToString(buffer);
          fieldname = token;
        }
      } else {
        token = reader._getNextToken();
        if (token != null && token.isNotEmpty) {
          String? str = ' ';
          while (str != ')') {
            str = reader._getNextToken();
            if (str != null && str.isNotEmpty && str != ')') {
              token = token! + ' ' + str;
            }
          }
          fieldname = token;
          token = str;
        }
      }
    }
    return <String?>[fieldname, token];
  }

  void _getFieldValue(_PdfReader reader, String? token, String fieldName,
      Map<String, List<String>> table) {
    token = reader._getNextToken();
    if (token != null && token.isNotEmpty) {
      if (token == '[') {
        token = reader._getNextToken();
        if (token != null && token.isNotEmpty) {
          final List<String> fieldValues = <String>[];
          while (token != ']') {
            token = _fieldValue(
                reader, token!, true, table, fieldName, fieldValues);
          }
          if (!table.containsKey(fieldName) && fieldValues.isNotEmpty) {
            table[fieldName] = fieldValues;
          }
        }
      } else {
        _fieldValue(reader, token, false, table, fieldName, null);
      }
    }
  }

  String? _fieldValue(
      _PdfReader reader,
      String? token,
      bool isMultiSelect,
      Map<String, List<String>> table,
      String fieldName,
      List<String>? fieldValues) {
    if (token == '<') {
      token = reader._getNextToken();
      if (token != null && token.isNotEmpty && token != '>') {
        final _PdfString str = _PdfString('');
        final List<int> buffer = str._hexToBytes(token);
        token = _PdfString._byteToString(buffer);
        if (isMultiSelect && fieldValues != null) {
          fieldValues.add(token);
        } else if (!table.containsKey(fieldName)) {
          table[fieldName] = <String>[token];
        }
      }
    } else {
      if (isMultiSelect && fieldValues != null) {
        while (token != '>' && token != ')' && token != ']') {
          if (token != null &&
              token.isNotEmpty &&
              (token == '/' || token != ')')) {
            token = reader._getNextToken();
            if (token != null &&
                token.isNotEmpty &&
                token != '>' &&
                token != ')') {
              String? str = ' ';
              while (str != ')' && str != '>') {
                str = reader._getNextToken();
                if (str != null &&
                    str.isNotEmpty &&
                    str != '>' &&
                    str != ')' &&
                    str != '/') {
                  token = token! + ' ' + str;
                }
                fieldValues.add(token!);
              }
            }
          }
          token = reader._getNextToken();
        }
      } else {
        while (token != '>' && token != ')') {
          if (token != null &&
              token.isNotEmpty &&
              (token == '/' || token != ')')) {
            token = reader._getNextToken();
            if (token != null &&
                token.isNotEmpty &&
                token != '>' &&
                token != ')') {
              String? str = ' ';
              while (str != ')' && str != '>') {
                str = reader._getNextToken();
                if (str != null &&
                    str.isNotEmpty &&
                    str != '>' &&
                    str != ')' &&
                    str != '/') {
                  token = token! + ' ' + str;
                }
              }
              if (!table.containsKey(fieldName)) {
                table[fieldName] = <String>[token!];
              }
            }
          }
          token = reader._getNextToken();
        }
      }
    }
    return token;
  }

  List<int> _exportDataXFDF(String formName) {
    final _XFdfDocument xfdf = _XFdfDocument(formName);
    for (int i = 0; i < fields.count; i++) {
      final PdfField field = fields[i];
      if (field.canExport) {
        field._exportEmptyField = exportEmptyFields;
        final _IPdfPrimitive? name = PdfField._getValue(field._dictionary,
            field._crossTable, _DictionaryProperties.ft, true);
        if (name != null && name is _PdfName) {
          switch (name._name) {
            case 'Tx':
              final _IPdfPrimitive? fieldValue = PdfField._getValue(
                  field._dictionary,
                  field._crossTable,
                  _DictionaryProperties.v,
                  true);
              if (fieldValue is _PdfString) {
                xfdf._setFields(field.name!, fieldValue.value!);
              } else if (exportEmptyFields) {
                xfdf._setFields(field.name!, '');
              }
              break;
            case 'Ch':
              if (field is PdfListBoxField) {
                final _IPdfPrimitive? primitive = PdfField._getValue(
                    field._dictionary,
                    field._crossTable,
                    _DictionaryProperties.v,
                    true);
                if (primitive is _PdfArray) {
                  xfdf._setFields(field.name!, primitive);
                } else if (primitive is _PdfString) {
                  xfdf._setFields(field.name!, primitive.value!);
                } else if (exportEmptyFields) {
                  xfdf._setFields(field.name!, '');
                }
              } else {
                final _IPdfPrimitive? listField = PdfField._getValue(
                    field._dictionary,
                    field._crossTable,
                    _DictionaryProperties.v,
                    true);
                if (listField is _PdfName) {
                  xfdf._setFields(field._name!, listField._name!);
                } else {
                  final _IPdfPrimitive? comboValue = PdfField._getValue(
                      field._dictionary,
                      field._crossTable,
                      _DictionaryProperties.v,
                      true);
                  if (comboValue is _PdfString) {
                    xfdf._setFields(field.name!, comboValue.value!);
                  } else if (exportEmptyFields) {
                    xfdf._setFields(field.name!, '');
                  }
                }
              }
              break;
            case 'Btn':
              final _IPdfPrimitive? buttonFieldPrimitive = PdfField._getValue(
                  field._dictionary,
                  field._crossTable,
                  _DictionaryProperties.v,
                  true);
              if (buttonFieldPrimitive != null) {
                final String? value =
                    field._getExportValue(field, buttonFieldPrimitive);
                if (value != null && value.isNotEmpty) {
                  xfdf._setFields(field.name!, value);
                } else if (field is PdfRadioButtonListField ||
                    field is PdfCheckBoxField) {
                  if (exportEmptyFields) {
                    xfdf._setFields(field.name!, '');
                  } else {
                    xfdf._setFields(field.name!, _DictionaryProperties.off);
                  }
                }
              } else {
                if (field is PdfRadioButtonListField) {
                  xfdf._setFields(
                      field.name!, field._getAppearanceStateValue(field));
                } else {
                  final _PdfDictionary holder = field._getWidgetAnnotation(
                      field._dictionary, field._crossTable);
                  final _IPdfPrimitive? holderName =
                      holder[_DictionaryProperties.usageApplication];
                  if (holderName is _PdfName) {
                    xfdf._setFields(field.name!, holderName._name!);
                  } else if (exportEmptyFields) {
                    xfdf._setFields(field.name!, '');
                  }
                }
              }
              break;
          }
        }
      }
    }
    return xfdf._save();
  }

  void _importDataJSON(List<int> bytes, bool continueImportOnError) {
    String? fieldKey, fieldValue;
    final Map<String, String> table = <String, String>{};
    final _PdfReader reader = _PdfReader(bytes);
    String? token = reader._getNextJsonToken();
    reader.position = 0;
    while (token != null && token.isNotEmpty) {
      if (token != '{' && token != '}' && token != '"' && token != ',') {
        fieldKey = token;
        do {
          token = reader._getNextJsonToken();
        } while (token != ':');
        do {
          token = reader._getNextJsonToken();
        } while (token != '"');
        token = reader._getNextJsonToken();
        if (token != '"') {
          fieldValue = token;
        }
      }
      if (fieldKey != null && fieldValue != null) {
        table[_decodeXMLConversion(fieldKey)] =
            _decodeXMLConversion(fieldValue);
        fieldKey = fieldValue = null;
      }
      token = reader._getNextJsonToken();
    }
    PdfField? field;
    table.forEach((String k, String v) {
      try {
        final int index = fields._getFieldIndex(k.toString());
        if (index == -1) {
          throw ArgumentError('Incorrect field name.');
        }
        field = fields[index];
        if (field != null) {
          field!._importFieldValue(v);
        }
      } catch (e) {
        if (!continueImportOnError) {
          rethrow;
        }
      }
    });
  }

  List<int> _exportDataJSON() {
    final List<int> bytes = <int>[];
    final Map<String, String> table = <String, String>{};
    for (int i = 0; i < fields.count; i++) {
      final PdfField field = fields[i];
      if (field._isLoadedField && field.canExport) {
        final _IPdfPrimitive? name = PdfField._getValue(field._dictionary,
            field._crossTable, _DictionaryProperties.ft, true);
        if (name != null && name is _PdfName)
          switch (name._name) {
            case 'Tx':
              final _IPdfPrimitive? textField = PdfField._getValue(
                  field._dictionary,
                  field._crossTable,
                  _DictionaryProperties.v,
                  true);
              if (textField != null && textField is _PdfString) {
                table[field.name!] = textField.value!;
              }
              break;
            case 'Ch':
              if (field is PdfListBoxField || field is PdfComboBoxField) {
                final _IPdfPrimitive? listValue = PdfField._getValue(
                    field._dictionary,
                    field._crossTable,
                    _DictionaryProperties.v,
                    true);
                if (listValue != null) {
                  final String? value = field._getExportValue(field, listValue);
                  if (value != null && value.isNotEmpty) {
                    table[field.name!] = value;
                  }
                }
              }
              break;
            case 'Btn':
              final _IPdfPrimitive? buttonFieldPrimitive = PdfField._getValue(
                  field._dictionary,
                  field._crossTable,
                  _DictionaryProperties.v,
                  true);
              if (buttonFieldPrimitive != null) {
                final String? value =
                    field._getExportValue(field, buttonFieldPrimitive);
                if (value != null && value.isNotEmpty) {
                  table[field.name!] = value;
                } else if (field is PdfRadioButtonListField ||
                    field is PdfCheckBoxField) {
                  table[field.name!] = 'Off';
                }
              } else {
                if (field is PdfRadioButtonListField) {
                  table[field.name!] = field._getAppearanceStateValue(field);
                } else {
                  final _PdfDictionary holder = field._getWidgetAnnotation(
                      field._dictionary, field._crossTable);
                  final _IPdfPrimitive? holderName =
                      holder[_DictionaryProperties.usageApplication];
                  if (holderName != null && holderName is _PdfName) {
                    table[field.name!] = holderName._name!;
                  }
                }
              }
              break;
          }
      }
    }
    bytes.addAll(utf8.encode('{'));
    String json;
    int j = 0;
    table.forEach((String k, String v) {
      json = '"${_replaceJsonDelimiters(k)}":"${_replaceJsonDelimiters(v)}"';
      bytes.addAll(utf8.encode(j > 0 ? ',$json' : json));
      j++;
    });
    bytes.addAll(utf8.encode('}'));
    return bytes;
  }

  String _replaceJsonDelimiters(String value) {
    // ignore: unnecessary_string_escapes
    return value.contains(RegExp('[":,{}]|[\[]|]'))
        ? value
            .replaceAll(',', '_x002C_')
            .replaceAll('"', '_x0022_')
            .replaceAll(':', '_x003A_')
            .replaceAll('{', '_x007B_')
            .replaceAll('}', '_x007D_')
            .replaceAll('[', '_x005B_')
            .replaceAll(']', '_x005D_')
        : value;
  }

  String _decodeXMLConversion(String value) {
    String newString = value;
    while (newString.contains('_x')) {
      final int index = newString.indexOf('_x');
      final String tempString = newString.substring(index);
      if (tempString.length >= 7 && tempString[6] == '_') {
        newString = newString.replaceRange(index, index + 2, '--');
        final int? charCode =
            int.tryParse(value.substring(index + 2, index + 6), radix: 16);
        if (charCode != null && charCode >= 0) {
          value = value.replaceRange(
              index, index + 7, String.fromCharCode(charCode));
          newString = newString.replaceRange(index, index + 7, '-');
        }
      } else {
        break;
      }
    }
    return value;
  }

  /// Imports XML Data from the given data.
  void _importDataXml(List<int> bytes, bool continueImportOnError) {
    final String data = String.fromCharCodes(bytes);
    final XmlDocument document = XmlDocument.parse(data);
    if (document.rootElement.name.local != 'Fields') {
      ArgumentError.value('The XML form data stream is not valid');
    } else {
      _importXmlData(document.rootElement.children, continueImportOnError);
    }
  }

  void _importXmlData(List<XmlNode> children, bool continueImportOnError) {
    for (final XmlNode childNode in children) {
      if (childNode is XmlElement) {
        if (childNode.innerText.isNotEmpty) {
          String fieldName = childNode.name.local.replaceAll('_x0020_', ' ');
          fieldName = fieldName
              .replaceAll('_x0023_', '#')
              .replaceAll('_x002C_', ',')
              .replaceAll('_x005C_', r'\')
              .replaceAll('_x0022_', '"')
              .replaceAll('_x003A_', ':')
              .replaceAll('_x005D_', ']')
              .replaceAll('_x005D_', ']')
              .replaceAll('_x007B_', '{')
              .replaceAll('_x007D_', '}')
              .replaceAll('_x0024_', r'$');
          try {
            final int index = fields._getFieldIndex(fieldName);
            if (index == -1) {
              throw ArgumentError('Incorrect field name.');
            }
            final PdfField formField = fields[index];
            formField._importFieldValue(childNode.innerText);
          } catch (e) {
            if (!continueImportOnError) {
              rethrow;
            }
          }
        }
        if (childNode.children.isNotEmpty) {
          _importXmlData(childNode.children, continueImportOnError);
        }
      }
    }
  }

  List<int> _exportDataXML() {
    final XmlBuilder builder = XmlBuilder();
    final List<XmlElement> elements = <XmlElement>[];
    builder.processing('xml', 'version="1.0" encoding="utf-8"');
    for (int i = 0; i < fields.count; i++) {
      final PdfField field = fields[i];
      if (field.canExport) {
        field._exportEmptyField = exportEmptyFields;
        final XmlElement? element = field._exportFieldForXml();
        if (element != null) {
          elements.add(element);
        }
      }
    }
    builder.element('Fields', nest: elements);
    return utf8.encode(builder.buildDocument().toXmlString(pretty: true));
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
