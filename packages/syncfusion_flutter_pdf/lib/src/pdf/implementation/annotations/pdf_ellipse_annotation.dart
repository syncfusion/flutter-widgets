part of pdf;

/// Represents a PDF ellipse annotation
class PdfEllipseAnnotation extends PdfAnnotation {
  // Constructor
  /// Initializes new instance of the [PdfEllipseAnnotation] class.
  /// ``` dart
  /// //Create a  PDF document.
  /// final PdfDocument document = PdfDocument();
  /// //Create a  page.
  /// final PdfPage page = document.pages.add();
  /// //Create a PDF Ellipse annotation.
  /// final PdfEllipseAnnotation ellipseAnnotation = PdfEllipseAnnotation(
  ///     const Rect.fromLTWH(0, 30, 100, 50), 'EllipseAnnotation',
  ///     innerColor: PdfColor(255, 0, 0), color: PdfColor(255, 255, 0));
  /// //Add annotation to the page.
  /// page.annotations.add(ellipseAnnotation);
  /// //Saves the document.
  /// final List<int> bytes = document.save();
  /// document.dispose();
  /// ```
  PdfEllipseAnnotation(Rect bounds, String text,
      {PdfColor color,
      PdfColor innerColor,
      PdfAnnotationBorder border,
      String author,
      String subject,
      DateTime modifiedDate,
      double opacity,
      bool setAppearance,
      bool flatten})
      : super._(
            bounds: bounds,
            text: text,
            color: color,
            innerColor: innerColor,
            border: border,
            author: author,
            subject: subject,
            modifiedDate: modifiedDate,
            opacity: opacity,
            setAppearance: setAppearance,
            flatten: flatten);

  PdfEllipseAnnotation._(
      _PdfDictionary dictionary, _PdfCrossTable crossTable, String text)
      : super._internal(dictionary, crossTable) {
    ArgumentError.checkNotNull(text, 'Text must be not null');
    _dictionary = dictionary;
    _crossTable = crossTable;
    this.text = text;
  }

  // Implementation
  @override
  void _initialize() {
    super._initialize();
    _dictionary.setProperty(
        _DictionaryProperties.subtype, _PdfName(_DictionaryProperties.circle));
  }

  @override
  void _save() {
    if (page.annotations.flatten) {
      flatten = true;
    }
    if (flatten || setAppearance || _pdfAppearance != null) {
      PdfTemplate appearance;
      if (_pdfAppearance != null) {
        appearance = _pdfAppearance.normal ??= _createAppearance();
      } else {
        appearance = _createAppearance();
      }
      if (flatten) {
        if (appearance != null || _isLoadedAnnotation) {
          if (page != null) {
            _flattenAnnotation(page, appearance);
          }
        }
      } else {
        if (appearance != null) {
          this.appearance.normal = appearance;
          _dictionary.setProperty(
              _DictionaryProperties.ap, _PdfReferenceHolder(this.appearance));
        }
      }
    }
    if (!flatten && !_isLoadedAnnotation) {
      super._save();
      _dictionary.setProperty(_DictionaryProperties.bs, border);
    }
    if (_flattenPopups) {
      _flattenPopup();
    }
  }

  void _flattenAnnotation(PdfPage page, PdfTemplate appearance) {
    if (_isLoadedAnnotation) {
      final bool isContainsAP =
          _dictionary.containsKey(_DictionaryProperties.ap);
      if (isContainsAP && appearance == null) {
        _PdfDictionary appearanceDictionary =
            _PdfCrossTable._dereference(_dictionary[_DictionaryProperties.ap])
                as _PdfDictionary;
        if (appearanceDictionary != null) {
          appearanceDictionary = _PdfCrossTable._dereference(
              appearanceDictionary[_DictionaryProperties.n]) as _PdfDictionary;
          if (appearanceDictionary != null) {
            final _PdfStream appearanceStream =
                appearanceDictionary as _PdfStream;
            if (appearanceStream != null) {
              appearance = PdfTemplate._fromPdfStream(appearanceStream);
              if (appearance != null) {
                final bool isNormalMatrix =
                    _validateTemplateMatrix(appearanceDictionary);
                _flattenAnnotationTemplate(appearance, isNormalMatrix);
              }
            }
          } else {
            setAppearance = true;
            appearance = _createAppearance();
            if (appearance != null) {
              final bool isNormalMatrix =
                  _validateTemplateMatrix(appearance._content);
              _flattenAnnotationTemplate(appearance, isNormalMatrix);
            }
          }
        }
      } else if (!isContainsAP && appearance == null) {
        setAppearance = true;
        appearance = _createAppearance();
        if (appearance != null) {
          final bool isNormalMatrix =
              _validateTemplateMatrix(appearance._content);
          _flattenAnnotationTemplate(appearance, isNormalMatrix);
        }
      } else {
        final bool isNormalMatrix =
            _validateTemplateMatrix(appearance._content);
        _flattenAnnotationTemplate(appearance, isNormalMatrix);
      }
    } else {
      page.graphics.save();
      final Rect rectangle =
          super._calculateTemplateBounds(bounds, page, appearance, true);
      if (opacity < 1) {
        page.graphics.setTransparency(opacity, mode: PdfBlendMode.normal);
      }
      page.graphics.drawPdfTemplate(
          appearance, Offset(rectangle.left, rectangle.top), rectangle.size);
      page.annotations.remove(this);
      page.graphics.restore();
    }
  }

