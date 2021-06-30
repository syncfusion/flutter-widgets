part of pdf;

/// Represents actions to be performed as response to field events.
class PdfFieldActions implements _IPdfWrapper {
  //Constructor
  /// Initializes a new instance of the [PdfFieldActions] class with
  /// the [PdfAnnotationActions]
  PdfFieldActions(PdfAnnotationActions annotationActions,
      {PdfJavaScriptAction? keyPressed,
      PdfJavaScriptAction? format,
      PdfJavaScriptAction? validate,
      PdfJavaScriptAction? calculate}) {
    _annotationActions = annotationActions;
    _initValues(keyPressed, format, validate, calculate);
  }

  PdfFieldActions._loaded(_PdfDictionary dictionary) {
    _dictionary = dictionary;
    _annotationActions = PdfAnnotationActions._loaded(dictionary);
  }

  //Fields
  _PdfDictionary? _dictionary = _PdfDictionary();
  late PdfAnnotationActions _annotationActions;
  PdfJavaScriptAction? _keyPressed;
  PdfJavaScriptAction? _format;
  PdfJavaScriptAction? _validate;
  PdfJavaScriptAction? _calculate;
  bool _isChanged = false;

  //Properties
  /// Gets or sets the JavaScript action to be performed when
  /// the user types a keystroke
  PdfJavaScriptAction? get keyPressed => _keyPressed;
  set keyPressed(PdfJavaScriptAction? value) {
    if (value != null && _keyPressed != value) {
      _keyPressed = value;
      _dictionary!.setProperty(_DictionaryProperties.k, _keyPressed);
      _isChanged = true;
    }
  }

  /// Gets or sets the JavaScript action to be performed before
  /// the field is formatted
  PdfJavaScriptAction? get format => _format;
  set format(PdfJavaScriptAction? value) {
    if (value != null && _format != value) {
      _format = value;
      _dictionary!.setProperty(_DictionaryProperties.f, _format);
      _isChanged = true;
    }
  }

  /// Gets or sets the JavaScript action to be performed when
  /// the field’s value is changed.
  PdfJavaScriptAction? get validate => _validate;
  set validate(PdfJavaScriptAction? value) {
    if (value != null && _validate != value) {
      _validate = value;
      _dictionary!.setProperty(_DictionaryProperties.v, _validate);
      _isChanged = true;
    }
  }

  /// Gets or sets the JavaScript action to be performed to recalculate
  /// the value of this field when that of another field changes.
  PdfJavaScriptAction? get calculate => _calculate;
  set calculate(PdfJavaScriptAction? value) {
    if (value != null && _calculate != value) {
      _calculate = value;
      _dictionary!.setProperty(_DictionaryProperties.c, _calculate);
      _isChanged = true;
    }
  }

  /// Gets or sets the action to be performed when the mouse cursor enters
  /// the fields’s area.
  PdfAction? get mouseEnter => _annotationActions.mouseEnter;
  set mouseEnter(PdfAction? value) {
    if (value != null) {
      _annotationActions.mouseEnter = value;
      _isChanged = true;
    }
  }

  /// Gets or sets the action to be performed when the cursor exits
  /// the fields’s area.
  PdfAction? get mouseLeave => _annotationActions.mouseLeave;
  set mouseLeave(PdfAction? value) {
    if (value != null) {
      _annotationActions.mouseLeave = value;
      _isChanged = true;
    }
  }

  /// Gets or sets the action to be performed when the mouse button is released
  /// inside the field’s area.
  PdfAction? get mouseUp => _annotationActions.mouseUp;
  set mouseUp(PdfAction? value) {
    if (value != null) {
      _annotationActions.mouseUp = value;
      _isChanged = true;
    }
  }

  /// Gets or sets the action to be performed when the mouse button is pressed inside the
  /// field’s area.
  PdfAction? get mouseDown => _annotationActions.mouseDown;
  set mouseDown(PdfAction? value) {
    if (value != null) {
      _annotationActions.mouseDown = value;
      _isChanged = true;
    }
  }

