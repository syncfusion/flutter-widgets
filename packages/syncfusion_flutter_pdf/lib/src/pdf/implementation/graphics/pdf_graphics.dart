part of pdf;

/// Represents a graphics context of the objects.
class PdfGraphics {
  //Constructor
  /// Initializes a new instance of the [PdfGraphics] class.
  PdfGraphics._(Size size, Function getResources, _PdfStream stream) {
    ArgumentError.checkNotNull(stream);
    ArgumentError.checkNotNull(getResources);
    ArgumentError.checkNotNull(size);
    _streamWriter = _PdfStreamWriter(stream);
    _getResources = getResources;
    _canvasSize = size;
    _initialize();
  }

  //Fields
  Function _getResources;
  _PdfStreamWriter _streamWriter;
  Size _canvasSize;
  bool _isStateSaved;
  PdfPen _currentPen;
  PdfBrush _currentBrush;
  PdfFont _currentFont;
  _PdfTransformationMatrix _transformationMatrix;
  final bool _hasTransparencyBrush = false;
  int _previousTextRenderingMode = _TextRenderingMode.fill;
  double _previousCharacterSpacing;
  double _previousWordSpacing;
  double _previousTextScaling;
  PdfStringFormat _currentStringFormat;
  _Rectangle _clipBounds;
  _PdfArray _cropBox;
  List<PdfGraphicsState> _graphicsState;
  double _mediaBoxUpperRightBound;
  PdfPageLayer _layer;
  bool _colorSpaceChanged = false;
  bool _isColorSpaceInitialized = false;
  final Map<PdfColorSpace, String> _colorSpaces = <PdfColorSpace, String>{
    PdfColorSpace.rgb: 'RGB',
    PdfColorSpace.cmyk: 'CMYK',
    PdfColorSpace.grayScale: 'GrayScale',
    PdfColorSpace.indexed: 'Indexed'
  };
  _PdfStringLayoutResult _stringLayoutResult;
  _PdfAutomaticFieldInfoCollection _automaticFields;
  Map<_TransparencyData, _PdfTransparency> _trasparencies;
  PdfLayer _documentLayer;

  //Properties
  /// Gets or sets the current color space of the document
  PdfColorSpace colorSpace;

  /// Gets the size of the canvas.
  Size get size => _canvasSize;

  /// Gets the size of the canvas reduced by margins and page templates.
  Size get clientSize => Size(_clipBounds.width, _clipBounds.height);

  _PdfTransformationMatrix get _matrix {
    _transformationMatrix ??= _PdfTransformationMatrix();
    return _transformationMatrix;
  }

  PdfPage get _page {
    if (_documentLayer != null) {
      return _documentLayer._page;
    } else {
      return _layer.page;
    }
  }

  /// Gets the automatic fields.
  _PdfAutomaticFieldInfoCollection get _autoFields {
    _automaticFields ??= _PdfAutomaticFieldInfoCollection();
    return _automaticFields;
  }

  //Public methods
  /// Changes the origin of the coordinate system
  /// by prepending the specified translation
  /// to the transformation matrix of this Graphics.
  void translateTransform(double offsetX, double offsetY) {
    final _PdfTransformationMatrix matrix = _PdfTransformationMatrix();
    matrix._translate(offsetX, -offsetY);
    _streamWriter._modifyCurrentMatrix(matrix);
    _matrix._multiply(matrix);
  }