  PdfTemplate _createAppearance() {
    if (_isLoadedAnnotation && !setAppearance) {
      return null;
    }
    final _Rectangle nativeRectangle =
        _Rectangle(0, 0, bounds.width, bounds.height);
    final PdfTemplate template = PdfTemplate._fromRect(nativeRectangle.rect);
    _setMatrix(template._content);
    if (_isLoadedAnnotation &&
        _dictionary.containsKey(_DictionaryProperties.be)) {
      template._writeTransformation = false;
    }
    final _PaintParams paintParams = _PaintParams();
    final double borderWidth = border.width / 2;
    final PdfPen mBorderPen = PdfPen(color, width: border.width.toDouble());
    if (border.width > 0 && color._alpha != 0) {
      paintParams._borderPen = mBorderPen;
    }
    PdfBrush mBackBrush;
    if (innerColor._alpha != 0) {
      mBackBrush = PdfSolidBrush(innerColor);
    }
    paintParams._foreBrush = PdfSolidBrush(color);
    paintParams._backBrush = mBackBrush;
    final PdfGraphics graphics = template.graphics;
    if (opacity < 1) {
      graphics.save();
      graphics.setTransparency(opacity);
    }
    if (_isLoadedAnnotation) {
      final _Rectangle rectangle =
          _obtainStyle(mBorderPen, nativeRectangle, borderWidth);
      if (_dictionary.containsKey(_DictionaryProperties.be)) {
        _drawAppearance(rectangle, borderWidth, graphics, paintParams);
      } else {
        graphics.drawEllipse(
            Rect.fromLTWH(rectangle.x + borderWidth, rectangle.y,
                rectangle.width - border.width, rectangle.height),
            pen: paintParams._borderPen,
            brush: paintParams._backBrush);
      }
    } else {
      final Rect rect = Rect.fromLTWH(nativeRectangle.left, nativeRectangle.top,
          nativeRectangle.width, nativeRectangle.height);
      graphics.drawEllipse(
          Rect.fromLTWH(rect.left + borderWidth, rect.top + borderWidth,
              rect.width - border.width, rect.height - border.width),
          pen: paintParams._borderPen,
          brush: paintParams._backBrush);
    }
    if (opacity < 1) {
      graphics.restore();
    }
    return template;
  }

  // Obtain Style for annotation
  _Rectangle _obtainStyle(
      PdfPen mBorderPen, _Rectangle rectangle, double borderWidth) {
    if (_dictionary.containsKey(_DictionaryProperties.bs)) {
      final _PdfDictionary bSDictionary =
          _PdfCrossTable._dereference(_dictionary[_DictionaryProperties.bs])
              as _PdfDictionary;

      if (bSDictionary != null &&
          bSDictionary.containsKey(_DictionaryProperties.d)) {
        final _PdfArray dashPatternArray =
            _PdfCrossTable._dereference(bSDictionary[_DictionaryProperties.d])
                as _PdfArray;
        final List<double> dashPattern = List<double>(dashPatternArray.count);
        for (int i = 0; i < dashPatternArray.count; i++) {
          dashPattern[i] =
              (dashPatternArray._elements[i] as _PdfNumber).value.toDouble();
        }
        mBorderPen.dashStyle = PdfDashStyle.dash;
        mBorderPen.dashPattern = dashPattern;
      }
    }
    if (!_isBounds && _dictionary[_DictionaryProperties.rd] != null) {
      final _PdfArray mRdArray =
          _PdfCrossTable._dereference(_dictionary[_DictionaryProperties.rd])
              as _PdfArray;
      if (mRdArray != null) {
        final _PdfNumber num1 = mRdArray._elements[0] as _PdfNumber;
        final _PdfNumber num2 = mRdArray._elements[1] as _PdfNumber;
        final _PdfNumber num3 = mRdArray._elements[2] as _PdfNumber;
        final _PdfNumber num4 = mRdArray._elements[3] as _PdfNumber;
        rectangle.x = rectangle.x + num1.value;
        rectangle.y = rectangle.y + borderWidth + num2.value;
        rectangle.width = rectangle.width - (2 * num3.value);
        rectangle.height = rectangle.height - border.width;
        rectangle.height = rectangle.height - (2 * num4.value);
      }
    } else {
      rectangle.y = rectangle.y + borderWidth;
      rectangle.height = bounds.height - border.width;
    }
    return rectangle;
  }

