part of pdf;

class _PdfCatalogNames implements _IPdfWrapper {
  _PdfCatalogNames([_PdfDictionary root]) {
    if (root != null) {
      _dictionary = root;
    }
  }
  //Fields
  _PdfDictionary _dictionary = _PdfDictionary();
  PdfAttachmentCollection _attachments;

  //Properties
  //Gets the destinations.
  _PdfDictionary get _destinations {
    final _IPdfPrimitive obj =
        _PdfCrossTable._dereference(_dictionary[_DictionaryProperties.dests]);
    final _PdfDictionary dests = obj as _PdfDictionary;
    return dests;
  }

  set _embeddedFiles(PdfAttachmentCollection value) {
    ArgumentError.checkNotNull(value, 'value');
    if (_attachments != value) {
      _attachments = value;
      _dictionary.setProperty(_DictionaryProperties.embeddedFiles,
          _PdfReferenceHolder(_attachments));
    }
  }

  //Methods
  //Gets the named object from a tree.
  _IPdfPrimitive _getNamedObjectFromTree(_PdfDictionary root, _PdfString name) {
    bool found = false;
    _PdfDictionary current = root;
    _IPdfPrimitive obj;
    while (!found && current != null && current._items.isNotEmpty) {
      if (current.containsKey(_DictionaryProperties.kids)) {
        current = _getProperKid(current, name);
      } else if (current.containsKey(_DictionaryProperties.names)) {
        obj = _findName(current, name);
        found = true;
      }
    }
    return obj;
  }

  //Finds the name in the tree.
  _IPdfPrimitive _findName(_PdfDictionary current, _PdfString name) {
    final _PdfArray names =
        _PdfCrossTable._dereference(current[_DictionaryProperties.names])
            as _PdfArray;
    final int halfLength = names.count ~/ 2;
    int lowIndex = 0, topIndex = halfLength - 1, half = 0;
    bool found = false;
    while (!found) {
      half = (lowIndex + topIndex) ~/ 2;
      if (lowIndex > topIndex) {
        break;
      }
      final _PdfString str =
          _PdfCrossTable._dereference(names[half * 2]) as _PdfString;
      final int cmp = _byteCompare(name, str);
      if (cmp > 0) {
        lowIndex = half + 1;
      } else if (cmp < 0) {
        topIndex = half - 1;
      } else {
        found = true;
        break;
      }
    }
    _IPdfPrimitive obj;
    if (found) {
      obj = _PdfCrossTable._dereference(names[half * 2 + 1]);
    }
    return obj;
  }

  //Gets the proper kid from an array.
  _PdfDictionary _getProperKid(_PdfDictionary current, _PdfString name) {
    final _PdfArray kids =
        _PdfCrossTable._dereference(current[_DictionaryProperties.kids])
            as _PdfArray;
    _PdfDictionary kid;
    for (final obj in kids._elements) {
      kid = _PdfCrossTable._dereference(obj) as _PdfDictionary;
      if (_checkLimits(kid, name)) {
        break;
      } else {
        kid = null;
      }
    }
    return kid;
  }

  // Checks the limits of the named tree node.
  bool _checkLimits(_PdfDictionary kid, _PdfString name) {
    _IPdfPrimitive obj = kid[_DictionaryProperties.limits];
    bool result = false;
    if (obj is _PdfArray && obj.count >= 2) {
      final _PdfArray limits = obj;
      obj = limits[0];
      final _PdfString lowerLimit = obj as _PdfString;
      obj = limits[1];
      final _PdfString higherLimit = obj as _PdfString;
      final int lowCmp = _byteCompare(lowerLimit, name);
      final int hiCmp = _byteCompare(higherLimit, name);
      if (lowCmp == 0 || hiCmp == 0) {
        result = true;
      } else if (lowCmp < 0 && hiCmp > 0) {
        result = true;
      }
    }
    return result;
  }

  int _byteCompare(_PdfString str1, _PdfString str2) {
    final List<int> data1 = str1.data;
    final List<int> data2 = str2.data;
    final int commonSize = [data1.length, data2.length].reduce(min);
    int result = 0;
    for (int i = 0; i < commonSize; ++i) {
      final int byte1 = data1[i];
      final int byte2 = data2[i];
      result = byte1 - byte2;
      if (result != 0) {
        break;
      }
    }
    if (result == 0) {
      result = data1.length - data2.length;
    }
    return result;
  }

  // Clear catalog names.
  void clear() {
    if (_dictionary != null) {
      _dictionary.clear();
    }
  }

  //Overrides
  @override
  _IPdfPrimitive get _element => _dictionary;

  @override
  set _element(_IPdfPrimitive value) {
    throw ArgumentError('primitive elements can\'t be set');
  }
}
