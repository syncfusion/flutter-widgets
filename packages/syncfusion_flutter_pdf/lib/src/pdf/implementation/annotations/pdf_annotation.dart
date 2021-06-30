part of pdf;

/// Represents the base class for annotation objects.
abstract class PdfAnnotation implements _IPdfWrapper {
  // constructor
  PdfAnnotation._(
      {PdfPage? page,
      String? text,
      Rect? bounds,
      PdfAnnotationBorder? border,
      PdfColor? color,
      PdfColor? innerColor,
      String? author,
      double? opacity,
      String? subject,
      DateTime? modifiedDate,
      bool? setAppearance}) {
    _initialize();
    _initializeAnnotationProperties(page, text, bounds, border, color,
        innerColor, author, opacity, subject, modifiedDate, setAppearance);
  }

  PdfAnnotation._internal(
      _PdfDictionary dictionary, _PdfCrossTable crossTable) {
    _dictionary = dictionary;
    _crossTable = crossTable;
    _isLoadedAnnotation = true;
    _PdfName? name;
    if (dictionary.containsKey(_DictionaryProperties.subtype)) {
      name = dictionary._items![_PdfName(_DictionaryProperties.subtype)]
          as _PdfName?;
    }
    if (name != null) {
      if (name._name == _DictionaryProperties.circle ||
          name._name == _DictionaryProperties.square ||
          name._name == _DictionaryProperties.line ||
          name._name == _DictionaryProperties.polygon) {
        crossTable._document!._catalog._beginSave = _dictionaryBeginSave;
        crossTable._document!._catalog.modify();
      }
    }
  }

  // fields
  PdfPage? _page;
  String? _text = '';
  _PdfDictionary _dictionary = _PdfDictionary();
  _Rectangle _rectangle = _Rectangle.empty;
  PdfColor? _innerColor;
  PdfAnnotationBorder? _border;
  _PdfCrossTable? _cTable;
  bool _isLoadedAnnotation = false;
  PdfColor _color = PdfColor.empty;
  PdfMargins? _margins = PdfMargins();
  String? _author = '';
  String? _subject = '';
  DateTime? _modifiedDate;
  double _opacity = 1.0;
  PdfAppearance? _pdfAppearance;
  bool _saved = false;
  bool _isBounds = false;

  /// Gets or sets whether the annotation needs appearance.
  bool setAppearance = false;

  // properties
  /// Gets a page of the annotation. Read-Only.
  PdfPage? get page => _page;

  /// Gets annotation's bounds in the PDF page.
  Rect get bounds {
    if (!_isLoadedAnnotation) {
      return _rectangle.rect;
    } else {
      final _Rectangle rect = _getBounds(_dictionary, _crossTable);
      rect.y = page != null
          ? rect.y == 0 && rect.height == 0
              ? rect.y + rect.height
              : page!.size.height - (rect.y + rect.height)
          : rect.y - rect.height;
      return rect.rect;
    }
  }

  /// Sets annotation's bounds in the PDF page.
  set bounds(Rect value) {
    if (!_isLoadedAnnotation) {
      final _Rectangle rectangle = _Rectangle.fromRect(value);
      if (_rectangle != rectangle) {
        _rectangle = rectangle;
        _dictionary.setProperty(_PdfName(_DictionaryProperties.rect),
            _PdfArray.fromRectangle(rectangle));
      }
    } else {
      _isBounds = true;
      if (value.isEmpty) {
        throw ArgumentError('rectangle');
      }
      final double height = page!.size.height;
      final List<_PdfNumber> values = <_PdfNumber>[
        _PdfNumber(value.left),
        _PdfNumber(height - (value.top + value.height)),
        _PdfNumber(value.left + value.width),
        _PdfNumber(height - value.top)
      ];
      final _PdfDictionary dic = _dictionary;
      dic._setArray(_DictionaryProperties.rect, values);
    }
  }

  /// Gets annotation's border properties like width, horizontal radius etc.
  PdfAnnotationBorder get border {
    if (!_isLoadedAnnotation) {
      _border ??= PdfAnnotationBorder();
    } else {
      _border ??= _obtainBorder();
      if (!_isLineBorder()) {
        _dictionary.setProperty(_DictionaryProperties.border, _border);
      }
    }
    _border!._isLineBorder = _isLineBorder();
    return _border!;
  }

  /// Sets annotation's border properties like width, horizontal radius etc.
  set border(PdfAnnotationBorder value) {
    _border = value;
    if (_isLineBorder()) {
      _dictionary.setProperty(_PdfName(_DictionaryProperties.bs), border);
    } else {
      _dictionary.setProperty(_PdfName(_DictionaryProperties.border), _border);
    }
  }

  /// Gets content of the annotation.
  /// The string value specifies the text of the annotation.
  String get text {
    if (!_isLoadedAnnotation) {
      if (_dictionary.containsKey(_DictionaryProperties.contents)) {
        _text =
            (_dictionary[_DictionaryProperties.contents]! as _PdfString).value;
      }
      return _text!;
    } else {
      return _text == null || _text!.isEmpty ? _obtainText()! : _text!;
    }
  }

  /// Sets content of the annotation.
  /// The string value specifies the text of the annotation.
  set text(String value) {
    if (_text != value) {
      _text = value;
      _dictionary._setString(_DictionaryProperties.contents, _text);
    }
  }

  _PdfCrossTable get _crossTable => _cTable!;

  set _crossTable(_PdfCrossTable value) {
    if (value != _cTable) {
      _cTable = value;
    }
  }

  /// Gets the annotation color.
  PdfColor get color => _isLoadedAnnotation ? _obtainColor() : _color;

  /// Sets the annotation color.
  set color(PdfColor value) {
    if (_color != value) {
      _color = value;
      PdfColorSpace? cs = PdfColorSpace.rgb;
      if (page != null && !page!._isLoadedPage) {
        cs = page!._section!._parent!._document!.colorSpace;
      }
      final _PdfArray colours = _color._toArray(cs);
      _dictionary.setProperty(_DictionaryProperties.c, colours);
    }
  }

  /// Gets the inner color of the annotation.
  PdfColor get innerColor {
    if (!_isLoadedAnnotation) {
      _innerColor ??= PdfColor(0, 0, 0, 0);
    } else {
      _innerColor = _obtainInnerColor();
    }
    return _innerColor!;
  }

  /// Sets the inner color of the annotation.
  set innerColor(PdfColor value) {
    _innerColor = value;
    if (_isLoadedAnnotation) {
      if (_innerColor!._alpha != 0) {
        _dictionary.setProperty(
            _DictionaryProperties.iC, _innerColor!._toArray(PdfColorSpace.rgb));
      } else if (_dictionary.containsKey(_DictionaryProperties.iC)) {
        _dictionary.remove(_DictionaryProperties.iC);
      }
    }
  }

  /// Gets the author of the annotation.
  String get author {
    if (!_isLoadedAnnotation) {
      if (_dictionary.containsKey(_DictionaryProperties.author)) {
        _author =
            (_dictionary[_DictionaryProperties.author]! as _PdfString).value;
      } else if (_dictionary.containsKey(_DictionaryProperties.t)) {
        _author = (_dictionary[_DictionaryProperties.t]! as _PdfString).value;
      }
    } else {
      _author = _obtainAuthor();
    }
    return _author!;
  }

