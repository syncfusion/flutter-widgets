part of pdf;

/// Represents a line annotation.
class PdfLineAnnotation extends PdfAnnotation {
  // Constructor
  /// Initializes new instance of [PdfLineAnnotation] class.
  /// ``` dart
  /// final PdfDocument document = PdfDocument();
  /// final PdfPage page = document.pages.add();
  /// final List<int> points = <int>[80, 420, 250, 420];
  /// final PdfLineAnnotation lineAnnotation = PdfLineAnnotation(
  ///     points, 'Line Annotation',
  ///     opacity: 0.95,
  ///     border: PdfAnnotationBorder(1),
  ///     lineIntent: PdfLineIntent.lineDimension,
  ///     beginLineStyle: PdfLineEndingStyle.butt,
  ///     endLineStyle: PdfLineEndingStyle.none,
  ///     innerColor: PdfColor(0, 255, 0),
  ///     color: PdfColor(0, 255, 255),
  ///     leaderLineExt: 10,
  ///     leaderLine: 2,
  ///     lineCaption: true,
  ///     captionType: PdfLineCaptionType.top);
  /// page.annotations.add(lineAnnotation);
  /// final List<int> bytes = document.save();
  /// document.dispose();
  /// ```
  PdfLineAnnotation(List<int> linePoints, String text,
      {PdfColor color,
      PdfColor innerColor,
      PdfAnnotationBorder border,
      String author,
      String subject,
      DateTime modifiedDate,
      double opacity,
      bool setAppearance,
      bool flatten,
      PdfLineEndingStyle beginLineStyle,
      PdfLineEndingStyle endLineStyle,
      PdfLineCaptionType captionType,
      PdfLineIntent lineIntent,
      int leaderLine,
      int leaderLineExt,
      bool lineCaption})
      : super._(
            text: text,
            color: color,
            innerColor: innerColor,
            border: border,
            author: author,
            subject: subject,
            modifiedDate: modifiedDate,
            opacity: opacity,
            setAppearance: setAppearance,
            flatten: flatten) {
    _linePoints = _PdfArray(linePoints);
    _points = linePoints;
    this.beginLineStyle = beginLineStyle ??= PdfLineEndingStyle.none;
    this.endLineStyle = endLineStyle ??= PdfLineEndingStyle.none;
    this.captionType = captionType ??= PdfLineCaptionType.inline;
    this.lineIntent = lineIntent ??= PdfLineIntent.lineArrow;
    this.lineCaption = lineCaption ??= false;
    if (leaderLine != null) {
      this.leaderLine = leaderLine;
    }
    if (leaderLineExt != null) {
      this.leaderLineExt = leaderLineExt;
    }
  }

  PdfLineAnnotation._(
      _PdfDictionary dictionary, _PdfCrossTable crossTable, String text)
      : super._internal(dictionary, crossTable) {
    ArgumentError.checkNotNull(text, 'Text must be not null');
    _dictionary = dictionary;
    _crossTable = crossTable;
    this.text = text;
  }

  // Fields
  _PdfArray _linePoints;
  _PdfArray _lineStyle;
  int _leaderLine = 0;
  List<int> _points = <int>[];
  PdfLineEndingStyle _beginLineStyle;
  PdfLineEndingStyle _endLineStyle;
  int _leaderLineExt = 0;
  bool _lineCaption;
  PdfLineIntent _lineIntent;
  PdfLineCaptionType _captionType;

  // Properties
  /// Gets the leader line.
  int get leaderLine => _isLoadedAnnotation ? _obtainLeaderLine() : _leaderLine;

  /// Sets the leader line.
  set leaderLine(int value) {
    if (value != 0 && !_isLoadedAnnotation) {
      _leaderLine = value;
    } else if (_isLoadedAnnotation) {
      _dictionary._setNumber(_DictionaryProperties.ll, value);
    }
  }

  /// Gets the line points of the annotation.
  List<int> get linePoints =>
      _isLoadedAnnotation ? _obtainLinePoints() : _points;

  /// Sets the line points of the annotation.
  set linePoints(List<int> value) {
    _points = value;
    _linePoints = _PdfArray(_points);
    if (_isLoadedAnnotation) {
      _dictionary.setProperty(_DictionaryProperties.l, _linePoints);
    }
  }

  /// Gets the line intent of the annotation.
  PdfLineIntent get lineIntent =>
      _isLoadedAnnotation ? _obtainLineIntent() : _lineIntent;

