import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

import '../../pdfviewer.dart';
import '../change_tracker/change_tracker.dart';
import 'pdf_form_field.dart';

/// Represents the text form field.
class PdfTextFormField extends PdfFormField {
  PdfTextFormField._();

  late String _text;
  List<PdfTextFormField>? _children;

  /// Gets or sets the text of the [PdfTextFormField].
  String get text => _text;

  set text(String value) {
    if (readOnly) {
      return;
    }
    (PdfFormFieldHelper.getHelper(this) as PdfTextFormFieldHelper)
        .invokeValueChanged(value);
  }

  @override
  set readOnly(bool value) {
    if (readOnly != value) {
      super.readOnly = value;
      if (_children != null && _children!.isNotEmpty) {
        for (final PdfTextFormField item in _children!) {
          item.readOnly = value;
        }
      }
    }
  }

  /// Gets the child items associated with this [PdfTextFormField].
  List<PdfTextFormField>? get children => _children != null
      ? List<PdfTextFormField>.unmodifiable(_children!)
      : null;
}

/// Helper class for [PdfTextFormField].
class PdfTextFormFieldHelper extends PdfFormFieldHelper {
  /// Initializes a new instance of the [PdfTextFormFieldHelper] class.
  PdfTextFormFieldHelper(this.pdfTextField, int pageIndex,
      {this.onValueChanged, this.onFocusChanged})
      : super(pdfTextField, pageIndex) {
    bounds = pdfTextField.bounds;
  }

  bool _hasFocus = false;

  /// The text field object from PDF library.
  final PdfTextBoxField pdfTextField;

  /// The callback which is called when the value of the form field is changed.
  final PdfFormFieldValueChangedCallback? onValueChanged;

  /// The callback which is called when the focus of the form field changes.
  final PdfFormFieldFocusChangeCallback? onFocusChanged;

  /// The text form field object.
  late PdfTextFormField textFormField;

  /// The text editing controller.
  late TextEditingController textEditingController;

  /// The focus node.
  late FocusNode focusNode;

  /// Creates the text form field object.
  PdfTextFormField getFormField(ChangeTracker changeTracker) {
    textFormField = PdfTextFormField._().._text = pdfTextField.text;
    super.load(textFormField);

    textEditingController = TextEditingController(text: textFormField._text);
    focusNode = createFocusNode(changeTracker);

    return textFormField;
  }

  /// Adds the grouped items.
  // ignore: use_setters_to_change_properties
  void updateChildItems(List<PdfTextFormField> groupedItems) {
    textFormField._children = groupedItems;
  }

  /// Gets the focus node of the [PdfTextFormField].
  FocusNode createFocusNode(ChangeTracker changeTracker) {
    return FocusNode(
      onKeyEvent: (FocusNode focusNode, KeyEvent event) {
        final bool isControlOrMeta =
            HardwareKeyboard.instance.isControlPressed ||
                HardwareKeyboard.instance.isMetaPressed;
        final bool isLogicalOrPhysicalZ =
            event.logicalKey == LogicalKeyboardKey.keyZ ||
                event.physicalKey == PhysicalKeyboardKey.keyZ;
        final bool isLogicalOrPhysicalY =
            event.logicalKey == LogicalKeyboardKey.keyY ||
                event.physicalKey == PhysicalKeyboardKey.keyY;

        if (isControlOrMeta && isLogicalOrPhysicalZ) {
          if (event is KeyDownEvent) {
            changeTracker.undoController.undo();
          }
          return KeyEventResult.handled;
        } else if (isControlOrMeta && isLogicalOrPhysicalY) {
          if (event is KeyDownEvent) {
            changeTracker.undoController.redo();
          }
          return KeyEventResult.handled;
        } else {
          return KeyEventResult.ignored;
        }
      },
    )..addListener(() {
        if (!focusNode.hasFocus) {
          invokeFocusChange(focusNode.hasFocus);
        }
      });
  }

  /// Updates the text form field.
  void invokeValueChanged(String newValue) {
    if (textFormField._text != newValue) {
      newValue =
          pdfTextField.maxLength > 0 && newValue.length > pdfTextField.maxLength
              ? newValue.substring(0, pdfTextField.maxLength)
              : newValue;
      final String oldValue = textFormField._text;
      setTextBoxValue(newValue);
      if (onValueChanged != null) {
        onValueChanged!(
            PdfFormFieldValueChangedDetails(textFormField, oldValue, newValue));
      }
      rebuild();
    }
  }

  /// Invokes the focus change.
  void invokeFocusChange(bool hasFocus) {
    if (!textFormField.readOnly &&
        _hasFocus != hasFocus &&
        onFocusChanged != null) {
      onFocusChanged!(PdfFormFieldFocusChangeDetails(textFormField, hasFocus));
    }
    _hasFocus = hasFocus;
  }

