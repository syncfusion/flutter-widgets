import 'dart:ui';

import '../../interfaces/pdf_interface.dart';
import '../forms/pdf_form_field_collection.dart';
import '../graphics/pdf_graphics.dart';
import '../graphics/pdf_margins.dart';
import '../io/pdf_constants.dart';
import '../io/pdf_cross_table.dart';
import '../pages/pdf_page.dart';
import '../pdf_document/outlines/pdf_outline.dart';
import '../pdf_document/pdf_document.dart';
import '../primitives/pdf_array.dart';
import '../primitives/pdf_dictionary.dart';
import '../primitives/pdf_name.dart';
import '../primitives/pdf_number.dart';
import '../primitives/pdf_reference_holder.dart';
import 'enum.dart';
import 'pdf_page_layer.dart';
import 'pdf_page_settings.dart';
import 'pdf_section.dart';
import 'pdf_section_collection.dart';

/// Represents the collection of pages in a [PdfDocument] .
class PdfPageCollection {
  //Constructor
  /// Initializes a new instance of the [PdfPageCollection] class.
  PdfPageCollection._(PdfDocument? document, [PdfSection? section]) {
    if (document == null) {
      throw ArgumentError.notNull('document');
    }
    _helper = PdfPageCollectionHelper(this);
    _helper.document = document;
    if (section != null) {
      _helper._section = section;
    }
    _helper._pageCache ??= <PdfDictionary?, PdfPage>{};
  }

  PdfPageCollection._fromCrossTable(
      PdfDocument document, PdfCrossTable crossTable) {
    _helper = PdfPageCollectionHelper(this);
    _helper.document = document;
    _helper._crossTable = crossTable;
    _helper._pageCache ??= <PdfDictionary?, PdfPage>{};
  }

  //Fields
  /// Represents the  method that executes on a PdfDocument
  /// when a new page is created.
  PageAddedCallback? pageAdded;
  IPdfPrimitive? _pageCatalog;
  PdfDictionary? _nodeDictionary;
  int _nodeCount = 0;
  PdfCrossTable? _lastCrossTable;
  PdfArray? _nodeKids;
  int _lastPageIndex = 0;
  int _lastKidIndex = 0;
  late PdfPageCollectionHelper _helper;

  //Properties
  /// Gets the page by index
  PdfPage operator [](int index) => _returnValue(index)!;

  /// Gets the total number of the pages.
  int get count {
    if (PdfDocumentHelper.getHelper(_helper.document!).isLoadedDocument) {
      int tempCount = 0;
      final IPdfPrimitive? obj = PdfDocumentHelper.getHelper(_helper.document!)
          .catalog[PdfDictionaryProperties.pages];
      final PdfDictionary? node =
          PdfCrossTable.dereference(obj) as PdfDictionary?;
      if (node != null) {
        tempCount = _getNodeCount(node);
      }
      return tempCount;
    } else {
      if (_helper._section == null) {
        return _countPages();
      } else {
        return PdfSectionHelper.getHelper(_helper._section!).count;
      }
    }
  }

  //Public methods
  /// Adds a new page.
  PdfPage add() {
    PdfPage page;
    if (PdfDocumentHelper.getHelper(_helper.document!).isLoadedDocument) {
      page = insert(count);
      PdfPageHelper.getHelper(page).document = _helper.document;
    } else {
      page = PdfPage();
      PdfPageHelper.getHelper(page).isNewPage = true;
      _helper.addPage(page);
      PdfPageHelper.getHelper(page).isNewPage = false;
    }
    return page;
  }

