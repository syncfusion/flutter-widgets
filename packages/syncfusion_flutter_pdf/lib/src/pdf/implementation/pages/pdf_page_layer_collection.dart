part of pdf;

/// The class provides methods and properties
/// to handle the collections of [PdfPageLayer].
class PdfPageLayerCollection extends PdfObjectCollection {
  //Constructor
  /// Initializes a new instance of the
  /// [PdfPageLayerCollection] class with PDF page.
  PdfPageLayerCollection(PdfPage page) : super() {
    ArgumentError.checkNotNull(page, 'page');
    _page = page;
    _parseLayers(page);
  }

  //Fields
  PdfPage _page;

  //Properties
  /// Gets [PdfPageLayer] by its index from [PdfPageLayerCollection].
  PdfPageLayer operator [](int index) => _returnValue(index);
  PdfPageLayer _returnValue(int index) {
    return _list[index] as PdfPageLayer;
  }

  //Public methods
  /// Creates a new <see cref="PdfPageLayer"/> and adds it to the end of the collection.
  PdfPageLayer add() {
    final PdfPageLayer layer = PdfPageLayer(_page);
    layer._name = '';
    addLayer(layer);
    return layer;
  }

  /// Adds [PdfPageLayer] to the collection.
  int addLayer(PdfPageLayer layer) {
    ArgumentError.checkNotNull(layer, 'layer');
    if (layer.page != _page) {
      ArgumentError.value(layer, 'The layer belongs to another page');
    }
    _list.add(layer);
    final int listIndex = count - 1;
    _page._contents._add(_PdfReferenceHolder(layer));
    return listIndex;
  }

  /// Returns index of the [PdfPageLayer] in the collection if exists,
  /// -1 otherwise.
  int indexOf(PdfPageLayer layer) {
    ArgumentError.checkNotNull(layer, 'layer');
    return _list.indexOf(layer);
  }

  //Implementation
  void _parseLayers(PdfPage page) {
    ArgumentError.checkNotNull(page, 'page');
    if (!page._isTextExtraction) {
      final _PdfArray contents = page._contents;
      final _PdfStream saveStream = _PdfStream();
      final _PdfStream restoreStream = _PdfStream();
      const int saveState = 113;
      const int restoreState = 81;
      saveStream._dataStream = <int>[saveState];
      if (contents.count > 0) {
        contents._insert(0, _PdfReferenceHolder(saveStream));
      } else {
        contents._add(_PdfReferenceHolder(saveStream));
      }
      restoreStream._dataStream = <int>[restoreState];
      contents._add(_PdfReferenceHolder(restoreStream));
    }
  }

  List<int> _combineContent(bool skipSave) {
    ArgumentError.checkNotNull(_page);
    final bool decompress = _page._isLoadedPage;
    List<int> combinedData;
    final List<int> end = <int>[13, 10];
    if (_page._isLoadedPage && _page._contents.count != count + 2) {
      combinedData = _combineProcess(_page, decompress, end, skipSave);
    }
    return combinedData;
  }

  List<int> _combineProcess(
      PdfPage page, bool decompress, List<int> end, bool isTextExtraction) {
    final List<int> data = <int>[];
    for (int i = 0; i < page._contents.count; i++) {
      _PdfStream layerStream;
      final _IPdfPrimitive contentPrimitive = page._contents[i];
      if (contentPrimitive is _PdfReferenceHolder) {
        final _IPdfPrimitive primitive = contentPrimitive.object;
        if (primitive != null && primitive is _PdfStream) {
          layerStream = primitive;
        }
      } else if (contentPrimitive is _PdfStream) {
        layerStream = contentPrimitive;
      }
      if (layerStream != null) {
        if (decompress) {
          final bool isChanged =
              layerStream._isChanged != null && layerStream._isChanged
                  ? true
                  : false;
          layerStream._decompress();
          layerStream._isChanged = isChanged || !isTextExtraction;
        }
        data.addAll(layerStream._dataStream);
        data.addAll(end);
      }
    }
    return data;
  }
}
