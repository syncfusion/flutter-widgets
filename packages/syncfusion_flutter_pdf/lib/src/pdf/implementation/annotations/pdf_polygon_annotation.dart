part of pdf;

/// Represents a Polygon annotation.
class PdfPolygonAnnotation extends PdfAnnotation {
  // Constructor
  /// Initializes new instance of the [PdfPolygonAnnotation] class.
  ///
  /// ``` dart
  /// PdfDocument document = PdfDocument();
  /// PdfPage page = document.pages.add();
  /// List<int> polypoints = <int>[
  ///   50,
  ///   298,
  ///   100,
  ///   325,
  ///   200,
  ///   355,
  ///   300,
  ///   230,
  ///   180,
  ///   230
  /// ];
  /// PdfPolygonAnnotation polygonAnnotation =
  ///     PdfPolygonAnnotation(polypoints, 'PolygonAnnotation');
  /// polygonAnnotation.color = PdfColor(255, 0, 0);
  /// polygonAnnotation.innerColor = PdfColor(255, 0, 255);
  /// page.annotations.add(polygonAnnotation);
  /// List<int> bytes = document.save();
  /// document.dispose();
  /// ```
  PdfPolygonAnnotation(List<int> points, String text,
      {PdfColor? color,
      PdfColor? innerColor,
      PdfAnnotationBorder? border,
      String? author,
      String? subject,
      DateTime? modifiedDate,
      double? opacity,
      bool? setAppearance})
      : super._(
            text: text,
            color: color,
            innerColor: innerColor,
            border: border,
            author: author,
            subject: subject,
            modifiedDate: modifiedDate,
            opacity: opacity,
            setAppearance: setAppearance) {
    _linePoints = _PdfArray(points);
    _polygonPoints = points;
  }

  PdfPolygonAnnotation._(
      _PdfDictionary dictionary, _PdfCrossTable crossTable, String text)
      : super._internal(dictionary, crossTable) {
    _dictionary = dictionary;
    _crossTable = crossTable;
    this.text = text;
  }

  // Fields
  _PdfArray? _linePoints;
  late List<int> _polygonPoints;

  /// Gets the polygon points of the annotation.
  List<int> get polygonPoints {
    if (_isLoadedAnnotation) {
      final List<int> points = <int>[];
      if (_dictionary.containsKey(_DictionaryProperties.vertices)) {
        final _PdfArray? linePoints =
            _dictionary[_DictionaryProperties.vertices] as _PdfArray?;
        if (linePoints != null) {
          // ignore: avoid_function_literals_in_foreach_calls
          linePoints._elements.forEach((_IPdfPrimitive? element) {
            if (element != null && element is _PdfNumber) {
              points.add(element.value!.toInt());
            }
          });
        }
      }
      return points;
    } else {
      return _polygonPoints;
    }
  }

  // Implementation
  @override
  void _initialize() {
    super._initialize();
    _dictionary.setProperty(
        _DictionaryProperties.subtype, _PdfName(_DictionaryProperties.polygon));
  }

  @override
  void _save() {
    if (page!.annotations._flatten) {
      _flatten = true;
    }
    if (_isLoadedAnnotation) {
      _saveOldPolygonAnnotation();
    } else {
      _saveNewPolygonAnnotation();
    }
  }

