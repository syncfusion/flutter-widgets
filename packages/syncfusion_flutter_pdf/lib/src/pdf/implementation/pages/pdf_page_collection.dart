part of pdf;

/// Represents the collection of pages in a [PdfDocument] .
class PdfPageCollection {
  //Constructor
  /// Initializes a new instance of the [PdfPageCollection] class.
  PdfPageCollection._(PdfDocument? document, [PdfSection? section]) {
    if (document == null) {
      throw ArgumentError.notNull('document');
    }
    _document = document;
    if (section != null) {
      _section = section;
    }
    _pageCache ??= <_PdfDictionary?, PdfPage>{};
  }

  PdfPageCollection._fromCrossTable(
      PdfDocument document, _PdfCrossTable crossTable) {
    _document = document;
    _crossTable = crossTable;
    _pageCache ??= <_PdfDictionary?, PdfPage>{};
  }

  //Fields
  /// Represents the  method that executes on a PdfDocument
  /// when a new page is created.
  PageAddedCallback? pageAdded;
  PdfDocument? _document;
  int _count = 0;
  final Map<PdfPage, int> _pageCollectionIndex = <PdfPage, int>{};
  PdfSection? _section;
  Map<_PdfDictionary?, PdfPage>? _pageCache;
  _PdfCrossTable? _crossTable;
  _IPdfPrimitive? _pageCatalog;
  _PdfDictionary? _nodeDictionary;
  int _nodeCount = 0;
  _PdfCrossTable? _lastCrossTable;
  _PdfArray? _nodeKids;
  int _lastPageIndex = 0;
  int _lastKidIndex = 0;

  //Properties
  /// Gets the page by index
  PdfPage operator [](int index) => _returnValue(index)!;

  /// Gets the total number of the pages.
  int get count {
    if (_document!._isLoadedDocument) {
      int tempCount = 0;
      final _IPdfPrimitive? obj =
          _document!._catalog[_DictionaryProperties.pages];
      final _PdfDictionary? node =
          _PdfCrossTable._dereference(obj) as _PdfDictionary?;
      if (node != null) {
        tempCount = _getNodeCount(node);
      }
      return tempCount;
    } else {
      if (_section == null) {
        return _countPages();
      } else {
        return _section!._count;
      }
    }
  }

  //Public methods
  /// Adds a new page.
  PdfPage add() {
    PdfPage page;
    if (_document!._isLoadedDocument) {
      page = insert(count);
    } else {
      page = PdfPage();
      page._isNewPage = true;
      _addPage(page);
      page._isNewPage = false;
    }
    return page;
  }

  /// Gets the index of the page.
  int indexOf(PdfPage page) {
    if (_document!._isLoadedDocument) {
      int index = -1;
      final int count = this.count;
      for (int i = 0; i < count; i++) {
        final PdfPage? p = _returnValue(i);
        if (p == page) {
          index = i;
          break;
        }
      }
      return index;
    } else if (_section != null) {
      return _section!._indexOf(page);
    } else {
      int index = -1;
      int numPages = 0;
      for (int i = 0; i < _document!._sections!.count; i++) {
        final PdfSection section = _document!.sections![i];
        index = section._indexOf(page);
        if (index >= 0) {
          index += numPages;
          break;
        }
        numPages += section._count;
      }
      return index;
    }
  }