  /// Sets the author of the annotation.
  set author(String value) {
    if (_author != value) {
      _author = value;
      _dictionary._setString(_DictionaryProperties.t, _author);
    }
  }

  /// Gets the subject of the annotation.
  String get subject {
    if (_isLoadedAnnotation) {
      _subject = _obtainSubject();
    } else {
      if (_dictionary.containsKey(_DictionaryProperties.subject)) {
        _subject =
            (_dictionary[_DictionaryProperties.subject]! as _PdfString).value;
      } else if (_dictionary.containsKey(_DictionaryProperties.subj)) {
        _subject =
            (_dictionary[_DictionaryProperties.subj]! as _PdfString).value;
      }
    }
    return _subject!;
  }

  /// Sets the subject of the annotation.
  set subject(String value) {
    if (subject != value) {
      _subject = value;
      _dictionary._setString(_DictionaryProperties.subj, _subject);
    }
  }

  /// Gets the ModifiedDate of the annotation.
  DateTime? get modifiedDate =>
      _isLoadedAnnotation ? _obtainModifiedDate() : _modifiedDate;

  /// Sets the ModifiedDate of the annotation.
  set modifiedDate(DateTime? value) {
    if (_modifiedDate != value) {
      _modifiedDate = value;
      _dictionary._setDateTime(_DictionaryProperties.m, _modifiedDate!);
    }
  }

  ///Gets or sets the boolean flag to flatten the annotation,
  ///by default, its become false.
  bool _flatten = false;

  /// Gets or sets flatten annotations popup.
  // ignore: prefer_final_fields
  bool _flattenPopups = false;

  /// Gets the opacity of the annotation.
  double get opacity {
    if (_isLoadedAnnotation) {
      return _obtainOpacity()!;
    }
    if (_dictionary._items!.containsKey(_PdfName('CA'))) {
      final _PdfNumber ca = _dictionary._items![_PdfName('CA')]! as _PdfNumber;
      _opacity = ca.value!.toDouble();
    }
    return _opacity;
  }

  /// Sets the opacity of the annotation.
  ///
  /// Opacity value should be between 0 to 1.
  set opacity(double value) {
    if (value < 0 || value > 1) {
      throw ArgumentError.value('Valid value should be between 0 to 1.');
    }
    if (_opacity != value) {
      _opacity = value;
      _dictionary.setProperty(_DictionaryProperties.ca, _PdfNumber(_opacity));
    }
  }

  /// Gets appearance of the annotation.
  PdfAppearance get appearance {
    _pdfAppearance ??= PdfAppearance(this);
    return _pdfAppearance!;
  }

  /// Sets appearance of the annotation.
  set appearance(PdfAppearance value) {
    _pdfAppearance = value;
  }

  //Public methods
  /// Flatten the annotation.
  ///
  /// The flatten will add at the time of saving the current document.
  void flatten() {
    _flatten = true;
  }

  // implementation
  bool _isLineBorder() {
    if (this is PdfRectangleAnnotation ||
        this is PdfPolygonAnnotation ||
        this is PdfEllipseAnnotation ||
        this is PdfLineAnnotation) {
      return true;
    } else {
      return false;
    }
  }

  void _initialize() {
    _dictionary._beginSave = _dictionaryBeginSave;
    _dictionary.setProperty(_PdfName(_DictionaryProperties.type),
        _PdfName(_DictionaryProperties.annot));
  }

  void _initializeAnnotationProperties(
      PdfPage? page,
      String? annotText,
      Rect? bounds,
      PdfAnnotationBorder? border,
      PdfColor? color,
      PdfColor? innerColor,
      String? author,
      double? opacity,
      String? subject,
      DateTime? modifiedDate,
      bool? setAppearance) {
    if (page != null) {
      _page = page;
    }
    if (bounds != null) {
      this.bounds = bounds;
    }
    if (annotText != null) {
      text = annotText;
      _dictionary.setProperty(
          _PdfName(_DictionaryProperties.contents), _PdfString(text));
    }
    if (border != null) {
      this.border = border;
    }
    if (color != null) {
      this.color = color;
    }
    if (innerColor != null) {
      this.innerColor = innerColor;
    }
    if (author != null) {
      this.author = author;
    }
    if (opacity != null) {
      this.opacity = opacity;
    }
    if (subject != null) {
      this.subject = subject;
    }
    if (modifiedDate != null) {
      this.modifiedDate = modifiedDate;
    }
    if (setAppearance != null) {
      this.setAppearance = setAppearance;
    }
  }

  void _dictionaryBeginSave(Object sender, _SavePdfPrimitiveArgs? ars) {
    if (_isContainsAnnotation()) {
      if (!_saved) {
        _save();
        _saved = true;
      }
    }
  }

  bool _isContainsAnnotation() {
    bool contains = false;
    _PdfArray? annotation;
    if (page != null &&
        page!._dictionary.containsKey(_DictionaryProperties.annots)) {
      annotation = _PdfCrossTable._dereference(
          page!._dictionary[_DictionaryProperties.annots]) as _PdfArray?;
      if (annotation != null &&
          annotation._elements.isNotEmpty &&
          annotation._contains(annotation._elements[0]!)) {
        contains = true;
      }
    }
    return contains;
  }

  void _save() {
    if (_page!._document != null &&
        _page!._document!._conformanceLevel != PdfConformanceLevel.none) {
      if (this is PdfActionAnnotation &&
          _page!._document!._conformanceLevel == PdfConformanceLevel.a1b) {
        throw ArgumentError(
            'The specified annotation type is not supported by PDF/A1-B or PDF/A1-A standard documents.');
      }
      //This is needed to attain specific PDF/A conformance.
      if (this is! PdfLinkAnnotation &&
          !setAppearance &&
          (_page!._document!._conformanceLevel == PdfConformanceLevel.a2b ||
              _page!._document!._conformanceLevel == PdfConformanceLevel.a3b)) {
        throw ArgumentError(
            'The appearance dictionary doesn\'t contain an entry. Enable setAppearance in PdfAnnotation class to overcome this error.');
      }
      _dictionary._setNumber(_DictionaryProperties.f, 4);
    }
    if (_border != null) {
      if (_isLineBorder()) {
        _dictionary.setProperty(_DictionaryProperties.bs, border);
      } else {
        _dictionary.setProperty(_PdfName(_DictionaryProperties.border), border);
      }
    }
    final _Rectangle nativeRectangle = _obtainNativeRectangle();
    if (_innerColor != null &&
        !_innerColor!.isEmpty &&
        _innerColor!._alpha != 0.0) {
      _dictionary.setProperty(_PdfName(_DictionaryProperties.ic),
          _innerColor!._toArray(PdfColorSpace.rgb));
    }
    _dictionary.setProperty(_PdfName(_DictionaryProperties.rect),
        _PdfArray.fromRectangle(nativeRectangle));
  }