  void _saveNewPolygonAnnotation() {
    Rect nativeRectangle = Rect.zero;
    if (setAppearance) {
      _getBoundsValue();
      nativeRectangle = Rect.fromLTWH(
          bounds.left - border.width,
          bounds.top - (border.width),
          bounds.width + (2 * border.width),
          bounds.height + (2 * border.width));
      _dictionary.setProperty(_DictionaryProperties.ap, appearance);
      if (_dictionary[_DictionaryProperties.ap] != null) {
        appearance.normal = PdfTemplate._fromRect(nativeRectangle);
        final PdfTemplate template = appearance.normal;
        template._writeTransformation = false;
        final PdfGraphics? graphics = template.graphics;
        final PdfBrush? _backBrush =
            innerColor.isEmpty ? null : PdfSolidBrush(innerColor);
        PdfPen? _borderPen;
        if (border.width > 0 && color._alpha != 0) {
          _borderPen = PdfPen(color, width: border.width.toDouble());
        }
        if (_flatten) {
          page!.annotations.remove(this);
          page!.graphics.drawPolygon(_getLinePoints()!,
              pen: _borderPen, brush: _backBrush);
        } else {
          graphics!.drawPolygon(_getLinePoints()!,
              pen: _borderPen, brush: _backBrush);
        }
      }
    }
    if (_flatten && !setAppearance) {
      page!.annotations.remove(this);
      PdfPen? _borderPen;
      if (border.width > 0 && color._alpha != 0) {
        _borderPen = PdfPen(color, width: border.width.toDouble());
      }
      final PdfBrush? _backBrush =
          innerColor.isEmpty ? null : PdfSolidBrush(innerColor);
      page!.graphics
          .drawPolygon(_getLinePoints()!, pen: _borderPen, brush: _backBrush);
    } else if (!_flatten) {
      super._save();
      _dictionary.setProperty(
          _DictionaryProperties.vertices, _PdfArray(_linePoints));
      _dictionary.setProperty(_DictionaryProperties.bs, border);
      _getBoundsValue();
      _dictionary.setProperty(_DictionaryProperties.rect,
          _PdfArray.fromRectangle(_Rectangle.fromRect(bounds)));
      if (setAppearance) {
        _dictionary.setProperty(_DictionaryProperties.rect,
            _PdfArray.fromRectangle(_Rectangle.fromRect(nativeRectangle)));
      }
    }
  }

