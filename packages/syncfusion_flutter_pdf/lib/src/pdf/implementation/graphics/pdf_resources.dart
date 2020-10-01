part of pdf;

class _PdfResources extends _PdfDictionary {
  //Constructor
  /// Initializes a new instance of the [_PdfResources] class.
  _PdfResources([_PdfDictionary baseDictionary]) : super(baseDictionary);

  //Fields
  Map<_IPdfPrimitive, _PdfName> _resourceNames;

  //Properties
  Map<_IPdfPrimitive, _PdfName> get _names => _getNames();

  //Implementation
  void _requireProcset(String procSetName) {
    ArgumentError.checkNotNull(procSetName);
    _PdfArray procSets = this[_DictionaryProperties.procSet] as _PdfArray;
    if (procSets == null) {
      procSets = _PdfArray();
      this[_DictionaryProperties.procSet] = procSets;
    }
    final _PdfName name = _PdfName(procSetName);
    if (!procSets._contains(name)) {
      procSets._add(name);
    }
  }

  _PdfName _getName(_IPdfWrapper resource) {
    ArgumentError.checkNotNull(resource);
    final _IPdfPrimitive primitive = resource._element;
    _PdfName name;
    if (_names.containsKey(primitive)) {
      name = _names[primitive];
    }
    if (name == null) {
      final String sName = _globallyUniqueIdentifier;
      name = _PdfName(sName);
      _names[primitive] = name;
      if (resource is PdfFont ||
          resource is PdfTemplate ||
          resource is PdfImage ||
          resource is _PdfTransparency) {
        _add(resource, name);
      }
    }
    return name;
  }

  void _add(_IPdfWrapper resource, _PdfName name) {
    if (resource is PdfFont) {
      _PdfDictionary dictionary;
      final _IPdfPrimitive fonts = this[_PdfName(_DictionaryProperties.font)];
      if (fonts != null) {
        if (fonts is _PdfDictionary) {
          dictionary = fonts;
        } else if (fonts is _PdfReferenceHolder) {
          dictionary = _PdfCrossTable._dereference(fonts);
        }
      } else {
        dictionary = _PdfDictionary();
        this[_PdfName(_DictionaryProperties.font)] = dictionary;
      }
      dictionary[name] = _PdfReferenceHolder(resource._element);
    } else if (resource is _PdfTransparency) {
      final _IPdfPrimitive savable = resource._element;
      if (savable != null) {
        _PdfDictionary transDic;
        if (containsKey(_DictionaryProperties.extGState)) {
          final _IPdfPrimitive primitive =
              this[_DictionaryProperties.extGState];
          if (primitive is _PdfDictionary) {
            transDic = primitive;
          } else if (primitive is _PdfReferenceHolder) {
            final _PdfReferenceHolder holder = primitive;
            transDic = holder.object as _PdfDictionary;
          }
        }
        if (transDic == null) {
          transDic = _PdfDictionary();
          this[_DictionaryProperties.extGState] = transDic;
        }
        transDic[name] = _PdfReferenceHolder(savable);
      }
    } else {
      _PdfDictionary xObjects;
      xObjects = this[_PdfName(_DictionaryProperties.xObject)];
      if (xObjects == null) {
        xObjects = _PdfDictionary();
        this[_PdfName(_DictionaryProperties.xObject)] = xObjects;
      }
      xObjects[name] = _PdfReferenceHolder(resource._element);
    }
  }

  Map<_IPdfPrimitive, _PdfName> _getNames() {
    _resourceNames ??= <_IPdfPrimitive, _PdfName>{};
    final _IPdfPrimitive fonts = this[_DictionaryProperties.font];
    if (fonts != null) {
      _PdfDictionary dictionary;
      if (fonts is _PdfDictionary) {
        dictionary = fonts;
      } else if (fonts is _PdfReferenceHolder) {
        dictionary = _PdfCrossTable._dereference(fonts) as _PdfDictionary;
      }
      if (dictionary != null) {
        dictionary._items.forEach(
            (_PdfName name, _IPdfPrimitive value) => _addName(name, value));
      }
    }
    return _resourceNames;
  }

  void _addName(_PdfName name, _IPdfPrimitive value) {
    final _IPdfPrimitive primitive = _PdfCrossTable._dereference(value);
    if (!_resourceNames.containsValue(name)) {
      _resourceNames[primitive] = name;
    }
  }

  static String get _globallyUniqueIdentifier {
    const String format = 'aaaaaaaa-aaaa-4aaa-baaa-aaaaaaaaaaaa';
    String result = '';
    for (int i = 0; i < format.length; i++) {
      if (format[i] == 'a') {
        result += Random().nextInt(15).toRadixString(16);
      } else if (format[i] == 'b') {
        result += (Random().nextInt(15) & 0x3 | 0x8).toRadixString(16);
      } else {
        result += format[i];
      }
    }
    return result;
  }
}