  _Rectangle _obtainNativeRectangle() {
    final _Rectangle nativeRectangle =
        _Rectangle(bounds.left, bounds.bottom, bounds.width, bounds.height);
    Size? size;
    _PdfArray? cropOrMediaBox;
    if (_page != null) {
      if (!_page!._isLoadedPage) {
        final PdfSection section = _page!._section!;
        nativeRectangle.location =
            section._pointToNativePdf(page!, nativeRectangle.location);
      } else {
        size = _page!.size;
        nativeRectangle.y = size.height - _rectangle.bottom;
      }
      cropOrMediaBox = _getCropOrMediaBox(_page!, cropOrMediaBox);
    }
    if (cropOrMediaBox != null) {
      if (cropOrMediaBox.count > 2) {
        if ((cropOrMediaBox[0]! as _PdfNumber).value != 0 ||
            (cropOrMediaBox[1]! as _PdfNumber).value != 0) {
          nativeRectangle.x = nativeRectangle.x +
              (cropOrMediaBox[0]! as _PdfNumber).value!.toDouble();
          nativeRectangle.y = nativeRectangle.y +
              (cropOrMediaBox[1]! as _PdfNumber).value!.toDouble();
        }
      }
    }
    return nativeRectangle;
  }

  _PdfArray? _getCropOrMediaBox(PdfPage page, _PdfArray? cropOrMediaBox) {
    if (page._dictionary.containsKey(_DictionaryProperties.cropBox)) {
      cropOrMediaBox = _PdfCrossTable._dereference(
          page._dictionary[_DictionaryProperties.cropBox]) as _PdfArray?;
    } else if (page._dictionary.containsKey(_DictionaryProperties.mediaBox)) {
      cropOrMediaBox = _PdfCrossTable._dereference(
          page._dictionary[_DictionaryProperties.mediaBox]) as _PdfArray?;
    }
    return cropOrMediaBox;
  }

  void _setPage(PdfPage page) {
    _page = page;
    if (!page._isLoadedPage) {
      if (_page!._document != null) {
        _page!._document!._catalog._beginSaveList ??=
            <_SavePdfPrimitiveCallback>[];
        final PdfGraphics graphics =
            page.graphics; //Accessed for creating page content.
        ArgumentError.checkNotNull(graphics);
        if (_dictionary.containsKey(_DictionaryProperties.subtype)) {
          final _PdfName? name = _dictionary
              ._items![_PdfName(_DictionaryProperties.subtype)] as _PdfName?;
          if (name != null) {
            if (name._name == _DictionaryProperties.text ||
                name._name == _DictionaryProperties.square ||
                _flatten) {
              _page!._document!._catalog._beginSaveList!
                  .add(_dictionaryBeginSave);
              _page!._document!._catalog.modify();
            }
          }
        } else if (_flatten) {
          _page!._document!._catalog._beginSaveList!.add(_dictionaryBeginSave);
          _page!._document!._catalog.modify();
        }
      }
    } else {
      if (_dictionary.containsKey(_DictionaryProperties.subtype)) {
        final _PdfName? name = _dictionary
            ._items![_PdfName(_DictionaryProperties.subtype)] as _PdfName?;
        _page!._document!._catalog._beginSaveList ??=
            <_SavePdfPrimitiveCallback>[];
        if (name != null) {
          if (name._name == _DictionaryProperties.circle ||
              name._name == _DictionaryProperties.square ||
              name._name == _DictionaryProperties.line ||
              name._name == _DictionaryProperties.polygon) {
            _page!._document!._catalog._beginSaveList!
                .add(_dictionaryBeginSave);
            _page!._document!._catalog.modify();
          }
        }
      } else if (_flatten) {
        _page!._document!._catalog._beginSaveList!.add(_dictionaryBeginSave);
        _page!._document!._catalog.modify();
      }
    }
    if (_page != null && !_page!._isLoadedPage) {
      _dictionary.setProperty(
          _PdfName(_DictionaryProperties.p), _PdfReferenceHolder(_page));
    }
  }

  /// Gets the bounds.
  _Rectangle _getBounds(_PdfDictionary dictionary, _PdfCrossTable crossTable) {
    _PdfArray? array;
    if (dictionary.containsKey(_DictionaryProperties.rect)) {
      array = crossTable._getObject(dictionary[_DictionaryProperties.rect])
          as _PdfArray?;
    }
    return array!.toRectangle();
  }

  // Gets the border.
  PdfAnnotationBorder _obtainBorder() {
    final PdfAnnotationBorder border = PdfAnnotationBorder();
    if (_dictionary.containsKey(_DictionaryProperties.border)) {
      final _PdfArray? borderArray =
          _PdfCrossTable._dereference(_dictionary[_DictionaryProperties.border])
              as _PdfArray?;
      if (borderArray != null && borderArray.count >= 2) {
        if (borderArray[0] is _PdfNumber &&
            borderArray[1] is _PdfNumber &&
            borderArray[2] is _PdfNumber) {
          final double width =
              (borderArray[0]! as _PdfNumber).value!.toDouble();
          final double hRadius =
              (borderArray[1]! as _PdfNumber).value!.toDouble();
          final double vRadius =
              (borderArray[2]! as _PdfNumber).value!.toDouble();
          border.width = vRadius;
          border.horizontalRadius = width;
          border.verticalRadius = hRadius;
        }
      }
    } else if (_dictionary.containsKey(_DictionaryProperties.bs)) {
      final _PdfDictionary lbDic = _crossTable
          ._getObject(_dictionary[_DictionaryProperties.bs])! as _PdfDictionary;
      if (lbDic.containsKey(_DictionaryProperties.w)) {
        final _PdfNumber? value = lbDic[_DictionaryProperties.w] as _PdfNumber?;
        if (value != null) {
          border.width = value.value!.toDouble();
        }
      }
      if (lbDic.containsKey(_DictionaryProperties.s)) {
        final _PdfName bstr =
            _PdfCrossTable._dereference(lbDic[_DictionaryProperties.s])!
                as _PdfName;
        border.borderStyle = _getBorderStyle(bstr._name.toString());
      }
      if (lbDic.containsKey(_DictionaryProperties.d)) {
        final _PdfArray? _dasharray =
            _PdfCrossTable._dereference(lbDic[_DictionaryProperties.d])
                as _PdfArray?;
        if (_dasharray != null) {
          final _PdfNumber dashArray = _dasharray[0]! as _PdfNumber;
          final int _dashArray = dashArray.value!.toInt();
          _dasharray._clear();
          _dasharray._insert(0, _PdfNumber(_dashArray));
          _dasharray._insert(1, _PdfNumber(_dashArray));
          border.dashArray = _dashArray;
        }
      }
    }
    return border;
  }

  // Gets the text.
  String? _obtainText() {
    String tempText;
    if (_dictionary.containsKey(_DictionaryProperties.contents)) {
      final _PdfString? mText = _PdfCrossTable._dereference(
          _dictionary[_DictionaryProperties.contents]) as _PdfString?;
      if (mText != null) {
        _text = mText.value.toString();
      }
      return _text;
    } else {
      tempText = '';
      return tempText;
    }
  }