  /// Sets the line intent of the annotation.
  set lineIntent(PdfLineIntent value) {
    if (!_isLoadedAnnotation) {
      _lineIntent = value;
    } else {
      _dictionary._setName(
          _PdfName(_DictionaryProperties.it), _getEnumName(value));
    }
  }

  /// Gets the line caption of the annotation.
  bool get lineCaption =>
      _isLoadedAnnotation ? _obtainLineCaption() : _lineCaption;

  /// Sets the line caption of the annotation.
  set lineCaption(bool value) {
    if (!_isLoadedAnnotation) {
      _lineCaption = value;
    } else {
      _dictionary._setBoolean(_DictionaryProperties.cap, value);
    }
  }

  /// Gets the leader line extension.
  int get leaderLineExt =>
      _isLoadedAnnotation ? _obtainLeaderExt() : _leaderLineExt;

  /// Sets the leader line extension.
  set leaderLineExt(int value) {
    if (!_isLoadedAnnotation) {
      _leaderLineExt = value;
    } else {
      _dictionary._setNumber(_DictionaryProperties.lle, value);
    }
  }

  /// Gets the begin line style of the annotation.
  PdfLineEndingStyle get beginLineStyle =>
      _isLoadedAnnotation ? _getLineStyle(0) : _beginLineStyle;

  /// Sets the end line style of the annotation.
  set beginLineStyle(PdfLineEndingStyle value) {
    if (!_isLoadedAnnotation) {
      _beginLineStyle = value;
    } else {
      final _PdfArray _lineStyle = _obtainLineStyle();
      if (_lineStyle == null) {
        _lineStyle._insert(
            1, _PdfName(_getEnumName(PdfLineEndingStyle.square)));
      } else {
        _lineStyle._elements.removeAt(0);
      }
      _lineStyle._insert(
          0,
          _PdfName(
              _getEnumName(_getLineStyle(_getEnumName(value.toString())))));
      _dictionary.setProperty(_DictionaryProperties.le, _lineStyle);
    }
  }

  /// Gets the end line style of the annotation.
  PdfLineEndingStyle get endLineStyle =>
      _isLoadedAnnotation ? _getLineStyle(1) : _endLineStyle;

  /// Sets the end line style of the annotation.
  set endLineStyle(PdfLineEndingStyle value) {
    if (!_isLoadedAnnotation) {
      _endLineStyle = value;
    } else {
      final _PdfArray _lineStyle = _obtainLineStyle();
      if (_lineStyle == null) {
        _lineStyle._insert(
            0, _PdfName(_getEnumName(PdfLineEndingStyle.square)));
      } else {
        _lineStyle._elements.removeAt(1);
      }
      _lineStyle._insert(
          1,
          _PdfName(
              _getEnumName(_getLineStyle(_getEnumName(value.toString())))));
      _dictionary.setProperty(_DictionaryProperties.le, _lineStyle);
    }
  }

  /// Gets the caption type of the annotation.
  PdfLineCaptionType get captionType =>
      _isLoadedAnnotation ? _obtainCaptionType() : _captionType;

  /// Sets the caption type of the annotation.
  set captionType(PdfLineCaptionType value) {
    if (!_isLoadedAnnotation) {
      _captionType = value;
    } else {
      _dictionary.setProperty(
          _DictionaryProperties.cp,
          _PdfName(
              _getEnumName(_getCaptionType(_getEnumName(value.toString())))));
    }
  }

  // Implementation
  @override
  void _initialize() {
    super._initialize();
    _dictionary.setProperty(
        _DictionaryProperties.subtype, _PdfName(_DictionaryProperties.line));
  }

  List<int> _obtainLinePoints() {
    List<int> points;
    if (!_isLoadedAnnotation) {
      if (_linePoints != null) {
        points = List<int>(_linePoints.count);
        int i = 0;
        // ignore: prefer_final_in_for_each
        for (_PdfNumber linePoint in _linePoints._elements) {
          points[i] = linePoint.value.toInt();
          i++;
        }
      }
    } else {
      if (_dictionary.containsKey(_DictionaryProperties.l)) {
        _linePoints =
            _PdfCrossTable._dereference(_dictionary[_DictionaryProperties.l])
                as _PdfArray;
        if (_linePoints != null) {
          points = List<int>(_linePoints.count);
          int i = 0;
          // ignore: prefer_final_in_for_each
          for (_PdfNumber value in _linePoints._elements) {
            points[i] = value.value.toInt();
            i++;
          }
        }
      }
    }
    return points;
  }