  void _saveOldPolygonAnnotation() {
    PdfGraphicsState? state;
    _Rectangle nativeRectangle = _Rectangle.empty;
    if (setAppearance) {
      _getBoundsValue();
      nativeRectangle = _Rectangle(
          bounds.left - border.width,
          page!.size.height - bounds.top - (border.width) - bounds.height,
          bounds.width + (2 * border.width),
          bounds.height + (2 * border.width));
      _dictionary.setProperty(_DictionaryProperties.ap, appearance);
      if (_dictionary[_DictionaryProperties.ap] != null) {
        appearance.normal = PdfTemplate._fromRect(nativeRectangle.rect);
        final PdfTemplate template = appearance.normal;
        template._writeTransformation = false;
        final PdfGraphics? graphics = appearance.normal.graphics;
        PdfBrush? backgroundBrush;
        if (innerColor._alpha != 0) {
          backgroundBrush = PdfSolidBrush(innerColor);
        }
        PdfPen? _borderPen;
        if (border.width > 0) {
          _borderPen = PdfPen(color, width: border.width.toDouble());
        }
        if (_dictionary.containsKey(_DictionaryProperties.bs)) {
          _PdfDictionary? bSDictionary;
          if (_dictionary._items![_PdfName(_DictionaryProperties.bs)]
              is _PdfReferenceHolder) {
            bSDictionary =
                (_dictionary._items![_PdfName(_DictionaryProperties.bs)]!
                        as _PdfReferenceHolder)
                    ._object as _PdfDictionary?;
          } else {
            bSDictionary = _dictionary
                ._items![_PdfName(_DictionaryProperties.bs)] as _PdfDictionary?;
          }
          if (bSDictionary!.containsKey(_DictionaryProperties.d)) {
            final _PdfArray? dashPatternArray = _PdfCrossTable._dereference(
                    bSDictionary._items![_PdfName(_DictionaryProperties.d)])
                as _PdfArray?;
            if (dashPatternArray != null) {
              final List<double> dashPattern = List<double>.filled(
                  dashPatternArray.count, 0,
                  growable: true);
              for (int i = 0; i < dashPatternArray.count; i++) {
                final _IPdfPrimitive? pdfPrimitive =
                    dashPatternArray._elements[i];
                if (pdfPrimitive != null && pdfPrimitive is _PdfNumber) {
                  dashPattern[i] = pdfPrimitive.value!.toDouble();
                }
              }
              _borderPen!.dashStyle = PdfDashStyle.dash;
              _borderPen._isSkipPatternWidth = true;
              _borderPen.dashPattern = dashPattern;
            }
          }
        }
        if (_flatten) {
          _page!.annotations.remove(this);
          if (opacity < 1) {
            state = page!.graphics.save();
            page!.graphics.setTransparency(opacity);
          }
          if (_dictionary.containsKey(_DictionaryProperties.be)) {
            final _PdfDictionary beDictionary =
                _dictionary[_PdfName(_DictionaryProperties.be)]!
                    as _PdfDictionary;
            final double? iNumber = (beDictionary
                    ._items![_PdfName(_DictionaryProperties.i)]! as _PdfNumber)
                .value as double?;
            final double radius = iNumber == 1 ? 5 : 10;
            if (radius > 0) {
              final List<Offset> points = _getLinePoints()!;
              if (points[0].dy > points[points.length - 1].dy) {
                _drawCloudStyle(graphics!, backgroundBrush, _borderPen, radius,
                    0.833, _getLinePoints()!, false);
              }
              _drawCloudStyle(page!.graphics, backgroundBrush, _borderPen,
                  radius, 0.833, _getLinePoints()!, false);
            } else {
              page!.graphics.drawPolygon(_getLinePoints()!,
                  pen: _borderPen, brush: backgroundBrush);
            }
          } else {
            page!.graphics.drawPolygon(_getLinePoints()!,
                pen: _borderPen, brush: backgroundBrush);
          }
          if (opacity < 1) {
            page!.graphics.restore(state);
          }
        } else {
          if (opacity < 1) {
            state = graphics!.save();
            graphics.setTransparency(opacity);
          }
          if (_dictionary.containsKey(_DictionaryProperties.be)) {
            final _PdfDictionary beDictionary =
                _dictionary[_PdfName(_DictionaryProperties.be)]!
                    as _PdfDictionary;
            final double? iNumber = (beDictionary
                    ._items![_PdfName(_DictionaryProperties.i)]! as _PdfNumber)
                .value as double?;
            final double radius = iNumber == 1 ? 5 : 10;
            List<Offset> points = _getLinePoints()!;
            if (points[0].dy > points[points.length - 1].dy) {
              final List<Offset> point = <Offset>[];
              for (int i = 0; i < points.length; i++) {
                point.add(Offset(points[i].dx, -points[i].dy));
              }
              points = point;
              _drawCloudStyle(graphics!, backgroundBrush, _borderPen, radius,
                  0.833, points, true);
            } else {
              _drawCloudStyle(graphics!, backgroundBrush, _borderPen, radius,
                  0.833, points, false);
            }
          } else {
            graphics!.drawPolygon(_getLinePoints()!,
                pen: _borderPen, brush: backgroundBrush);
          }
          if (opacity < 1) {
            graphics.restore(state);
          }
        }
        _dictionary.setProperty(_DictionaryProperties.rect,
            _PdfArray.fromRectangle(nativeRectangle));
      }
    }
    if (_flatten && !setAppearance) {
      if (_dictionary[_DictionaryProperties.ap] != null) {
        _IPdfPrimitive? obj = _dictionary[_DictionaryProperties.ap];
        _PdfDictionary? dic =
            _PdfCrossTable._dereference(obj) as _PdfDictionary?;
        PdfTemplate? template;
        if (dic != null) {
          obj = dic[_DictionaryProperties.n];
          dic = _PdfCrossTable._dereference(obj) as _PdfDictionary?;
          if (dic != null && dic is _PdfStream) {
            final _PdfStream stream = dic;
            template = PdfTemplate._fromPdfStream(stream);
            state = page!.graphics.save();
            if (opacity < 1) {
              page!.graphics.setTransparency(opacity);
            }
            final bool isNormalMatrix = _validateTemplateMatrix(dic);
            final Rect rect = _calculateTemplateBounds(
                bounds, page, template, isNormalMatrix);
            page!.graphics.drawPdfTemplate(template, rect.topLeft, rect.size);
            page!.graphics.restore(state);
            page!.annotations.remove(this);
          }
        }
      } else {
        page!.annotations.remove(this);
        final PdfPen _borderPen = PdfPen(color, width: border.width.toDouble());
        final PdfBrush? backgroundBrush =
            innerColor.isEmpty ? null : PdfSolidBrush(innerColor);
        if (opacity < 1) {
          state = page!.graphics.save();
          page!.graphics.setTransparency(opacity);
        }
        if (_dictionary.containsKey(_DictionaryProperties.be)) {
          final _IPdfPrimitive? primitive =
              _dictionary[_PdfName(_DictionaryProperties.be)];
          final _PdfDictionary beDictionary = (primitive is _PdfReferenceHolder
              ? primitive._object
              : primitive)! as _PdfDictionary;
          final double? iNumber = (beDictionary
                  ._items![_PdfName(_DictionaryProperties.i)]! as _PdfNumber)
              .value as double?;
          final double radius = iNumber == 1 ? 5 : 10;
          _drawCloudStyle(page!.graphics, backgroundBrush, _borderPen, radius,
              0.833, _getLinePoints()!, false);
        } else {
          page!.graphics.drawPolygon(_getLinePoints()!,
              pen: _borderPen, brush: backgroundBrush);
        }
        if (opacity < 1) {
          page!.graphics.restore(state);
        }
      }
      if (_flattenPopups) {
        _flattenPopup();
      }
    }
  }