  /// Gets the index of the page.
  int indexOf(PdfPage page) {
    if (PdfDocumentHelper.getHelper(_helper.document!).isLoadedDocument) {
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
    } else if (_helper._section != null) {
      return PdfSectionHelper.getHelper(_helper._section!).indexOf(page);
    } else {
      int index = -1;
      int numPages = 0;
      for (int i = 0; i < _helper.document!.sections!.count; i++) {
        final PdfSection section = _helper.document!.sections![i];
        index = PdfSectionHelper.getHelper(section).indexOf(page);
        if (index >= 0) {
          index += numPages;
          break;
        }
        numPages += PdfSectionHelper.getHelper(section).count;
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
      margins.all = PdfDocumentHelper.defaultMargin;
    }
    settings.margins = margins;
    settings.rotate = rotation;
    final PdfSection sec = PdfSectionHelper.load(_helper.document, settings);
    PdfSectionHelper.getHelper(sec).dropCropBox();
    PdfSectionHelper.getHelper(sec).add(page);
    PdfDictionary dic = IPdfWrapper.getElement(sec)! as PdfDictionary;
    int? localIndex = 0;
    final Map<String, dynamic> result =
        _getValidParent(index, localIndex, false);
    final PdfDictionary parent = result['node'] as PdfDictionary;
    localIndex = result['index'] as int?;
    if (parent.containsKey(PdfDictionaryProperties.rotate)) {
      final int rotationValue = page.rotation.index * 90;
      final PdfNumber parentRotation =
          parent[PdfDictionaryProperties.rotate]! as PdfNumber;
      if (parentRotation.value!.toInt() != rotationValue &&
          (!dic.containsKey(PdfDictionaryProperties.rotate))) {
        PdfPageHelper.getHelper(page)
                .dictionary![PdfDictionaryProperties.rotate] =
            PdfNumber(rotationValue);
      }
    }
    dic[PdfDictionaryProperties.parent] = PdfReferenceHolder(parent);
    final PdfArray kids = _getNodeKids(parent)!;
    kids.insert(localIndex!, PdfReferenceHolder(dic));
    _updateCount(parent);
    dic = IPdfWrapper.getElement(page)! as PdfDictionary;
    _helper._pageCache![dic] = page;
    page.graphics.colorSpace = _helper.document!.colorSpace;
    PdfPageLayerHelper.getHelper(
            PdfGraphicsHelper.getHelper(page.graphics).layer!)
        .colorSpace = _helper.document!.colorSpace;
    return page;
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
  /// List<int> bytes = await document.save();
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
  /// List<int> bytes = await document.save();
  /// document.dispose();
  /// ```
  void removeAt(int index) {
    if (index > -1 && index < count) {
      final PdfPage? page = _returnValue(index);
      _removePage(page, index);
    }
  }

  //Implementation
  int _getNodeCount(PdfDictionary node) {
    final PdfNumber? number = _helper._crossTable!
        .getObject(node[PdfDictionaryProperties.count]) as PdfNumber?;
    return (number == null) ? 0 : number.value!.toInt();
  }

  PdfPage? _returnValue(int index) {
    if (PdfDocumentHelper.getHelper(_helper.document!).isLoadedDocument) {
      int localIndex = 0;
      final Map<String, dynamic> result = _getParent(index, localIndex);
      PdfDictionary node = result['node'] as PdfDictionary;
      localIndex = result['index'] as int;
      final PdfArray? kids = _getNodeKids(node);
      int i = localIndex;
      int j = 0;
      while (true) {
        node =
            _helper._crossTable!.getObject(kids![localIndex])! as PdfDictionary;
        if ((node[PdfDictionaryProperties.type]! as PdfName).name == 'Pages') {
          i++;
          node = _helper._crossTable!.getObject(kids[i])! as PdfDictionary;
          final PdfArray? innerKids = _getNodeKids(node);
          if (innerKids == null) {
            break;
          }
          if (innerKids.count > 0) {
            node =
                _helper._crossTable!.getObject(innerKids[j])! as PdfDictionary;
            j++;
            break;
          }
        } else {
          break;
        }
      }
      return _helper.getPage(node);
    } else {
      if (_helper._section != null) {
        return PdfSectionHelper.getHelper(_helper._section!)
            .getPageByIndex(index);
      } else {
        if (index < 0 || index >= count) {
          throw ArgumentError.value('index', 'out of range');
        }
        PdfPage? page;
        int sectionStartIndex = 0;
        int sectionCount = 0;
        int pageIndex = 0;
        for (int i = 0; i < _helper.document!.sections!.count; i++) {
          final PdfSection section = _helper.document!.sections![i];
          sectionCount = PdfSectionHelper.getHelper(section).count;
          pageIndex = index - sectionStartIndex;
          if (index >= sectionStartIndex && pageIndex < sectionCount) {
            page =
                PdfSectionHelper.getHelper(section).getPageByIndex(pageIndex);
            break;
          }
          sectionStartIndex += sectionCount;
        }
        return page;
      }
    }
  }

  void _updateCount(PdfDictionary? parent) {
    while (parent != null) {
      final int count = _getNodeCount(parent) + 1;
      parent[PdfDictionaryProperties.count] = PdfNumber(count);
      parent = PdfCrossTable.dereference(parent[PdfDictionaryProperties.parent])
          as PdfDictionary?;
    }
  }

  Map<String, dynamic> _getValidParent(
      int index, int? localIndex, bool zeroValid) {
    if (index < 0 && index > count) {
      throw ArgumentError.value(index, 'page index is not within range');
    }
    final IPdfPrimitive? obj = PdfDocumentHelper.getHelper(_helper.document!)
        .catalog[PdfDictionaryProperties.pages];
    PdfDictionary node = _helper._crossTable!.getObject(obj)! as PdfDictionary;
    int lowIndex = 0;
    localIndex = _getNodeCount(node);
    if (index == 0 && !zeroValid) {
      localIndex = 0;
    } else if (index < count) {
      PdfArray kids = _getNodeKids(node)!;
      for (int i = 0; i < kids.count; i++) {
        final IPdfPrimitive? primitive = kids.elements[i];
        if (primitive != null && primitive is PdfReferenceHolder) {
          final PdfReferenceHolder pageReferenceHolder = primitive;
          final PdfDictionary kidsCollection =
              pageReferenceHolder.object! as PdfDictionary;
          final List<PdfName?> keys = kidsCollection.items!.keys.toList();
          for (int keyIndex = 0; keyIndex < keys.length; keyIndex++) {
            final PdfName key = keys[keyIndex]!;
            final IPdfPrimitive? value = kidsCollection[key];
            if (key.name == 'Kids') {
              PdfArray? kidValue;
              if (value is PdfReferenceHolder) {
                kidValue = value.object as PdfArray?;
              } else {
                kidValue = value as PdfArray?;
              }
              if (kidValue != null && kidValue.count == 0) {
                kids.removeAt(i);
              }
            }
          }
        }
      }
      for (int i = 0, count = kids.count; i < count; ++i) {
        final PdfDictionary subNode =
            _helper._crossTable!.getObject(kids[i])! as PdfDictionary;
        String? pageValue =
            (subNode[PdfDictionaryProperties.type]! as PdfName).name;
        if (_isNodeLeaf(subNode) &&
            !(pageValue == PdfDictionaryProperties.pages)) {
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
              final PdfDictionary kidsSubNode =
                  _helper._crossTable!.getObject(kids[0])! as PdfDictionary;
              pageValue =
                  (kidsSubNode[PdfDictionaryProperties.type]! as PdfName).name;
              if (pageValue == PdfDictionaryProperties.pages) {
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
    _pageCatalog ??= PdfDocumentHelper.getHelper(_helper.document!)
        .catalog[PdfDictionaryProperties.pages];
    bool isNodeChanged = false;
    PdfDictionary? node;
    if (_nodeDictionary == null) {
      _nodeDictionary =
          _helper._crossTable!.getObject(_pageCatalog) as PdfDictionary?;
      node = _nodeDictionary;
      _nodeCount = _getNodeCount(node!);
      _lastCrossTable = _helper._crossTable;
      isNodeChanged = true;
    } else if (_helper._crossTable == _lastCrossTable) {
      node = _nodeDictionary;
    } else {
      _nodeDictionary =
          _helper._crossTable!.getObject(_pageCatalog) as PdfDictionary?;
      node = _nodeDictionary;
      _nodeCount = _getNodeCount(node!);
      _lastCrossTable = _helper._crossTable;
      isNodeChanged = true;
    }
    localIndex = _nodeCount > 0 ? _nodeCount : _getNodeCount(node!);
    if (index < count) {
      PdfArray? kids;
      if (_nodeKids == null || isNodeChanged) {
        _nodeKids = _getNodeKids(node!);
        kids = _nodeKids;
        for (int i = 0; i < kids!.count; i++) {
          final IPdfPrimitive? primitive = kids.elements[i];
          if (primitive != null && primitive is PdfReferenceHolder) {
            final PdfReferenceHolder pageReferenceHolder = primitive;
            final PdfDictionary kidsCollection =
                pageReferenceHolder.object! as PdfDictionary;
            final List<PdfName?> keys = kidsCollection.items!.keys.toList();
            for (int keyIndex = 0; keyIndex < keys.length; keyIndex++) {
              final PdfName key = keys[keyIndex]!;
              final IPdfPrimitive? value = kidsCollection[key];
              if (key.name == 'Kids') {
                PdfArray? kidValue;
                if (value is PdfReferenceHolder) {
                  kidValue = value.object as PdfArray?;
                } else {
                  kidValue = value as PdfArray?;
                }
                if (kidValue != null && kidValue.count == 0) {
                  kids.removeAt(i);
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
      PdfDictionary? tempNode;
      int? tempLocalIndex = 0;

      if (kids!.count == count) {
        Map<String, dynamic> returnValue = _getParentNode(kidStartIndex, kids,
            0, index, tempNode, tempLocalIndex, isParentNodeFetched);
        tempNode = returnValue['tempNode'] as PdfDictionary?;
        tempLocalIndex = returnValue['tempLocalIndex'] as int?;
        isParentNodeFetched = returnValue['isParentNodeFetched'] as bool?;
        if (!isParentNodeFetched!) {
          returnValue = _getParentNode(
              0, kids, 0, index, tempNode, tempLocalIndex, isParentNodeFetched);
          tempNode = returnValue['tempNode'] as PdfDictionary?;
          tempLocalIndex = returnValue['tempLocalIndex'] as int?;
          isParentNodeFetched = returnValue['isParentNodeFetched'] as bool?;
        }
      } else {
        final Map<String, dynamic> returnValue = _getParentNode(
            0, kids, 0, index, tempNode, tempLocalIndex, isParentNodeFetched);
        tempNode = returnValue['tempNode'] as PdfDictionary?;
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

  PdfArray? _getNodeKids(PdfDictionary node) {
    final IPdfPrimitive? obj = node[PdfDictionaryProperties.kids];
    final PdfArray? kids = _helper._crossTable!.getObject(obj) as PdfArray?;
    return kids;
  }

  Map<String, dynamic> _getParentNode(
      int kidStartIndex,
      PdfArray kids,
      int lowIndex,
      int pageIndex,
      PdfDictionary? node,
      int? localIndex,
      bool? isParentFetched) {
    isParentFetched = false;
    node = null;
    localIndex = -1;
    bool isNonLeafNode = false;
    int tempCount = kids.count;
    for (int i = kidStartIndex; i < tempCount; ++i) {
      final IPdfPrimitive? primitive = _helper._crossTable!.getObject(kids[i]);
      if (primitive != null && primitive is PdfDictionary) {
        final PdfDictionary subNode = primitive;
        final String? pageValue =
            (subNode[PdfDictionaryProperties.type]! as PdfName).name;
        if (_isNodeLeaf(subNode) &&
            !(pageValue == PdfDictionaryProperties.pages)) {
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

  bool _isNodeLeaf(PdfDictionary node) {
    return _getNodeCount(node) == 0;
  }

  int _countPages() {
    final PdfSectionCollection sectionCollection = _helper.document!.sections!;
    int count = 0;
    for (int i = 0;
        i <
            PdfSectionCollectionHelper.getHelper(sectionCollection)
                .sections
                .length;
        i++) {
      final PdfSection section = sectionCollection[i];
      count += PdfSectionHelper.getHelper(section).count;
    }
    return count;
  }

  void _removePage(PdfPage? page, int index) {
    if (PdfDocumentHelper.getHelper(_helper.document!).isLoadedDocument &&
        index > -1) {
      final Map<PdfPage, dynamic>? pageToBookmarkDic =
          PdfDocumentHelper.getHelper(_helper.document!)
              .createBookmarkDestinationDictionary();
      if (pageToBookmarkDic != null) {
        List<dynamic>? bookmarks;
        if (pageToBookmarkDic.containsKey(page)) {
          bookmarks = pageToBookmarkDic[page!] as List<dynamic>?;
        }
        if (bookmarks != null) {
          for (int i = 0; i < bookmarks.length; i++) {
            if (bookmarks[i] is PdfBookmarkBase) {
              final PdfBookmarkBase current = bookmarks[i] as PdfBookmarkBase;
              if (PdfBookmarkBaseHelper.getHelper(current)
                  .dictionary!
                  .containsKey(PdfDictionaryProperties.a)) {
                PdfBookmarkBaseHelper.getHelper(current)
                    .dictionary!
                    .remove(PdfDictionaryProperties.a);
              }
              if (PdfBookmarkBaseHelper.getHelper(current)
                  .dictionary!
                  .containsKey(PdfDictionaryProperties.dest)) {
                PdfBookmarkBaseHelper.getHelper(current)
                    .dictionary!
                    .remove(PdfDictionaryProperties.dest);
              }
            }
          }
        }
      }
      final PdfDictionary dic = IPdfWrapper.getElement(page!)! as PdfDictionary;
      int? localIndex = 0;
      final Map<String, dynamic> result = _getParent(index, localIndex);
      final PdfDictionary parent = result['node'] as PdfDictionary;
      localIndex = result['index'] as int?;
      dic[PdfDictionaryProperties.parent] = PdfReferenceHolder(parent);
      PdfArray? kids = _getNodeKids(parent);
      if (index == 0) {
        final PdfCrossTable table =
            PdfDocumentHelper.getHelper(_helper.document!).crossTable;
        if (table.documentCatalog != null) {
          final IPdfPrimitive? primitive = table.documentCatalog!['OpenAction'];
          PdfArray? documentCatalog;
          if (primitive != null) {
            if (primitive is PdfArray) {
              documentCatalog = primitive;
            }
          }
          if (documentCatalog != null) {
            documentCatalog.remove(PdfReferenceHolder(dic));
          } else if (primitive is PdfReferenceHolder) {
            final IPdfPrimitive? documentDic = primitive.object;
            if (documentDic != null && documentDic is PdfDictionary) {
              if (documentDic.containsKey('D')) {
                final IPdfPrimitive? documentObject = documentDic['D'];
                if (documentObject != null && documentObject is PdfArray) {
                  for (int i = 0; i < documentObject.count; i++) {
                    final IPdfPrimitive? entry = documentObject[i];
                    if (entry != null && entry is PdfReferenceHolder) {
                      final IPdfPrimitive? referenceDictionary = entry.object;
                      if (referenceDictionary != null &&
                          referenceDictionary == dic) {
                        documentObject.remove(entry);
                      }
                    }
                  }
                }
              }
            }
          }
        }
      }
      PdfReferenceHolder? remove;
      for (int i = 0; i < kids!.count; i++) {
        final IPdfPrimitive? holder = kids[i];
        if (holder != null &&
            holder is PdfReferenceHolder &&
            holder.object == dic) {
          remove = holder;
          break;
        }
      }
      if (remove != null) {
        _removeFormFields(remove);
        kids.remove(remove);
        if (kids.count == 0 &&
            parent.containsKey(PdfDictionaryProperties.parent)) {
          PdfDictionary? parentDic;
          IPdfPrimitive? holder = parent[PdfDictionaryProperties.parent];
          if (holder is PdfReferenceHolder) {
            holder = holder.object;
            if (holder != null && holder is PdfDictionary) {
              parentDic = holder;
            }
          } else if (holder is PdfDictionary) {
            parentDic = holder;
          }
          if (parentDic != null) {
            IPdfPrimitive? kidsPrimitive =
                parentDic[PdfDictionaryProperties.kids];
            if (kidsPrimitive is PdfReferenceHolder) {
              kidsPrimitive = kidsPrimitive.object;
              if (kidsPrimitive != null && kidsPrimitive is PdfArray) {
                kids = kidsPrimitive;
              }
            } else if (kidsPrimitive is PdfArray) {
              kids = kidsPrimitive;
            }
            PdfReferenceHolder? remove;
            for (int i = 0; i < kids.count; i++) {
              final IPdfPrimitive? holder = kids[i];
              if (holder != null &&
                  holder is PdfReferenceHolder &&
                  holder.object == parent) {
                remove = holder;
                break;
              }
            }
            if (remove != null) {
              kids.remove(remove);
            }
          }
        }
      }
      _updateCountDecrement(parent);
    }
  }

  void _removeFormFields(PdfReferenceHolder pageHolder) {
    if (PdfDocumentHelper.getHelper(_helper.document!).isLoadedDocument) {
      PdfFormFieldCollectionHelper.getHelper(
              PdfPageCollectionHelper.getHelper(this).document!.form.fields)
          .removeContainingField(pageHolder);
    }
  }

  void _updateCountDecrement(PdfDictionary? parent) {
    while (parent != null) {
      int count = _getNodeCount(parent) - 1;
      if (count == 0) {
        final PdfDictionary node = parent;
        final IPdfPrimitive? result =
            PdfCrossTable.dereference(parent[PdfDictionaryProperties.parent]);
        if (result != null && result is PdfDictionary) {
          final IPdfPrimitive? kids = result[PdfDictionaryProperties.kids];
          if (kids != null && kids is PdfArray) {
            kids.remove(PdfReferenceHolder(node));
          }
        }
      }
      count = _getNodeCount(parent) - 1;
      parent[PdfDictionaryProperties.count] = PdfNumber(count);
      final IPdfPrimitive? primitive =
          PdfCrossTable.dereference(parent[PdfDictionaryProperties.parent]);
      parent =
          (primitive != null && primitive is PdfDictionary) ? primitive : null;
    }
  }
}

/// [PdfPageCollection] helper
class PdfPageCollectionHelper {
  /// internal constructor
  PdfPageCollectionHelper(this.base);

  /// internal field
  late PdfPageCollection base;

  /// internal method
  static PdfPageCollectionHelper getHelper(PdfPageCollection base) {
    return base._helper;
  }

  /// internal method
  static PdfPageCollection load(PdfDocument? document, [PdfSection? section]) {
    return PdfPageCollection._(document, section);
  }

  /// internal method
  static PdfPageCollection fromCrossTable(
      PdfDocument document, PdfCrossTable crossTable) {
    return PdfPageCollection._fromCrossTable(document, crossTable);
  }

  /// internal field
  PdfDocument? document;

  /// internal field
  final Map<PdfPage, int> pageCollectionIndex = <PdfPage, int>{};
  int _count = 0;
  PdfSection? _section;
  Map<PdfDictionary?, PdfPage>? _pageCache;
  PdfCrossTable? _crossTable;

  /// internal method
  void addPage(PdfPage page) {
    PdfSection section = _section ?? _getLastSection();
    if (_section == null) {
      if (!_checkPageSettings(PdfSectionHelper.getHelper(section).settings)) {
        section = document!.sections!.add();
        section.pageSettings =
            PdfPageSettingsHelper.getHelper(document!.pageSettings).clone();
      }
      if (!pageCollectionIndex.containsKey(page)) {
        pageCollectionIndex[page] = _count++;
      }
    }
    PdfSectionHelper.getHelper(section).add(page);
  }

  PdfSection _getLastSection() {
    final PdfSectionCollection sectionCollection = document!.sections!;
    if (PdfSectionCollectionHelper.getHelper(sectionCollection)
        .sections
        .isEmpty) {
      sectionCollection.add();
    }
    return sectionCollection[
        PdfSectionCollectionHelper.getHelper(sectionCollection)
                .sections
                .length -
            1];
  }

  bool _checkPageSettings(PdfPageSettings sectionSettings) {
    final PdfPageSettings docSettings = document!.pageSettings;
    return sectionSettings.size == docSettings.size &&
        sectionSettings.orientation == docSettings.orientation &&
        (sectionSettings.margins.left == docSettings.margins.left &&
            sectionSettings.margins.top == docSettings.margins.top &&
            sectionSettings.margins.right == docSettings.margins.right &&
            sectionSettings.margins.bottom == docSettings.margins.bottom);
  }

  /// internal method
  bool contains(PdfPage page) {
    if (_section != null) {
      return PdfSectionHelper.getHelper(_section!).indexOf(page) != -1;
    } else {
      bool value = false;
      for (int i = 0; i < document!.sections!.count; i++) {
        value |= PdfPageCollectionHelper.getHelper(document!.sections![i].pages)
            .contains(page);
      }
      return value;
    }
  }

  /// internal method
  void onPageAdded(PageAddedArgs args) {
    if (base.pageAdded != null) {
      base.pageAdded!(base, args);
    }
  }

  /// internal method
  void remove(PdfPage page) {
    if (_section != null) {
      PdfSectionHelper.getHelper(_section!).remove(page);
    } else {
      for (int i = 0; i < document!.sections!.count; i++) {
        if (PdfPageCollectionHelper.getHelper(document!.sections![i].pages)
            .contains(page)) {
          PdfPageCollectionHelper.getHelper(document!.sections![i].pages)
              .remove(page);
          break;
        }
      }
    }
  }

  /// internal method
  PdfPage getPage(PdfDictionary? dic) {
    final Map<PdfDictionary?, PdfPage> pageCahce = _pageCache!;
    PdfPage? page;
    if (pageCahce.containsKey(dic)) {
      page = pageCahce[dic];
    }
    if (page == null) {
      page = PdfPageHelper.fromDictionary(document!, _crossTable!, dic!);
      pageCahce[dic] = page;
    }
    return page;
  }
}
