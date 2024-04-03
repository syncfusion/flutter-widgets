import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import '../../pdfviewer.dart';
import '../common/pdfviewer_helper.dart';
import 'pdf_form_field.dart';

/// Represents the radio button form field.
class PdfRadioFormField extends PdfFormField {
  PdfRadioFormField._();

  late String _selectedItem;
  late List<String> _items;

  /// Gets the items of the [PdfRadioFormField].
  List<String> get items => List<String>.unmodifiable(_items);

  /// Gets or sets a selected item of the [PdfRadioFormField].
  String get selectedItem => _selectedItem;

  set selectedItem(String value) {
    if (readOnly) {
      return;
    }
    (PdfFormFieldHelper.getHelper(this) as PdfRadioFormFieldHelper)
        .invokeValueChanged(value);
  }
}

/// Helper class for [PdfRadioFormField].
class PdfRadioFormFieldHelper extends PdfFormFieldHelper {
  /// Initializes a new instance of the [PdfRadioFormFieldHelper] class.
  PdfRadioFormFieldHelper(this.pdfRadioField, int pageIndex,
      {this.onValueChanged})
      : super(pdfRadioField, pageIndex) {
    bounds = pdfRadioField.bounds;
  }

  /// THe radio button field object from PDF library.
  final PdfRadioButtonListField pdfRadioField;

  /// The callback which is called when the value of the form field is changed.
  final PdfFormFieldValueChangedCallback? onValueChanged;

  /// The radio button form field object.
  late PdfRadioFormField radioFormField;

  /// Flag to determine whether the form field can be reset to null value.
  late final bool canReset;

  /// Creates the radio button form field object.
  PdfRadioFormField getFormField() {
    final List<String> items = <String>[];
    for (int index = 0; index < pdfRadioField.items.count; index++) {
      items.add(pdfRadioField.items[index].value);
    }
    final String selectedValue = pdfRadioField.selectedIndex != -1
        ? items[pdfRadioField.selectedIndex]
        : '';
    canReset = selectedValue == '';
    radioFormField = PdfRadioFormField._()
      .._items = items
      .._selectedItem = selectedValue;
    super.load(radioFormField);

    return radioFormField;
  }

  /// Invokes the value changed callback.
  void invokeValueChanged(String newValue) {
    if (radioFormField._selectedItem != newValue) {
      if (!radioFormField.items.contains(newValue)) {
        throw ArgumentError.value(
            newValue, 'selectedItem', 'The value is not in the list of items.');
      }
      final String oldValue = radioFormField._selectedItem;
      setRadioButtonValue(newValue);
      if (onValueChanged != null) {
        onValueChanged!(PdfFormFieldValueChangedDetails(
            radioFormField, oldValue, newValue));
      }
      rebuild();
    }
  }

  /// Sets the radio button value.
  void setRadioButtonValue(String selectedItem) {
    radioFormField._selectedItem = selectedItem;
    pdfRadioField.selectedValue = selectedItem;
  }

  /// Builds the radio button form field.
  List<Widget> build(BuildContext context, double heightPercentage,
      {required Function(Offset) onTap}) {
    final List<Widget> widgets = <Widget>[];
    final PdfRadioButtonItemCollection item = pdfRadioField.items;

    for (int j = 0; j < item.count; j++) {
      final Rect bounds = item[j].bounds;
      final double selectionPadding =
          kIsDesktop ? 0 : kFormFieldSelectionPadding;
      final Rect adjustedBounds = bounds.inflate(selectionPadding);

      widgets.add(
        Positioned(
          left: adjustedBounds.left / heightPercentage,
          top: adjustedBounds.top / heightPercentage,
          width: adjustedBounds.width / heightPercentage,
          height: adjustedBounds.height / heightPercentage,
          child: Listener(
            onPointerUp: (PointerUpEvent event) {
              onTap(event.localPosition.translate(
                  adjustedBounds.left / heightPercentage,
                  adjustedBounds.top / heightPercentage));
            },
            child: PdfRadioButton(
              groupValue: radioFormField._selectedItem,
              value: item[j].value,
              readOnly: radioFormField.readOnly,
              onChanged: invokeValueChanged,
              heightPercentage: heightPercentage,
              selectionPadding: selectionPadding,
              fillColor: pdfRadioField.items[j].backColor.isEmpty
                  ? const Color.fromARGB(255, 221, 228, 255)
                  : Color.fromRGBO(
                      pdfRadioField.items[j].backColor.r,
                      pdfRadioField.items[j].backColor.g,
                      pdfRadioField.items[j].backColor.b,
                      1),
              size: bounds.height / heightPercentage,
            ),
          ),
        ),
      );
    }

    return widgets;
  }
}

/// Customized radio button
class PdfRadioButton extends StatefulWidget {
  /// Constructor for PdfRadioButton
  const PdfRadioButton(
      {Key? key,
      required this.value,
      required this.groupValue,
      this.readOnly = false,
      required this.onChanged,
      required this.heightPercentage,
      required this.selectionPadding,
      required this.fillColor,
      this.size = 24.0})
      : super(key: key);

  /// Height percentage
  final double heightPercentage;

  /// Radio button value
  final String value;

  /// Radio button groupValue
  final String? groupValue;

  /// Radio button readOnly
  final bool readOnly;

  /// Radio button onChanged
  final ValueChanged<String> onChanged;

  /// Radio button fill color
  final Color fillColor;

  /// Radio button size
  final double size;

  /// Radio button padding
  final double selectionPadding;

  @override
  _PdfRadioButtonState createState() => _PdfRadioButtonState();
}

class _PdfRadioButtonState extends State<PdfRadioButton> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (widget.readOnly) {
          return;
        }
        widget.onChanged(widget.value);
      },
      child: Padding(
        padding:
            EdgeInsets.all(widget.selectionPadding / widget.heightPercentage),
        child: Container(
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: widget.fillColor,
          ),
          child: widget.groupValue == widget.value
              ? Icon(
                  Icons.circle,
                  size: widget.size / 2.0,
                  color: Colors.black,
                )
              : Container(),
        ),
      ),
    );
  }
}
