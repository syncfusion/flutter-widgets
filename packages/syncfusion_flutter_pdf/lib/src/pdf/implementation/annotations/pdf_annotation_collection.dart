part of pdf;

/// Represents the collection of [PdfAnnotation] objects.
class PdfAnnotationCollection extends PdfObjectCollection
    implements _IPdfWrapper {
  // constructor
  /// Initializes a new instance of the [PdfAnnotationCollection]
  /// class with the specified page.
  PdfAnnotationCollection(PdfPage page) : super() {
    _page = page;
  }

  PdfAnnotationCollection._(PdfPage page) : super() {
    _page = page;
    for (int i = 0; i < _page._terminalAnnotation.length; ++i) {
      final PdfAnnotation? annot = _getAnnotation(i);
      if (annot != null) {
        _doAdd(annot);
      }
    }
  }

  // Fields
  late PdfPage _page;
  _PdfArray _annotations = _PdfArray();
  bool _flatten = false;

  // Properties
  /// Sets the annotation flatten.
  set _flattenAll(bool value) {
    _flatten = value;
    if (_flatten && _page._document != null) {
      final _PdfCrossTable? cross = _page._crossTable;
      if (cross != null &&
          _page._dictionary.containsKey(_DictionaryProperties.annots)) {
        final _PdfArray? annots =
            cross._getObject(_page._dictionary[_DictionaryProperties.annots])
                as _PdfArray?;
        if (annots != null) {
          for (int count = 0; count < annots.count; ++count) {
            final _PdfDictionary? annotDicrionary =
                cross._getObject(annots[count]) as _PdfDictionary?;
            if (annotDicrionary != null) {
              if (annotDicrionary.containsKey(_DictionaryProperties.ft)) {
                annotDicrionary.remove(_DictionaryProperties.ft);
              }
              if (annotDicrionary.containsKey(_DictionaryProperties.v)) {
                annotDicrionary.remove(_DictionaryProperties.v);
              }
            }
          }
        }
      }
    }
  }

  /// Gets the annotations array.
  _PdfArray get _internalAnnotations => _annotations;
  set _internalAnnotations(_PdfArray? value) {
    if (value != null) {
      _annotations = value;
    }
  }

  // public methods
  /// Gets the PdfAnnotation at the specified index.
  PdfAnnotation operator [](int index) {
    if (index < 0 || index >= count) {
      throw ArgumentError('$index, Index is out of range.');
    }
    final PdfAnnotation annotation = _list[index] as PdfAnnotation;
    if (!_page._isLoadedPage) {
      return annotation;
    } else {
      annotation._isLoadedAnnotation
          ? annotation._page = _page
          : annotation._setPage(_page);
    }
    return annotation;
  }

  /// Adds a new annotation to the collection.
  int add(PdfAnnotation annotation) {
    return _doAdd(annotation);
  }

  /// Removes the specified annotation from the collection.
  void remove(PdfAnnotation annot) {
    _doRemove(annot);
  }

  /// Determines whether a specified annotation is in the annotation collection.
  bool contains(PdfAnnotation annotation) {
    return _list.contains(annotation);
  }

  /// Flatten all the annotations.
  ///
  /// The flatten will add at the time of saving the current document.
  void flattenAllAnnotations() {
    _flattenAll = true;
  }

  // implementation
  int _doAdd(PdfAnnotation annot) {
    if (_flatten) {
      annot._flatten = true;
    }
    annot._setPage(_page);
    if (_page._isLoadedPage) {
      _PdfArray? array;
      if (_page._dictionary.containsKey(_DictionaryProperties.annots)) {
        array = _PdfCrossTable._dereference(
            _page._dictionary[_DictionaryProperties.annots]) as _PdfArray?;
      }
      array ??= _PdfArray();
      final _PdfReferenceHolder reference =
          _PdfReferenceHolder(annot._dictionary);
      if (!_checkPresence(array, reference)) {
        array._add(reference);
        _page._dictionary.setProperty(_DictionaryProperties.annots, array);
      }
    }
    annot._element ??= annot._dictionary;
    _annotations._add(_PdfReferenceHolder(annot));
    _list.add(annot);
    return count - 1;
  }

  bool _checkPresence(_PdfArray array, _PdfReferenceHolder reference) {
    bool result = false;
    result = array._contains(reference);
    if (!result) {
      for (int i = 0; i < array._elements.length; i++) {
        if (array._elements[i] is _PdfReferenceHolder) {
          final _PdfReferenceHolder holder =
              array._elements[i] as _PdfReferenceHolder;
          if (holder.object == reference.object) {
            result = true;
            break;
          }
        }
      }
    }
    return result;
  }

  void _doRemove(PdfAnnotation annot) {
    if (_page._isLoadedPage) {
      _removeFromDictionaries(annot);
    }
    final int index = _list.indexOf(annot);
    _annotations._elements.removeAt(index);
    _list.removeAt(index);
  }

  void _removeFromDictionaries(PdfAnnotation annot) {
    final _PdfDictionary pageDic = _page._dictionary;
    _PdfArray? annots;
    if (pageDic.containsKey(_DictionaryProperties.annots)) {
      annots = _page._crossTable!
          ._getObject(pageDic[_DictionaryProperties.annots]) as _PdfArray?;
    } else {
      annots = _PdfArray();
    }
    if (annot._dictionary.containsKey(_DictionaryProperties.popup)) {
      final _IPdfPrimitive? popUpDictionary =
          (annot._dictionary[_PdfName(_DictionaryProperties.popup)]
                  is _PdfReferenceHolder)
              ? (annot._dictionary[_PdfName(_DictionaryProperties.popup)]
                      as _PdfReferenceHolder)
                  .object
              : annot._dictionary[_PdfName(_DictionaryProperties.popup)];
      if (popUpDictionary is _PdfDictionary) {
        for (int i = 0; i < annots!.count; i++) {
          if (popUpDictionary ==
              _page._crossTable!._getObject(annots[i]) as _PdfDictionary?) {
            annots._elements.removeAt(i);
            annots._isChanged = true;
            break;
          }
        }
        final _IPdfPrimitive popUpObj =
            _page._crossTable!._getObject(popUpDictionary)!;
        final int? popUpIndex = _page._crossTable!._items!._lookFor(popUpObj);
        if (popUpIndex != null && popUpIndex != -1) {
          _page._crossTable!._items!._objectCollection!.removeAt(popUpIndex);
        }
        _removeAllReference(popUpObj);
        _page._terminalAnnotation.remove(popUpDictionary);
      }
    }
    for (int i = 0; i < annots!.count; i++) {
      if (annot._dictionary ==
          _page._crossTable!._getObject(annots[i]) as _PdfDictionary?) {
        annots._elements.removeAt(i);
        annots._isChanged = true;
        break;
      }
    }
    annot._dictionary._isChanged = false;
    _page._dictionary.setProperty(_DictionaryProperties.annots, annots);
  }

  void _removeAllReference(_IPdfPrimitive obj) {
    final _IPdfPrimitive? dictionary =
        obj is _PdfReferenceHolder ? obj.object : obj;
    if (dictionary is _PdfDictionary) {
      dictionary._items!.forEach((k, v) {
        if ((v is _PdfReferenceHolder || v is _PdfDictionary) &&
            k!._name != _DictionaryProperties.p &&
            k._name != _DictionaryProperties.parent) {
          final _IPdfPrimitive newobj = _page._crossTable!._getObject(v)!;
          final int? index = _page._crossTable!._items!._lookFor(newobj);
          if (index != null && index != -1) {
            _page._crossTable!._items!._objectCollection!.removeAt(index);
          }
          _removeAllReference(v!);
          (_PdfCrossTable._dereference(v) as _PdfStream)
            ..dispose()
            .._isChanged = false;
        }
      });
    }
  }

  // Gets the annotation.
  PdfAnnotation? _getAnnotation(int index) {
    final _PdfDictionary dictionary = _page._terminalAnnotation[index];
    final _PdfCrossTable? crossTable = _page._crossTable;
    PdfAnnotation? annot;
    if (dictionary.containsKey(_DictionaryProperties.subtype)) {
      final _PdfName name = PdfAnnotation._getValue(
              dictionary, crossTable, _DictionaryProperties.subtype, true)
          as _PdfName;
      final _PdfAnnotationTypes type =
          _getAnnotationType(name, dictionary, crossTable);
      final _PdfArray? rectValue =
          _PdfCrossTable._dereference(dictionary[_DictionaryProperties.rect])
              as _PdfArray?;
      if (rectValue != null) {
        String text = '';
        if (dictionary.containsKey(_DictionaryProperties.contents)) {
          final _PdfString? str = _PdfCrossTable._dereference(
              dictionary[_DictionaryProperties.contents]) as _PdfString?;
          if (str != null) {
            text = str.value.toString();
          }
        }
        switch (type) {
          case _PdfAnnotationTypes.documentLinkAnnotation:
            annot = _createDocumentLinkAnnotation(dictionary, crossTable!);
            break;
          case _PdfAnnotationTypes.linkAnnotation:
            if (dictionary.containsKey(_DictionaryProperties.a)) {
              final _PdfDictionary? remoteLinkDic = _PdfCrossTable._dereference(
                  dictionary[_DictionaryProperties.a]) as _PdfDictionary?;
              if (remoteLinkDic != null &&
                  remoteLinkDic.containsKey(_DictionaryProperties.s)) {
                _PdfName? gotor;
                gotor = _PdfCrossTable._dereference(
                    remoteLinkDic[_DictionaryProperties.s]) as _PdfName?;
                if (gotor != null && gotor._name == 'URI') {
                  annot = _createLinkAnnotation(dictionary, crossTable!, text);
                }
              }
            } else {
              annot = _createLinkAnnotation(dictionary, crossTable!, text);
            }
            break;
          case _PdfAnnotationTypes.lineAnnotation:
            annot = _createLineAnnotation(dictionary, crossTable!, text);
            break;
          case _PdfAnnotationTypes.circleAnnotation:
            annot = _createEllipseAnnotation(dictionary, crossTable!, text);
            break;
          case _PdfAnnotationTypes.rectangleAnnotation:
            annot = _createRectangleAnnotation(dictionary, crossTable!, text);
            break;
          case _PdfAnnotationTypes.polygonAnnotation:
            annot = _createPolygonAnnotation(dictionary, crossTable!, text);
            break;
          case _PdfAnnotationTypes.textWebLinkAnnotation:
            annot = _createTextWebLinkAnnotation(dictionary, crossTable!, text);
            break;
          case _PdfAnnotationTypes.widgetAnnotation:
            annot = _createWidgetAnnotation(dictionary, crossTable!);
            break;
          default:
            break;
        }
        return annot;
      } else {
        return annot;
      }
    }
    return annot;
  }

  /// Gets the type of the annotation.
  _PdfAnnotationTypes _getAnnotationType(
      _PdfName name, _PdfDictionary dictionary, _PdfCrossTable? crossTable) {
    final String str = name._name!;
    _PdfAnnotationTypes type = _PdfAnnotationTypes.noAnnotation;
    switch (str.toLowerCase()) {
      case 'link':
        _PdfDictionary? linkDic;
        if (dictionary.containsKey(_DictionaryProperties.a)) {
          linkDic =
              _PdfCrossTable._dereference(dictionary[_DictionaryProperties.a])
                  as _PdfDictionary?;
        }
        if (linkDic != null && linkDic.containsKey(_DictionaryProperties.s)) {
          name = _PdfCrossTable._dereference(linkDic[_DictionaryProperties.s])
              as _PdfName;
          final _PdfArray? border = (_PdfCrossTable._dereference(
                  dictionary[_DictionaryProperties.border]) is _PdfArray)
              ? _PdfCrossTable._dereference(
                  dictionary[_DictionaryProperties.border]) as _PdfArray?
              : null;
          final bool mType = _findAnnotation(border);
          if (name._name == 'URI') {
            type = _PdfAnnotationTypes.linkAnnotation;
            if (!mType) {
              type = _PdfAnnotationTypes.linkAnnotation;
            } else {
              type = _PdfAnnotationTypes.textWebLinkAnnotation;
            }
          } else if (name._name == 'GoToR') {
            type = _PdfAnnotationTypes.linkAnnotation;
          } else if (name._name == 'GoTo') {
            type = _PdfAnnotationTypes.documentLinkAnnotation;
          }
        } else if (dictionary.containsKey(_DictionaryProperties.subtype)) {
          final _PdfName? strText = _PdfCrossTable._dereference(
              dictionary[_DictionaryProperties.subtype]) as _PdfName?;
          if (strText != null) {
            switch (strText._name) {
              case 'Link':
                type = _PdfAnnotationTypes.documentLinkAnnotation;
                break;
            }
          }
        }
        break;
      case 'line':
        type = _PdfAnnotationTypes.lineAnnotation;
        break;
      case 'circle':
        type = _PdfAnnotationTypes.circleAnnotation;
        break;
      case 'square':
        type = _PdfAnnotationTypes.rectangleAnnotation;
        break;
      case 'polygon':
        type = _PdfAnnotationTypes.polygonAnnotation;
        break;
      case 'widget':
        type = _PdfAnnotationTypes.widgetAnnotation;
        break;
      default:
        break;
    }
    return type;
  }

  // Creates the file link annotation.
  PdfAnnotation _createDocumentLinkAnnotation(
      _PdfDictionary dictionary, _PdfCrossTable crossTable) {
    final PdfAnnotation annot =
        PdfDocumentLinkAnnotation._(dictionary, crossTable);
    annot._setPage(_page);
    annot._page = _page;
    return annot;
  }

  PdfAnnotation _createLinkAnnotation(
      _PdfDictionary dictionary, _PdfCrossTable crossTable, String text) {
    final PdfAnnotation annot =
        PdfUriAnnotation._(dictionary, crossTable, text);
    annot._setPage(_page);
    return annot;
  }

  // Creates the Line Annotation.
  PdfAnnotation _createLineAnnotation(
      _PdfDictionary dictionary, _PdfCrossTable crossTable, String text) {
    final PdfAnnotation annot =
        PdfLineAnnotation._(dictionary, crossTable, text);
    annot._setPage(_page);
    annot._page = _page;
    return annot;
  }

// Creates the Ellipse Annotation.
  PdfAnnotation _createEllipseAnnotation(
      _PdfDictionary dictionary, _PdfCrossTable crossTable, String text) {
    final PdfAnnotation annot =
        PdfEllipseAnnotation._(dictionary, crossTable, text);
    annot._setPage(_page);
    annot._page = _page;
    return annot;
  }

  // Creates the Rectangle Annotation.
  PdfAnnotation _createRectangleAnnotation(
      _PdfDictionary dictionary, _PdfCrossTable crossTable, String text) {
    final PdfAnnotation annot =
        PdfRectangleAnnotation._(dictionary, crossTable, text);
    annot._setPage(_page);
    annot._page = _page;
    return annot;
  }

  // Creates the Polygon Annotation.
  PdfAnnotation _createPolygonAnnotation(
      _PdfDictionary dictionary, _PdfCrossTable crossTable, String text) {
    final PdfAnnotation annot =
        PdfPolygonAnnotation._(dictionary, crossTable, text);
    annot._setPage(_page);
    annot._page = _page;
    return annot;
  }

  PdfAnnotation _createTextWebLinkAnnotation(
      _PdfDictionary dictionary, _PdfCrossTable crossTable, String text) {
    final PdfAnnotation annot = PdfTextWebLink._(dictionary, crossTable, text);
    annot._setPage(_page);
    return annot;
  }

  //Creates the widget annotation.
  PdfAnnotation _createWidgetAnnotation(
      _PdfDictionary dictionary, _PdfCrossTable crossTable) {
    final PdfAnnotation annot = _WidgetAnnotation._(dictionary, crossTable);
    annot._setPage(_page);
    return annot;
  }

  bool _findAnnotation(_PdfArray? arr) {
    if (arr == null) {
      return false;
    }
    for (int i = 0; i < arr.count; i++) {
      if (arr[i] is _PdfArray) {
        final _PdfArray temp = arr[i] as _PdfArray;
        for (int j = 0; j < temp.count; j++) {
          final _PdfNumber? value =
              (temp[j] is _PdfNumber) ? temp[j] as _PdfNumber? : null;
          int? val = 0;
          if (value != null) {
            val = value.value as int?;
          }
          if (val! > 0) {
            return false;
          }
        }
      } else {
        int val = 0;
        final _PdfNumber? value =
            (arr[i] is _PdfNumber) ? arr[i] as _PdfNumber? : null;
        if (value != null) {
          val = value.value!.toInt();
        }
        if (val > 0) {
          return false;
        }
      }
    }
    return true;
  }

  _PdfArray? _rearrange(_PdfReference reference, int tabIndex, int index) {
    final _PdfArray? annots = _page._crossTable!
            ._getObject(_page._dictionary[_DictionaryProperties.annots])
        as _PdfArray?;
    if (annots != null) {
      if (tabIndex > annots.count) {
        tabIndex = 0;
      }
      if (index >= annots.count) {
        index = _page._annotsReference._indexOf(reference);
      }
      final _IPdfPrimitive? annotReference = annots._elements[index];
      if (annotReference != null && annotReference is _PdfReferenceHolder) {
        final _IPdfPrimitive? annotObject = annotReference.object;
        if (annotObject != null &&
            annotObject is _PdfDictionary &&
            annotObject.containsKey(_DictionaryProperties.parent)) {
          final _IPdfPrimitive? annotParent =
              annotObject[_DictionaryProperties.parent];
          if (annotReference.reference == reference ||
              (annotParent != null &&
                  annotParent is _PdfReferenceHolder &&
                  reference == annotParent.reference)) {
            final _IPdfPrimitive? temp = annots[index];
            if (temp != null) {
              annots._elements[index] = annots[tabIndex];
              annots._elements[tabIndex] = temp;
            }
          }
        }
      }
    }
    return annots;
  }

  @override
  _IPdfPrimitive? _element;
}