  /// Inserts a page at the specified index to the last section in the
  /// document.
  ///
  /// [index] - The index of the page in the section.
  /// [size] - The page size.
  /// [margins] - The page margin.
  /// [rotation] - The PDF page rotation angle.
  /// [orientation] - The PDF page orientation.
  PdfPage insert(int index,
      [Size? size,
      PdfMargins? margins,
      PdfPageRotateAngle? rotation,
      PdfPageOrientation? orientation]) {
    if (size == null || size.isEmpty) {
      size = PdfPageSize.a4;
    }
    rotation ??= PdfPageRotateAngle.rotateAngle0;
    orientation ??= (size.width > size.height)
        ? PdfPageOrientation.landscape
        : PdfPageOrientation.portrait;
    final PdfPage page = PdfPage();
    final PdfPageSettings settings = PdfPageSettings(size, orientation);
    if (margins == null) {
      margins = PdfMargins();
      margins.all = PdfDocument._defaultMargin;
    }
    settings.margins = margins;
    settings.rotate = rotation;
    final PdfSection sec = PdfSection._(_document, settings);
    sec._dropCropBox();
    sec._add(page);
    _PdfDictionary dic = sec._element! as _PdfDictionary;
    int? localIndex = 0;
    final Map<String, dynamic> result =
        _getValidParent(index, localIndex, false);
    final _PdfDictionary parent = result['node'] as _PdfDictionary;
    localIndex = result['index'] as int?;
    if (parent.containsKey(_DictionaryProperties.rotate)) {
      final int rotationValue = page.rotation.index * 90;
      final _PdfNumber parentRotation =
          parent[_DictionaryProperties.rotate]! as _PdfNumber;
      if (parentRotation.value!.toInt() != rotationValue &&
          (!dic.containsKey(_DictionaryProperties.rotate))) {
        page._dictionary[_DictionaryProperties.rotate] =
            _PdfNumber(rotationValue);
      }
    }
    dic[_DictionaryProperties.parent] = _PdfReferenceHolder(parent);
    final _PdfArray kids = _getNodeKids(parent)!;
    kids._insert(localIndex!, _PdfReferenceHolder(dic));
    _updateCount(parent);
    dic = page._element! as _PdfDictionary;
    _pageCache![dic] = page;
    page.graphics.colorSpace = _document!.colorSpace;
    page.graphics._layer!._colorSpace = _document!.colorSpace;
    return page;
  }

  //Implementation

  int _getNodeCount(_PdfDictionary node) {
    final _PdfNumber? number = _crossTable!
        ._getObject(node[_DictionaryProperties.count]) as _PdfNumber?;
    return (number == null) ? 0 : number.value!.toInt();
  }

  void _addPage(PdfPage page) {
    PdfSection section = _section ?? _getLastSection();
    if (_section == null) {
      if (!_checkPageSettings(section._settings)) {
        section = _document!.sections!.add();
        section.pageSettings = _document!.pageSettings._clone();
      }
      if (!_pageCollectionIndex.containsKey(page)) {
        _pageCollectionIndex[page] = _count++;
      }
    }
    section._add(page);
  }

  bool _checkPageSettings(PdfPageSettings sectionSettings) {
    final PdfPageSettings docSettings = _document!.pageSettings;
    return sectionSettings.size == docSettings.size &&
        sectionSettings.orientation == docSettings.orientation &&
        (sectionSettings.margins.left == docSettings.margins.left &&
            sectionSettings.margins.top == docSettings.margins.top &&
            sectionSettings.margins.right == docSettings.margins.right &&
            sectionSettings.margins.bottom == docSettings.margins.bottom);
  }

  bool _contains(PdfPage page) {
    if (_section != null) {
      return _section!._indexOf(page) != -1;
    } else {
      bool value = false;
      for (int i = 0; i < _document!.sections!.count; i++) {
        value |= _document!.sections![i].pages._contains(page);
      }
      return value;
    }
  }

  PdfPage? _returnValue(int index) {
    if (_document!._isLoadedDocument) {
      int localIndex = 0;
      final Map<String, dynamic> result = _getParent(index, localIndex);
      _PdfDictionary node = result['node'] as _PdfDictionary;
      localIndex = result['index'] as int;
      final _PdfArray? kids = _getNodeKids(node);
      int i = localIndex;
      int j = 0;
      while (true) {
        node = _crossTable!._getObject(kids![localIndex])! as _PdfDictionary;
        if ((node[_DictionaryProperties.type]! as _PdfName)._name == 'Pages') {
          i++;
          node = _crossTable!._getObject(kids[i])! as _PdfDictionary;
          final _PdfArray? innerKids = _getNodeKids(node);
          if (innerKids == null) {
            break;
          }
          if (innerKids.count > 0) {
            node = _crossTable!._getObject(innerKids[j])! as _PdfDictionary;
            j++;
            break;
          }
        } else {
          break;
        }
      }
      return _getPage(node);
    } else {
      if (_section != null) {
        return _section!._getPageByIndex(index);
      } else {
        if (index < 0 || index >= count) {
          throw ArgumentError.value('index', 'out of range');
        }
        PdfPage? page;
        int sectionStartIndex = 0;
        int sectionCount = 0;
        int pageIndex = 0;
        for (int i = 0; i < _document!.sections!.count; i++) {
          final PdfSection section = _document!.sections![i];
          sectionCount = section._count;
          pageIndex = index - sectionStartIndex;
          if (index >= sectionStartIndex && pageIndex < sectionCount) {
            page = section._getPageByIndex(pageIndex);
            break;
          }
          sectionStartIndex += sectionCount;
        }
        return page;
      }
    }
  }

