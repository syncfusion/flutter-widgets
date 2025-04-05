import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import '../../pdfviewer.dart';
import 'pdf_form_field.dart';

/// Represents the combo box form field.
class PdfComboBoxFormField extends PdfFormField {
  PdfComboBoxFormField._();

  late String _selectedItem;
  late List<String> _items;

  /// Gets the items of the [PdfComboBoxFormField].
  List<String> get items => List<String>.unmodifiable(_items);

  /// Gets or sets a selected item of the [PdfComboBoxFormField].
  String get selectedItem => _selectedItem;

  set selectedItem(String value) {
    if (readOnly) {
      return;
    }
    (PdfFormFieldHelper.getHelper(this) as PdfComboBoxFormFieldHelper)
        .invokeValueChanged(value);
  }
}

/// Helper class for [PdfComboBoxFormField].
class PdfComboBoxFormFieldHelper extends PdfFormFieldHelper {
  /// Initializes a new instance of the [PdfComboBoxFormFieldHelper] class.
  PdfComboBoxFormFieldHelper(
    this.pdfComboBoxField,
    int pageIndex, {
    this.onValueChanged,
  }) : super(pdfComboBoxField, pageIndex) {
    bounds = pdfComboBoxField.bounds;
  }

  /// The combo box field object from PDF library.
  final PdfComboBoxField pdfComboBoxField;

  /// The callback which is called when the value of the form field is changed.
  final PdfFormFieldValueChangedCallback? onValueChanged;

  /// The combo box form field object.
  late PdfComboBoxFormField comboBoxFormField;

  /// Creates the combo box form field object.
  PdfComboBoxFormField getFormField() {
    final List<String> items = <String>[];
    for (int index = 0; index < pdfComboBoxField.items.count; index++) {
      items.add(pdfComboBoxField.items[index].text);
    }

    final String selectedValue = pdfComboBoxField.selectedIndex != -1
        ? pdfComboBoxField.items[pdfComboBoxField.selectedIndex].text
        : '';

    comboBoxFormField = PdfComboBoxFormField._()
      .._items = items
      .._selectedItem = selectedValue;
    super.load(comboBoxFormField);

    return comboBoxFormField;
  }

  /// Invokes the value changed callback.
  void invokeValueChanged(String newValue) {
    if (comboBoxFormField._selectedItem != newValue) {
      if (!comboBoxFormField.items.contains(newValue)) {
        throw ArgumentError.value(
          newValue,
          'selectedItem',
          'The value is not in the list of items.',
        );
      }
      final String oldValue = comboBoxFormField._selectedItem;
      setComboBoxValue(newValue);
      if (onValueChanged != null) {
        onValueChanged!(
          PdfFormFieldValueChangedDetails(
            comboBoxFormField,
            oldValue,
            newValue,
          ),
        );
      }
      rebuild();
    }
  }

  /// Sets the combo box value.
  void setComboBoxValue(String selectedItem) {
    comboBoxFormField._selectedItem = selectedItem;
    pdfComboBoxField.selectedValue = selectedItem;
  }

  /// Builds the combo box form field widget.
  Widget build(BuildContext context, double heightPercentage) {
    return Positioned(
      left: bounds.left / heightPercentage,
      top: bounds.top / heightPercentage,
      width: bounds.width / heightPercentage,
      height: bounds.height / heightPercentage,
      child: PdfComboBox(
        bounds: bounds,
        heightPercentage: heightPercentage,
        items: comboBoxFormField._items,
        selectedItem: comboBoxFormField._selectedItem,
        readOnly: comboBoxFormField.readOnly,
        font: pdfComboBoxField.font?.name,
        textAlign: pdfComboBoxField.textAlignment.textAlign,
        alignment: pdfComboBoxField.textAlignment.alignmentGeometry,
        fillColor: pdfComboBoxField.backColor.isEmpty
            ? const Color.fromARGB(255, 221, 228, 255)
            : Color.fromRGBO(
                pdfComboBoxField.backColor.r,
                pdfComboBoxField.backColor.g,
                pdfComboBoxField.backColor.b,
                1,
              ),
        borderColor: pdfComboBoxField.borderColor.isEmpty
            ? Colors.transparent
            : Color.fromRGBO(
                pdfComboBoxField.borderColor.r,
                pdfComboBoxField.borderColor.g,
                pdfComboBoxField.borderColor.b,
                1,
              ),
        borderWidth: pdfComboBoxField.borderWidth / heightPercentage,
        fontSize: (pdfComboBoxField.font?.size ?? 14.0) / heightPercentage,
        onValueChanged: invokeValueChanged,
      ),
    );
  }
}

/// Customized combo box
class PdfComboBox extends StatefulWidget {
  /// Initializes a new instance of the [PdfComboBox] class.
  const PdfComboBox({
    required this.bounds,
    required this.heightPercentage,
    required this.items,
    required this.selectedItem,
    this.readOnly = false,
    required this.fillColor,
    this.font,
    this.fontSize,
    this.onValueChanged,
    required this.borderColor,
    required this.borderWidth,
    this.textAlign = TextAlign.left,
    this.alignment = Alignment.centerLeft,
    super.key,
  });

  /// Combo box bounds.
  final Rect bounds;

  /// Combo box scale factor.
  final double heightPercentage;

  /// Combo box selected item.
  final String selectedItem;

  /// Combo box items.
  final List<String> items;

  /// Combo box read only.
  final bool readOnly;

  /// Combo box fill color.
  final Color fillColor;

  /// Combo box font name.
  final String? font;

  /// Combo box font size.
  final double? fontSize;

  /// Combo box value changed callback.
  final ValueChanged<String>? onValueChanged;

  /// Combo box border color
  final Color borderColor;

  /// Combo box border width
  final double borderWidth;

  /// Combo box text widget alignment
  final TextAlign textAlign;

  /// Combo box text alignment
  final AlignmentGeometry alignment;

  @override
  State<PdfComboBox> createState() => _PdfComboBoxState();
}

class _PdfComboBoxState extends State<PdfComboBox> {
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Container(
        decoration: BoxDecoration(
          color: widget.fillColor,
          border: Border.all(
            color: widget.borderColor,
            width: widget.borderWidth,
          ),
        ),
        child: DropdownButton<String>(
          alignment: widget.alignment,
          value: widget.selectedItem.isNotEmpty ? widget.selectedItem : null,
          items: widget.items.map((String value) {
            return DropdownMenuItem<String>(
              alignment: widget.alignment,
              value: value,
              child: Tooltip(
                excludeFromSemantics: true,
                message: value,
                child: Text(
                  textAlign: widget.textAlign,
                  value,
                  style: const TextStyle(fontSize: 16.0),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            );
          }).toList(),
          isExpanded: true,
          onChanged: widget.readOnly
              ? null
              : (String? newValue) {
                  if (widget.onValueChanged != null && newValue != null) {
                    widget.onValueChanged!(newValue);
                  }
                },
          style: Theme.of(context).textTheme.bodyMedium,
          selectedItemBuilder: (BuildContext context) {
            return widget.items.map((String value) {
              return Padding(
                padding: EdgeInsets.only(left: 2 / widget.heightPercentage),
                child: Align(
                  alignment: widget.alignment,
                  child: Text(
                    value,
                    textAlign: widget.textAlign,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: widget.fontSize,
                      color: Colors.black,
                    ),
                  ),
                ),
              );
            }).toList();
          },
          underline: Container(),
          menuMaxHeight: 300,
          icon: Icon(
            Icons.arrow_drop_down_outlined,
            size: widget.bounds.height / widget.heightPercentage,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
