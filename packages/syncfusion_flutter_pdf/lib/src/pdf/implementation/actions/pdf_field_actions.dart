import '../../interfaces/pdf_interface.dart';
import '../io/pdf_constants.dart';
import '../primitives/pdf_dictionary.dart';
import '../primitives/pdf_name.dart';
import '../primitives/pdf_string.dart';
import 'pdf_action.dart';
import 'pdf_annotation_action.dart';

/// Represents actions to be performed as response to field events.
class PdfFieldActions implements IPdfWrapper {
  //Constructor
  /// Initializes a new instance of the [PdfFieldActions] class with
  /// the [PdfAnnotationActions]
  PdfFieldActions(PdfAnnotationActions annotationActions,
      {PdfJavaScriptAction? keyPressed,
      PdfJavaScriptAction? format,
      PdfJavaScriptAction? validate,
      PdfJavaScriptAction? calculate}) {
    _helper.annotationActions = annotationActions;
    _initValues(keyPressed, format, validate, calculate);
  }

  PdfFieldActions._loaded(PdfDictionary dictionary) {
    _helper.dictionary = dictionary;
    _helper.annotationActions = PdfAnnotationActionsHelper.load(dictionary);
  }

  //Fields
  final PdfFieldActionsHelper _helper = PdfFieldActionsHelper();
  PdfJavaScriptAction? _keyPressed;
  PdfJavaScriptAction? _format;
  PdfJavaScriptAction? _validate;
  PdfJavaScriptAction? _calculate;

  //Properties
  /// Gets or sets the JavaScript action to be performed when
  /// the user types a keystroke
  PdfJavaScriptAction? get keyPressed => _keyPressed;
  set keyPressed(PdfJavaScriptAction? value) {
    if (value != null && _keyPressed != value) {
      _keyPressed = value;
      _helper.dictionary!.setProperty(PdfDictionaryProperties.k, _keyPressed);
      _helper.changed = true;
    }
  }

  /// Gets or sets the JavaScript action to be performed before
  /// the field is formatted
  PdfJavaScriptAction? get format => _format;
  set format(PdfJavaScriptAction? value) {
    if (value != null && _format != value) {
      _format = value;
      _helper.dictionary!.setProperty(PdfDictionaryProperties.f, _format);
      _helper.changed = true;
    }
  }

  /// Gets or sets the JavaScript action to be performed when
  /// the field’s value is changed.
  PdfJavaScriptAction? get validate => _validate;
  set validate(PdfJavaScriptAction? value) {
    if (value != null && _validate != value) {
      _validate = value;
      _helper.dictionary!.setProperty(PdfDictionaryProperties.v, _validate);
      _helper.changed = true;
    }
  }

  /// Gets or sets the JavaScript action to be performed to recalculate
  /// the value of this field when that of another field changes.
  PdfJavaScriptAction? get calculate => _calculate;
  set calculate(PdfJavaScriptAction? value) {
    if (value != null && _calculate != value) {
      _calculate = value;
      _helper.dictionary!.setProperty(PdfDictionaryProperties.c, _calculate);
      _helper.changed = true;
    }
  }

  /// Gets or sets the action to be performed when the mouse cursor enters
  /// the fields’s area.
  PdfAction? get mouseEnter => _helper.annotationActions.mouseEnter;
  set mouseEnter(PdfAction? value) {
    if (value != null) {
      _helper.annotationActions.mouseEnter = value;
      _helper.changed = true;
    }
  }

  /// Gets or sets the action to be performed when the cursor exits
  /// the fields’s area.
  PdfAction? get mouseLeave => _helper.annotationActions.mouseLeave;
  set mouseLeave(PdfAction? value) {
    if (value != null) {
      _helper.annotationActions.mouseLeave = value;
      _helper.changed = true;
    }
  }

  /// Gets or sets the action to be performed when the mouse button is released
  /// inside the field’s area.
  PdfAction? get mouseUp => _helper.annotationActions.mouseUp;
  set mouseUp(PdfAction? value) {
    if (value != null) {
      _helper.annotationActions.mouseUp = value;
      _helper.changed = true;
    }
  }

  /// Gets or sets the action to be performed when the mouse button is pressed inside the
  /// field’s area.
  PdfAction? get mouseDown => _helper.annotationActions.mouseDown;
  set mouseDown(PdfAction? value) {
    if (value != null) {
      _helper.annotationActions.mouseDown = value;
      _helper.changed = true;
    }
  }

  /// Gets or sets the action to be performed when the field receives the
  /// input focus.
  PdfAction? get gotFocus => _helper.annotationActions.gotFocus;
  set gotFocus(PdfAction? value) {
    if (value != null) {
      _helper.annotationActions.gotFocus = value;
      _helper.changed = true;
    }
  }

  /// Gets or sets the action to be performed when the field loses the
  /// input focus.
  PdfAction? get lostFocus => _helper.annotationActions.lostFocus;
  set lostFocus(PdfAction? value) {
    if (value != null) {
      _helper.annotationActions.lostFocus = value;
      _helper.changed = true;
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
}

/// [PdfFieldActions] helper
class PdfFieldActionsHelper {
  /// internal field
  bool changed = false;

  /// internal field
  PdfDictionary? dictionary = PdfDictionary();

  /// internal field
  late PdfAnnotationActions annotationActions;

  /// internal property
  IPdfPrimitive? get element => dictionary;
  // ignore: unused_element
  set element(IPdfPrimitive? value) {
    if (value != null && value is PdfDictionary) {
      dictionary = value;
    }
  }

  /// internal method
  static PdfFieldActionsHelper getHelper(PdfFieldActions fieldActions) {
    return fieldActions._helper;
  }

  /// internal method
  static PdfFieldActions load(PdfDictionary dictionary) {
    return PdfFieldActions._loaded(dictionary);
  }
}

/// Represents an java script action in PDF document.
class PdfJavaScriptAction extends PdfAction {
  //Constructor
  /// Initializes a new instance of the [PdfJavaScriptAction] class with
  /// the java script code
  PdfJavaScriptAction(String javaScript) : super() {
    _initValue(javaScript);
    PdfActionHelper.getHelper(this).dictionary.setProperty(
        PdfDictionaryProperties.s, PdfName(PdfDictionaryProperties.javaScript));
    PdfActionHelper.getHelper(this)
        .dictionary
        .setProperty(PdfDictionaryProperties.js, PdfString(_javaScript));
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
      PdfActionHelper.getHelper(this)
          .dictionary
          .setString(PdfDictionaryProperties.js, _javaScript);
    }
  }

  // ignore: use_setters_to_change_properties
  void _initValue(String js) {
    javaScript = js;
  }
}
