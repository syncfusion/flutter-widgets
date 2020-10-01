part of pdf;

/// The [PdfPageLayer] used to create layers in PDF document.
/// Layers refers to sections of content in a PDF document that can be
/// selectively viewed or hidden by document authors or consumers.
class PdfPageLayer implements _IPdfWrapper {
  //Constructor
  /// Initializes a new instance of the [PdfPageLayer] class
  /// with specified PDF page.
  PdfPageLayer(PdfPage pdfPage) {
    _initialize(pdfPage, true);
  }

  PdfPageLayer._fromClipPageTemplate(PdfPage pdfPage,
      [bool clipPageTemplates]) {
    _initialize(pdfPage, clipPageTemplates);
  }

  //Fields
  _PdfStream _content;
  PdfPage _page;
  bool _clipPageTemplates;
  //ignore:unused_field
  String _name;
  PdfGraphics _graphics;
  //ignore:unused_field
  PdfColorSpace _colorSpace;
  PdfGraphicsState _graphicsState;
  bool _isEndState = false;
  bool _isSaved = false;

  //Properties
  /// Gets parent page of the layer.
  PdfPage get page => _page;

  /// Gets Graphics context of the layer, used to draw various graphical
  /// content on layer.
  PdfGraphics get graphics {
    if (_graphics == null || _isSaved) {
      _initializeGraphics(page);
    }
    return _graphics;
  }

  //Implementation
  void _initialize(PdfPage pdfPage, bool clipPageTemplates) {
    if (pdfPage != null) {
      _page = pdfPage;
    } else {
      throw ArgumentError.value(pdfPage, 'page');
    }
    _clipPageTemplates = clipPageTemplates;
    _content = _PdfStream();
  }

  void _initializeGraphics(PdfPage page) {
    if (_graphics == null) {
      final Function resources = page._getResources;
      bool isPageHasMediaBox = false;
      bool isInvalidSize = false;
      if (page._dictionary
          .containsKey(_PdfName(_DictionaryProperties.mediaBox))) {
        isPageHasMediaBox = true;
      }
      double llx = 0;
      double lly = 0;
      double urx = 0;
      double ury = 0;
      final _PdfArray mediaBox = page._dictionary._getValue(
          _DictionaryProperties.mediaBox, _DictionaryProperties.parent);
      if (mediaBox != null) {
        // Lower Left X co-ordinate Value.
        llx = (mediaBox[0] as _PdfNumber).value.toDouble();
        // Lower Left Y co-ordinate value.
        lly = (mediaBox[1] as _PdfNumber).value.toDouble();
        // Upper right X co-ordinate value.
        urx = (mediaBox[2] as _PdfNumber).value.toDouble();
        // Upper right Y co-ordinate value.
        ury = (mediaBox[3] as _PdfNumber).value.toDouble();
      }
      _PdfArray cropBox;
      if (page._dictionary.containsKey(_DictionaryProperties.cropBox)) {
        cropBox = page._dictionary._getValue(
            _DictionaryProperties.cropBox, _DictionaryProperties.parent);
        final double cropX = (cropBox[0] as _PdfNumber).value.toDouble();
        final double cropY = (cropBox[1] as _PdfNumber).value.toDouble();
        final double cropRX = (cropBox[2] as _PdfNumber).value.toDouble();
        final double cropRY = (cropBox[3] as _PdfNumber).value.toDouble();
        if ((cropX < 0 || cropY < 0 || cropRX < 0 || cropRY < 0) &&
            (cropY.abs().floor() == page.size.height.abs().floor()) &&
            (cropX.abs().floor()) == page.size.width.abs().floor()) {
          final Size pageSize =
              Size([cropX, cropRX].reduce(max), [cropY, cropRY].reduce(max));
          _graphics = PdfGraphics._(pageSize, resources, _content);
        } else {
          _graphics = PdfGraphics._(page.size, resources, _content);
          _graphics._cropBox = cropBox;
        }
      } else if ((llx < 0 || lly < 0 || urx < 0 || ury < 0) &&
          (lly.abs().floor() == page.size.height.abs().floor()) &&
          (urx.abs().floor() == page.size.width.abs().floor())) {
        Size pageSize = Size([llx, urx].reduce(max), [lly, ury].reduce(max));
        if (pageSize.width <= 0 || pageSize.height <= 0) {
          isInvalidSize = true;
          if (llx < 0) {
            llx = -llx;
          } else if (urx < 0) {
            urx = -urx;
          }
          if (lly < 0) {
            lly = -lly;
          } else if (ury < 0) {
            ury = -ury;
          }
          pageSize = Size([llx, urx].reduce(max), [lly, ury].reduce(max));
          _graphics = PdfGraphics._(pageSize, resources, _content);
        }
      } else {
        _graphics = PdfGraphics._(page.size, resources, _content);
      }

      if (isPageHasMediaBox) {
        _graphics._mediaBoxUpperRightBound = isInvalidSize ? -lly : ury;
      }
      if (page != null && !page._isLoadedPage) {
        final PdfSectionCollection sectionCollection = page._section._parent;
        if (sectionCollection != null) {
          _graphics.colorSpace = sectionCollection._document.colorSpace;
          _colorSpace = sectionCollection._document.colorSpace;
        }
      }
      _content._beginSave = _beginSaveContent;
    }
    _graphicsState = _graphics.save();
    _graphics._initializeCoordinates();
    if (_graphics._hasTransparencyBrush) {
      _graphics._setTransparencyGroup(page);
    }
    if (page != null &&
        page._isLoadedPage &&
        (page._rotation != PdfPageRotateAngle.rotateAngle0 ||
            page._dictionary.containsKey(_DictionaryProperties.rotate))) {
      _PdfArray cropBox;
      if (page._dictionary.containsKey(_DictionaryProperties.cropBox)) {
        cropBox = page._dictionary._getValue(
            _DictionaryProperties.cropBox, _DictionaryProperties.parent);
      }
      _updatePageRotation(page, _graphics, cropBox);
    }
    if (page != null && !page._isLoadedPage) {
      final _Rectangle clipRect = page._section._getActualBounds(page, true);
      if (_clipPageTemplates) {
        if (page._origin.dx >= 0 && page._origin.dy >= 0) {
          _graphics._clipTranslateMarginsWithBounds(clipRect);
        }
      } else {
        final PdfMargins margins = page._section.pageSettings.margins;
        _graphics._clipTranslateMargins(clipRect.x, clipRect.y, margins.left,
            margins.top, margins.right, margins.bottom);
      }
    }
    _graphics._setLayer(this);
    _isSaved = false;
  }

