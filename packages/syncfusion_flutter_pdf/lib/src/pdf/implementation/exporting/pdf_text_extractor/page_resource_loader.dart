part of pdf;

class _PageResourceLoader {
  //Construcotr
  _PageResourceLoader();

  //Implementations
  // Extracts the pageResource from the page
  _PdfPageResources getPageResources(PdfPage page) {
    _PdfPageResources pageResources = _PdfPageResources();
    double resourceNumber = 0;
    _PdfDictionary? resources = page._getResources();
    pageResources =
        updatePageResources(pageResources, getFontResources(resources, page));
    pageResources =
        updatePageResources(pageResources, getFormResources(resources));
    while (resources != null &&
        resources.containsKey(_DictionaryProperties.xObject)) {
      _PdfDictionary? tempResources = resources;
      _PdfDictionary? xobjects;
      if (resources[_DictionaryProperties.xObject] is _PdfReferenceHolder) {
        xobjects =
            (resources[_DictionaryProperties.xObject] as _PdfReferenceHolder)
                .object as _PdfDictionary?;
      } else {
        xobjects = resources[_DictionaryProperties.xObject] as _PdfDictionary?;
      }
      resources = xobjects![_DictionaryProperties.resources] as _PdfDictionary?;
      for (final dynamic objValue in xobjects._items!.values) {
        _PdfDictionary? xobjectDictionary;
        if (objValue is _PdfReferenceHolder) {
          xobjectDictionary = objValue.object as _PdfDictionary?;
        } else {
          xobjectDictionary = objValue as _PdfDictionary?;
        }
        if (xobjectDictionary != null &&
            xobjectDictionary.containsKey(_DictionaryProperties.resources)) {
          if (xobjectDictionary[_DictionaryProperties.resources]
              is _PdfReferenceHolder) {
            final _PdfReferenceHolder resourceReference =
                xobjectDictionary[_DictionaryProperties.resources]
                    as _PdfReferenceHolder;
            if (resourceNumber != resourceReference.reference!._objNum) {
              resources = resourceReference.object as _PdfDictionary?;
              resourceNumber = resourceReference.reference!._objNum!.toDouble();
            } else {
              continue;
            }
          } else {
            resources = xobjectDictionary[_DictionaryProperties.resources]
                as _PdfDictionary?;
          }
          if (resources == tempResources) {
            resources = null;
            tempResources = null;
          }
          pageResources = updatePageResources(
              pageResources, getFontResources(resources, page));
        }
      }
    }
    // m_commonMatrix = commonMatrix;
    if (page._rotation == PdfPageRotateAngle.rotateAngle90) {
      pageResources.resources[_DictionaryProperties.rotate] = 90.toDouble();
    } else if (page._rotation == PdfPageRotateAngle.rotateAngle180) {
      pageResources.resources[_DictionaryProperties.rotate] = 180.toDouble();
    } else if (page._rotation == PdfPageRotateAngle.rotateAngle270) {
      pageResources.resources[_DictionaryProperties.rotate] = 270.toDouble();
    }
    return pageResources;
  }

  Map<String?, dynamic> getFormResources(_PdfDictionary? resourceDictionary) {
    final Map<String?, dynamic> pageResources = <String?, dynamic>{};
    if (resourceDictionary != null &&
        resourceDictionary.containsKey(_DictionaryProperties.xObject)) {
      final _IPdfPrimitive? primitive =
          resourceDictionary[_DictionaryProperties.xObject];
      _PdfDictionary? xObjects;
      if (primitive is _PdfReferenceHolder) {
        final _IPdfPrimitive? holder = primitive.object;
        if (holder != null && holder is _PdfDictionary) {
          xObjects = holder;
        }
      } else if (primitive is _PdfDictionary) {
        xObjects = primitive;
      }
      if (xObjects != null) {
        xObjects._items!.forEach((_PdfName? key, _IPdfPrimitive? value) {
          _PdfDictionary? xObjectDictionary;
          if (value is _PdfReferenceHolder && value.object is _PdfDictionary) {
            xObjectDictionary = value.object as _PdfDictionary?;
          } else if (value is _PdfDictionary) {
            xObjectDictionary = value;
          }
          if (xObjectDictionary != null &&
              xObjectDictionary.containsKey(_DictionaryProperties.subtype)) {
            final _IPdfPrimitive? subType =
                xObjectDictionary[_DictionaryProperties.subtype];
            if (subType is _PdfName &&
                (subType._name == _DictionaryProperties.form ||
                    (subType._name != _DictionaryProperties.image &&
                        !pageResources.containsKey(key!._name)))) {
              pageResources[key!._name] =
                  _XObjectElement(xObjectDictionary, key._name);
            }
          }
        });
      }
    }
    return pageResources;
  }