  // Gets the color.
  PdfColor _obtainColor() {
    PdfColor color = PdfColor.empty;
    _PdfArray? colours;
    if (_dictionary.containsKey(_DictionaryProperties.c)) {
      colours = _dictionary[_DictionaryProperties.c] as _PdfArray?;
    }
    if (colours != null && colours._elements.length == 1) {
      //Convert the float color values into bytes
      final _PdfNumber? color0 =
          _crossTable._getObject(colours[0]) as _PdfNumber?;
      if (color0 != null) {
        color = PdfColor._fromGray(color0.value! as double);
      }
    } else if (colours != null && colours._elements.length == 3) {
      final _PdfNumber color0 = colours[0]! as _PdfNumber;
      final _PdfNumber color1 = colours[1]! as _PdfNumber;
      final _PdfNumber color2 = colours[2]! as _PdfNumber;
      //Convert the float color values into bytes
      final int red = (color0.value! * 255).round().toUnsigned(8).toInt();
      final int green = (color1.value! * 255).round().toUnsigned(8).toInt();
      final int blue = (color2.value! * 255).round().toUnsigned(8).toInt();
      color = PdfColor(red, green, blue);
    } else if (colours != null && colours._elements.length == 4) {
      final _PdfNumber? color0 =
          _crossTable._getObject(colours[0]) as _PdfNumber?;
      final _PdfNumber? color1 =
          _crossTable._getObject(colours[1]) as _PdfNumber?;
      final _PdfNumber? color2 =
          _crossTable._getObject(colours[2]) as _PdfNumber?;
      final _PdfNumber? color3 =
          _crossTable._getObject(colours[3]) as _PdfNumber?;
      if (color0 != null &&
          color1 != null &&
          color2 != null &&
          color3 != null) {
        //Convert the float color values into bytes
        final double cyan = color0.value! as double;
        final double magenta = color1.value! as double;
        final double yellow = color2.value! as double;
        final double black = color3.value! as double;
        color = PdfColor.fromCMYK(cyan, magenta, yellow, black);
      }
    }
    return color;
  }

  // Gets the Opacity.
  double? _obtainOpacity() {
    if (_dictionary.containsKey(_DictionaryProperties.ca)) {
      _opacity = _getNumber(_DictionaryProperties.ca)!;
    }
    return _opacity;
  }

  // Gets the number value.
  double? _getNumber(String keyName) {
    double? result = 0;
    final _PdfNumber? numb = _dictionary[keyName] as _PdfNumber?;
    if (numb != null) {
      result = numb.value as double?;
    }
    return result;
  }

  // Gets the Author.
  String? _obtainAuthor() {
    String? author;
    if (_dictionary.containsKey(_DictionaryProperties.author)) {
      final _PdfString? _author =
          _PdfCrossTable._dereference(_dictionary[_DictionaryProperties.author])
              as _PdfString?;
      if (_author != null) {
        author = _author.value;
      }
    } else if (_dictionary.containsKey(_DictionaryProperties.t)) {
      final _PdfString? _author =
          _PdfCrossTable._dereference(_dictionary[_DictionaryProperties.t])
              as _PdfString?;
      if (_author != null) {
        author = _author.value;
      }
    }
    return author;
  }

  // Gets the Subject.
  String? _obtainSubject() {
    String? subject;
    if (_dictionary.containsKey(_DictionaryProperties.subject)) {
      final _PdfString? _subject = _PdfCrossTable._dereference(
          _dictionary[_DictionaryProperties.subject]) as _PdfString?;
      if (_subject != null) {
        subject = _subject.value;
      }
    } else if (_dictionary.containsKey(_DictionaryProperties.subj)) {
      final _PdfString? _subject =
          _PdfCrossTable._dereference(_dictionary[_DictionaryProperties.subj])
              as _PdfString?;
      if (_subject != null) {
        subject = _subject.value;
      }
    }
    return subject;
  }

  // Gets the ModifiedDate.
  DateTime? _obtainModifiedDate() {
    if (_dictionary.containsKey(_DictionaryProperties.modificationDate) ||
        _dictionary.containsKey(_DictionaryProperties.m)) {
      _PdfString? modifiedDate =
          _dictionary[_DictionaryProperties.modificationDate] as _PdfString?;
      modifiedDate ??= _dictionary[_DictionaryProperties.m] as _PdfString?;
      _modifiedDate = _dictionary._getDateTime(modifiedDate!);
    }
    return _modifiedDate;
  }

  String _getEnumName(dynamic annotText) {
    final int index = annotText.toString().indexOf('.');
    final String name = annotText.toString().substring(index + 1);
    return name[0].toUpperCase() + name.substring(1);
  }

  //Get the inner line color
  PdfColor _obtainInnerColor() {
    PdfColor color = PdfColor.empty;
    _PdfArray? colours;
    if (_dictionary.containsKey(_DictionaryProperties.iC)) {
      colours =
          _PdfCrossTable._dereference(_dictionary[_DictionaryProperties.iC])
              as _PdfArray?;
      if (colours != null && colours.count > 0) {
        final int red =
            ((colours[0]! as _PdfNumber).value! * 255).round().toUnsigned(8);
        final int green =
            ((colours[1]! as _PdfNumber).value! * 255).round().toUnsigned(8);
        final int blue =
            ((colours[2]! as _PdfNumber).value! * 255).round().toUnsigned(8);
        color = PdfColor(red, green, blue);
      }
    }
    return color;
  }

  PdfMargins? _obtainMargin() {
    if (page != null && page!._section != null) {
      _margins = page!._section!.pageSettings.margins;
    }
    return _margins;
  }

  void _flattenPopup() {
    if (page != null && !_isLoadedAnnotation) {
      _flattenAnnotationPopups(
          page!, color, bounds, border, author, subject, text);
    }
  }

  void _flattenAnnotationPopups(PdfPage page, PdfColor color, Rect annotBounds,
      PdfAnnotationBorder border, String author, String subject, String text) {
    final Size clientSize =
        page._isLoadedPage ? page.size : page.getClientSize();
    final double x = clientSize.width - 180;
    final double y = (annotBounds.top + 142) < clientSize.height
        ? annotBounds.top
        : clientSize.height - 142;
    Rect bounds = Rect.fromLTWH(x, y, 180, 142);
    // Draw annotation based on bounds
    if (_dictionary[_DictionaryProperties.popup] != null) {
      final _IPdfPrimitive? obj = _dictionary[_DictionaryProperties.popup];
      final _PdfDictionary? dictionary =
          _PdfCrossTable._dereference(obj) as _PdfDictionary?;
      if (dictionary != null) {
        final _PdfArray? rectValue =
            _PdfCrossTable._dereference(dictionary[_DictionaryProperties.rect])
                as _PdfArray?;
        final _PdfCrossTable? crosstable = page._crossTable;
        if (rectValue != null) {
          final _PdfNumber left =
              crosstable!._getReference(rectValue[0]) as _PdfNumber;
          final _PdfNumber top =
              crosstable._getReference(rectValue[1]) as _PdfNumber;
          final _PdfNumber width =
              crosstable._getReference(rectValue[2]) as _PdfNumber;
          final _PdfNumber height =
              crosstable._getReference(rectValue[3]) as _PdfNumber;
          bounds = Rect.fromLTWH(
              left.value! as double,
              top.value! as double,
              width.value! - (left.value! as double),
              height.value! - (top.value! as double));
        }
      }
    }
    final PdfBrush backBrush = PdfSolidBrush(color);
    final double borderWidth = border.width / 2;
    double? trackingHeight = 0;
    final PdfBrush aBrush = PdfSolidBrush(_getForeColor(color));
    if (author != '') {
      final Map<String, double?> returnedValue = _drawAuthor(author, subject,
          bounds, backBrush, aBrush, page, trackingHeight, border);
      trackingHeight = returnedValue['height'];
    } else if (subject != '') {
      final Rect titleRect = Rect.fromLTWH(bounds.left + borderWidth,
          bounds.top + borderWidth, bounds.width - border.width, 40);
      _saveGraphics(page, PdfBlendMode.hardLight);
      page.graphics.drawRectangle(
          pen: PdfPens.black, brush: backBrush, bounds: titleRect);
      page.graphics.restore();
      Rect contentRect = Rect.fromLTWH(titleRect.left + 11, titleRect.top,
          titleRect.width, titleRect.height / 2);
      contentRect = Rect.fromLTWH(
          contentRect.left,
          contentRect.top + contentRect.height - 2,
          contentRect.width,
          titleRect.height / 2);
      _saveGraphics(page, PdfBlendMode.normal);
      _drawSubject(this.subject, contentRect, page);
      page.graphics.restore();
      trackingHeight = 40;
    } else {
      _saveGraphics(page, PdfBlendMode.hardLight);
      final Rect titleRect = Rect.fromLTWH(bounds.left + borderWidth,
          bounds.top + borderWidth, bounds.width - border.width, 20);
      page.graphics.drawRectangle(
          pen: PdfPens.black, brush: backBrush, bounds: titleRect);
      trackingHeight = 20;
      page.graphics.restore();
    }
    Rect cRect = Rect.fromLTWH(
        bounds.left + borderWidth,
        bounds.top + borderWidth + trackingHeight!,
        bounds.width - border.width,
        bounds.height - (trackingHeight + border.width));
    _saveGraphics(page, PdfBlendMode.hardLight);
    page.graphics.drawRectangle(
        pen: PdfPens.black, brush: PdfBrushes.white, bounds: cRect);
    cRect = Rect.fromLTWH(
        cRect.left + 11, cRect.top + 5, cRect.width - 22, cRect.height);
    page.graphics.restore();
    _saveGraphics(page, PdfBlendMode.normal);
    page.graphics.drawString(
        text, PdfStandardFont(PdfFontFamily.helvetica, 10.5),
        brush: PdfBrushes.black, bounds: cRect);
    page.graphics.restore();
  }