  /// Applies the specified rotation
  /// to the transformation matrix of this Graphics.
  ///
  /// /// ```dart
  /// //Creates a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Adds a page to the PDF document.
  /// PdfPage page = doc.pages.add();
  /// PdfFont font = PdfStandardFont(PdfFontFamily.courier, 14);
  /// //Set rotate transform
  /// page.graphics.rotateTransform(-90);
  /// //Draws the text into PDF graphics in -90 degree rotation.
  /// page.graphics.drawString('Hello world.', font,
  ///   bounds: Rect.fromLTWH(-100, 0, 200, 50));
  /// //Saves the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  void rotateTransform(double angle) {
    final _PdfTransformationMatrix matrix = _PdfTransformationMatrix();
    matrix._rotate(-angle);
    _streamWriter._modifyCurrentMatrix(matrix);
    _matrix._multiply(matrix);
  }

  /// Saves the current state of this Graphics
  /// and identifies the saved state with a GraphicsState.
  PdfGraphicsState save() {
    final PdfGraphicsState state = PdfGraphicsState._(this, _matrix);
    state._brush = _currentBrush;
    state._pen = _currentPen;
    state._font = _currentFont;
    state._colorSpace = colorSpace;
    state._characterSpacing = _previousCharacterSpacing;
    state._wordSpacing = _previousWordSpacing;
    state._textScaling = _previousTextScaling;
    state._textRenderingMode = _previousTextRenderingMode;
    _graphicsState.add(state);
    if (_isStateSaved) {
      _streamWriter._restoreGraphicsState();
      _isStateSaved = false;
    }
    _streamWriter._saveGraphicsState();
    return state;
  }

  /// Restores the state of this Graphics to the state represented
  /// by a GraphicsState.
  void restore([PdfGraphicsState state]) {
    if (state == null) {
      if (_graphicsState.isNotEmpty) {
        _doRestoreState();
      }
    } else {
      if (state._graphics != this) {
        throw ArgumentError.value(
            this, 'The graphics state belongs to another graphics object');
      }
      if (_graphicsState.contains(state)) {
        while (true) {
          if (_graphicsState.isEmpty) {
            break;
          }
          final PdfGraphicsState popState = _doRestoreState();
          if (popState == state) {
            break;
          }
        }
      }
    }
  }

  /// Draws the specified text string at the specified location
  void drawString(String s, PdfFont font,
      {PdfPen pen, PdfBrush brush, Rect bounds, PdfStringFormat format}) {
    ArgumentError.checkNotNull(s);
    ArgumentError.checkNotNull(font);
    _Rectangle layoutRectangle;
    if (bounds != null) {
      layoutRectangle = _Rectangle.fromRect(bounds);
    } else {
      layoutRectangle = _Rectangle.empty;
    }
    if (pen == null && brush == null) {
      brush = PdfSolidBrush(PdfColor(0, 0, 0));
    }
    _layoutString(s, font,
        pen: pen,
        brush: brush,
        layoutRectangle: layoutRectangle,
        format: format);
  }

  /// Draws a line connecting the two points specified by the coordinate pairs.
  void drawLine(PdfPen pen, Offset point1, Offset point2) {
    _beginMarkContent();
    _stateControl(pen, null, null, null);
    _streamWriter._beginPath(point1.dx, point1.dy);
    _streamWriter._appendLineSegment(point2.dx, point2.dy);
    _streamWriter._strokePath();
    _endMarkContent();
    (_getResources() as _PdfResources)
        ._requireProcset(_DictionaryProperties.pdf);
  }

  /// Draws a rectangle specified by a pen, a brush and a Rect structure.
  void drawRectangle({PdfPen pen, PdfBrush brush, Rect bounds}) {
    _beginMarkContent();
    _stateControl(pen, brush, null, null);
    bounds != null
        ? _streamWriter._appendRectangle(
            bounds.left, bounds.top, bounds.width, bounds.height)
        : _streamWriter._appendRectangle(0, 0, 0, 0);
    _drawPath(pen, brush, PdfFillMode.winding, false);
    _endMarkContent();
    (_getResources() as _PdfResources)
        ._requireProcset(_DictionaryProperties.pdf);
  }

  /// Draws a template at the specified location and size.
  ///
  /// ```dart
  /// //Creates a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Adds a page to the PDF document.
  /// PdfPage page = doc.pages.add();
  /// PdfFont font = PdfStandardFont(PdfFontFamily.courier, 14);
  /// PdfBrush brush = PdfSolidBrush(PdfColor(255, 0, 0));
  /// //Create a PDF Template.
  /// PdfTemplate template = PdfTemplate(200, 100);
  /// //Draws a rectangle into the graphics of the template.
  /// template.graphics.drawRectangle(brush: brush,
  /// bounds: Rect.fromLTWH(0, 20, 200, 50));
  /// //Draws a string into the graphics of the template.
  /// template.graphics.drawString('This is PDF template.', font);
  /// //Draws the template into the page graphics of the document.
  /// page.graphics.drawPdfTemplate(template, Offset(100, 100));
  /// //Saves the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  void drawPdfTemplate(PdfTemplate template, Offset location, [Size size]) {
    ArgumentError.checkNotNull(template);
    size ??= template.size;
    _drawTemplate(template, location, size);
  }

  /// Draws an image into PDF graphics.
  ///
  /// ```dart
  /// //Creates a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw the image.
  /// doc.pages
  ///   .add()
  ///   .graphics
  ///   .drawImage(PdfBitmap(imageData), Rect.fromLTWH(0, 0, 100, 100));
  /// //Saves the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  void drawImage(PdfImage image, Rect bounds) {
    ArgumentError.checkNotNull(image);
    ArgumentError.checkNotNull(bounds);
    _drawImage(image, bounds);
  }

  /// Sets the transparency of this Graphics.
  void setTransparency(double alpha, {double alphaBrush, PdfBlendMode mode}) {
    if (alpha == null || alpha < 0 || alpha > 1) {
      ArgumentError.value(alpha, 'alpha', 'invalid alpha value');
    }
    alphaBrush ??= alpha;
    mode ??= PdfBlendMode.normal;
    _setTransparency(alpha, alphaBrush, mode);
  }

  //Implementation
  void _initialize() {
    _mediaBoxUpperRightBound = 0;
    _isStateSaved = false;
    colorSpace = PdfColorSpace.rgb;
    _previousTextRenderingMode = _TextRenderingMode.fill;
    _previousTextRenderingMode = -1;
    _previousCharacterSpacing = -1.0;
    _previousWordSpacing = -1.0;
    _previousTextScaling = -100.0;
    _clipBounds = _Rectangle(0, 0, size.width, size.height);
    _graphicsState = <PdfGraphicsState>[];
    (_getResources() as _PdfResources)
        ._requireProcset(_DictionaryProperties.pdf);
  }

  void _setTransparency(double alpha, double alphaBrush, PdfBlendMode mode) {
    _trasparencies ??= <_TransparencyData, _PdfTransparency>{};
    _PdfTransparency transparency;
    final _TransparencyData transparencyData =
        _TransparencyData(alpha, alphaBrush, mode);
    if (_trasparencies.containsKey(transparencyData)) {
      transparency = _trasparencies[transparencyData];
    }
    if (transparency == null) {
      transparency = _PdfTransparency(alpha, alphaBrush, mode,
          conformance: _layer != null
              ? _page._document._conformanceLevel == PdfConformanceLevel.a1b
              : false);
      _trasparencies[transparencyData] = transparency;
    }
    final _PdfResources resources = _getResources();
    final _PdfName name = resources._getName(transparency);
    if (_layer != null) {
      _page._setResources(resources);
    }
    _streamWriter._setGraphicsState(name);
  }

  void _drawImage(PdfImage image, Rect rectangle) {
    _beginMarkContent();
    final _Rectangle bounds = _Rectangle.fromRect(rectangle);
    PdfGraphicsState beforeOrientation;
    final int angle = image._jpegOrientationAngle.toInt();
    if (angle > 0) {
      beforeOrientation = save();
      switch (angle) {
        case 90:
          translateTransform(bounds.x, bounds.y);
          rotateTransform(90);
          bounds.x = 0;
          bounds.y = -bounds.width.toDouble();
          final double modwidth = bounds.height.toDouble();
          final double modHeight = bounds.width.toDouble();
          bounds.width = modwidth;
          bounds.height = modHeight;
          break;
        case 180:
          translateTransform(bounds.x, bounds.y);
          rotateTransform(180);
          bounds.x = -bounds.width.toDouble();
          bounds.y = -bounds.height.toDouble();
          break;
        case 270:
          translateTransform(bounds.x, bounds.y);
          rotateTransform(270);
          bounds.x = -bounds.height;
          bounds.y = 0;
          final double modwidth2 = bounds.height.toDouble();
          final double modHeight2 = bounds.width.toDouble();
          bounds.width = modwidth2;
          bounds.height = modHeight2;
          break;
        default:
          break;
      }
    }
    if (clientSize.height < 0) {
      bounds.y += clientSize.height;
    }
    image._save();
    final PdfGraphicsState state = save();
    final _PdfTransformationMatrix matrix = _PdfTransformationMatrix();
    matrix._translate(bounds.x, -(bounds.y + bounds.height));
    matrix._scale(bounds.width, bounds.height);
    _streamWriter._modifyCurrentMatrix(matrix);
    final _PdfResources resources = _getResources();
    final _PdfName name = resources._getName(image);
    if (_layer != null) {
      _page._setResources(resources);
    }
    _streamWriter._executeObject(name);
    restore(state);
    if (beforeOrientation != null) {
      restore(beforeOrientation);
    }
    _endMarkContent();
    (_getResources() as _PdfResources)
        ._requireProcset(_DictionaryProperties.grayScaleImage);
    (_getResources() as _PdfResources)
        ._requireProcset(_DictionaryProperties.colorImage);
    (_getResources() as _PdfResources)
        ._requireProcset(_DictionaryProperties.indexedImage);
    (_getResources() as _PdfResources)
        ._requireProcset(_DictionaryProperties.text);
  }

  void _drawPath(
      PdfPen pen, PdfBrush brush, PdfFillMode fillMode, bool needClosing) {
    final bool isPen = pen != null && pen.color._isFilled;
    final bool isBrush =
        brush != null && (brush as PdfSolidBrush).color._isFilled;
    final bool isEvenOdd = fillMode == PdfFillMode.alternate;
    if (isPen && isBrush) {
      if (needClosing) {
        _streamWriter._closeFillStrokePath(isEvenOdd);
      } else {
        _streamWriter._fillStrokePath(isEvenOdd);
      }
    } else if (!isPen && !isBrush) {
      _streamWriter._endPath();
    } else if (isPen) {
      if (needClosing) {
        _streamWriter._closeStrokePath();
      } else {
        _streamWriter._strokePath();
      }
    } else if (isBrush) {
      if (needClosing) {
        _streamWriter._closeFillPath(isEvenOdd);
      } else {
        _streamWriter._fillPath(isEvenOdd);
      }
    } else {
      throw UnsupportedError('Internal CLR error.');
    }
  }

  void _drawTemplate(PdfTemplate template, Offset location, Size size) {
    _beginMarkContent();
    if (_layer != null &&
        _page._document != null &&
        _page._document._conformanceLevel != PdfConformanceLevel.none &&
        template.graphics._currentFont != null &&
        (template.graphics._currentFont is PdfStandardFont ||
            template.graphics._currentFont is PdfCjkStandardFont)) {
      throw ArgumentError(
          'All the fonts must be embedded in ${_page._document._conformanceLevel.toString()} document.');
    } else if (_layer != null &&
        _page._document != null &&
        _page._document._conformanceLevel == PdfConformanceLevel.a1b &&
        template.graphics._currentFont != null &&
        template.graphics._currentFont is PdfTrueTypeFont) {
      (template.graphics._currentFont as PdfTrueTypeFont)
          ._fontInternal
          ._initializeCidSet();
    }
    if ((_layer != null || _documentLayer != null) &&
        template._isLoadedPageTemplate) {
      _PdfCrossTable crossTable;
      crossTable = _page._section._document._crossTable;
      if ((template._isReadonly) || (template._isLoadedPageTemplate)) {
        template._cloneResources(crossTable);
      }
    }
    final double scaleX =
        (template.size.width > 0) ? size.width / template.size.width : 1;
    final double scaleY =
        (template.size.height > 0) ? size.height / template.size.height : 1;
    final bool hasScale = !(scaleX == 1 && scaleY == 1);
    final PdfGraphicsState state = save();
    final _PdfTransformationMatrix matrix = _PdfTransformationMatrix();
    if ((_layer != null || _documentLayer != null) &&
        _page != null &&
        template._isLoadedPageTemplate) {
      bool needTransformation = false;
      if (_page._dictionary.containsKey(_DictionaryProperties.cropBox) &&
          _page._dictionary.containsKey(_DictionaryProperties.mediaBox)) {
        _PdfArray cropBox;
        _PdfArray mediaBox;
        if (_page._dictionary[_DictionaryProperties.cropBox]
            is _PdfReferenceHolder) {
          cropBox = (_page._dictionary[_DictionaryProperties.cropBox]
                  as _PdfReferenceHolder)
              .object as _PdfArray;
        } else {
          cropBox =
              _page._dictionary[_DictionaryProperties.cropBox] as _PdfArray;
        }
        if (_page._dictionary[_DictionaryProperties.mediaBox]
            is _PdfReferenceHolder) {
          mediaBox = (_page._dictionary[_DictionaryProperties.mediaBox]
                  as _PdfReferenceHolder)
              .object as _PdfArray;
        } else {
          mediaBox =
              _page._dictionary[_DictionaryProperties.mediaBox] as _PdfArray;
        }
        if (cropBox != null && mediaBox != null) {
          if (cropBox.toRectangle() == mediaBox.toRectangle()) {
            needTransformation = true;
          }
        }
      }
      if (_page._dictionary.containsKey(_DictionaryProperties.mediaBox)) {
        _PdfArray mBox;
        if (_page._dictionary[_DictionaryProperties.mediaBox]
            is _PdfReferenceHolder) {
          mBox = (_page._dictionary[_DictionaryProperties.mediaBox]
                  as _PdfReferenceHolder)
              .object as _PdfArray;
        } else {
          mBox = _page._dictionary[_DictionaryProperties.mediaBox] as _PdfArray;
        }
        if (mBox != null) {
          if ((mBox[3] as _PdfNumber).value == 0) {
            needTransformation = true;
          }
        }
      }
      if ((_page._origin.dx >= 0 && _page._origin.dy >= 0) ||
          needTransformation) {
        matrix._translate(location.dx, -(location.dy + size.height));
      } else if ((_page._origin.dx >= 0 && _page._origin.dy <= 0)) {
        matrix._translate(location.dx, -(location.dy + size.height));
      } else {
        matrix._translate(location.dx, -(location.dy + 0));
      }
    } else {
      matrix._translate(location.dx, -(location.dy + size.height));
    }
    if (hasScale) {
      matrix._scale(scaleX, scaleY);
    }
    _streamWriter._modifyCurrentMatrix(matrix);
    final _PdfResources resources = _getResources();
    final _PdfName name = resources._getName(template);
    _streamWriter._executeObject(name);
    restore(state);
    _endMarkContent();
    //Transfer automatic fields from template.
    final PdfGraphics g = template.graphics;

    if (g != null) {
      for (final _PdfAutomaticFieldInfo fieldInfo in g._autoFields._list) {
        final _Point newLocation = _Point(fieldInfo.location.x + location.dx,
            fieldInfo.location.y + location.dy);
        final double scalingX =
            template.size.width == 0 ? 0 : size.width / template.size.width;
        final double scalingY =
            template.size.height == 0 ? 0 : size.height / template.size.height;
        _autoFields.add(_PdfAutomaticFieldInfo(
            fieldInfo.field, newLocation, scalingX, scalingY));
        _page._dictionary.modify();
      }
    }
    resources._requireProcset(_DictionaryProperties.grayScaleImage);
    resources._requireProcset(_DictionaryProperties.colorImage);
    resources._requireProcset(_DictionaryProperties.indexedImage);
    resources._requireProcset(_DictionaryProperties.text);
  }

  void _layoutString(String s, PdfFont font,
      {PdfPen pen,
      PdfBrush brush,
      _Rectangle layoutRectangle,
      PdfStringFormat format}) {
    final _PdfStringLayouter layouter = _PdfStringLayouter();
    _PdfStringLayoutResult result;
    result = layouter._layout(s, font, format,
        width: layoutRectangle.width, height: layoutRectangle.height);
    if (!result._isEmpty) {
      final _Rectangle rectangle = _checkCorrectLayoutRectangle(
          result._size, layoutRectangle.x, layoutRectangle.y, format);
      if (layoutRectangle.width <= 0) {
        layoutRectangle.x = rectangle.x;
        layoutRectangle.width = rectangle.width;
      }
      if (layoutRectangle.height <= 0) {
        layoutRectangle.y = rectangle.y;
        layoutRectangle.height = rectangle.height;
      }
      if (clientSize.height < 0) {
        layoutRectangle.y += clientSize.height;
      }
      _drawStringLayoutResult(
          result, font, pen, brush, layoutRectangle, format);
      _stringLayoutResult = result;
      (_getResources() as _PdfResources)
          ._requireProcset(_DictionaryProperties.text);
    }
  }

  void _translate() {
    if (_mediaBoxUpperRightBound == size.height ||
        _mediaBoxUpperRightBound == 0) {
      translateTransform(0, -size.height);
    } else {
      translateTransform(0, -_mediaBoxUpperRightBound);
    }
  }

  void _initializeCoordinates() {
    _streamWriter._writeComment('Change co-ordinate system to left/top.');
    if (_mediaBoxUpperRightBound != -size.height) {
      if (_cropBox == null) {
        _translate();
      } else {
        final double cropX = (_cropBox[0] as _PdfNumber).value.toDouble();
        final double cropY = (_cropBox[1] as _PdfNumber).value.toDouble();
        final double cropW = (_cropBox[2] as _PdfNumber).value.toDouble();
        final double cropH = (_cropBox[3] as _PdfNumber).value.toDouble();
        if (cropX > 0 ||
            cropY > 0 ||
            size.width == cropW ||
            size.height == cropH) {
          translateTransform(cropX, -cropH);
        } else {
          _translate();
        }
      }
    }
  }

  void _clipTranslateMarginsWithBounds(_Rectangle clipBounds) {
    _clipBounds = clipBounds;
    _streamWriter._writeComment('Clip margins.');
    _streamWriter._appendRectangle(
        clipBounds.x, clipBounds.y, clipBounds.width, clipBounds.height);
    _streamWriter._closePath();
    _streamWriter._clipPath(false);
    _streamWriter._writeComment('Translate co-ordinate system.');
    translateTransform(clipBounds.x, clipBounds.y);
  }

  void _clipTranslateMargins(double x, double y, double left, double top,
      double right, double bottom) {
    final _Rectangle clipArea = _Rectangle(
        left, top, size.width - left - right, size.height - top - bottom);
    _clipBounds = clipArea;
    _streamWriter._writeComment('Clip margins.');
    _streamWriter._appendRectangle(
        _clipBounds.x, _clipBounds.y, _clipBounds.width, _clipBounds.height);
    _streamWriter._closePath();
    _streamWriter._clipPath(false);
    _streamWriter._writeComment('Translate co-ordinate system.');
    translateTransform(x, y);
  }

  void _setLayer(PdfPageLayer pageLayer, [PdfLayer pdfLayer]) {
    PdfPage page;
    if (pageLayer != null) {
      _layer = pageLayer;
      page = pageLayer.page;
    } else if (pdfLayer != null) {
      _documentLayer = pdfLayer;
      page = pdfLayer._page;
    }
    if (page != null) {
      page._beginSave = () {
        if (_automaticFields != null) {
          for (final _PdfAutomaticFieldInfo fieldInfo
              in _automaticFields._list) {
            fieldInfo.field._performDraw(this, fieldInfo.location,
                fieldInfo.scalingX, fieldInfo.scalingY);
          }
        }
      };
    }
  }

  void _setTransparencyGroup(PdfPage page) {
    final _PdfDictionary group = _PdfDictionary();
    group[_DictionaryProperties.colorSpace] = _PdfName('DeviceRGB');
    group[_DictionaryProperties.k] = _PdfBoolean(false);
    group[_DictionaryProperties.s] = _PdfName('Transparency');
    group[_DictionaryProperties.i] = _PdfBoolean(false);
    page._dictionary[_DictionaryProperties.group] = group;
  }

  PdfGraphicsState _doRestoreState() {
    final PdfGraphicsState state = _graphicsState.last;
    _graphicsState.remove(_graphicsState.last);
    _transformationMatrix = state._matrix;
    _currentBrush = state._brush;
    _currentPen = state._pen;
    _currentFont = state._font;
    colorSpace = state._colorSpace;
    _previousCharacterSpacing = state._characterSpacing;
    _previousWordSpacing = state._wordSpacing;
    _previousTextScaling = state._textScaling;
    _previousTextRenderingMode = state._textRenderingMode;
    _streamWriter._restoreGraphicsState();
    return state;
  }

  void _reset(Size size) {
    _canvasSize = size;
    _streamWriter._clear();
    _initialize();
    _initializeCoordinates();
  }

  void _drawStringLayoutResult(
      _PdfStringLayoutResult result,
      PdfFont font,
      PdfPen pen,
      PdfBrush brush,
      _Rectangle layoutRectangle,
      PdfStringFormat format) {
    ArgumentError.checkNotNull(result);
    ArgumentError.checkNotNull(font);
    if (!result._isEmpty) {
      _beginMarkContent();
      _applyStringSettings(font, pen, brush, format, layoutRectangle);
      final double textScaling = format != null ? format._scalingFactor : 100.0;
      if (textScaling != _previousTextScaling) {
        _streamWriter._setTextScaling(textScaling);
        _previousTextScaling = textScaling;
      }
      double verticalAlignShift = _getTextVerticalAlignShift(
          result._size.height, layoutRectangle.height, format);
      final _PdfTransformationMatrix matrix = _PdfTransformationMatrix();
      matrix._translate(
          layoutRectangle.x,
          (-(layoutRectangle.y + font.height) -
                  (font._metrics._getDescent(format) > 0
                      ? -font._metrics._getDescent(format)
                      : font._metrics._getDescent(format))) -
              verticalAlignShift);
      _streamWriter._modifyTransformationMatrix(matrix);
      if (layoutRectangle.height < font.size) {
        if ((result._size.height - layoutRectangle.height) <
            (font.size / 2) - 1) {
          verticalAlignShift = 0.0;
        }
      }
      _drawLayoutResult(result, font, format, layoutRectangle);
      if (verticalAlignShift != 0) {
        _streamWriter._startNextLine(
            0, -(verticalAlignShift - result._lineHeight));
      }
      _streamWriter._endText();
      _underlineStrikeoutText(
          pen, brush, result, font, layoutRectangle, format);
      _endMarkContent();
    }
  }

  double _getLineIndent(_LineInfo lineInfo, PdfStringFormat format,
      _Rectangle layoutBounds, bool firstLine) {
    double lineIndent = 0;
    final bool firstParagraphLine = (lineInfo._lineType &
            _PdfStringLayouter._getLineTypeValue(
                _LineType.firstParagraphLine)) >
        0;
    if (format != null && firstParagraphLine) {
      lineIndent = firstLine ? format._firstLineIndent : format.paragraphIndent;
      lineIndent = (layoutBounds.width > 0)
          ? (layoutBounds.width <= lineIndent ? layoutBounds.width : lineIndent)
          : lineIndent;
    }
    return lineIndent;
  }

  void _drawLayoutResult(_PdfStringLayoutResult result, PdfFont font,
      PdfStringFormat format, _Rectangle layoutRectangle) {
    ArgumentError.checkNotNull(result);
    ArgumentError.checkNotNull(font);
    bool unicode = false;
    if (font is PdfTrueTypeFont) {
      unicode = font._unicode;
    }
    final List<_LineInfo> lines = result._lines;
    final double height = (format == null || format.lineSpacing == 0)
        ? font.height
        : format.lineSpacing + font.height;
    for (int i = 0; i < lines.length; i++) {
      final _LineInfo lineInfo = lines[i];
      final String line = lineInfo.text;
      final double lineWidth = lineInfo.width;
      if (line == null || line.isEmpty) {
        final double verticalAlignShift = _getTextVerticalAlignShift(
            result._size.height, layoutRectangle.height, format);
        final _PdfTransformationMatrix matrix = _PdfTransformationMatrix();
        double baseline = (-(layoutRectangle.y + font.height) -
                font._metrics._getDescent(format)) -
            verticalAlignShift;
        baseline -= height * (i + 1);
        matrix._translate(layoutRectangle.x, baseline);
        _streamWriter._modifyTransformationMatrix(matrix);
      } else {
        double horizontalAlignShift =
            _getHorizontalAlignShift(lineWidth, layoutRectangle.width, format);
        final double lineIndent =
            _getLineIndent(lineInfo, format, layoutRectangle, i == 0);
        horizontalAlignShift += (!_rightToLeft(format)) ? lineIndent : 0;

        if (horizontalAlignShift != 0) {
          _streamWriter._startNextLine(horizontalAlignShift, 0);
        }
        if (font is PdfCjkStandardFont) {
          _drawCjkString(lineInfo, layoutRectangle, font, format);
        } else if (unicode) {
          _drawUnicodeLine(lineInfo, layoutRectangle, font, format);
        } else {
          _drawAsciiLine(lineInfo, layoutRectangle, font, format);
        }

        if (i + 1 != lines.length) {
          final double verticalAlignShift = _getTextVerticalAlignShift(
              result._size.height, layoutRectangle.height, format);
          final _PdfTransformationMatrix matrix = _PdfTransformationMatrix();
          double baseline = (-(layoutRectangle.y + font.height) -
                  font._metrics._getDescent(format)) -
              verticalAlignShift;
          baseline -= height * (i + 1);
          matrix._translate(layoutRectangle.x, baseline);
          _streamWriter._modifyTransformationMatrix(matrix);
        }
      }
    }
    (_getResources() as _PdfResources)
        ._requireProcset(_DictionaryProperties.text);
  }

  void _drawAsciiLine(_LineInfo lineInfo, _Rectangle layoutRectangle,
      PdfFont font, PdfStringFormat format) {
    _justifyLine(lineInfo, layoutRectangle.width, format);
    final _PdfString str = _PdfString(lineInfo.text);
    str.isAsciiEncode = true;
    _streamWriter._showNextLineText(str);
  }

  void _drawCjkString(_LineInfo lineInfo, _Rectangle layoutRectangle,
      PdfFont font, PdfStringFormat format) {
    ArgumentError.checkNotNull(font);
    _justifyLine(lineInfo, layoutRectangle.width, format);
    final String line = lineInfo.text;
    final List<int> str = _getCjkString(line);
    _streamWriter._showNextLineText(str);
  }

  void _drawUnicodeLine(_LineInfo lineInfo, _Rectangle layoutRectangle,
      PdfFont font, PdfStringFormat format) {
    final String line = lineInfo.text;
    final bool useWordSpace = format != null &&
        (format.wordSpacing != 0 ||
            format.alignment == PdfTextAlignment.justify);
    final PdfTrueTypeFont ttfFont = font as PdfTrueTypeFont;
    final double wordSpacing =
        _justifyLine(lineInfo, layoutRectangle.width, format);
    if (format != null && format.textDirection != PdfTextDirection.none) {
      final _ArabicShapeRenderer renderer = _ArabicShapeRenderer();
      final String txt = renderer.shape(line.split(''), 0);
      final _Bidi bidi = _Bidi();
      final String result = bidi.getLogicalToVisualString(
          txt, format.textDirection == PdfTextDirection.rightToLeft);
      final List<String> blocks = <String>[];
      if (useWordSpace) {
        final List<String> words = result.split(' ');
        for (int i = 0; i < words.length; i++) {
          blocks.add(_addChars(font, words[i], format));
        }
      } else {
        blocks.add(_addChars(font, result, format));
      }
      List<String> words = <String>[];
      if (blocks.length > 1) {
        words = result.split(' ');
      } else {
        words.add(result);
      }
      _drawUnicodeBlocks(blocks, words, ttfFont, format, wordSpacing);
    } else if (useWordSpace) {
      final dynamic result = _breakUnicodeLine(line, ttfFont, null);
      final List<String> blocks = result['tokens'];
      final List<String> words = result['words'];
      _drawUnicodeBlocks(blocks, words, ttfFont, format, wordSpacing);
    } else {
      final String token = _convertToUnicode(line, ttfFont);
      final _PdfString value = _getUnicodeString(token);
      _streamWriter._showNextLineText(value);
    }
  }

  void _drawUnicodeBlocks(List<String> blocks, List<String> words,
      PdfTrueTypeFont font, PdfStringFormat format, double wordSpacing) {
    ArgumentError.checkNotNull(blocks);
    ArgumentError.checkNotNull(words);
    ArgumentError.checkNotNull(font);
    _streamWriter._startNextLine();
    double x = 0;
    double xShift = 0;
    double firstLineIndent = 0;
    double paragraphIndent = 0;
    try {
      if (format != null) {
        firstLineIndent = format._firstLineIndent.toDouble();
        paragraphIndent = format.paragraphIndent.toDouble();
        format._firstLineIndent = 0;
        format.paragraphIndent = 0;
      }
      double spaceWidth = font._getCharWidth(' ', format) + wordSpacing;
      final double characterSpacing =
          format != null ? format.characterSpacing : 0;
      final double wordSpace =
          format != null && wordSpacing == 0 ? format.wordSpacing : 0;
      spaceWidth += characterSpacing + wordSpace;
      for (int i = 0; i < blocks.length; i++) {
        final String token = blocks[i];
        final String word = words[i];
        double tokenWidth = 0;
        if (x != 0.0) {
          _streamWriter._startNextLine(x, 0);
        }
        if (word.isNotEmpty) {
          tokenWidth += font.measureString(word, format: format).width;
          tokenWidth += characterSpacing;
          final _PdfString val = _getUnicodeString(token);
          _streamWriter._showText(val);
        }
        if (i != blocks.length - 1) {
          x = tokenWidth + spaceWidth;
          xShift += x;
        }
      }
      // Rolback current line position.
      if (xShift > 0) {
        _streamWriter._startNextLine(-xShift, 0);
      }
    } finally {
      if (format != null) {
        format._firstLineIndent = firstLineIndent;
        format.paragraphIndent = paragraphIndent;
      }
    }
  }

  dynamic _breakUnicodeLine(
      String line, PdfTrueTypeFont ttfFont, List<String> words) {
    ArgumentError.checkNotNull(line);
    words = line.split(' ');
    final List<String> tokens = <String>[];
    for (int i = 0; i < words.length; i++) {
      final String word = words[i];
      final String token = _convertToUnicode(word, ttfFont);
      tokens.add(token);
    }
    return <String, dynamic>{'tokens': tokens, 'words': words};
  }

  _PdfString _getUnicodeString(String token) {
    ArgumentError.checkNotNull(token);
    final _PdfString val = _PdfString(token);
    val.isAsciiEncode = true;
    return val;
  }

  String _convertToUnicode(String text, PdfTrueTypeFont font) {
    String token;
    ArgumentError.checkNotNull(text);
    ArgumentError.checkNotNull(font);
    if (font._fontInternal is _UnicodeTrueTypeFont) {
      final _TtfReader ttfReader = font._fontInternal._reader;
      font._setSymbols(text);
      token = ttfReader._convertString(text);
      final List<int> bytes = _PdfString._toUnicodeArray(token, false);
      token = _PdfString._byteToString(bytes);
    }
    return token;
  }

  List<int> _getCjkString(String line) {
    ArgumentError.checkNotNull(line);
    List<int> value = _PdfString.toUnicodeArray(line);
    value = _PdfString._escapeSymbols(value);
    return value;
  }

  double _justifyLine(
      _LineInfo lineInfo, double boundsWidth, PdfStringFormat format) {
    final String line = lineInfo.text;
    double lineWidth = lineInfo.width;
    final bool shouldJustify = _shouldJustify(lineInfo, boundsWidth, format);
    final bool hasWordSpacing = format != null && format.wordSpacing != 0;
    final int whitespacesCount =
        _StringTokenizer._getCharacterCount(line, _StringTokenizer._spaces);
    double wordSpace = 0;
    if (shouldJustify) {
      if (hasWordSpacing) {
        lineWidth -= whitespacesCount * format.wordSpacing;
      }
      final double difference = boundsWidth - lineWidth;
      wordSpace = difference / whitespacesCount;
      _streamWriter._setWordSpacing(wordSpace);
    } else if (format != null && format.alignment == PdfTextAlignment.justify) {
      _streamWriter._setWordSpacing(0);
    }
    return wordSpace;
  }

  bool _shouldJustify(
      _LineInfo lineInfo, double boundsWidth, PdfStringFormat format) {
    final String line = lineInfo.text;
    final double lineWidth = lineInfo.width;
    final bool justifyStyle =
        format != null && format.alignment == PdfTextAlignment.justify;
    final bool goodWidth = boundsWidth >= 0 && lineWidth < boundsWidth;
    final int whitespacesCount =
        _StringTokenizer._getCharacterCount(line, _StringTokenizer._spaces);
    final bool hasSpaces =
        whitespacesCount > 0 && line[0] != _StringTokenizer._whiteSpace;
    final bool goodLineBreakStyle = (lineInfo._lineType &
            _PdfStringLayouter._getLineTypeValue(_LineType.layoutBreak)) >
        0;
    final bool shouldJustify =
        justifyStyle && goodWidth && hasSpaces && goodLineBreakStyle;
    return shouldJustify;
  }

  bool _rightToLeft(PdfStringFormat format) {
    bool rtl =
        format != null && format.textDirection == PdfTextDirection.rightToLeft;
    if (format != null && format.textDirection != PdfTextDirection.none) {
      rtl = true;
    }
    return rtl;
  }

  double _getTextVerticalAlignShift(
      double textHeight, double boundsHeight, PdfStringFormat format) {
    double shift = 0;
    if (boundsHeight >= 0 &&
        format != null &&
        format.lineAlignment != PdfVerticalAlignment.top) {
      switch (format.lineAlignment) {
        case PdfVerticalAlignment.middle:
          shift = (boundsHeight - textHeight) / 2;
          break;

        case PdfVerticalAlignment.bottom:
          shift = boundsHeight - textHeight;
          break;
        default:
          break;
      }
    }
    return shift;
  }

  double _getHorizontalAlignShift(
      double lineWidth, double boundsWidth, PdfStringFormat format) {
    double shift = 0;
    if (boundsWidth >= 0 &&
        format != null &&
        format.alignment != PdfTextAlignment.left) {
      switch (format.alignment) {
        case PdfTextAlignment.center:
          shift = (boundsWidth - lineWidth) / 2;
          break;
        case PdfTextAlignment.right:
          shift = boundsWidth - lineWidth;
          break;
        default:
          break;
      }
    }
    return shift;
  }

  void _applyStringSettings(PdfFont font, PdfPen pen, PdfBrush brush,
      PdfStringFormat format, _Rectangle bounds) {
    final int renderingMode = _getTextRenderingMode(pen, brush, format);
    _streamWriter._writeOperator(_Operators.beginText);
    _stateControl(pen, brush, font, format);
    if (renderingMode != _previousTextRenderingMode) {
      _streamWriter._setTextRenderingMode(renderingMode);
      _previousTextRenderingMode = renderingMode;
    }
    final double characterSpace =
        (format != null) ? format.characterSpacing : 0;
    if (characterSpace != _previousCharacterSpacing) {
      _streamWriter._setCharacterSpacing(characterSpace);
      _previousCharacterSpacing = characterSpace;
    }
    final double wordSpace = (format != null) ? format.wordSpacing : 0;
    if (wordSpace != _previousWordSpacing) {
      _streamWriter._setWordSpacing(wordSpace);
      _previousWordSpacing = wordSpace;
    }
  }

  void _stateControl(
      PdfPen pen, PdfBrush brush, PdfFont font, PdfStringFormat format) {
    if (brush != null) {
      if (_layer != null) {
        if (!_page._isLoadedPage &&
            !_page._section._pdfDocument._isLoadedDocument) {
          if (_colorSpaceChanged == false) {
            if (_page != null) {
              colorSpace = _page._document.colorSpace;
            }
            _colorSpaceChanged = true;
          }
        }
      }
      _initCurrentColorSpace(colorSpace);
    } else if (pen != null) {
      if (_layer != null) {
        if (!_page._isLoadedPage &&
            !_page._section._pdfDocument._isLoadedDocument) {
          colorSpace = _page._document.colorSpace;
        }
      }
      _initCurrentColorSpace(colorSpace);
    }
    _penControl(pen, false);
    _brushControl(brush, false);
    _fontControl(font, format, false);
  }

  void _initCurrentColorSpace(PdfColorSpace colorspace) {
    if (!_isColorSpaceInitialized) {
      _streamWriter._setColorSpace(
          _PdfName('Device' + _colorSpaces[colorSpace]), true);
      _streamWriter._setColorSpace(
          _PdfName('Device' + _colorSpaces[colorSpace]), false);
      _isColorSpaceInitialized = true;
    }
  }

  void _penControl(PdfPen pen, bool saveState) {
    if (pen != null) {
      _currentPen = pen;
      colorSpace = PdfColorSpace.rgb;
      pen._monitorChanges(_currentPen, _streamWriter, _getResources, saveState,
          colorSpace, _matrix);
      _currentPen = pen;
    }
  }

  void _brushControl(PdfBrush brush, bool saveState) {
    if (brush != null) {
      brush._monitorChanges(
          _currentBrush, _streamWriter, _getResources, saveState, colorSpace);
      _currentBrush = brush;
      brush = null;
    }
  }

  void _fontControl(PdfFont font, PdfStringFormat format, bool saveState) {
    if (font != null) {
      if ((font is PdfStandardFont || font is PdfCjkStandardFont) &&
          _layer != null &&
          _page._document != null &&
          _page._document._conformanceLevel != PdfConformanceLevel.none) {
        throw ArgumentError(
            'All the fonts must be embedded in ${_page._document._conformanceLevel.toString()} document.');
      } else if (font is PdfTrueTypeFont &&
          _layer != null &&
          _page._document != null &&
          _page._document._conformanceLevel == PdfConformanceLevel.a1b) {
        font._fontInternal._initializeCidSet();
      }
      final PdfSubSuperscript current =
          format != null ? format.subSuperscript : PdfSubSuperscript.none;
      final PdfSubSuperscript privious = _currentStringFormat != null
          ? _currentStringFormat.subSuperscript
          : PdfSubSuperscript.none;
      if (saveState || font != _currentFont || current != privious) {
        final _PdfResources resources = _getResources();
        _currentFont = font;
        _currentStringFormat = format;
        _streamWriter._setFont(
            font, resources._getName(font), font._metrics._getSize(format));
      }
    }
  }

  int _getTextRenderingMode(
      PdfPen pen, PdfBrush brush, PdfStringFormat format) {
    int tm = _TextRenderingMode.none;
    if (pen != null && brush != null) {
      tm = _TextRenderingMode.fillStroke;
    } else if (pen != null) {
      tm = _TextRenderingMode.stroke;
    } else {
      tm = _TextRenderingMode.fill;
    }
    if (format != null && format.clipPath) {
      tm |= _TextRenderingMode.clipFlag;
    }
    return tm;
  }

  _Rectangle _checkCorrectLayoutRectangle(
      _Size textSize, double x, double y, PdfStringFormat format) {
    final _Rectangle layoutedRectangle =
        _Rectangle(x, y, textSize.width, textSize.width);
    if (format != null) {
      switch (format.alignment) {
        case PdfTextAlignment.center:
          layoutedRectangle.x -= layoutedRectangle.width / 2;
          break;
        case PdfTextAlignment.right:
          layoutedRectangle.x -= layoutedRectangle.width;
          break;
        default:
          break;
      }
      switch (format.lineAlignment) {
        case PdfVerticalAlignment.middle:
          layoutedRectangle.y -= layoutedRectangle.height / 2;
          break;
        case PdfVerticalAlignment.bottom:
          layoutedRectangle.y -= layoutedRectangle.height;
          break;
        default:
          break;
      }
    }
    return layoutedRectangle;
  }

  void _underlineStrikeoutText(
      PdfPen pen,
      PdfBrush brush,
      _PdfStringLayoutResult result,
      PdfFont font,
      _Rectangle layoutRectangle,
      PdfStringFormat format) {
    if (font._isUnderline | font._isStrikeout) {
      final PdfPen linePen =
          _createUnderlineStikeoutPen(pen, brush, font, format);
      if (linePen != null) {
        final double verticalShift = _getTextVerticalAlignShift(
            result._size.height, layoutRectangle.height, format);
        double underlineYOffset = layoutRectangle.y +
            verticalShift +
            font._metrics._getAscent(format) +
            1.5 * linePen.width;
        double strikeoutYOffset = layoutRectangle.y +
            verticalShift +
            font._metrics._getHeight(format) / 2 +
            1.5 * linePen.width;
        final List<_LineInfo> lines = result._lines;
        for (int i = 0; i < result._lines.length; i++) {
          final _LineInfo lineInfo = lines[i];
          final double lineWidth = lineInfo.width;
          double horizontalShift = _getHorizontalAlignShift(
              lineWidth, layoutRectangle.width, format);
          final double lineIndent =
              _getLineIndent(lineInfo, format, layoutRectangle, i == 0);
          horizontalShift += (!_rightToLeft(format)) ? lineIndent : 0;
          final double x1 = layoutRectangle.x + horizontalShift;
          final double x2 =
              (!_shouldJustify(lineInfo, layoutRectangle.width, format))
                  ? x1 + lineWidth - lineIndent
                  : x1 + layoutRectangle.width - lineIndent;
          if (font._isUnderline) {
            drawLine(linePen, Offset(x1, underlineYOffset),
                Offset(x2, underlineYOffset));
            underlineYOffset += result._lineHeight;
          }
          if (font._isStrikeout) {
            drawLine(linePen, Offset(x1, strikeoutYOffset),
                Offset(x2, strikeoutYOffset));
            strikeoutYOffset += result._lineHeight;
          }
        }
      }
    }
  }

  PdfPen _createUnderlineStikeoutPen(
      PdfPen pen, PdfBrush brush, PdfFont font, PdfStringFormat format) {
    final double lineWidth = font._metrics._getSize(format) / 20;
    PdfPen linePen;
    if (pen != null) {
      linePen = PdfPen(pen.color, width: lineWidth);
    } else if (brush != null) {
      linePen = PdfPen.fromBrush(brush, width: lineWidth);
    }
    return linePen;
  }

  Rect _getLineBounds(int lineIndex, _PdfStringLayoutResult result,
      PdfFont font, _Rectangle layoutRectangle, PdfStringFormat format) {
    ArgumentError.checkNotNull(result);
    ArgumentError.checkNotNull(font);
    _Rectangle bounds = _Rectangle.empty;
    if (!result._isEmpty && lineIndex < result._lineCount && lineIndex >= 0) {
      final _LineInfo line = result._lines[lineIndex];
      final double verticalShift = _getTextVerticalAlignShift(
          result._size.height, layoutRectangle.height, format);
      final double y =
          verticalShift + layoutRectangle.y + (result._lineHeight * lineIndex);
      final double lineWidth = line.width;
      double horizontalShift =
          _getHorizontalAlignShift(lineWidth, layoutRectangle.width, format);
      final double lineIndent =
          _getLineIndent(line, format, layoutRectangle, lineIndex == 0);
      horizontalShift += (!_rightToLeft(format)) ? lineIndent : 0;
      final double x = layoutRectangle.x + horizontalShift;
      final double width =
          (!_shouldJustify(line, layoutRectangle.width, format))
              ? lineWidth - lineIndent
              : layoutRectangle.width - lineIndent;
      final double height = result._lineHeight;
      bounds = _Rectangle(x, y, width, height);
    }
    return bounds.rect;
  }

  String _addChars(PdfTrueTypeFont font, String line, PdfStringFormat format) {
    ArgumentError.checkNotNull(font, 'font');
    ArgumentError.checkNotNull(line, 'line');
    String text = line;
    final _UnicodeTrueTypeFont internalFont = font._fontInternal;
    final _TtfReader ttfReader = internalFont._reader;
    if (format != null) {
      internalFont._setSymbols(line);
    } else {
      font._setSymbols(text);
    }
    // Reconvert string according to unicode standard.
    text = ttfReader._convertString(text);
    final List<int> bytes = _PdfString.toUnicodeArray(text);
    text = _PdfString._byteToString(bytes);
    return text;
  }

  /// Sets the clipping region of this Graphics to the result of the
  /// specified operation combining the current clip region and the
  ///  rectangle specified by a RectangleF structure.
  void setClip({Rect bounds, PdfFillMode mode}) {
    if (bounds != null) {
      mode ??= PdfFillMode.winding;
      _streamWriter._appendRectangle(
          bounds.left, bounds.top, bounds.width, bounds.height);
      _streamWriter._clipPath(mode == PdfFillMode.alternate);
    }
  }

  /// Draws a Bezier spline defined by four [Offset] structures.
  void drawBezier(Offset startPoint, Offset firstControlPoint,
      Offset secondControlPoint, Offset endPoint,
      {PdfPen pen}) {
    _beginMarkContent();
    _stateControl(pen, null, null, null);
    final _PdfStreamWriter sw = _streamWriter;
    sw._beginPath(startPoint.dx, startPoint.dy);
    sw._appendBezierSegment(firstControlPoint.dx, firstControlPoint.dy,
        secondControlPoint.dx, secondControlPoint.dy, endPoint.dx, endPoint.dy);
    sw._strokePath();
    _endMarkContent();
  }

  /// Draws a GraphicsPath defined by a pen, a brush and path
  void drawPath(PdfPath path, {PdfPen pen, PdfBrush brush}) {
    _beginMarkContent();
    _stateControl(pen, brush, null, null);
    _buildUpPath(path._points, path._pathTypes);
    _drawPath(pen, brush, path._fillMode, false);
    _endMarkContent();
  }

  /// Draws a pie shape defined by an ellipse specified by a Rect structure
  ///  uiand two radial lines.
  void drawPie(Rect bounds, double startAngle, double sweepAngle,
      {PdfPen pen, PdfBrush brush}) {
    if (sweepAngle != 0) {
      _beginMarkContent();
      _stateControl(pen, brush, null, null);
      _constructArcPath(bounds.left, bounds.top, bounds.left + bounds.width,
          bounds.top + bounds.height, startAngle, sweepAngle);
      _streamWriter._appendLineSegment(
          bounds.left + bounds.width / 2, bounds.top + bounds.height / 2);
      _drawPath(pen, brush, PdfFillMode.winding, true);
      _endMarkContent();
    }
  }

  /// Draws an ellipse specified by a bounding Rect structure.
  void drawEllipse(Rect bounds, {PdfPen pen, PdfBrush brush}) {
    _beginMarkContent();
    _stateControl(pen, brush, null, null);
    _constructArcPath(
        bounds.left, bounds.top, bounds.right, bounds.bottom, 0, 360);
    _drawPath(pen, brush, PdfFillMode.winding, true);
    _endMarkContent();
  }

  /// Draws an arc representing a portion of an ellipse specified
  /// by a Rect structure.
  void drawArc(Rect bounds, double startAngle, double sweepAngle,
      {PdfPen pen}) {
    if (sweepAngle != 0) {
      _beginMarkContent();
      _stateControl(pen, null, null, null);
      _constructArcPath(bounds.left, bounds.top, bounds.left + bounds.width,
          bounds.top + bounds.height, startAngle, sweepAngle);
      _drawPath(pen, null, PdfFillMode.winding, false);
      _endMarkContent();
    }
  }

  /// Draws a polygon defined by a brush, an array of [Offset] structures.
  void drawPolygon(List<Offset> points, {PdfPen pen, PdfBrush brush}) {
    _beginMarkContent();
    if (points.isEmpty) {
      return;
    }
    _stateControl(pen, brush, null, null);
    _streamWriter._beginPath(points.elementAt(0).dx, points.elementAt(0).dy);

    for (int i = 1; i < points.length; ++i) {
      _streamWriter._appendLineSegment(
          points.elementAt(i).dx, points.elementAt(i).dy);
    }
    _drawPath(pen, brush, PdfFillMode.winding, true);
    _endMarkContent();
  }

  void _buildUpPath(List<Offset> points, List<_PathPointType> types) {
    for (int i = 0; i < points.length; ++i) {
      final dynamic typeValue = types[i];
      final Offset point = points[i];
      switch (typeValue as _PathPointType) {
        case _PathPointType.start:
          _streamWriter._beginPath(point.dx, point.dy);
          break;

        case _PathPointType.bezier3:
          Offset p2, p3;
          final Map<String, dynamic> returnValue =
              _getBezierPoints(points, types, i, p2, p3);
          i = returnValue['i'];
          final List<Offset> p = returnValue['points'];
          p2 = p.first;
          p3 = p.last;
          _streamWriter._appendBezierSegment(
              point.dx, point.dy, p2.dx, p2.dy, p3.dx, p3.dy);
          break;

        case _PathPointType.line:
          _streamWriter._appendLineSegment(point.dx, point.dy);
          break;

        case _PathPointType.closeSubpath:
          _streamWriter._closePath();
          break;

        default:
          throw ArgumentError('Incorrect path formation.');
      }
    }
  }

  Map<String, dynamic> _getBezierPoints(List<Offset> points,
      List<_PathPointType> types, int i, Offset p2, Offset p3) {
    const String errorMsg = 'Malforming path.';
    ++i;
    if (types[i] == _PathPointType.bezier3) {
      p2 = points[i];
      ++i;
      if (types[i] == _PathPointType.bezier3) {
        p3 = points[i];
      } else {
        throw ArgumentError(errorMsg);
      }
    } else {
      throw throw ArgumentError(errorMsg);
    }
    return <String, dynamic>{
      'i': i,
      'points': <Offset>[p2, p3]
    };
  }

  void _constructArcPath(double x1, double y1, double x2, double y2,
      double startAng, double sweepAngle) {
    final List<List<double>> points =
        _getBezierArcPoints(x1, y1, x2, y2, startAng, sweepAngle);
    if (points.isEmpty) {
      return;
    }
    List<double> pt = points[0];
    _streamWriter._beginPath(pt[0], pt[1]);
    for (int i = 0; i < points.length; ++i) {
      pt = points.elementAt(i);
      _streamWriter._appendBezierSegment(
          pt[2], pt[3], pt[4], pt[5], pt[6], pt[7]);
    }
  }

  static List<List<double>> _getBezierArcPoints(double x1, double y1, double x2,
      double y2, double startAng, double extent) {
    if (x1 > x2) {
      double tmp;
      tmp = x1;
      x1 = x2;
      x2 = tmp;
    }
    if (y2 > y1) {
      double tmp;
      tmp = y1;
      y1 = y2;
      y2 = tmp;
    }
    double fragAngle;
    int numFragments;

    if (extent.abs() <= 90) {
      fragAngle = extent;
      numFragments = 1;
    } else {
      numFragments = (extent.abs() / 90).ceil();
      fragAngle = extent / numFragments;
    }
    final double xCen = (x1 + x2) / 2;
    final double yCen = (y1 + y2) / 2;
    final double rx = (x2 - x1) / 2;
    final double ry = (y2 - y1) / 2;
    final double halfAng = (fragAngle * pi / 360.0).toDouble();
    final double kappa =
        ((4.0 / 3.0 * (1.0 - cos(halfAng)) / sin(halfAng)).abs()).toDouble();
    final List<List<double>> pointList = <List<double>>[];
    for (int i = 0; i < numFragments; ++i) {
      final double theta0 =
          ((startAng + i * fragAngle) * pi / 180.0).toDouble();
      final double theta1 =
          ((startAng + (i + 1) * fragAngle) * pi / 180.0).toDouble();
      final double cos0 = cos(theta0).toDouble();
      final double cos1 = cos(theta1).toDouble();
      final double sin0 = sin(theta0).toDouble();
      final double sin1 = sin(theta1).toDouble();
      if (fragAngle > 0) {
        pointList.add(<double>[
          xCen + rx * cos0,
          yCen - ry * sin0,
          xCen + rx * (cos0 - kappa * sin0),
          yCen - ry * (sin0 + kappa * cos0),
          xCen + rx * (cos1 + kappa * sin1),
          yCen - ry * (sin1 - kappa * cos1),
          xCen + rx * cos1,
          yCen - ry * sin1
        ]);
      } else {
        pointList.add(<double>[
          xCen + rx * cos0,
          yCen - ry * sin0,
          xCen + rx * (cos0 + kappa * sin0),
          yCen - ry * (sin0 - kappa * cos0),
          xCen + rx * (cos1 - kappa * sin1),
          yCen - ry * (sin1 + kappa * cos1),
          xCen + rx * cos1,
          yCen - ry * sin1
        ]);
      }
    }
    return pointList;
  }

  void _beginMarkContent() {
    if (_documentLayer != null) {
      _documentLayer._beginLayer(this);
    }
  }

  void _endMarkContent() {
    if (_documentLayer != null) {
      if (_documentLayer._isEndState &&
          _documentLayer._parentLayer.isNotEmpty) {
        for (int i = 0; i < _documentLayer._parentLayer.length; i++) {
          _streamWriter._write('EMC\n');
        }
      }
      if (_documentLayer._isEndState) {
        _streamWriter._write('EMC\n');
      }
    }
  }
}

class _TransparencyData {
  //Constructor
  _TransparencyData(
      double alphaPen, double alphaBrush, PdfBlendMode blendMode) {
    if (alphaPen == null) {
      ArgumentError.value(alphaPen, 'alphaPen', 'alpha value cannot be null');
    } else {
      this.alphaPen = alphaPen;
    }
    if (alphaBrush == null) {
      ArgumentError.value(
          alphaBrush, 'alphaBrush', 'alpha value cannot be null');
    } else {
      this.alphaBrush = alphaBrush;
    }
    if (blendMode == null) {
      ArgumentError.value(blendMode, 'blendMode', 'blend mode cannot be null');
    } else {
      this.blendMode = blendMode;
    }
  }
  //Fields
  double alphaPen;
  double alphaBrush;
  PdfBlendMode blendMode;

  @override
  bool operator ==(Object other) {
    return other is _TransparencyData
        ? other.alphaPen == alphaPen &&
            alphaBrush == other.alphaBrush &&
            blendMode == other.blendMode
        : false;
  }

  @override
  int get hashCode =>
      alphaPen.hashCode + alphaBrush.hashCode + blendMode.hashCode;
}