  // Collects all the fonts in the page in a dictionary.
  // Returns dictionary containing font name and the font.
  Map<String?, Object?> getFontResources(_PdfDictionary? resourceDictionary,
      [PdfPage? page]) {
    final Map<String?, Object?> pageResources = <String?, Object?>{};
    if (resourceDictionary != null) {
      _IPdfPrimitive? fonts = resourceDictionary[_DictionaryProperties.font];
      if (fonts != null) {
        _PdfDictionary? fontsDictionary;
        if (fonts is _PdfReferenceHolder) {
          fontsDictionary = fonts.object as _PdfDictionary?;
        } else {
          fontsDictionary = fonts as _PdfDictionary;
        }

        if (fontsDictionary != null) {
          fontsDictionary._items!.forEach((_PdfName? k, _IPdfPrimitive? v) {
            if (v is _PdfReferenceHolder) {
              if (v.reference != null) {
                pageResources[k!._name] =
                    _FontStructure(v.object, v.reference.toString());
              } else {
                pageResources[k!._name] = _FontStructure(v.object);
              }
            } else {
              if (v is _PdfDictionary) {
                pageResources[k!._name] = _FontStructure(v);
              } else {
                pageResources[k!._name] = _FontStructure(
                    v, (v as _PdfReferenceHolder).reference.toString());
              }
            }
          });
        }
      }
      if (page != null) {
        final _IPdfPrimitive? parentPage =
            page._dictionary[_DictionaryProperties.parent];
        if (parentPage != null) {
          final _IPdfPrimitive? parentRef =
              (parentPage as _PdfReferenceHolder).object;
          final _PdfResources parentResources =
              _PdfResources(parentRef as _PdfDictionary?);
          fonts = parentResources[_DictionaryProperties.font];
          if (fonts != null) {
            final _PdfDictionary? fontsDictionary = fonts as _PdfDictionary;
            if (fontsDictionary != null) {
              fontsDictionary._items!.forEach((_PdfName? k, _IPdfPrimitive? v) {
                if (v is _PdfDictionary) {
                  pageResources[k!._name] = (v as _PdfReferenceHolder).object;
                }
                pageResources[k!._name] = _FontStructure(
                    v, (v as _PdfReferenceHolder).reference.toString());
              });
            }
          }
        }
      }
    }
    return pageResources;
  }

  // Updates the resources in the page
  _PdfPageResources updatePageResources(
      _PdfPageResources pageResources, Map<String?, Object?> objects) {
    objects.forEach((String? k, Object? v) {
      pageResources.add(k, v);
    });
    return pageResources;
  }
}

class _PdfPageResources {
  // Initializes the new instance of the class [PdfPageResources].
  _PdfPageResources() {
    resources = <String?, Object?>{};
  }

  //Fields
  late Map<String?, Object?> resources;
  final Map<String?, _FontStructure> _fontCollection =
      <String?, _FontStructure>{};

  dynamic operator [](String key) => _returnValue(key);

  dynamic _returnValue(String key) {
    if (resources.containsKey(key)) {
      return resources[key];
    } else {
      return null;
    }
  }

  /// Returns true if the FontCollection has same font face.
  bool isSameFont() {
    int i = 0;
    _fontCollection.forEach((String? k, _FontStructure v) {
      _fontCollection.forEach((String? k1, _FontStructure v1) {
        if (v.fontName != v1.fontName) {
          i = 1;
        }
      });
    });
    if (i == 0) {
      return true;
    } else {
      return false;
    }
  }

  // Adds the resource with the specified name.
  void add(String? resourceName, Object? resource) {
    if (resourceName == 'ProcSet') {
      return;
    }
    if (!resources.containsKey(resourceName)) {
      resources[resourceName] = resource;
      if (resource is _FontStructure) {
        _fontCollection[resourceName] = resource;
      }
    }
  }

  // Returns true if the key already exists.
  bool containsKey(String? key) {
    return resources.containsKey(key);
  }
}