  /// Gets or sets the action to be performed when the field receives the
  /// input focus.
  PdfAction? get gotFocus => _annotationActions.gotFocus;
  set gotFocus(PdfAction? value) {
    if (value != null) {
      _annotationActions.gotFocus = value;
      _isChanged = true;
    }
  }

  /// Gets or sets the action to be performed when the field loses the
  /// input focus.
  PdfAction? get lostFocus => _annotationActions.lostFocus;
  set lostFocus(PdfAction? value) {
    if (value != null) {
      _annotationActions.lostFocus = value;
      _isChanged = true;
    }
  }

  // Implementation
  void _initValues(
    PdfJavaScriptAction? keyPress,
    PdfJavaScriptAction? fmt,
    PdfJavaScriptAction? val,
    PdfJavaScriptAction? cal,
  ) {
    if (keyPress != null) {
      keyPressed = keyPress;
    }
    if (fmt != null) {
      format = fmt;
    }
    if (val != null) {
      validate = val;
    }
    if (cal != null) {
      calculate = cal;
    }
  }

  @override
  _IPdfPrimitive? get _element => _dictionary;

  @override
  // ignore: unused_element
  set _element(_IPdfPrimitive? value) {
    _element = value;
  }
}

/// Represents an java script action in PDF document.
class PdfJavaScriptAction extends PdfAction {
  //Constructor
  /// Initializes a new instance of the [PdfJavaScriptAction] class with
  /// the java script code
  PdfJavaScriptAction(String javaScript) : super._() {
    _initValue(javaScript);
  }

  //Fields
  String _javaScript = '';

  //Properties
  /// Gets or sets the javascript code to be executed when
  /// this action is executed.
  String get javaScript => _javaScript;
  set javaScript(String value) {
    if (_javaScript != value) {
      _javaScript = value;
      _dictionary._setString(_DictionaryProperties.js, _javaScript);
    }
  }

  //Implementation
  @override
  void _initialize() {
    super._initialize();
    _dictionary.setProperty(
        _DictionaryProperties.s, _PdfName(_DictionaryProperties.javaScript));
    _dictionary.setProperty(_DictionaryProperties.js, _PdfString(_javaScript));
  }

  void _initValue(String js) {
    javaScript = js;
  }
}

/// Represents the action on form fields.
class PdfFormAction extends PdfAction {
  //Constrcutor
  /// Initializes a new instance of the [PdfFormAction] class.
  PdfFormAction._() : super._();

  //Fields
  PdfFormFieldCollection? _fields;

  /// Gets or sets a value indicating whether fields contained in the fields
  /// collection will be included for resetting or submitting.
  ///
  /// If the [include] property is true, only the fields in this collection
  /// will be reset or submitted.
  /// If the [include] property is false, the fields in this collection
  /// are not reset or submitted and only the remaining form fields are
  /// reset or submitted.
  /// If the collection is empty, then all the form fields are reset
  /// and the [include] property is ignored.
  bool include = false;

  ///Gets the fields.
  PdfFormFieldCollection get fields {
    if (_fields == null) {
      _fields = PdfFormFieldCollection._();
      _dictionary.setProperty(_DictionaryProperties.fields, _fields);
    }
    _fields!._isAction = true;
    return _fields!;
  }
}

/// Represents PDF form's reset action,this action allows a user to reset
/// the form fields to their default values.
class PdfResetAction extends PdfFormAction {
  //Constructor
  /// Initializes a new instance of the [PdfResetAction] class.
  PdfResetAction({bool? include, List<PdfField>? fields}) : super._() {
    _initValues(include, fields);
  }

  //Properties
  @override
  set include(bool value) {
    if (super.include != value) {
      super.include = value;
      _dictionary._setNumber(
          _DictionaryProperties.flags, super.include ? 0 : 1);
    }
  }

  //Implementation
  @override
  void _initialize() {
    super._initialize();
    _dictionary.setProperty(
        _DictionaryProperties.s, _PdfName(_DictionaryProperties.resetForm));
  }

  void _initValues(bool? initInclude, List<PdfField>? field) {
    if (initInclude != null) {
      include = initInclude;
    }
    if (field != null) {
      // ignore: avoid_function_literals_in_foreach_calls
      field.forEach((PdfField f) => fields.add(f));
    }
  }
}