  List<Offset>? _getLinePoints() {
    if (_isLoadedAnnotation) {
      List<Offset>? points;
      if (_dictionary.containsKey(_DictionaryProperties.vertices)) {
        final _PdfArray? linePoints =
            _dictionary[_DictionaryProperties.vertices] as _PdfArray?;
        if (linePoints != null) {
          final List<double> point = <double>[];
          for (int i = 0; i < linePoints.count; i++) {
            final _PdfNumber number = linePoints[i]! as _PdfNumber;
            point.add(number.value!.toDouble());
          }
          points = <Offset>[];
          for (int j = 0; j < point.length; j = j + 2) {
            if (_flatten) {
              points.add(Offset(point[j], page!.size.height - point[j + 1]));
            } else {
              points.add(Offset(point[j].toDouble(), -point[j + 1]));
            }
          }
        }
      }
      return points;
    } else {
      final List<Offset> points = <Offset>[];
      if (_linePoints != null) {
        final List<double> pointsValue = <double>[];
        // ignore: prefer_final_in_for_each
        for (_IPdfPrimitive? linePoint in _linePoints!._elements) {
          if (linePoint is _PdfNumber) {
            pointsValue.add(linePoint.value!.toDouble());
          }
        }
        for (int j = 0; j < pointsValue.length; j = j + 2) {
          final double pageHeight = page!.size.height;
          if (_flatten) {
            page!._isLoadedPage
                ? points.add(
                    Offset(pointsValue[j], pageHeight - pointsValue[j + 1]))
                : points.add(Offset(
                    pointsValue[j] - page!._section!.pageSettings.margins.left,
                    pageHeight -
                        pointsValue[j + 1] -
                        page!._section!.pageSettings.margins.right));
          } else {
            points.add(Offset(pointsValue[j], -pointsValue[j + 1]));
          }
        }
      }
      return points;
    }
  }

  void _getBoundsValue() {
    if (_isLoadedAnnotation) {
      final _PdfArray rect =
          _dictionary[_DictionaryProperties.rect]! as _PdfArray;
      bounds = rect.toRectangle().rect;
      final List<double> xval = <double>[];
      final List<double> yval = <double>[];
      if (_dictionary.containsKey(_DictionaryProperties.vertices)) {
        final _PdfArray linePoints = _PdfCrossTable._dereference(
            _dictionary[_DictionaryProperties.vertices])! as _PdfArray;
        if (linePoints.count > 0) {
          final List<double> points =
              List<double>.filled(linePoints.count, 0, growable: true);
          for (int j = 0; j < linePoints.count; j++) {
            final _PdfNumber number = linePoints[j]! as _PdfNumber;
            points[j] = number.value!.toDouble();
          }
          for (int i = 0; i < points.length; i++) {
            if (i.isEven) {
              xval.add(points[i]);
            } else {
              yval.add(points[i]);
            }
          }
        }
      }
      xval.sort();
      yval.sort();
      bounds = Rect.fromLTWH(xval[0], yval[0], xval[xval.length - 1] - xval[0],
          yval[yval.length - 1] - yval[0]);
    } else {
      final List<double> xval = <double>[];
      final List<double> yval = <double>[];
      if (_linePoints!.count > 0) {
        final List<double> pointsValue = <double>[];
        // ignore: prefer_final_in_for_each
        for (_IPdfPrimitive? linePoint in _linePoints!._elements) {
          if (linePoint is _PdfNumber) {
            pointsValue.add(linePoint.value!.toDouble());
          }
        }
        for (int i = 0; i < pointsValue.length; i++) {
          if (i.isEven) {
            xval.add(pointsValue[i]);
          } else {
            yval.add(pointsValue[i]);
          }
        }
      }
      xval.sort();
      yval.sort();
      bounds = Rect.fromLTWH(xval[0], yval[0], xval[xval.length - 1] - xval[0],
          yval[yval.length - 1] - yval[0]);
    }
  }

  @override
  _IPdfPrimitive get _element => _dictionary;

  @override
  set _element(_IPdfPrimitive? value) {
    _element = value;
  }
}