  _Rectangle _obtainLineBounds() {
    _Rectangle bounds = _Rectangle.fromRect(this.bounds);
    if ((_points != null && _points.length == 4) ||
        (_isLoadedAnnotation && linePoints != null && _points != null)) {
      final List<int> linePoints = _obtainLinePoints();
      if (linePoints != null && linePoints.length == 4) {
        final _PdfArray lineStyle = _PdfArray();
        if (lineStyle._elements.isNotEmpty) {
          lineStyle._insert(0, _PdfName(_getEnumName(beginLineStyle)));
          lineStyle._insert(1, _PdfName(_getEnumName(endLineStyle)));
        } else {
          lineStyle._add(_PdfName(beginLineStyle.toString()));
          lineStyle._add(_PdfName(endLineStyle.toString()));
        }
        bounds = _isLoadedAnnotation
            ? _calculateLineBounds(linePoints, leaderLineExt, leaderLine,
                _obtainLeaderOffset(), lineStyle, border.width.toDouble())
            : _calculateLineBounds(linePoints, leaderLineExt, _leaderLine, 0,
                lineStyle, border.width.toDouble());
        bounds = _Rectangle(bounds.left - 8, bounds.top - 8,
            bounds.width + 2 * 8, bounds.height + 2 * 8);
      }
    }
    return bounds;
  }

  // Gets leader offset of the annotation.
  int _obtainLeaderOffset() {
    int lLineOffset = 0;
    if (_dictionary.containsKey(_DictionaryProperties.llo)) {
      final _PdfNumber lOffset =
          _dictionary[_DictionaryProperties.llo] as _PdfNumber;
      lLineOffset = lOffset.value.toInt();
    }
    return lLineOffset;
  }

  @override
  void _save() {
    if (page.annotations.flatten) {
      flatten = true;
    }
    if (flatten || setAppearance) {
      final PdfTemplate appearance = _createAppearance();
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
      _savePdfLineDictionary();
    }
    if (_flattenPopups) {
      _flattenPopup();
    }
  }