  // Draw appearance for annotation
  void _drawAppearance(_Rectangle rectangle, double borderWidth,
      PdfGraphics graphics, _PaintParams paintParams) {
    final PdfPath graphicsPath = PdfPath();
    graphicsPath.addEllipse(Rect.fromLTWH(
        rectangle.x + borderWidth,
        -rectangle.y - rectangle.height,
        rectangle.width - border.width,
        rectangle.height));
    double radius = 0;
    if (_dictionary.containsKey(_DictionaryProperties.rd)) {
      final _PdfArray rdArray = _PdfCrossTable._dereference(
          _dictionary._items[_PdfName(_DictionaryProperties.rd)]) as _PdfArray;
      if (rdArray != null) {
        radius = (rdArray._elements[0] as _PdfNumber).value;
      }
    }
    if (radius > 0) {
      final _Rectangle rect = _Rectangle(
          rectangle.x + borderWidth,
          -rectangle.y - rectangle.height,
          rectangle.width - border.width,
          rectangle.height);
      final List<Offset> startPointList = <Offset>[];
      final List<Offset> controlPointList = <Offset>[];
      final List<Offset> endPointList = <Offset>[];
      final List<Offset> points = <Offset>[];

      controlPointList.add(Offset(rect.right, rect.bottom));
      controlPointList.add(Offset(rect.left, rect.bottom));
      controlPointList.add(Offset(rect.left, rect.top));
      controlPointList.add(Offset(rect.right, rect.top));

      startPointList.add(Offset(rect.right, rect.top + (rect.height / 2)));
      startPointList.add(Offset(rect.left + rect.width / 2, rect.bottom));
      startPointList.add(Offset(rect.left, rect.top + (rect.height / 2)));
      startPointList.add(Offset(rect.left + (rect.width / 2), rect.top));

      endPointList.add(Offset(rect.left + rect.width / 2, rect.bottom));
      endPointList.add(Offset(rect.left, rect.top + (rect.height / 2)));
      endPointList.add(Offset(rect.left + (rect.width / 2), rect.top));
      endPointList.add(Offset(rect.right, rect.top + (rect.height / 2)));

      for (int i = 0; i < controlPointList.length; i++) {
        _createBezier(
            startPointList[i], controlPointList[i], endPointList[i], points);
      }
      _drawCloudStyle(graphics, paintParams._backBrush, paintParams._borderPen,
          radius, 0.833, points, false);
      startPointList.clear();
      controlPointList.clear();
      endPointList.clear();
      points.clear();
    } else {
      graphics.drawEllipse(
          Rect.fromLTWH(rectangle.x + borderWidth, -rectangle.y,
              rectangle.width - border.width, -rectangle.height),
          pen: paintParams._borderPen,
          brush: paintParams._backBrush);
    }
  }

  // Create bezier curve
  void _createBezier(
      Offset ctrl1, Offset ctrl2, Offset ctrl3, List<Offset> bezierPoints) {
    bezierPoints.add(ctrl1); // add the first control point
    _populateBezierPoints(ctrl1, ctrl2, ctrl3, 0, bezierPoints);
    bezierPoints.add(ctrl3); // add the last control point
  }

  // calculate bezier points
  void _populateBezierPoints(Offset ctrl1, Offset ctrl2, Offset ctrl3,
      int currentIteration, List<Offset> bezierPoints) {
    if (currentIteration < 2) {
      //calculate next mid points
      final Offset midPoint1 =
          Offset((ctrl1.dx + ctrl2.dx) / 2, (ctrl1.dy + ctrl2.dy) / 2);
      final Offset midPoint2 =
          Offset((ctrl2.dx + ctrl3.dx) / 2, (ctrl2.dy + ctrl3.dy) / 2);
      final Offset midPoint3 = Offset(
          (midPoint1.dx + midPoint2.dx) / 2, (midPoint1.dy + midPoint2.dy) / 2);
      //the next control point
      currentIteration++;
      _populateBezierPoints(ctrl1, midPoint1, midPoint3, currentIteration,
          bezierPoints); //left branch
      bezierPoints.add(midPoint3);
      //add the next control point
      _populateBezierPoints(midPoint3, midPoint2, ctrl3, currentIteration,
          bezierPoints); //right branch
    }
  }

  @override
  _IPdfPrimitive get _element => _dictionary;

  @override
  set _element(_IPdfPrimitive value) {
    _element = value;
  }
}
