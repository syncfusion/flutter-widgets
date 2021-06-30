part of pdf;

/// Represents a PDF rectangle annotation
class PdfRectangleAnnotation extends PdfAnnotation {
  // Constructor
  /// Initializes new instance of the [PdfRectangleAnnotation] with bounds, text, border, color, innerColor, author, rotate, subject and modifiedDate.
  /// ``` dart
  /// PdfDocument document = PdfDocument();
  /// PdfPage page = document.pages.add();
  /// PdfRectangleAnnotation rectangleAnnotation = PdfRectangleAnnotation(
  ///     const Rect.fromLTWH(0, 30, 80, 80), 'SquareAnnotation',
  ///     innerColor: PdfColor(255, 0, 0), color: PdfColor(255, 255, 0));
  /// page.annotations.add(rectangleAnnotation);
  /// List<int> bytes = document.save();
  /// document.dispose();
  /// ```
  PdfRectangleAnnotation(Rect bounds, String text,
      {PdfColor? color,
      PdfColor? innerColor,
      PdfAnnotationBorder? border,
      String? author,
      String? subject,
      double? opacity,
      DateTime? modifiedDate,
      bool? setAppearance})
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
            setAppearance: setAppearance);

  PdfRectangleAnnotation._(
      _PdfDictionary dictionary, _PdfCrossTable crossTable, String text)
      : super._internal(dictionary, crossTable) {
    _dictionary = dictionary;
    _crossTable = crossTable;
    this.text = text;
  }

  // Implementation
  @override
  void _initialize() {
    super._initialize();
    _dictionary.setProperty(
        _DictionaryProperties.subtype, _PdfName(_DictionaryProperties.square));
  }

  @override
  void _save() {
    if (page!.annotations._flatten) {
      _flatten = true;
    }
    if (_flatten || setAppearance || _pdfAppearance != null) {
      PdfTemplate? appearance;
      if (_pdfAppearance != null) {
        appearance = _pdfAppearance!.normal;
      } else {
        appearance = _createAppearance();
      }
      if (_flatten) {
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
    if (!_flatten && !_isLoadedAnnotation) {
      super._save();
      _dictionary.setProperty(_DictionaryProperties.bs, border);
    }
    if (_flattenPopups) {
      _flattenPopup();
    }
  }

  PdfTemplate? _createAppearance() {
    if (_isLoadedAnnotation) {
      if (setAppearance) {
        final _PaintParams paintParams = _PaintParams();
        final double borderWidth = border.width / 2;
        final PdfPen mBorderPen = PdfPen(color, width: border.width.toDouble());
        PdfBrush? mBackBrush;
        final Map<String, dynamic> result = _calculateCloudBorderBounds();
        final double borderIntensity = result['borderIntensity'] as double;
        final String? borderStyle = result['borderStyle'] as String?;
        final _Rectangle nativeRectangle =
            _Rectangle(0, 0, bounds.width, bounds.height);
        final PdfTemplate template =
            PdfTemplate._fromRect(nativeRectangle.rect);
        _setMatrix(template._content);
        if (borderIntensity > 0 && borderStyle == 'C') {
          template._writeTransformation = false;
        }
        final PdfGraphics? graphics = template.graphics;
        if (innerColor._alpha != 0) {
          mBackBrush = PdfSolidBrush(innerColor);
        }
        if (border.width > 0) {
          paintParams._borderPen = mBorderPen;
        }
        paintParams._foreBrush = PdfSolidBrush(color);
        paintParams._backBrush = mBackBrush;
        final _Rectangle rectangle = _obtainStyle(
            mBorderPen, nativeRectangle, borderWidth,
            borderIntensity: borderIntensity, borderStyle: borderStyle);
        if (opacity < 1) {
          graphics!.save();
          graphics.setTransparency(opacity);
        }
        if (borderIntensity > 0 && borderStyle == 'C') {
          _drawAppearance(
              rectangle, borderWidth, graphics, paintParams, borderIntensity);
        } else {
          graphics!.drawRectangle(
              pen: paintParams._borderPen,
              brush: paintParams._backBrush,
              bounds: Rect.fromLTWH(
                  rectangle.x, rectangle.y, rectangle.width, rectangle.height));
        }
        if (opacity < 1) {
          graphics!.restore();
        }
        return template;
      }
      return null;
    } else {
      final Rect nativeRectangle =
          Rect.fromLTWH(0, 0, bounds.width, bounds.height);
      final PdfTemplate template = PdfTemplate(bounds.width, bounds.height);
      _setMatrix(template._content);
      final _PaintParams paintParams = _PaintParams();
      final PdfGraphics graphics = template.graphics!;
      if (border.width > 0 && color._alpha != 0) {
        final PdfPen mBorderPen = PdfPen(color, width: border.width.toDouble());
        paintParams._borderPen = mBorderPen;
      }
      PdfBrush? mBackBrush;
      if (innerColor._alpha != 0) {
        mBackBrush = PdfSolidBrush(innerColor);
      }
      final double width = border.width / 2;

      paintParams._backBrush = mBackBrush;
      if (paintParams._foreBrush != PdfSolidBrush(color)) {
        paintParams._foreBrush = PdfSolidBrush(color);
      }
      final Rect rect = Rect.fromLTWH(nativeRectangle.left, nativeRectangle.top,
          nativeRectangle.width, nativeRectangle.height);
      if (opacity < 1) {
        graphics.save();
        graphics.setTransparency(opacity, mode: PdfBlendMode.normal);
      }
      graphics.drawRectangle(
          bounds: Rect.fromLTWH(rect.left + width, rect.top + width,
              rect.width - border.width, rect.height - border.width),
          pen: paintParams._borderPen,
          brush: paintParams._backBrush);
      if (opacity < 1) {
        graphics.restore();
      }
      return template;
    }
  }

  Map<String, dynamic> _calculateCloudBorderBounds() {
    double borderIntensity = 0;
    String borderStyle = '';
    if (!_dictionary.containsKey(_DictionaryProperties.rd) &&
        _dictionary.containsKey(_DictionaryProperties.be)) {
      final _PdfDictionary dict =
          _PdfCrossTable._dereference(_dictionary[_DictionaryProperties.be])!
              as _PdfDictionary;
      if (dict.containsKey(_DictionaryProperties.s)) {
        borderStyle =
            _getEnumName((dict[_DictionaryProperties.s]! as _PdfName)._name);
      }
      if (dict.containsKey(_DictionaryProperties.i)) {
        borderIntensity =
            (dict[_DictionaryProperties.i]! as _PdfNumber).value!.toDouble();
      }
      if (borderIntensity != 0 && borderStyle == 'C') {
        final Rect cloudRectangle = Rect.fromLTWH(
            bounds.left - borderIntensity * 5 - border.width / 2,
            bounds.top - borderIntensity * 5 - border.width / 2,
            bounds.width + borderIntensity * 10 + border.width,
            bounds.height + borderIntensity * 10 + border.width);
        final double radius = borderIntensity * 5;
        final List<double> arr = <double>[
          radius + border.width / 2,
          radius + border.width / 2,
          radius + border.width / 2,
          radius + border.width / 2
        ];
        _dictionary.setProperty(_DictionaryProperties.rd, _PdfArray(arr));
        bounds = cloudRectangle;
      }
    }
    if (!_isBounds && _dictionary[_DictionaryProperties.rd] != null) {
      final _PdfArray mRdArray =
          _dictionary[_DictionaryProperties.rd]! as _PdfArray;
      final _PdfNumber num1 = mRdArray._elements[0]! as _PdfNumber;
      final _PdfNumber num2 = mRdArray._elements[1]! as _PdfNumber;
      final _PdfNumber num3 = mRdArray._elements[2]! as _PdfNumber;
      final _PdfNumber num4 = mRdArray._elements[3]! as _PdfNumber;
      Rect cloudRectangle = Rect.fromLTWH(
          bounds.left + num1.value!.toDouble(),
          bounds.top + num2.value!.toDouble(),
          bounds.width - num3.value!.toDouble() * 2,
          bounds.height - num4.value!.toDouble() * 2);
      if (borderIntensity != 0 && borderStyle == 'C') {
        cloudRectangle = Rect.fromLTWH(
            cloudRectangle.left - borderIntensity * 5 - border.width / 2,
            cloudRectangle.top - borderIntensity * 5 - border.width / 2,
            cloudRectangle.width + borderIntensity * 10 + border.width,
            cloudRectangle.height + borderIntensity * 10 + border.width);
        final double radius = borderIntensity * 5;
        final List<double> arr = <double>[
          radius + border.width / 2,
          radius + border.width / 2,
          radius + border.width / 2,
          radius + border.width / 2
        ];
        _dictionary.setProperty(_DictionaryProperties.rd, _PdfArray(arr));
      } else {
        _dictionary.remove(_DictionaryProperties.rd);
      }
      bounds = cloudRectangle;
    }
    return <String, dynamic>{
      'borderIntensity': borderIntensity,
      'borderStyle': borderStyle
    };
  }

  void _flattenAnnotation(PdfPage? page, PdfTemplate? appearance) {
    if (_isLoadedAnnotation) {
      final bool isContainsAP =
          _dictionary.containsKey(_DictionaryProperties.ap);
      if (isContainsAP && appearance == null) {
        _PdfDictionary? appearanceDictionary =
            _PdfCrossTable._dereference(_dictionary[_DictionaryProperties.ap])
                as _PdfDictionary?;
        if (appearanceDictionary != null) {
          appearanceDictionary = _PdfCrossTable._dereference(
              appearanceDictionary[_DictionaryProperties.n]) as _PdfDictionary?;
          if (appearanceDictionary != null) {
            final _PdfStream appearanceStream =
                appearanceDictionary as _PdfStream;
            appearance = PdfTemplate._fromPdfStream(appearanceStream);
            final bool isNormalMatrix =
                _validateTemplateMatrix(appearanceDictionary);
            _flattenAnnotationTemplate(appearance, isNormalMatrix);
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
            _validateTemplateMatrix(appearance!._content);
        _flattenAnnotationTemplate(appearance, isNormalMatrix);
      }
    } else {
      page!.graphics.save();
      final Rect rectangle =
          super._calculateTemplateBounds(bounds, page, appearance, true);

      if (opacity < 1) {
        page.graphics.setTransparency(opacity, mode: PdfBlendMode.normal);
      }
      page.graphics.drawPdfTemplate(
          appearance!, Offset(rectangle.left, rectangle.top), rectangle.size);
      page.annotations.remove(this);
      page.graphics.restore();
    }
  }

  // Obtain Style from annotation
  _Rectangle _obtainStyle(
      PdfPen mBorderPen, _Rectangle rectangle, double borderWidth,
      {double? borderIntensity, String? borderStyle}) {
    if (_dictionary.containsKey(_DictionaryProperties.bs)) {
      final _PdfDictionary? bSDictionary =
          _PdfCrossTable._dereference(_dictionary[_DictionaryProperties.bs])
              as _PdfDictionary?;
      if (bSDictionary != null &&
          bSDictionary.containsKey(_DictionaryProperties.d)) {
        final _PdfArray dashPatternArray =
            _PdfCrossTable._dereference(bSDictionary[_DictionaryProperties.d])!
                as _PdfArray;
        final List<double> dashPattern = <double>[];
        for (int i = 0; i < dashPatternArray.count; i++) {
          dashPattern.add(
              (dashPatternArray._elements[i]! as _PdfNumber).value!.toDouble());
        }
        mBorderPen.dashStyle = PdfDashStyle.dash;
        mBorderPen.dashPattern = dashPattern;
      }
    }
    if (borderIntensity != null &&
        borderIntensity > 0 &&
        borderStyle != null &&
        borderStyle == 'C') {
      final double radius = borderIntensity * 5;
      rectangle.x = rectangle.x + radius + borderWidth;
      rectangle.y = rectangle.y + radius + borderWidth;
      rectangle.width = rectangle.width - (2 * radius) - 2 * borderWidth;
      rectangle.height = rectangle.height - (2 * radius) - 2 * borderWidth;
    } else {
      rectangle.x += borderWidth;
      rectangle.y += borderWidth;
      rectangle.width -= border.width;
      rectangle.height -= border.width;
    }
    return rectangle;
  }

  // Draw appearance for annotation
  void _drawAppearance(_Rectangle rectangle, double borderWidth,
      PdfGraphics? graphics, _PaintParams paintParams, double borderIntensity) {
    final PdfPath graphicsPath = PdfPath();
    graphicsPath.addRectangle(rectangle.rect);
    final double radius = borderIntensity * 4.25;
    if (radius > 0) {
      if (graphicsPath._points.length == 5 &&
          graphicsPath._points[4] == Offset.zero) {
        graphicsPath._points.removeAt(4);
      }
      final List<Offset> points = <Offset>[];
      for (int i = 0; i < graphicsPath._points.length; i++) {
        points.add(
            Offset(graphicsPath._points[i].dx, -graphicsPath._points[i].dy));
      }
      _drawCloudStyle(graphics!, paintParams._backBrush, paintParams._borderPen,
          radius, 0.833, points, false);
    } else {
      graphics!.drawRectangle(
          pen: paintParams._borderPen,
          brush: paintParams._backBrush,
          bounds: Rect.fromLTWH(rectangle.x + borderWidth, rectangle.y,
              rectangle.width - border.width, rectangle.height));
    }
  }

  @override
  _IPdfPrimitive get _element => _dictionary;

  @override
  set _element(_IPdfPrimitive? value) {
    _element = value;
  }
}