  void _savePdfLineDictionary() {
    super._save();
    _lineStyle = _PdfArray();
    if (_lineStyle._elements.isNotEmpty) {
      _lineStyle._insert(0, _PdfName(_getEnumName(beginLineStyle)));
      _lineStyle._insert(1, _PdfName(_getEnumName(endLineStyle)));
    } else {
      _lineStyle._add(_PdfName(_getEnumName(beginLineStyle)));
      _lineStyle._add(_PdfName(_getEnumName(endLineStyle)));
    }
    _dictionary.setProperty(_DictionaryProperties.le, _lineStyle);
    if (_linePoints != null) {
      _dictionary.setProperty(_DictionaryProperties.l, _linePoints);
    } else {
      throw ArgumentError.value('LinePoints cannot be null');
    }
    if (border.dashArray == 0) {
      if (border.borderStyle == PdfBorderStyle.dashed) {
        border.dashArray = 4;
      } else if (border.borderStyle == PdfBorderStyle.dot) {
        border.dashArray = 2;
      }
    }
    _dictionary.setProperty(_DictionaryProperties.bs, border);
    if (innerColor != null && !innerColor.isEmpty && innerColor._alpha != 0) {
      _dictionary.setProperty(
          _DictionaryProperties.ic, innerColor._toArray(PdfColorSpace.rgb));
    }
    _dictionary[_DictionaryProperties.c] = color._toArray(PdfColorSpace.rgb);

    _dictionary.setProperty(
        _DictionaryProperties.it, _PdfName(_getEnumName(lineIntent)));

    _dictionary.setProperty(
        _DictionaryProperties.lle, _PdfNumber(leaderLineExt));

    _dictionary.setProperty(_DictionaryProperties.ll, _PdfNumber(_leaderLine));

    _dictionary.setProperty(
        _DictionaryProperties.cp, _PdfName(_getEnumName(captionType)));

    _dictionary.setProperty(
        _DictionaryProperties.cap, _PdfBoolean(lineCaption));

    _dictionary.setProperty(_DictionaryProperties.rect,
        _PdfArray.fromRectangle(_obtainLineBounds()));
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
        page.graphics.setTransparency(opacity);
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
    final Rect nativeRectangle = _obtainLineBounds().rect;
    final PdfTemplate template = PdfTemplate._fromRect(nativeRectangle);
    _setMatrix(template._content);
    template._writeTransformation = false;
    final _PaintParams paintParams = _PaintParams();
    final PdfGraphics graphics = template.graphics;
    final PdfPen mBorderPen = PdfPen(color, width: border.width.toDouble());
    if (border.borderStyle == PdfBorderStyle.dashed) {
      mBorderPen.dashStyle = PdfDashStyle.dash;
    } else if (border.borderStyle == PdfBorderStyle.dot) {
      mBorderPen.dashStyle = PdfDashStyle.dot;
    }
    paintParams._borderPen = mBorderPen;
    paintParams._foreBrush = PdfSolidBrush(color);
    final PdfFont mFont = PdfStandardFont(
        PdfFontFamily.helvetica, _isLoadedAnnotation ? 10 : 9,
        style: PdfFontStyle.regular);
    final PdfStringFormat format = PdfStringFormat();
    format.alignment = PdfTextAlignment.center;
    format.lineAlignment = PdfVerticalAlignment.middle;
    final double lineWidth = mFont.measureString(text, format: format).width;
    final List<int> linePoints = _obtainLinePoints();
    if (linePoints != null && linePoints.length == 4) {
      final double x1 = linePoints[0].toDouble();
      final double y1 = linePoints[1].toDouble();
      final double x2 = linePoints[2].toDouble();
      final double y2 = linePoints[3].toDouble();
      double angle = 0;
      if (x2 - x1 == 0) {
        if (y2 > y1) {
          angle = 90;
        } else {
          angle = 270;
        }
      } else {
        angle = _getAngle(x1, y1, x2, y2);
      }
      double leadLine = 0;
      double lineAngle = 0;
      if (leaderLine < 0) {
        leadLine = -leaderLine.toDouble();
        lineAngle = angle + 180;
      } else {
        leadLine = leaderLine.toDouble();
        lineAngle = angle;
      }
      final List<double> x1y1 = <double>[x1, y1];
      final List<double> x2y2 = <double>[x2, y2];
      final double line = leadLine +
          (_isLoadedAnnotation ? _obtainLeaderOffset().toDouble() : 0);
      final List<double> startingPoint =
          _getAxisValue(x1y1, lineAngle + 90, line);
      final List<double> endingPoint =
          _getAxisValue(x2y2, lineAngle + 90, line);
      final double lineDistance = sqrt(
          pow(endingPoint[0] - startingPoint[0], 2) +
              pow(endingPoint[1] - startingPoint[1], 2));
      final double centerWidth =
          lineDistance / 2 - ((lineWidth / 2) + border.width);
      final List<double> middlePoint1 =
          _getAxisValue(startingPoint, angle, centerWidth);
      final List<double> middlePoint2 =
          _getAxisValue(endingPoint, angle + 180, centerWidth);
      List<double> lineStartingPoint;
      List<double> lineEndingPoint;
      if (beginLineStyle == PdfLineEndingStyle.openArrow ||
          beginLineStyle == PdfLineEndingStyle.closedArrow) {
        lineStartingPoint =
            _getAxisValue(startingPoint, angle, border.width.toDouble());
      } else {
        lineStartingPoint = startingPoint;
      }
      if (endLineStyle == PdfLineEndingStyle.openArrow ||
          endLineStyle == PdfLineEndingStyle.closedArrow) {
        lineEndingPoint = _getAxisValue(endingPoint, angle, -border.width);
      } else {
        lineEndingPoint = endingPoint;
      }
      final String caption = _getEnumName(captionType);
      if (opacity < 1) {
        graphics.save();
        graphics.setTransparency(opacity);
      }
      if (text == null || text.isEmpty || caption == 'Top' || !lineCaption) {
        graphics.drawLine(
            mBorderPen,
            Offset(lineStartingPoint[0], -lineStartingPoint[1]),
            Offset(lineEndingPoint[0], -lineEndingPoint[1]));
      } else {
        graphics.drawLine(
            mBorderPen,
            Offset(lineStartingPoint[0], -lineStartingPoint[1]),
            Offset(middlePoint1[0], -middlePoint1[1]));
        graphics.drawLine(
            mBorderPen,
            Offset(lineEndingPoint[0], -lineEndingPoint[1]),
            Offset(middlePoint2[0], -middlePoint2[1]));
      }
      if (opacity < 1) {
        graphics.restore();
      }
      //Set begin and end line style.
      final PdfBrush backBrush = PdfSolidBrush(innerColor);
      final _PdfArray lineStyle = _PdfArray();
      lineStyle._insert(0, _PdfName(_getEnumName(beginLineStyle)));
      lineStyle._insert(1, _PdfName(_getEnumName(endLineStyle)));
      final double borderLength = border.width.toDouble();
      _setLineEndingStyles(startingPoint, endingPoint, graphics, angle,
          mBorderPen, backBrush, lineStyle, borderLength);
      //Set leader extension.
      final List<double> beginLineExt = _getAxisValue(
          startingPoint, lineAngle + 90, leaderLineExt.toDouble());
      graphics.drawLine(mBorderPen, Offset(startingPoint[0], -startingPoint[1]),
          Offset(beginLineExt[0], -beginLineExt[1]));
      final List<double> endLineExt =
          _getAxisValue(endingPoint, lineAngle + 90, leaderLineExt.toDouble());
      graphics.drawLine(mBorderPen, Offset(endingPoint[0], -endingPoint[1]),
          Offset(endLineExt[0], -endLineExt[1]));
      //Set leader line
      final List<double> beginLeaderLine =
          _getAxisValue(startingPoint, lineAngle - 90, leadLine.toDouble());
      graphics.drawLine(mBorderPen, Offset(startingPoint[0], -startingPoint[1]),
          Offset(beginLeaderLine[0], -beginLeaderLine[1]));
      final List<double> endLeaderLine =
          _getAxisValue(endingPoint, lineAngle - 90, leadLine.toDouble());
      graphics.drawLine(mBorderPen, Offset(endingPoint[0], -endingPoint[1]),
          Offset(endLeaderLine[0], -endLeaderLine[1]));
      //Set caption Type.
      if (lineCaption) {
        final double midpoint = lineDistance / 2;
        final List<double> centerPoint =
            _getAxisValue(startingPoint, angle, midpoint);
        final List<double> captionPosition =
            _getCaptionPosition(caption, centerPoint, angle, mFont);
        graphics.translateTransform(captionPosition[0], -captionPosition[1]);
        graphics.rotateTransform(-angle);
        graphics.drawString(text, mFont,
            brush: backBrush, bounds: Rect.fromLTWH(-lineWidth / 2, 0, 0, 0));
      }
    }
    if (_isLoadedAnnotation) {
      _dictionary.setProperty(_DictionaryProperties.rect,
          _PdfArray.fromRectangle(_obtainLineBounds()));
    }
    if (!_isLoadedAnnotation && flatten) {
      final double pageHeight = page.size.height;
      final PdfMargins margins = _obtainMargin();
      if (page != null) {
        bounds = Rect.fromLTWH(
            nativeRectangle.left - margins.left,
            pageHeight -
                (nativeRectangle.top + nativeRectangle.height) -
                margins.top,
            nativeRectangle.width,
            nativeRectangle.height);
      } else {
        bounds = Rect.fromLTWH(
            nativeRectangle.left,
            pageHeight - (nativeRectangle.top + nativeRectangle.height),
            nativeRectangle.width,
            nativeRectangle.height);
      }
    }
    return template;
  }