  /// Sets the text box value.
  void setTextBoxValue(String text) {
    textFormField._text = text;
    if (textEditingController.text != text) {
      textEditingController.text = text;
    }
    _updateChildItems(text);
    pdfTextField.text = text;
  }

  /// Updates the grouped field items.
  void _updateChildItems(String text) {
    if (textFormField._children != null &&
        textFormField._children!.isNotEmpty) {
      for (final PdfTextFormField item in textFormField._children!) {
        final PdfFormFieldHelper childHelper =
            PdfFormFieldHelper.getHelper(item);
        if (childHelper is PdfTextFormFieldHelper &&
            childHelper.textEditingController.text != text) {
          childHelper.textEditingController.text = text;
        }
      }
    }
  }

  /// Builds the text form field widget.
  Widget build(BuildContext context, double heightPercentage,
      {required Function(Offset) onTap}) {
    // Since the height of the text form field is dependent on the font size,
    // we calculate the vertical padding in order to align the text vertically at the center.
    final double verticalPadding = (bounds.height - pdfTextField.font.size) / 2;
    return Positioned(
      left: bounds.left / heightPercentage,
      top: bounds.top / heightPercentage,
      width: bounds.width / heightPercentage,
      height: bounds.height / heightPercentage,
      child: Listener(
        onPointerUp: (PointerUpEvent event) {
          onTap(event.localPosition.translate(
              bounds.left / heightPercentage, bounds.top / heightPercentage));
        },
        child: PdfTextBox(
          textEditingController: textEditingController,
          focusNode: focusNode,
          readOnly: textFormField.readOnly,
          font: pdfTextField.font.name,
          fontSize: pdfTextField.font.size / heightPercentage,
          verticalPadding: verticalPadding / heightPercentage,
          isPassword: pdfTextField.isPassword,
          fillColor: pdfTextField.backColor.isEmpty
              ? const Color.fromARGB(255, 221, 228, 255)
              : Color.fromRGBO(
                  pdfTextField.backColor.r,
                  pdfTextField.backColor.g,
                  pdfTextField.backColor.b,
                  1,
                ),
          multiline: pdfTextField.multiline,
          maxLength: pdfTextField.maxLength,
          onValueChanged: invokeValueChanged,
          onFocusChange: invokeFocusChange,
        ),
      ),
    );
  }

  @override
  void dispose() {
    textEditingController.dispose();
    focusNode.dispose();
    super.dispose();
  }
}

/// Customized text box.
class PdfTextBox extends StatefulWidget {
  /// Creates a text form field widget.
  const PdfTextBox(
      {required this.textEditingController,
      required this.focusNode,
      this.readOnly = false,
      required this.font,
      required this.fontSize,
      this.isPassword = false,
      required this.fillColor,
      this.multiline = false,
      required this.verticalPadding,
      this.maxLength = 0,
      this.onValueChanged,
      this.onFocusChange,
      super.key});

  /// Text form field text editing controller.
  final TextEditingController textEditingController;

  /// Text form field focus node.
  final FocusNode focusNode;

  /// Text form field read only.
  final bool readOnly;

  /// Text form field is password.
  final bool isPassword;

  /// Text form field fill color.
  final Color fillColor;

  /// Text form field is multiline.
  final bool multiline;

  /// Text form field font.
  final String font;

  /// Text form field font size.
  final double fontSize;

  /// Text form field value changed.
  final ValueChanged<String>? onValueChanged;

  /// Text form field focus change.
  final ValueChanged<bool>? onFocusChange;

  /// Vertical padding.
  final double verticalPadding;

  /// Text form field maximum length.
  final int maxLength;

  @override
  State<PdfTextBox> createState() => _PdfTextBoxState();
}

class _PdfTextBoxState extends State<PdfTextBox> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTap: () {
        if (widget.onFocusChange != null) {
          widget.onFocusChange!(true);
        }
      },
      controller: widget.textEditingController,
      focusNode: !widget.readOnly ? widget.focusNode : null,
      readOnly: widget.readOnly,
      maxLines: widget.multiline ? null : 1,
      cursorColor: Colors.black,
      obscureText: widget.isPassword,
      onChanged: widget.onValueChanged,
      inputFormatters: widget.maxLength > 0
          ? <TextInputFormatter>[
              LengthLimitingTextInputFormatter(widget.maxLength),
            ]
          : null,
      keyboardType:
          widget.multiline ? TextInputType.multiline : TextInputType.text,
      scrollPhysics: widget.multiline ? const ClampingScrollPhysics() : null,
      cursorWidth: 0.5,
      expands: widget.multiline,
      textAlignVertical: TextAlignVertical.top,
      style: TextStyle(
        color: Colors.black,
        fontFamily: widget.font,
        fontSize: widget.fontSize,
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor: widget.fillColor,
        contentPadding: widget.multiline
            ? const EdgeInsets.all(3)
            : EdgeInsets.symmetric(
                vertical: widget.verticalPadding, horizontal: 3),
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide.none,
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