  void _updateCount(_PdfDictionary? parent) {
    while (parent != null) {
      final int count = _getNodeCount(parent) + 1;
      parent[_DictionaryProperties.count] = _PdfNumber(count);
      parent = _PdfCrossTable._dereference(parent[_DictionaryProperties.parent])
          as _PdfDictionary?;
    }
  }

  Map<String, dynamic> _getValidParent(
      int index, int? localIndex, bool zeroValid) {
    if (index < 0 && index > count) {
      throw ArgumentError.value(index, 'page index is not within range');
    }
    final _IPdfPrimitive? obj =
        _document!._catalog[_DictionaryProperties.pages];
    _PdfDictionary node = _crossTable!._getObject(obj)! as _PdfDictionary;
    int lowIndex = 0;
    localIndex = _getNodeCount(node);
    if (index == 0 && !zeroValid) {
      localIndex = 0;
    } else if (index < count) {
      _PdfArray kids = _getNodeKids(node)!;
      for (int i = 0; i < kids.count; i++) {
        final _IPdfPrimitive? primitive = kids._elements[i];
        if (primitive != null && primitive is _PdfReferenceHolder) {
          final _PdfReferenceHolder pageReferenceHolder = primitive;
          final _PdfDictionary kidsCollection =
              pageReferenceHolder.object! as _PdfDictionary;
          final List<_PdfName?> keys = kidsCollection._items!.keys.toList();
          for (int keyIndex = 0; keyIndex < keys.length; keyIndex++) {
            final _PdfName key = keys[keyIndex]!;
            final _IPdfPrimitive? value = kidsCollection[key];
            if (key._name == 'Kids') {
              _PdfArray? kidValue;
              if (value is _PdfReferenceHolder) {
                kidValue = value.object as _PdfArray?;
              } else {
                kidValue = value as _PdfArray?;
              }
              if (kidValue != null && kidValue.count == 0) {
                kids._removeAt(i);
              }
            }
          }
        }
      }
      for (int i = 0, count = kids.count; i < count; ++i) {
        final _PdfDictionary subNode =
            _crossTable!._getObject(kids[i])! as _PdfDictionary;
        String? pageValue =
            (subNode[_DictionaryProperties.type]! as _PdfName)._name;
        if (_isNodeLeaf(subNode) &&
            !(pageValue == _DictionaryProperties.pages)) {
          if ((lowIndex + i) == index) {
            localIndex = i;
            break;
          }
        } else {
          final int nodeCount = _getNodeCount(subNode);
          if (index < lowIndex + nodeCount + i) {
            lowIndex += i;
            node = subNode;
            kids = _getNodeKids(node)!;
            i = -1;
            count = kids.count;
            if (nodeCount == count) {
              final _PdfDictionary kidsSubNode =
                  _crossTable!._getObject(kids[0])! as _PdfDictionary;
              pageValue =
                  (kidsSubNode[_DictionaryProperties.type]! as _PdfName)._name;
              if (pageValue == _DictionaryProperties.pages) {
                continue;
              } else {
                localIndex = index - lowIndex;
                break;
              }
            }
            continue;
          } else {
            lowIndex += nodeCount - 1;
          }
        }
      }
    } else {
      localIndex = _getNodeKids(node)!.count;
    }
    return <String, dynamic>{'node': node, 'index': localIndex};
  }