  void _updatePageRotation(
      PdfPage page, PdfGraphics graphics, _PdfArray cropBox) {
    _PdfNumber rotation;
    if (page._dictionary.containsKey(_DictionaryProperties.rotate)) {
      rotation = page._dictionary[_DictionaryProperties.rotate];
      rotation ??= rotation = _PdfCrossTable._dereference(
          page._dictionary[_DictionaryProperties.rotate]);
    } else if (page._rotation != PdfPageRotateAngle.rotateAngle0) {
      if (page._rotation == PdfPageRotateAngle.rotateAngle90) {
        rotation = _PdfNumber(90);
      } else if (page._rotation == PdfPageRotateAngle.rotateAngle180) {
        rotation = _PdfNumber(180);
      } else if (page._rotation == PdfPageRotateAngle.rotateAngle270) {
        rotation = _PdfNumber(270);
      }
    }
    if (rotation.value == 90) {
      graphics.translateTransform(0, page.size.height);
      graphics.rotateTransform(-90);
      if (cropBox != null) {
        final double height = (cropBox[3] as _PdfNumber).value.toDouble();
        final Size cropBoxSize = Size(
            (cropBox[2] as _PdfNumber).value.toDouble(),
            height != 0 ? height : (cropBox[1] as _PdfNumber).value.toDouble());
        final Offset cropBoxOffset = Offset(
            (cropBox[0] as _PdfNumber).value.toDouble(),
            (cropBox[1] as _PdfNumber).value.toDouble());
        if (page.size.height < cropBoxSize.height) {
          graphics._clipBounds.size = _Size(page.size.height - cropBoxOffset.dy,
              cropBoxSize.width - cropBoxOffset.dx);
        } else {
          graphics._clipBounds.size = _Size(
              cropBoxSize.height - cropBoxOffset.dy,
              cropBoxSize.width - cropBoxOffset.dx);
        }
      } else {
        graphics._clipBounds.size = _Size(page.size.height, page.size.width);
      }
    } else if (rotation.value == 180) {
      graphics.translateTransform(page.size.width, page.size.height);
      graphics.rotateTransform(-180);
    } else if (rotation.value == 270) {
      graphics.translateTransform(page.size.width, 0);
      graphics.rotateTransform(-270);
      graphics._clipBounds.size = _Size(page.size.height, page.size.width);
    }
  }

  void _beginSaveContent(Object sender, _SavePdfPrimitiveArgs args) {
    if (_graphicsState != null) {
      if (_isEndState) {
        graphics._streamWriter._write('EMC\n');
        _isEndState = false;
      }
      graphics.restore(_graphicsState);
      _graphicsState = null;
    }
    _isSaved = true;
  }

  //_IPdfWrapper elements
  @override
  _IPdfPrimitive get _element => _content;
  @override
  //ignore: unused_element
  set _element(_IPdfPrimitive value) {
    _content = value;
  }
}