  void _drawSubject(String subject, Rect bounds, PdfPage page) {
    page.graphics.drawString(
        subject,
        PdfStandardFont(PdfFontFamily.helvetica, 10.5,
            style: PdfFontStyle.bold),
        brush: PdfBrushes.black,
        bounds: bounds,
        format: PdfStringFormat(
            alignment: PdfTextAlignment.left,
            lineAlignment: PdfVerticalAlignment.middle));
  }

  void _saveGraphics(PdfPage page, PdfBlendMode mode) {
    page.graphics.save();
    page.graphics._setTransparency(0.8, 8.0, mode);
  }

  PdfColor _getForeColor(PdfColor c) {
    return (((c.r + c.b + c.g) / 3) > 128)
        ? PdfColor(0, 0, 0, 255)
        : PdfColor(255, 255, 255, 255);
  }

  Map<String, double?> _drawAuthor(
      String author,
      String subject,
      Rect bounds,
      PdfBrush backBrush,
      PdfBrush aBrush,
      PdfPage page,
      double? trackingHeight,
      PdfAnnotationBorder border) {
    final double borderWidth = border.width / 2;
    final _Rectangle titleRect = _Rectangle.fromRect(Rect.fromLTWH(
        bounds.left + borderWidth,
        bounds.top + borderWidth,
        bounds.width - border.width,
        20));
    if (subject != '') {
      titleRect.height += 20;
      trackingHeight = titleRect.height;
      _saveGraphics(page, PdfBlendMode.hardLight);
      page.graphics.drawRectangle(
          pen: PdfPens.black, brush: backBrush, bounds: titleRect.rect);
      page.graphics.restore();
      Rect contentRect = Rect.fromLTWH(
          titleRect.x + 11, titleRect.y, titleRect.width, titleRect.height / 2);
      _saveGraphics(page, PdfBlendMode.normal);
      page.graphics.drawString(
          author,
          PdfStandardFont(PdfFontFamily.helvetica, 10.5,
              style: PdfFontStyle.bold),
          brush: aBrush,
          bounds: contentRect,
          format: PdfStringFormat(
              alignment: PdfTextAlignment.left,
              lineAlignment: PdfVerticalAlignment.middle));
      contentRect = Rect.fromLTWH(
          contentRect.left,
          contentRect.top + contentRect.height - 2,
          contentRect.width,
          titleRect.height / 2);
      _drawSubject(subject, contentRect, page);
      page.graphics.restore();
    } else {
      _saveGraphics(page, PdfBlendMode.hardLight);
      page.graphics.drawRectangle(
          pen: PdfPens.black, brush: backBrush, bounds: titleRect.rect);
      page.graphics.restore();
      final Rect contentRect = Rect.fromLTWH(
          titleRect.x + 11, titleRect.y, titleRect.width, titleRect.height);
      _saveGraphics(page, PdfBlendMode.normal);
      page.graphics.drawString(
          author, PdfStandardFont(PdfFontFamily.helvetica, 10.5),
          brush: aBrush,
          bounds: contentRect,
          format: PdfStringFormat(
              alignment: PdfTextAlignment.left,
              lineAlignment: PdfVerticalAlignment.middle));
      trackingHeight = titleRect.height;
      page.graphics.restore();
    }
    return <String, double?>{'height': trackingHeight};
  }

  Rect _calculateTemplateBounds(
      Rect bounds, PdfPage? page, PdfTemplate? template, bool isNormalMatrix) {
    double x = bounds.left,
        y = bounds.top,
        width = bounds.width,
        height = bounds.height;
    if (page != null) {
      final int graphicsRotation =
          _obtainGraphicsRotation(page.graphics._matrix);
      if (page is PdfPage) {
        if (graphicsRotation == 0 && !isNormalMatrix) {
          x = bounds.left;
          y = bounds.top + bounds.height - bounds.width;
          width = bounds.height;
          height = bounds.width;
        }
      }
    }
    return Rect.fromLTWH(x, y, width, height);
  }

  int _obtainGraphicsRotation(_PdfTransformationMatrix matrix) {
    int angle = 0;
    final double radians =
        atan2(matrix._matrix._elements[2], matrix._matrix._elements[0]);
    angle = (radians * 180 / pi).round();
    switch (angle) {
      case -90:
        angle = 90;
        break;
      case -180:
        angle = 180;
        break;
      case 90:
        angle = 270;
        break;
    }
    return angle;
  }

  void _setMatrix(_PdfDictionary template) {
    final _PdfArray? bbox = template[_DictionaryProperties.bBox] as _PdfArray?;
    if (bbox != null) {
      final List<double> elements = <double>[
        1,
        0,
        0,
        1,
        -(bbox[0]! as _PdfNumber).value! as double,
        -(bbox[1]! as _PdfNumber).value! as double
      ];
      template[_DictionaryProperties.matrix] = _PdfArray(elements);
    }
  }

  PdfBorderStyle _getBorderStyle(String bstyle) {
    PdfBorderStyle style = PdfBorderStyle.solid;
    switch (bstyle) {
      case 'S':
        style = PdfBorderStyle.solid;
        break;
      case 'D':
        style = PdfBorderStyle.dashed;
        break;
      case 'B':
        style = PdfBorderStyle.beveled;
        break;
      case 'I':
        style = PdfBorderStyle.inset;
        break;
      case 'U':
        style = PdfBorderStyle.underline;
        break;
    }
    return style;
  }