  Map<String, dynamic> _getParent(int index, int? localIndex) {
    if (index < 0 && index > count) {
      throw ArgumentError.value(index, 'page index is not within range');
    }
    _pageCatalog ??= _document!._catalog[_DictionaryProperties.pages];
    bool isNodeChanged = false;
    _PdfDictionary? node;
    if (_nodeDictionary == null) {
      _nodeDictionary =
          _crossTable!._getObject(_pageCatalog) as _PdfDictionary?;
      node = _nodeDictionary;
      _nodeCount = _getNodeCount(node!);
      _lastCrossTable = _crossTable;
      isNodeChanged = true;
    } else if (_crossTable == _lastCrossTable) {
      node = _nodeDictionary;
    } else {
      _nodeDictionary =
          _crossTable!._getObject(_pageCatalog) as _PdfDictionary?;
      node = _nodeDictionary;
      _nodeCount = _getNodeCount(node!);
      _lastCrossTable = _crossTable;
      isNodeChanged = true;
    }
    localIndex = _nodeCount > 0 ? _nodeCount : _getNodeCount(node!);
    if (index < count) {
      _PdfArray? kids;
      if (_nodeKids == null || isNodeChanged) {
        _nodeKids = _getNodeKids(node!);
        kids = _nodeKids;
        for (int i = 0; i < kids!.count; i++) {
          final _IPdfPrimitive? primitive = kids._elements[i];
          if (primitive != null && primitive is _PdfReferenceHolder) {
            final _PdfReferenceHolder pageReferenceHolder = primitive;
            final _PdfDictionary kidsCollection =
                pageReferenceHolder.object! as _PdfDictionary;
            final List<_PdfName?> keys = kidsCollection._items!.keys.toList();
            for (int keyIndex = 0; keyIndex < keys.length; keyIndex++) {
              final _PdfName key = keys[keyIndex]!;
              final _IPdfPrimitive? value = kidsCollection[key];
              if (key._name == 'Kids') {
                _PdfArray? kidValue;
                if (value is _PdfReferenceHolder) {
                  kidValue = value.object as _PdfArray?;
                } else {
                  kidValue = value as _PdfArray?;
                }
                if (kidValue != null && kidValue.count == 0) {
                  kids._removeAt(i);
                }
              }
            }
          }
        }
      } else {
        kids = _nodeKids;
      }
      int kidStartIndex = 0;
      if ((_lastPageIndex == index - 1 || _lastPageIndex < index) &&
          _lastKidIndex < kids!.count) {
        kidStartIndex = _lastKidIndex;
      }
      bool? isParentNodeFetched = false;
      _PdfDictionary? tempNode;
      int? tempLocalIndex = 0;

      if (kids!.count == count) {
        Map<String, dynamic> returnValue = _getParentNode(kidStartIndex, kids,
            0, index, tempNode, tempLocalIndex, isParentNodeFetched);
        tempNode = returnValue['tempNode'] as _PdfDictionary?;
        tempLocalIndex = returnValue['tempLocalIndex'] as int?;
        isParentNodeFetched = returnValue['isParentNodeFetched'] as bool?;
        if (!isParentNodeFetched!) {
          returnValue = _getParentNode(
              0, kids, 0, index, tempNode, tempLocalIndex, isParentNodeFetched);
          tempNode = returnValue['tempNode'] as _PdfDictionary?;
          tempLocalIndex = returnValue['tempLocalIndex'] as int?;
          isParentNodeFetched = returnValue['isParentNodeFetched'] as bool?;
        }
      } else {
        final Map<String, dynamic> returnValue = _getParentNode(
            0, kids, 0, index, tempNode, tempLocalIndex, isParentNodeFetched);
        tempNode = returnValue['tempNode'] as _PdfDictionary?;
        tempLocalIndex = returnValue['tempLocalIndex'] as int?;
        isParentNodeFetched = returnValue['isParentNodeFetched'] as bool?;
      }

      if (tempNode != null) {
        node = tempNode;
      }
      if (tempLocalIndex != -1) {
        localIndex = tempLocalIndex;
      }
    } else {
      localIndex = _getNodeKids(node!)!.count;
    }
    _lastPageIndex = index;
    return <String, dynamic>{'node': node, 'index': localIndex};
  }

  _PdfArray? _getNodeKids(_PdfDictionary node) {
    final _IPdfPrimitive? obj = node[_DictionaryProperties.kids];
    final _PdfArray? kids = _crossTable!._getObject(obj) as _PdfArray?;
    return kids;
  }

  Map<String, dynamic> _getParentNode(
      int kidStartIndex,
      _PdfArray kids,
      int lowIndex,
      int pageIndex,
      _PdfDictionary? node,
      int? localIndex,
      bool? isParentFetched) {
    isParentFetched = false;
    node = null;
    localIndex = -1;
    bool isNonLeafNode = false;
    int tempCount = kids.count;
    for (int i = kidStartIndex; i < tempCount; ++i) {
      final _IPdfPrimitive? primitive = _crossTable!._getObject(kids[i]);
      if (primitive != null && primitive is _PdfDictionary) {
        final _PdfDictionary subNode = primitive;
        final String? pageValue =
            (subNode[_DictionaryProperties.type]! as _PdfName)._name;
        if (_isNodeLeaf(subNode) &&
            !(pageValue == _DictionaryProperties.pages)) {
          if ((lowIndex + i) == pageIndex) {
            localIndex = i;
            isParentFetched = true;
            if (!isNonLeafNode) {
              _lastKidIndex = i;
            }
            break;
          }
        } else {
          final int nodeCount = _getNodeCount(subNode);
          if (pageIndex < lowIndex + nodeCount + i) {
            isNonLeafNode = true;
            _lastKidIndex = i;
            lowIndex += i;
            node = subNode;
            kids = _getNodeKids(node)!;
            i = -1;
            tempCount = kids.count;
            continue;
          } else {
            lowIndex += nodeCount - 1;
          }
        }
      }
    }
    return <String, dynamic>{
      'tempNode': node,
      'tempLocalIndex': localIndex,
      'isParentNodeFetched': isParentFetched
    };
  }