  List<double> _getCaptionPosition(
      String caption, List<double> centerPoint, double angle, PdfFont font) {
    List<double> captionPosition = List<double>(2);
    if (_isLoadedAnnotation) {
      final bool isContainsMeasure = _dictionary._items
          .containsKey(_PdfName(_DictionaryProperties.measure));
      final double length = caption == 'Top'
          ? isContainsMeasure ? 2 * font.height : font.height
          : isContainsMeasure ? 3 * (font.height / 2) : font.height / 2;
      captionPosition = _getAxisValue(centerPoint, angle + 90, length);
    } else {
      captionPosition = _getAxisValue(centerPoint, angle + 90,
          caption == 'Top' ? font.height : font.height / 2);
    }
    return captionPosition;
  }

  // Gets leader line of the annotation.
  int _obtainLeaderLine() {
    int lLine = 0;
    if (_dictionary.containsKey(_DictionaryProperties.ll)) {
      final _PdfNumber ll = _dictionary[_DictionaryProperties.ll] as _PdfNumber;
      lLine = ll.value.toInt();
    }
    return lLine;
  }

  // Gets the line intent of the annotation.
  PdfLineIntent _obtainLineIntent() {
    PdfLineIntent _lineintent = PdfLineIntent.lineArrow;
    if (_dictionary.containsKey(_DictionaryProperties.it)) {
      final _PdfName lineintent = _crossTable
          ._getObject(_dictionary[_DictionaryProperties.it]) as _PdfName;
      _lineintent = _getLineIntentText(lineintent._name.toString());
    }
    return _lineintent;
  }