  _Rectangle _calculateLineBounds(
      List<int> linePoints,
      int _leaderLineExt,
      int _leaderLine,
      int leaderOffset,
      _PdfArray lineStyle,
      double borderLength) {
    _Rectangle bounds = _Rectangle.fromRect(this.bounds);
    final PdfPath path = PdfPath();
    if (linePoints.length == 4) {
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
      int leaderLine = 0;
      double lineAngle = 0;
      if (_leaderLine < 0) {
        leaderLine = _leaderLine * -1;
        lineAngle = angle + 180;
      } else {
        leaderLine = _leaderLine;
        lineAngle = angle;
      }
      final List<double> x1y1 = <double>[x1, y1];
      final List<double> x2y2 = <double>[x2, y2];
      if (leaderOffset != 0) {
        final List<double> offsetPoint1 =
            _getAxisValue(x1y1, lineAngle + 90, leaderOffset.toDouble());
        final List<double> offsetPoint2 =
            _getAxisValue(x2y2, lineAngle + 90, leaderOffset.toDouble());
        linePoints[0] = offsetPoint1[0].toInt();
        linePoints[1] = offsetPoint1[1].toInt();
        linePoints[2] = offsetPoint2[0].toInt();
        linePoints[3] = offsetPoint2[1].toInt();
      }

      final List<double> startingPoint = _getAxisValue(
          x1y1, lineAngle + 90, (leaderLine + leaderOffset).toDouble());
      final List<double> endingPoint = _getAxisValue(
          x2y2, lineAngle + 90, (leaderLine + leaderOffset).toDouble());

      final List<double> beginLineLeader = _getAxisValue(x1y1, lineAngle + 90,
          (_leaderLineExt + leaderLine + leaderOffset).toDouble());

      final List<double> endLineLeader = _getAxisValue(x2y2, lineAngle + 90,
          (_leaderLineExt + leaderLine + leaderOffset).toDouble());

      final List<_Point> stylePoint = <_Point>[];

      for (int i = 0; i < lineStyle.count; i++) {
        final _PdfName lineEndingStyle = lineStyle[i]! as _PdfName;
        final _Point point = _Point.empty;
        switch (_getEnumName(lineEndingStyle._name)) {
          case 'Square':
          case 'Circle':
          case 'Diamond':
            {
              point.x = 3;
              point.y = 3;
            }
            break;
          case 'OpenArrow':
          case 'ClosedArrow':
            {
              point.x = 1;
              point.y = 5;
            }
            break;
          case 'ROpenArrow':
          case 'RClosedArrow':
            {
              point.x = 9 + (borderLength / 2);
              point.y = 5 + (borderLength / 2);
            }
            break;
          case 'Slash':
            {
              point.x = 5;
              point.y = 9;
            }
            break;
          case 'Butt':
            {
              point.x = 1;
              point.y = 3;
            }
            break;
          default:
            {
              point.x = 0;
              point.y = 0;
            }
            break;
        }
        stylePoint.add(point);
      }
      final List<double> widthX = List<double>.filled(2, 0);
      final List<double> heightY = List<double>.filled(2, 0);

      if ((lineAngle >= 45 && lineAngle <= 135) ||
          (lineAngle >= 225 && lineAngle <= 315)) {
        widthX[0] = stylePoint[0].y;
        heightY[0] = stylePoint[0].x;
        widthX[1] = stylePoint[1].y;
        heightY[1] = stylePoint[1].x;
      } else {
        widthX[0] = stylePoint[0].x;
        heightY[0] = stylePoint[0].y;
        widthX[1] = stylePoint[1].x;
        heightY[1] = stylePoint[1].y;
      }

      final double height = max(heightY[0], heightY[1]);
      if (startingPoint[0] ==
          <double>[startingPoint[0], endingPoint[0]].reduce(min)) {
        startingPoint[0] -= widthX[0] * borderLength;
        endingPoint[0] += widthX[1] * borderLength;
        startingPoint[0] =
            <double>[startingPoint[0], linePoints[0].toDouble()].reduce(min);
        startingPoint[0] = min(startingPoint[0], beginLineLeader[0]);
        endingPoint[0] = max(endingPoint[0], linePoints[2].toDouble());
        endingPoint[0] = max(endingPoint[0], endLineLeader[0]);
      } else {
        startingPoint[0] += widthX[0] * borderLength;
        endingPoint[0] -= widthX[1] * borderLength;
        startingPoint[0] = max(startingPoint[0], linePoints[0].toDouble());
        startingPoint[0] = max(startingPoint[0], beginLineLeader[0]);
        endingPoint[0] = min(endingPoint[0], linePoints[2].toDouble());
        endingPoint[0] = min(endingPoint[0], endLineLeader[0]);
      }
      if (startingPoint[1] == min(startingPoint[1], endingPoint[1])) {
        startingPoint[1] -= height * borderLength;
        endingPoint[1] += height * borderLength;
        startingPoint[1] = min(startingPoint[1], linePoints[1].toDouble());
        startingPoint[1] = min(startingPoint[1], beginLineLeader[1]);
        endingPoint[1] = max(endingPoint[1], linePoints[3].toDouble());
        endingPoint[1] = max(endingPoint[1], endLineLeader[1]);
      } else {
        startingPoint[1] += height * borderLength;
        endingPoint[1] -= height * borderLength;
        startingPoint[1] = max(startingPoint[1], linePoints[1].toDouble());
        startingPoint[1] = max(startingPoint[1], beginLineLeader[1]);
        endingPoint[1] = min(endingPoint[1], linePoints[3].toDouble());
        endingPoint[1] = min(endingPoint[1], endLineLeader[1]);
      }
      path.addLine(Offset(startingPoint[0], startingPoint[1]),
          Offset(endingPoint[0], endingPoint[1]));
      bounds = path._getBoundsInternal();
    }
    return bounds;
  }

  List<double> _getAxisValue(List<double> value, double angle, double length) {
    const double degToRad = pi / 180.0;
    final List<double> xy = List<double>.filled(2, 0);
    xy[0] = value[0] + cos(angle * degToRad) * length;
    xy[1] = value[1] + sin(angle * degToRad) * length;

    return xy;
  }

  double _getAngle(double x1, double y1, double x2, double y2) {
    double angle = 0;
    final double angleRatio = (y2 - y1) / (x2 - x1);
    final double radians = atan(angleRatio);
    angle = radians * (180 / pi);

    if ((x2 - x1) < 0 || (y2 - y1) < 0) {
      angle += 180;
    }
    if ((x2 - x1) > 0 && (y2 - y1) < 0) {
      angle -= 180;
    }
    if (angle < 0) {
      angle += 360;
    }

    return angle;
  }