  bool _isNodeLeaf(_PdfDictionary node) {
    return _getNodeCount(node) == 0;
  }

  PdfSection _getLastSection() {
    final PdfSectionCollection sectionCollection = _document!.sections!;
    if (sectionCollection._sections.isEmpty) {
      sectionCollection.add();
    }
    return sectionCollection[sectionCollection._sections.length - 1];
  }

  int _countPages() {
    final PdfSectionCollection sectionCollection = _document!.sections!;
    int count = 0;
    for (int i = 0; i < sectionCollection._sections.length; i++) {
      final PdfSection section = sectionCollection[i];
      count += section._count;
    }
    return count;
  }

  void _onPageAdded(PageAddedArgs args) {
    if (pageAdded != null) {
      pageAdded!(this, args);
    }
  }

  void _remove(PdfPage page) {
    if (_section != null) {
      _section!._remove(page);
    } else {
      for (int i = 0; i < _document!.sections!.count; i++) {
        if (_document!.sections![i].pages._contains(page)) {
          _document!.sections![i].pages._remove(page);
          break;
        }
      }
    }
  }

  /// Removes the specified page.
  ///
  /// ```dart
  /// //Load an exisiting PDF document.
  /// PdfDocument document = PdfDocument.fromBase64String(pdfData);
  /// //Get the first page.
  /// PdfPage page = document.pages[0];
  /// //Remove the first page.
  /// document.pages.remove(page);
  /// //Save and dispose document.
  /// List<int> bytes = document.save();
  /// document.dispose();
  /// ```
  void remove(PdfPage page) {
    _removePage(page, indexOf(page));
  }

  /// Removes the page at the given specified index.
  ///
  /// ```dart
  /// //Load an exisiting PDF document.
  /// PdfDocument document = PdfDocument.fromBase64String(pdfData);
  /// //Remove the page at index 0.
  /// document.pages.removeAt(0);
  /// //Save and dispose document.
  /// List<int> bytes = document.save();
  /// document.dispose();
  /// ```
  void removeAt(int index) {
    if (index > -1 && index < count) {
      final PdfPage? page = _returnValue(index);
      _removePage(page, index);
    }
  }