  // Get the Line Intent Text.
  PdfLineIntent _getLineIntentText(String lintent) {
    PdfLineIntent lineintent = PdfLineIntent.lineArrow;
    switch (lintent) {
      case 'LineArrow':
        lineintent = PdfLineIntent.lineArrow;
        break;
      case 'LineDimension':
        lineintent = PdfLineIntent.lineDimension;
        break;
    }
    return lineintent;
  }

  // Gets line caption of the annotation.
  bool _obtainLineCaption() {
    bool lCaption = false;
    if (_dictionary.containsKey(_DictionaryProperties.cap)) {
      final _PdfBoolean lCap =
          _dictionary[_DictionaryProperties.cap] as _PdfBoolean;
      lCaption = lCap.value;
    }
    return lCaption;
  }

  // Gets leader ext of the annotation.
  int _obtainLeaderExt() {
    int lLineExt = 0;
    if (_dictionary.containsKey(_DictionaryProperties.lle)) {
      final _PdfNumber lExt =
          _dictionary[_DictionaryProperties.lle] as _PdfNumber;
      lLineExt = lExt.value.toInt();
    }
    return lLineExt;
  }

  // Gets line style of the annotation.
  PdfLineEndingStyle _getLineStyle(dynamic value) {
    PdfLineEndingStyle linestyle = PdfLineEndingStyle.none;
    if (value is int) {
      final _PdfArray array = _obtainLineStyle();
      if (array != null) {
        final _PdfName style = array[value] as _PdfName;
        linestyle = _getLineStyle(style._name);
      }
    } else if (value is String) {
      switch (value) {
        case 'Square':
          linestyle = PdfLineEndingStyle.square;
          break;
        case 'Circle':
          linestyle = PdfLineEndingStyle.circle;
          break;
        case 'Diamond':
          linestyle = PdfLineEndingStyle.diamond;
          break;
        case 'OpenArrow':
          linestyle = PdfLineEndingStyle.openArrow;
          break;
        case 'ClosedArrow':
          linestyle = PdfLineEndingStyle.closedArrow;
          break;
        case 'None':
          linestyle = PdfLineEndingStyle.none;
          break;
        case 'ROpenArrow':
          linestyle = PdfLineEndingStyle.rOpenArrow;
          break;
        case 'Butt':
          linestyle = PdfLineEndingStyle.butt;
          break;
        case 'RClosedArrow':
          linestyle = PdfLineEndingStyle.rClosedArrow;
          break;
        case 'Slash':
          linestyle = PdfLineEndingStyle.slash;
          break;
      }
    }
    return linestyle;
  }

  // Gets line style of the annotation.
  _PdfArray _obtainLineStyle() {
    _PdfArray array;
    if (_dictionary.containsKey(_DictionaryProperties.le)) {
      array = _crossTable._getObject(_dictionary[_DictionaryProperties.le])
          as _PdfArray;
    }
    return array;
  }

  // Gets caption type of the annotation.
  PdfLineCaptionType _obtainCaptionType() {
    PdfLineCaptionType _captiontype = PdfLineCaptionType.inline;
    if (_dictionary.containsKey(_DictionaryProperties.cp)) {
      final _PdfName cType = _dictionary[_DictionaryProperties.cp] as _PdfName;
      _captiontype = _getCaptionType(cType._name.toString());
    }
    return _captiontype;
  }

  // Gets caption type of the annotation.
  PdfLineCaptionType _getCaptionType(String cType) {
    PdfLineCaptionType captiontype = PdfLineCaptionType.inline;
    if (cType == 'Inline') {
      captiontype = PdfLineCaptionType.inline;
    } else {
      captiontype = PdfLineCaptionType.top;
    }
    return captiontype;
  }

  @override
  _IPdfPrimitive get _element => _dictionary;

  @override
  set _element(_IPdfPrimitive value) {
    _element = value;
  }
}
