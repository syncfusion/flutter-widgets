part of pdf;

/// Represents base class for field's group items.
class PdfFieldItem {
  //Constructor
  /// Initializes a new instance of the [PdfFieldItem] class.
  PdfFieldItem._(PdfField field, int index, _PdfDictionary? dictionary) {
    _field = field;
    _collectionIndex = index;
    _dictionary = dictionary;
  }

  //Field
  late PdfField _field;
  int _collectionIndex = 0;
  _PdfDictionary? _dictionary;
  PdfPage? _page;

  //Properties
  /// Gets or sets the bounds.
  Rect get bounds {
    final int backUpIndex = _field._defaultIndex;
    _field._defaultIndex = _collectionIndex;
    final Rect rect = _field.bounds;
    _field._defaultIndex = backUpIndex;
    return rect;
  }

  set bounds(Rect value) {
    if (value.isEmpty) {
      ArgumentError('bounds can\'t be null/empty');
    }
    final int backUpIndex = _field._defaultIndex;
    _field._defaultIndex = _collectionIndex;
    _field.bounds = value;
    _field._defaultIndex = backUpIndex;
  }

  /// Gets the page of the field.
  PdfPage? get page {
    if (_page == null) {
      final int backUpIndex = _field._defaultIndex;
      _field._defaultIndex = _collectionIndex;
      _page = _field.page;
      final _PdfName pName = _PdfName(_DictionaryProperties.p);
      if (_field._kids != null && _field._kids!.count > 0) {
        final PdfDocument? doc = _field._crossTable!._document;
        if (doc != null && doc._isLoadedDocument) {
          if (_dictionary!.containsKey(pName)) {
            final _IPdfPrimitive? pageRef = _field._crossTable!
                ._getObject(_dictionary![_DictionaryProperties.p]);
            if (pageRef != null && pageRef is _PdfDictionary) {
              final _PdfReference widgetReference =
                  _field._crossTable!._getReference(_dictionary);
              for (int i = 0; i < doc.pages.count; i++) {
                final PdfPage loadedPage = doc.pages[i];
                final _PdfArray? lAnnots = loadedPage._obtainAnnotations();
                if (lAnnots != null) {
                  for (int i = 0; i < lAnnots.count; i++) {
                    final _IPdfPrimitive? holder = lAnnots[i];
                    if (holder != null &&
                        holder is _PdfReferenceHolder &&
                        holder.reference!._objNum == widgetReference._objNum &&
                        holder.reference!._genNum == widgetReference._genNum) {
                      _page = doc.pages._getPage(pageRef);
                      _field._defaultIndex = backUpIndex;
                      return _page;
                    }
                  }
                }
              }
              _field._defaultIndex = backUpIndex;
              _page = null;
            }
          } else {
            final _PdfReference widgetReference =
                _field._crossTable!._getReference(_dictionary);
            for (int i = 0; i < doc.pages.count; i++) {
              final PdfPage loadedPage = doc.pages[i];
              final _PdfArray? lAnnots = loadedPage._obtainAnnotations();
              if (lAnnots != null) {
                for (int i = 0; i < lAnnots.count; i++) {
                  final _IPdfPrimitive? holder = lAnnots[i];
                  if (holder != null &&
                      holder is _PdfReferenceHolder &&
                      holder.reference!._objNum == widgetReference._objNum &&
                      holder.reference!._genNum == widgetReference._genNum) {
                    return _page = loadedPage;
                  }
                }
              }
            }
            _page = null;
          }
        }
      }
      _field._defaultIndex = backUpIndex;
    }
    return _page;
  }

  PdfPen? get _borderPen {
    final int backUpIndex = _field._defaultIndex;
    _field._defaultIndex = _collectionIndex;
    final PdfPen? pen = _field._borderPen;
    _field._defaultIndex = backUpIndex;
    return pen;
  }

  PdfBorderStyle? get _borderStyle {
    final int backUpIndex = _field._defaultIndex;
    _field._defaultIndex = _collectionIndex;
    final PdfBorderStyle bs = _field._borderStyle;
    _field._defaultIndex = backUpIndex;
    return bs;
  }

  int get _borderWidth {
    final int backUpIndex = _field._defaultIndex;
    _field._defaultIndex = _collectionIndex;
    final int borderWidth = _field._borderWidth;
    _field._defaultIndex = backUpIndex;
    return borderWidth;
  }

  PdfStringFormat? get _format {
    final int backUpIndex = _field._defaultIndex;
    _field._defaultIndex = _collectionIndex;
    final PdfStringFormat? sFormat = _field._format;
    _field._defaultIndex = backUpIndex;
    return sFormat;
  }

  PdfBrush? get _backBrush {
    final int backUpIndex = _field._defaultIndex;
    _field._defaultIndex = _collectionIndex;
    final PdfBrush? backBrush = _field._backBrush;
    _field._defaultIndex = backUpIndex;
    return backBrush;
  }

  PdfBrush? get _foreBrush {
    final int backUpIndex = _field._defaultIndex;
    _field._defaultIndex = _collectionIndex;
    final PdfBrush? foreBrush = _field._foreBrush;
    _field._defaultIndex = backUpIndex;
    return foreBrush;
  }

  PdfBrush? get _shadowBrush {
    final int backUpIndex = _field._defaultIndex;
    _field._defaultIndex = _collectionIndex;
    final PdfBrush? shadowBrush = _field._shadowBrush;
    _field._defaultIndex = backUpIndex;
    return shadowBrush;
  }

  PdfFont get _font {
    final int backUpIndex = _field._defaultIndex;
    _field._defaultIndex = _collectionIndex;
    final PdfFont font = _field._font!;
    _field._defaultIndex = backUpIndex;
    return font;
  }
}