  void _removePage(PdfPage? page, int index) {
    if (_document!._isLoadedDocument && index > -1) {
      final Map<PdfPage, dynamic>? pageToBookmarkDic =
          _document!._createBookmarkDestinationDictionary();
      if (pageToBookmarkDic != null) {
        List<dynamic>? bookmarks;
        if (pageToBookmarkDic.containsKey(page)) {
          bookmarks = pageToBookmarkDic[page!] as List<dynamic>?;
        }
        if (bookmarks != null) {
          for (int i = 0; i < bookmarks.length; i++) {
            if (bookmarks[i] is PdfBookmarkBase) {
              final PdfBookmarkBase current = bookmarks[i] as PdfBookmarkBase;
              if (current._dictionary!.containsKey(_DictionaryProperties.a)) {
                current._dictionary!.remove(_DictionaryProperties.a);
              }
              if (current._dictionary!
                  .containsKey(_DictionaryProperties.dest)) {
                current._dictionary!.remove(_DictionaryProperties.dest);
              }
            }
          }
        }
      }
      final _PdfDictionary dic = page!._element! as _PdfDictionary;
      int? localIndex = 0;
      final Map<String, dynamic> result = _getParent(index, localIndex);
      final _PdfDictionary parent = result['node'] as _PdfDictionary;
      localIndex = result['index'] as int?;
      dic[_DictionaryProperties.parent] = _PdfReferenceHolder(parent);
      _PdfArray? kids = _getNodeKids(parent);
      if (index == 0) {
        final _PdfCrossTable table = _document!._crossTable;
        if (table.documentCatalog != null) {
          final _IPdfPrimitive? primitive =
              table.documentCatalog!['OpenAction'];
          _PdfArray? documentCatalog;
          if (primitive != null) {
            if (primitive is _PdfArray) {
              documentCatalog = primitive;
            }
          }
          if (documentCatalog != null) {
            documentCatalog._remove(_PdfReferenceHolder(dic));
          } else if (primitive is _PdfReferenceHolder) {
            final _IPdfPrimitive? documentDic = primitive.object;
            if (documentDic != null && documentDic is _PdfDictionary) {
              if (documentDic.containsKey('D')) {
                final _IPdfPrimitive? documentObject = documentDic['D'];
                if (documentObject != null && documentObject is _PdfArray) {
                  for (int i = 0; i < documentObject.count; i++) {
                    final _IPdfPrimitive? entry = documentObject[i];
                    if (entry != null && entry is _PdfReferenceHolder) {
                      final _IPdfPrimitive? referenceDictionary = entry.object;
                      if (referenceDictionary != null &&
                          referenceDictionary == dic) {
                        documentObject._remove(entry);
                      }
                    }
                  }
                }
              }
            }
          }
        }
      }
      _PdfReferenceHolder? remove;
      for (int i = 0; i < kids!.count; i++) {
        final _IPdfPrimitive? holder = kids[i];
        if (holder != null &&
            holder is _PdfReferenceHolder &&
            holder._object == dic) {
          remove = holder;
          break;
        }
      }
      if (remove != null) {
        kids._remove(remove);
        if (kids.count == 0 &&
            parent.containsKey(_DictionaryProperties.parent)) {
          _PdfDictionary? parentDic;
          _IPdfPrimitive? holder = parent[_DictionaryProperties.parent];
          if (holder is _PdfReferenceHolder) {
            holder = holder._object;
            if (holder != null && holder is _PdfDictionary) {
              parentDic = holder;
            }
          } else if (holder is _PdfDictionary) {
            parentDic = holder;
          }
          if (parentDic != null) {
            _IPdfPrimitive? kidsPrimitive =
                parentDic[_DictionaryProperties.kids];
            if (kidsPrimitive is _PdfReferenceHolder) {
              kidsPrimitive = kidsPrimitive._object;
              if (kidsPrimitive != null && kidsPrimitive is _PdfArray) {
                kids = kidsPrimitive;
              }
            } else if (kidsPrimitive is _PdfArray) {
              kids = kidsPrimitive;
            }
            _PdfReferenceHolder? remove;
            for (int i = 0; i < kids.count; i++) {
              final _IPdfPrimitive? holder = kids[i];
              if (holder != null &&
                  holder is _PdfReferenceHolder &&
                  holder._object == parent) {
                remove = holder;
                break;
              }
            }
            if (remove != null) {
              kids._remove(remove);
            }
          }
        }
      }
      _updateCountDecrement(parent);
    }
  }

  void _updateCountDecrement(_PdfDictionary? parent) {
    while (parent != null) {
      int count = _getNodeCount(parent) - 1;
      if (count == 0) {
        final _PdfDictionary node = parent;
        final _IPdfPrimitive? result =
            _PdfCrossTable._dereference(parent[_DictionaryProperties.parent]);
        if (result != null && result is _PdfDictionary) {
          final _IPdfPrimitive? kids = result[_DictionaryProperties.kids];
          if (kids != null && kids is _PdfArray) {
            kids._remove(_PdfReferenceHolder(node));
          }
        }
      }
      count = _getNodeCount(parent) - 1;
      parent[_DictionaryProperties.count] = _PdfNumber(count);
      final _IPdfPrimitive? primitive =
          _PdfCrossTable._dereference(parent[_DictionaryProperties.parent]);
      parent =
          (primitive != null && primitive is _PdfDictionary) ? primitive : null;
    }
  }

  PdfPage _getPage(_PdfDictionary? dic) {
    final Map<_PdfDictionary?, PdfPage> pageCahce = _pageCache!;
    PdfPage? page;
    if (pageCahce.containsKey(dic)) {
      page = pageCahce[dic];
    }
    if (page == null) {
      page = PdfPage._fromDictionary(_document!, _crossTable!, dic!);
      pageCahce[dic] = page;
    }
    return page;
  }
}