  void _setLineEndingStyles(
      List<double> startingPoint,
      List<double> endingPoint,
      PdfGraphics? graphics,
      double angle,
      PdfPen? borderPen,
      PdfBrush? backBrush,
      _PdfArray lineStyle,
      double borderLength) {
    List<double> axisPoint;
    if (borderLength == 0) {
      borderLength = 1;
      borderPen = null;
    }
    if (backBrush is PdfSolidBrush) {
      if (backBrush.color.isEmpty) {
        backBrush = null;
      }
    }
    for (int i = 0; i < lineStyle.count; i++) {
      final _PdfName lineEndingStyle = lineStyle[i]! as _PdfName;
      if (i == 0) {
        axisPoint = startingPoint;
      } else {
        axisPoint = endingPoint;
      }
      switch (lineEndingStyle._name) {
        case 'Square':
          {
            final Rect rect = Rect.fromLTWH(
                axisPoint[0] - (3 * borderLength),
                -(axisPoint[1] + (3 * borderLength)),
                6 * borderLength,
                6 * borderLength);
            graphics!
                .drawRectangle(bounds: rect, pen: borderPen, brush: backBrush);
          }
          break;
        case 'Circle':
          {
            final Rect rect = Rect.fromLTWH(
                axisPoint[0] - (3 * borderLength),
                -(axisPoint[1] + (3 * borderLength)),
                6 * borderLength,
                6 * borderLength);
            graphics!.drawEllipse(rect, pen: borderPen, brush: backBrush);
          }
          break;
        case 'OpenArrow':
          {
            int arraowAngle = 0;
            if (i == 0) {
              arraowAngle = 30;
            } else {
              arraowAngle = 150;
            }
            final double length = 9 * borderLength;
            List<double> startPoint;
            if (i == 0) {
              startPoint = _getAxisValue(axisPoint, angle, borderLength);
            } else {
              startPoint = _getAxisValue(axisPoint, angle, -borderLength);
            }
            final List<double> point1 =
                _getAxisValue(startPoint, angle + arraowAngle, length);
            final List<double> point2 =
                _getAxisValue(startPoint, angle - arraowAngle, length);

            final PdfPath path = PdfPath(pen: borderPen);
            path.addLine(Offset(startPoint[0], -startPoint[1]),
                Offset(point1[0], -point1[1]));
            path.addLine(Offset(startPoint[0], -startPoint[1]),
                Offset(point2[0], -point2[1]));
            graphics!.drawPath(path, pen: borderPen);
          }
          break;
        case 'ClosedArrow':
          {
            int arraowAngle = 0;
            if (i == 0) {
              arraowAngle = 30;
            } else {
              arraowAngle = 150;
            }
            final double length = 9 * borderLength;
            List<double> startPoint;
            if (i == 0) {
              startPoint = _getAxisValue(axisPoint, angle, borderLength);
            } else {
              startPoint = _getAxisValue(axisPoint, angle, -borderLength);
            }
            final List<double> point1 =
                _getAxisValue(startPoint, angle + arraowAngle, length);
            final List<double> point2 =
                _getAxisValue(startPoint, angle - arraowAngle, length);
            final List<Offset> points = <Offset>[
              Offset(startPoint[0], -startPoint[1]),
              Offset(point1[0], -point1[1]),
              Offset(point2[0], -point2[1])
            ];
            graphics!.drawPolygon(points, pen: borderPen, brush: backBrush);
          }
          break;
        case 'ROpenArrow':
          {
            int arraowAngle = 0;
            if (i == 0) {
              arraowAngle = 150;
            } else {
              arraowAngle = 30;
            }
            final double length = 9 * borderLength;
            List<double> startPoint;
            if (i == 0) {
              startPoint = _getAxisValue(axisPoint, angle, -borderLength);
            } else {
              startPoint = _getAxisValue(axisPoint, angle, borderLength);
            }
            final List<double> point1 =
                _getAxisValue(startPoint, angle + arraowAngle, length);
            final List<double> point2 =
                _getAxisValue(startPoint, angle - arraowAngle, length);

            final PdfPath path = PdfPath(pen: borderPen);
            path.addLine(Offset(startPoint[0], -startPoint[1]),
                Offset(point1[0], -point1[1]));
            path.addLine(Offset(startPoint[0], -startPoint[1]),
                Offset(point2[0], -point2[1]));
            graphics!.drawPath(path, pen: borderPen);
          }
          break;
        case 'RClosedArrow':
          {
            int arraowAngle = 0;
            if (i == 0) {
              arraowAngle = 150;
            } else {
              arraowAngle = 30;
            }
            final double length = 9 * borderLength;
            List<double> startPoint;
            if (i == 0) {
              startPoint = _getAxisValue(axisPoint, angle, -borderLength);
            } else {
              startPoint = _getAxisValue(axisPoint, angle, borderLength);
            }

            final List<double> point1 =
                _getAxisValue(startPoint, angle + arraowAngle, length);
            final List<double> point2 =
                _getAxisValue(startPoint, angle - arraowAngle, length);
            final List<Offset> points = <Offset>[
              Offset(startPoint[0], -startPoint[1]),
              Offset(point1[0], -point1[1]),
              Offset(point2[0], -point2[1])
            ];
            graphics!.drawPolygon(points, pen: borderPen, brush: backBrush);
          }
          break;
        case 'Slash':
          {
            final double length = 9 * borderLength;
            final List<double> point1 =
                _getAxisValue(axisPoint, angle + 60, length);
            final List<double> point2 =
                _getAxisValue(axisPoint, angle - 120, length);
            graphics!.drawLine(borderPen!, Offset(axisPoint[0], -axisPoint[1]),
                Offset(point1[0], -point1[1]));
            graphics.drawLine(borderPen, Offset(axisPoint[0], -axisPoint[1]),
                Offset(point2[0], -point2[1]));
          }
          break;
        case 'Diamond':
          {
            final double length = 3 * borderLength;
            final List<double> point1 = _getAxisValue(axisPoint, 180, length);
            final List<double> point2 = _getAxisValue(axisPoint, 90, length);
            final List<double> point3 = _getAxisValue(axisPoint, 0, length);
            final List<double> point4 = _getAxisValue(axisPoint, -90, length);
            final List<Offset> points = <Offset>[
              Offset(point1[0], -point1[1]),
              Offset(point2[0], -point2[1]),
              Offset(point3[0], -point3[1]),
              Offset(point4[0], -point4[1])
            ];
            graphics!.drawPolygon(points, pen: borderPen, brush: backBrush);
          }
          break;
        case 'Butt':
          {
            final double length = 3 * borderLength;
            final List<double> point1 =
                _getAxisValue(axisPoint, angle + 90, length);
            final List<double> point2 =
                _getAxisValue(axisPoint, angle - 90, length);

            graphics!.drawLine(borderPen!, Offset(point1[0], -point1[1]),
                Offset(point2[0], -point2[1]));
          }
          break;
      }
    }
  }

  // Returns the appearance matrix is rotated or not
  bool _validateTemplateMatrix(_PdfDictionary dictionary) {
    bool isRotatedMatrix = false;
    if (dictionary.containsKey(_DictionaryProperties.matrix)) {
      final _PdfArray? matrix =
          _PdfCrossTable._dereference(dictionary[_DictionaryProperties.matrix])
              as _PdfArray?;
      if (matrix != null && matrix.count > 3) {
        if ((matrix[0]! as _PdfNumber).value == 1 &&
            (matrix[1]! as _PdfNumber).value == 0 &&
            (matrix[2]! as _PdfNumber).value == 0 &&
            (matrix[3]! as _PdfNumber).value == 1) {
          isRotatedMatrix = true;
        }
      }
    } else {
      isRotatedMatrix = true;
    }
    return isRotatedMatrix;
  }

  // Flatten annotation template
  void _flattenAnnotationTemplate(PdfTemplate appearance, bool isNormalMatrix) {
    final PdfGraphicsState state = page!.graphics.save();
    if (opacity < 1) {
      page!.graphics.setTransparency(opacity);
    }
    final Rect bound =
        _calculateTemplateBounds(bounds, page, appearance, isNormalMatrix);
    page!.graphics.drawPdfTemplate(appearance, bound.topLeft, bounds.size);
    page!.graphics.restore(state);
    page!.annotations.remove(this);
  }

  // Draw CloudStye to the Shapes
  void _drawCloudStyle(PdfGraphics graphics, PdfBrush? brush, PdfPen? pen,
      double radius, double overlap, List<Offset> points, bool isAppearance) {
    if (_isClockWise(points)) {
      points = List<Offset>.generate(
          points.length, (int i) => points[points.length - (i + 1)]);
    }

    // Create a list of circles
    final List<_CloudStyleArc> circles = <_CloudStyleArc>[];
    final double circleOverlap = 2 * radius * overlap;
    Offset previousPoint = points[points.length - 1];
    for (int i = 0; i < points.length; i++) {
      final Offset currentPoint = points[i];
      double dx = currentPoint.dx - previousPoint.dx;
      double dy = currentPoint.dy - previousPoint.dy;
      final double len = sqrt(dx * dx + dy * dy);
      dx = dx / len;
      dy = dy / len;
      final double d = circleOverlap;
      for (double a = 0; a + 0.1 * d < len; a += d) {
        final _CloudStyleArc cur = _CloudStyleArc();
        cur.point =
            Offset(previousPoint.dx + a * dx, previousPoint.dy + a * dy);
        circles.add(cur);
      }
      previousPoint = currentPoint;
    }
    final PdfPath gpath = PdfPath();
    gpath.addPolygon(points);

    // Determine intersection angles of circles
    _CloudStyleArc previousCurvedStyleArc = circles[circles.length - 1];
    for (int i = 0; i < circles.length; i++) {
      final _CloudStyleArc currentCurvedStyleArc = circles[i];
      final Offset angle = _getIntersectionDegrees(
          previousCurvedStyleArc.point, currentCurvedStyleArc.point, radius);
      previousCurvedStyleArc.endAngle = angle.dx;
      currentCurvedStyleArc.startAngle = angle.dy;
      previousCurvedStyleArc = currentCurvedStyleArc;
    }

    // Draw the cloud
    PdfPath path = PdfPath();
    for (int i = 0; i < circles.length; i++) {
      final _CloudStyleArc curr = circles[i];
      final double angle = curr.startAngle < 0
          ? ((curr.startAngle * -1) % 360) * -1
          : curr.startAngle % 360;
      final double angle1 = curr.endAngle < 0
          ? ((curr.endAngle * -1) % 360) * -1
          : curr.endAngle % 360;
      double sweepAngel = 0;
      if (angle > 0 && angle1 < 0) {
        sweepAngel = (180 - angle) + (180 - (angle1 < 0 ? -angle1 : angle1));
      } else if (angle < 0 && angle1 > 0) {
        sweepAngel = -angle + angle1;
      } else if (angle > 0 && angle1 > 0) {
        double difference = 0;
        if (angle > angle1) {
          difference = angle - angle1;
          sweepAngel = 360 - difference;
        } else {
          sweepAngel = angle1 - angle;
        }
      } else if (angle < 0 && angle1 < 0) {
        double difference = 0;
        if (angle > angle1) {
          difference = angle - angle1;
          sweepAngel = 360 - difference;
        } else {
          sweepAngel = -(angle + (-angle1));
        }
      }
      if (sweepAngel < 0) {
        sweepAngel = -sweepAngel;
      }
      curr.endAngle = sweepAngel;
      path.addArc(
          Rect.fromLTWH(curr.point.dx - radius, curr.point.dy - radius,
              2 * radius, 2 * radius),
          angle,
          sweepAngel);
    }
    path.closeFigure();
    PdfPath pdfPath = PdfPath();
    if (isAppearance) {
      for (int i = 0; i < path._points.length; i++) {
        pdfPath._points.add(Offset(path._points[i].dx, -path._points[i].dy));
      }
    } else {
      pdfPath._points.addAll(path._points);
    }
    pdfPath._pathTypes.addAll(path._pathTypes);
    if (brush != null) {
      graphics.drawPath(pdfPath, brush: brush);
    }
    const double incise = 180 / (pi * 3);
    path = PdfPath();
    for (int i = 0; i < circles.length; i++) {
      final _CloudStyleArc curr = circles[i];
      path.addArc(
          Rect.fromLTWH(curr.point.dx - radius, curr.point.dy - radius,
              2 * radius, 2 * radius),
          curr.startAngle,
          curr.endAngle + incise);
    }
    path.closeFigure();
    pdfPath = PdfPath();
    if (isAppearance) {
      for (int i = 0; i < path._points.length; i++) {
        pdfPath._points.add(Offset(path._points[i].dx, -path._points[i].dy));
      }
    } else {
      pdfPath._points.addAll(path._points);
    }
    pdfPath._pathTypes.addAll(path._pathTypes);
    graphics.drawPath(pdfPath, pen: pen);
  }

  bool _isClockWise(List<Offset> points) {
    double sum = 0.0;
    for (int i = 0; i < points.length; i++) {
      final Offset v1 = points[i];
      final Offset v2 = points[(i + 1) % points.length];
      sum += (v2.dx - v1.dx) * (v2.dy + v1.dy);
    }
    return sum > 0.0;
  }

  Offset _getIntersectionDegrees(Offset point1, Offset point2, double radius) {
    final double dx = point2.dx - point1.dx;
    final double dy = point2.dy - point1.dy;
    final double len = sqrt(dx * dx + dy * dy);
    double a = 0.5 * len / radius;
    if (a < -1) {
      a = -1;
    }
    if (a > 1) {
      a = 1;
    }
    final double radian = atan2(dy, dx);
    final double cosvalue = acos(a);
    return Offset((radian - cosvalue) * (180 / pi),
        (pi + radian + cosvalue) * (180 / pi));
  }

  // Gets the value.
  static _IPdfPrimitive? _getValue(_PdfDictionary dictionary,
      _PdfCrossTable? crossTable, String value, bool inheritable) {
    _IPdfPrimitive? primitive;
    if (dictionary.containsKey(value)) {
      primitive = crossTable!._getObject(dictionary[value]);
    } else {
      if (inheritable) {
        primitive = _searchInParents(dictionary, crossTable, value);
      }
    }
    return primitive;
  }

  // Searches the in parents.
  static _IPdfPrimitive? _searchInParents(
      _PdfDictionary dictionary, _PdfCrossTable? crossTable, String value) {
    _IPdfPrimitive? primitive;
    _PdfDictionary? dic = dictionary;
    while ((primitive == null) && (dic != null)) {
      if (dic.containsKey(value)) {
        primitive = crossTable!._getObject(dic[value]);
      } else {
        if (dic.containsKey(_DictionaryProperties.parent)) {
          dic = crossTable!._getObject(dic[_DictionaryProperties.parent])
              as _PdfDictionary?;
        } else {
          dic = null;
        }
      }
    }
    return primitive;
  }

  //Overrides
  @override
  _IPdfPrimitive? get _element => _dictionary;

  @override
  set _element(_IPdfPrimitive? value) {
    throw ArgumentError('Primitive element can\'t be set');
  }
}

class _CloudStyleArc {
  late Offset point;
  double endAngle = 0;
  double startAngle = 0;
}
